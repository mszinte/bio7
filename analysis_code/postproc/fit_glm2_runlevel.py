#!/usr/bin/env python3
"""
-----------------------------------------------------------------------------------------
fit_glm.py
-----------------------------------------------------------------------------------------
Goal of the script:
Seconds level GLM analysis of task runs on participant level, run-level analysis
-----------------------------------------------------------------------------------------
Input(s):
sys.argv[1]: base_dir (e.g. /BIO7/data/bids)
sys.argv[2]: subject name (e.g. sub-8761)
sys.argv[3]: session (e.g. ses-02)
sys.argv[4]: task (e.g. faces, faceloc)
sys.argv[5]: space (e.g. T1w)
sys.argv[6]: run number to analyse (e.g. run-01)
sys.argv[7]: pre-processing label of fmri image (desc-prepoc)
-----------------------------------------------------------------------------------------
Output(s):
...
-----------------------------------------------------------------------------------------
To run:
On mesocentre
>> cd to where glm analyses and scripts folders are located
>> python glm/fit_glm.py [base_dir] [subject] [session] [task] [reg] [run] [preproc]
-----------------------------------------------------------------------------------------
Example:

run from directory where the functions are... 
cd /Volumes/DATA_CNS/CNS_HUMAN/BIO7/data/bids/derivatives/mri_analysis/
python scripts_glm/fit_glm2_runlevel.py /Volumes/DATA_CNS/CNS_HUMAN/BIO7/data/bids sub-8761 ses-02 faces T1w desc-preproc

-----------------------------------------------------------------------------------------
"""

# Stop warnings
# -------------
import warnings
warnings.filterwarnings("ignore")

# General imports
# ---------------
import os
import sys
import json
import numpy as np
import pandas as pd
import scipy.stats as stats
import pdb
deb = pdb.set_trace

# MRI imports
# -----------
import nibabel as nb

# Functions import
# ----------------
import importlib.util

# GLM imports
# -----------
from nilearn.glm.second_level import SecondLevelModel
from nilearn.glm import threshold_stats_img
from nilearn import plotting
from nilearn.plotting import plot_design_matrix
from nilearn.image import mean_img
from nilearn.maskers import NiftiMasker
from nilearn.interfaces.fmriprep import load_confounds

# Plot imports 
# -----------
try:
    import matplotlib.pyplot as plt
except ImportError:
    raise RuntimeError("This script needs the matplotlib library")

# Get inputs
# ----------
base_dir =  sys.argv[1]
subject = sys.argv[2]
session = sys.argv[3]
task = sys.argv[4] 
space = sys.argv[5] 
preproc = sys.argv[6] 

subject_folder = subject if space=='T1w' else '{}_mni'.format(subject)

# Define glm first level second level folder
# -------------

glm1_folder = '{base_dir}/derivatives/glm_faces/{subject}/{session}/glm/fit/'.format(base_dir=base_dir, subject=subject_folder, session = session)

glm2_folder = '{base_dir}/derivatives/glm_faces/{subject}/{session}/glm2/fit/'.format(base_dir=base_dir, subject=subject_folder, session = session)

try: os.makedirs(glm2_folder)
except: pass

func_dir = "{base_dir}/{subject}/{session}/func/".format(base_dir=base_dir, subject=subject, session=session)
list_fmriruns = [f for f in os.listdir(func_dir) if f.endswith('bold.nii.gz') and task in f]

runs = len(list_fmriruns)

select_fmriruns = list_fmriruns[0]

#extracting subject and run labels from fmri bold files 
x = select_fmriruns.split("_")
subno = x[0][4:]
sublab = x[0]
seslab = x[1]
tasklab = x[2]
dirlab = x[3]

# Make second level desing matrix
# ------------
design_matrix2 = pd.DataFrame([1] * len(list_fmriruns), columns = ['intercept'])

fig, (ax1) = plt.subplots(figsize=(10, 6), nrows=1, ncols=1)
plot_design_matrix(design_matrix2, ax=ax1)
ax1.set_title('Run level (2nd level) design matrix', fontsize=12)
ax1.set_ylabel('contrasts')

filename = glm2_folder +"{}_{}_{}_{}_2ndlevel_designmatrix.png".format(sublab, seslab, tasklab, dirlab)
plt.savefig(filename) 
plt.close()

# Defining contrasts
if task == 'faceloc':
    contrasts = ('Fear-Neutral', 'Neutral-Fear', 'Happy-Neutral', 'Neutral-Happy', 'Fear-Happy','Happy-Fear')
    
elif task == 'faces':
    contrasts = ('Fear-Neutral','Happy-Neutral','Fear-Happy','Con-Uncon')

    
# Run GLM analyses 
# -------------

print('GLM run-level analysis on {} {} ...'.format(subject, task))

anat_img = "{base_dir}/derivatives/fmriprep/fmriprep/{subject}/ses-01/anat/{subject}_ses-01_rec-BcSsLf_run-1_desc-preproc_T1w.nii.gz".\
                format(base_dir=base_dir, subject=subject)
fmri_img = "{base_dir}/derivatives/fmriprep/fmriprep/{subject}/{session}/func/{subject}_{session}_task-{task}_{dirlab}_run-1_space-{space}_{preproc}_bold.nii.gz".\
                format(base_dir=base_dir, subject=subject,session=session,task=task,dirlab=dirlab, space=space, preproc = preproc)
                
# Making mean fmri image for plotting, would be good to get on anatomic...
mean_img = mean_img(fmri_img)

