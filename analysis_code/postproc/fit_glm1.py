#!/usr/bin/env python3
"""
-----------------------------------------------------------------------------------------
fit_glm.py
-----------------------------------------------------------------------------------------
Goal of the script:
First level GLM analysis of task runs on participant level
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

cd /Volumes/DATA_CNS/CNS_HUMAN/BIO7/data/bids/derivatives/mri_analysis/
python scripts_glm/fit_glm1.py /Volumes/DATA_CNS/CNS_HUMAN/BIO7/data/bids sub-8761 ses-02 faces T1w run-01 desc-preproc

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
from nilearn.glm.first_level import make_first_level_design_matrix
from nilearn.glm.first_level import FirstLevelModel
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
run = sys.argv[6] 
preproc = sys.argv[7] 

subject_folder = subject if space=='T1w' else '{}_mni'.format(subject) # output folder

# Define GLM parameters
# --------------------------
glm_alpha = "ar1"
glm_noise_model = 0.01
hrf_model = 'spm'

# Define scan parameters
# --------------------------

tr = 1.08 #repetition time in seconds 

if task == "faces": 
    if subject == "sub-8761":
        n_scans = 255 #number of scans/volumes in fMRI run, same for all runs, subject 1 less
    else:
        n_scans = 260 #number of scans/volumes in fMRI run, same for all runs
elif task == "faceloc": 
    if subject == "sub-8761":
        n_scans = 200 #number of scans/volumes in fMRI run, same for all runs, subject 1 less
    else:
        n_scans = 170 #number of scans/volumes in fMRI run, same for all runs
    
#number of frames in total in seconds 
frame_times = np.arange(n_scans) * tr

# Find task names 
# --------------------------

func_dir = "{base_dir}/{subject}/{session}/func/".format(base_dir=base_dir, subject=subject, session=session)
list_onsets_tsvs = [f for f in os.listdir(func_dir) if f.endswith('events.tsv') and task in f]

#possible to do for loop here: for i in list_onsets_tsvs: to loop over all runs...?

select_onsets_tsv = [o for o in list_onsets_tsvs if run in o]

#extracting subject and run labels from onsets file loaded
x = select_onsets_tsv[0].split("_")
subno = x[0][4:]
sublab = x[0]
seslab = x[1]
tasklab = x[2]
dirlab = x[3]
runno = x[4][4:]
runnoshort = runno[1]
runlab = x[4]
    
#read in current onsets file 
onsets_path = func_dir + select_onsets_tsv[0]
onsets_run = pd.read_csv(onsets_path,sep='\t')
onsets_run_headers = list(onsets_run)[1:]
       
#extracting necessary info
conditions = list(onsets_run["trial_type"])
duration = list(onsets_run["duration"])  
onsets = list(onsets_run["onset"])
       
#combining to events df
events = pd.DataFrame({'trial_type': conditions, 'onset': onsets, 'duration': duration})   

print(events)             
            
#events_glm = utils.eventsMatrix(design_file_run1, task)

# Define ouput folder
# -------------

glm_folder = '{base_dir}/derivatives/glm_{task}/{subject}/{session}/glm/fit/'.format(base_dir=base_dir, task=task, subject=subject_folder, session = session)

try: os.makedirs(glm_folder)
except: pass


# Run GLM analyses 
# -------------

print('GLM analysis on {} {} {}...'.format(subject, task, run))

anat_img = "{base_dir}/derivatives/fmriprep/fmriprep/{subject}/ses-01/anat/{subject}_ses-01_rec-BcSsLf_run-1_desc-preproc_T1w.nii.gz".\
                format(base_dir=base_dir, subject=subject)
fmri_img = "{base_dir}/derivatives/fmriprep/fmriprep/{subject}/{session}/func/{subject}_{session}_task-{task}_{dirlab}_run-{runnoshort}_space-{space}_{preproc}_bold.nii.gz".\
                format(base_dir=base_dir, subject=subject,session=session,task=task,dirlab=dirlab, space=space, runnoshort=runnoshort, preproc = preproc)
                
# could use the presurfer strip_mask instead of brainmask ?... 
#file_mask_img = '{base_dir}/derivatives/fmriprep/fmriprep/{subject}/ses-01/anat/{subject}_ses-01_rec-BcSsLf_run-1_desc-brain_mask.nii.gz'.\
#                format(base_dir=base_dir, subject=subject)

file_mask_img = '{base_dir}/derivatives/fmriprep/fmriprep/{subject}/{session}/func/{subject}_{session}_task-{task}_{dirlab}_run-1_space-{space}_desc-brain_mask.nii.gz'.\
                format(base_dir=base_dir, subject=subject,session=session,task=task,dirlab=dirlab, space=space)

print(anat_img)
print(file_mask_img)

print('fmri image info')
print(len(fmri_img))
print(fmri_img)
# Searching for confounds
# -------------
                          
confounds = load_confounds(fmri_img, strategy=("motion", "high_pass", "wm_csf"), motion="full",wm_csf="basic", global_signal="basic")

#from load_confounds import Confounds

#confounds = Confounds(strategy=(["motion", "high_pass", "wm_csf"]), motion="full").load(fmri_img)

print('confound info')
print(confounds)
print(len(confounds[0]))

confound_shape = np.shape(confounds[0])
print(confound_shape[1]) 
   
print('fmri image info')
print(len(fmri_img))

# Make desing matrix
# -------------

print(n_scans)
print(frame_times)

design_matrix_des = make_first_level_design_matrix(
    frame_times,
    events,
    drift_model=None,
    hrf_model=hrf_model)

fig, (ax1) = plt.subplots(figsize=(10, 6), nrows=1, ncols=1)
plot_design_matrix(design_matrix_des, ax=ax1)
ax1.set_title('Event-related design matrix', fontsize=12)

filename = glm_folder +"{}_{}_{}_{}_{}_designmatrix_desired.png".format(sublab, seslab, tasklab, dirlab,runlab)
plt.savefig(filename) 
plt.close()


# first level GLM
mask_img = nb.load(file_mask_img)
mean_img = mean_img(fmri_img)

#mean_img_anat = mean_img(anat_img)

#fmri_glm = FirstLevelModel( t_r=tr,
#                            drift_model=None,
#                            slice_time_ref=0.5,
#                            hrf_model=hrf_model,
#                            mask_img=mask_img)

fmri_glm = FirstLevelModel( t_r=tr,
                             drift_model=None,
                             slice_time_ref=0.5,
                             hrf_model=hrf_model,
                             smoothing_fwhm=3.2,
                             mask_img=mask_img)

fmri_glm = fmri_glm.fit(fmri_img, events, confounds[0])
#fmri_glm = fmri_glm.fit(fmri_img, design_matrix, confounds)

design_matrix = fmri_glm.design_matrices_[0]

print(design_matrix.shape)

plot_design_matrix(design_matrix)

#saving for each subject, run, trialtype condition 
filename = glm_folder +"/{}_{}_{}_{}_{}_designmatrix.png".format(sublab, seslab, tasklab, dirlab,runlab)
plt.savefig(filename) 
plt.close()

# contrast
if task == 'faceloc':
    
    confound_array = np.zeros(design_matrix.shape[1]-3)
    
    conditions = {
        'Fear': np.concatenate((np.array([1., 0., 0.]),confound_array)),
        'Happy': np.concatenate((np.array([0., 1., 0.]),confound_array)),
        'Neutral': np.concatenate((np.array([0., 0., 1.]),confound_array))}
    contrasts = {
        'Fear-Neutral': conditions['Fear'] - conditions['Neutral'],
        'Neutral-Fear': conditions['Neutral'] - conditions['Fear'],
        'Happy-Neutral':     conditions['Happy'] - conditions['Neutral'],
        'Neutral-Happy':     conditions['Neutral'] - conditions['Happy'],
        'Fear-Happy':    conditions['Fear'] - conditions['Happy'],
        'Happy-Fear':    conditions['Happy'] - conditions['Fear']}
    
elif task == 'faces':
    confound_array = np.zeros(design_matrix.shape[1]-6)
    conditions = {
        'Fear': np.concatenate((np.array([1., 0., 0., 1., 0., 0.]),confound_array)),
        'Happy': np.concatenate((np.array([0., 1., 0., 0., 1., 0.]),confound_array)),
        'Neutral': np.concatenate((np.array([0., 0., 1., 0., 0., 1.]),confound_array)),
        'Con': np.concatenate((np.array([1., 1., 1., 0., 0., 0.]),confound_array)),
        'Uncon': np.concatenate((np.array([0., 0., 0., 1., 1., 1.]),confound_array))}
    contrasts = {
        'Fear-Neutral': conditions['Fear'] - conditions['Neutral'],
        'Happy-Neutral':     conditions['Happy'] - conditions['Neutral'],
        'Fear-Happy':    conditions['Fear'] - conditions['Happy'],
        'Con-Uncon':    conditions['Con'] - conditions['Uncon']}


# compute glm maps
for contrast in contrasts:
    
    output_fn = '{glm_folder}{subject}_{session}_task-{task}_{runlab}_space-{space}_{preproc}_glm-{contrast}.nii.gz'.\
            format(glm_folder=glm_folder, subject=subject,session=session,task=task,space=space,runlab=runlab,preproc=preproc,contrast=contrast)
    
    print('{}'.format(output_fn))
    
    # stats maps
             
    eff_map = fmri_glm.compute_contrast(contrasts[contrast],
                                        output_type='effect_size')    
    stat_eff_fn = '{glm_folder}{subject}_{session}_task-{task}_{runlab}_space-{space}_{preproc}_glm-{contrast}_stat_eff.nii.gz'.\
            format(glm_folder=glm_folder, subject=subject,session=session,task=task,space=space,runlab=runlab,preproc=preproc,contrast=contrast)
    eff_map.to_filename(stat_eff_fn)
    
    z_map = fmri_glm.compute_contrast(contrasts[contrast],
                                        output_type='z_score')
    stat_z_fn = '{glm_folder}{subject}_{session}_task-{task}_{runlab}_space-{space}_{preproc}_glm-{contrast}_stat_z.nii.gz'.\
            format(glm_folder=glm_folder, subject=subject,session=session,task=task,space=space,runlab=runlab,preproc=preproc,contrast=contrast)    
    z_map.to_filename(stat_z_fn)

    z_p_map = 2*(1 - stats.norm.cdf(abs(z_map.dataobj)))
        
    # _,fdr_map, th = threshold_stats_img(z_map, alpha=glm_alpha, height_control='fdr')
    # _,fdr_p_map = 2*(1 - stats.norm.cdf(abs(fdr_map.dataobj)))
    
    # _,fdr_cluster10_map, th = threshold_stats_img(z_map, alpha=glm_alpha, height_control='fdr', cluster_threshold=10)
    # _,fdr_cluster10_p_map = 2*(1 - stats.norm.cdf(abs(fdr_cluster10_map.dataobj)))
    
                              
    # Save results
    img = nb.load(fmri_img)
    deriv = np.zeros((img.shape[0],img.shape[1],img.shape[2],11))*np.nan
    
    deriv[...,0]  = eff_map.dataobj
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
    
    zmap_fn = '{glm_folder}{subject}_{session}_task-{task}_{runlab}_space-{space}_{preproc}_glm-{contrast}_zmap.png'.\
            format(glm_folder=glm_folder, subject=subject,session=session,task=task,space=space,runlab=runlab,preproc=preproc,contrast=contrast)
 
    # plotting.plot_stat_map(
    #         z_map, bg_img=mean_img, threshold=3.0, display_mode='y',
    #         cut_coords=8, title=contrast, output_file=zmap_fn)
        
    plotting.plot_stat_map(
        z_map, bg_img=mean_img, threshold=3.0, display_mode='y',
        cut_coords=(-60,-45,-30,-15,0,15,30,45,60), title=contrast, output_file=zmap_fn) 
    
    if task == 'faceloc':
        from brainsprite import viewer_substitute
        
        anat_bgimg = nb.load(anat_img)
        print(anat_bgimg)
        
        bsprite = viewer_substitute(threshold=3, opacity=0.5, title="{glmfolder}{subject}_{session}_task-{task}_space-{space}_{contrast}_zmap".\
                                    format(glmfolder=glm_folder,subject=subject, session=session, task=task,space=space,contrast=contrast), 
                                 cut_coords=[36, -27, 66])
        bsprite.fit(z_map, bg_img=anat_bgimg)

        import tempita
        #/Users/penny/.pyenv/versions/3.9.5/lib/python3.9/site-packages/brainsprite/data/html/viewer_template.html
        file_template = '/Users/penny/.pyenv/versions/3.9.5/lib/python3.9/site-packages/brainsprite/data/html/viewer_template.html'
        template = tempita.Template.from_filename(file_template, encoding="utf-8")
        viewer = bsprite.transform(template, javascript='js', html='html', library='bsprite')
        viewer.save_as_html('{glmfolder}{subject}_{session}_task-{task}_space-{space}_{contrast}_zmap.html'.\
                            format(glmfolder=glm_folder, subject=subject, session=session, task=task, space=space, contrast=contrast))