# compute glm maps
for contrast in contrasts:
    
    output_fn = '{glm2_folder}{subject}_{session}_task-{task}_space-{space}_{preproc}_glm2-{contrast}.nii.gz'.\
            format(glm2_folder=glm2_folder, subject=subject,session=session,task=task,space=space,preproc=preproc,contrast=contrast)
            
    fmri_contrasts = [c for c in os.listdir(glm1_folder) if c.endswith('stat_z.nii.gz') and contrast in c and task in c]
    
    fmri_contrasts_path = [glm1_folder + s for s in fmri_contrasts]
    
    print(fmri_contrasts_path)
    print('{}'.format(output_fn))
    
    second_level_model = SecondLevelModel(smoothing_fwhm=3.2)
    second_level_model = second_level_model.fit(fmri_contrasts_path, design_matrix = design_matrix2)
    
    
    # stats maps
    # eff_map = second_level_model.compute_contrast(second_level_contrast='intercept',
    #                                     output_type='effect_size')
    
    z_map = second_level_model.compute_contrast(second_level_contrast='intercept',
                                        output_type='z_score')

    z_p_map = 2*(1 - stats.norm.cdf(abs(z_map.dataobj)))
        
    # fdr_map, th = threshold_stats_img(z_map, alpha=glm_alpha, height_control='fdr')
    # fdr_p_map = 2*(1 - stats.norm.cdf(abs(fdr_map.dataobj)))
    
    # fdr_cluster10_map, th = threshold_stats_img(z_map, alpha=glm_alpha, height_control='fdr', cluster_threshold=10)
    # fdr_cluster10_p_map = 2*(1 - stats.norm.cdf(abs(fdr_cluster10_map.dataobj)))
    
                              
    # Save results
    img = nb.load(fmri_img)
    deriv = np.zeros((img.shape[0],img.shape[1],img.shape[2],11))*np.nan
    
    # deriv[...,0]  = eff_map.dataobj
    deriv[...,1]  = z_map.dataobj
    deriv[...,2]  = z_p_map
    # deriv[...,3]  = fdr_map.dataobj
    # deriv[...,4]  = fdr_p_map
    # deriv[...,5]  = fdr_cluster10_map.dataobj
    # deriv[...,6]  = fdr_cluster10_p_map

                              
    deriv = deriv.astype(np.float32)
    new_img = nb.Nifti1Image(dataobj = deriv, affine = img.affine, header = img.header)
    new_img.to_filename(output_fn)

    
#    observed_timeseries = NiftiMasker.fit_transform(fmri_img)
#    predicted_timeseries = NiftiMasker.fit_transform(fmri_glm.predicted[0])
    
    zmap_fn = '{glm2_folder}{subject}_{session}_task-{task}_space-{space}_{preproc}_glm2-{contrast}_zmap.png'.\
            format(glm2_folder=glm2_folder, subject=subject,session=session,task=task,space=space,preproc=preproc,contrast=contrast)
 
    # plotting.plot_stat_map(
    #         z_map, bg_img=mean_img, threshold=3.0, display_mode='y',
    #         cut_coords=8, title=contrast, output_file=zmap_fn)
        
    plotting.plot_stat_map(
        z_map, bg_img=mean_img, threshold=3.0, display_mode='y',
        cut_coords=(-60,-45,-30,-15,0,15,30,45,60), title=contrast, output_file=zmap_fn)  
    

    
    #%%
    # We are going to use the same template and instruction as in the
    # `plot_anat <plot_anat.html>`_ tutorial. The defaults are set for a functional
    # map, so there is not much to do. We still tweak a couple parameters to get a
    # clean map:
    #
    #  * apply a threshold to get rid of small activation (:code:`threshold`),
    #  * reduce the opacity of the overlay to see the underlying anatomy (:code:`opacity`)
    #  * Put a title inside the figure (:code:`title`)
    #  * manually specify the cut coordinates (:code:`cut_coords`)
    
    from brainsprite import viewer_substitute
    
    stat_img = nb.load(output_fn) 
    print(stat_img)
    anat_bgimg = nb.load(anat_img)
    print(anat_bgimg)

    bsprite = viewer_substitute(threshold=2.3, opacity=0.5, title="{glmfolder}{subject}_{session}_task-{task}_space-{space}_{contrast}_zmap".\
                                format(glmfolder=glm2_folder,subject=subject, session=session, task=task,space=space,contrast=contrast), 
                             cut_coords=[36, -27, 66])
    bsprite.fit(z_map, bg_img=anat_bgimg)

    #%%[0]
    # We can now open the template with tempita, and fill it with the required
    # information. The parameters indicate which tempita names we used in the
    # template for the javascript, html and library code, respectively.
    import tempita
    #/Users/penny/.pyenv/versions/3.9.5/lib/python3.9/site-packages/brainsprite/data/html/viewer_template.html
    file_template = '/Users/penny/.pyenv/versions/3.9.5/lib/python3.9/site-packages/brainsprite/data/html/viewer_template.html'
    template = tempita.Template.from_filename(file_template, encoding="utf-8")

    viewer = bsprite.transform(template, javascript='js', html='html', library='bsprite')

    # In a Jupyter notebook, if ``view`` is the output of a cell, it will
    # be displayed below the cell
    #viewer

    #%%
    # The following instruction can be used to save the viewer in a stand-alone,
    # html document:
    viewer.save_as_html('{glmfolder}{subject}_{session}_task-{task}_space-{space}_{contrast}_zmap.html'.\
                        format(glmfolder=glm2_folder, subject=subject, session=session, task=task, space=space, contrast=contrast))
    
    #%%
    # There are a lot more control one can use to modify the appearance of the
    # brain viewer. Check the Python API for more information.