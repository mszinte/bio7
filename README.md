# BIO7
## About
---
We study the visual and cognitive system and their interaction with multiple sclerosis.</br>
In this repository is kept all codes allowing us to run the experiments and analyse our dataset [OpenNeuro:DSXXXXX](https://openneuro.org/datasets/dsXXXX).</br>

---
## Authors: 
---
Penelope Tilsley, Mihaela Nicolescu, Martin Szinte & Jan-Patrick Stellmann

### Main dependencies
---
[PyDeface](https://github.com/poldracklab/pydeface); 
[fMRIprep](https://fmriprep.org/en/stable/); 
[pRFpy](https://github.com/VU-Cog-Sci/prfpy); 
[pybest](https://github.com/lukassnoek/pybest);
[FreeSurfer](https://surfer.nmr.mgh.harvard.edu/)
</br>

### To do
- [ ] add argparse --help option to codes + modify home_sw_dir paths 
- [ ] penny event files R + data > sourcedata 
- [ ] penny - put experiment code in experiment_code/ folder
- [x] martin - put experiment code in experiment_code/ folder
- [ ] martin event files + data > sourcedata
- [ ] martin presurfer python way 
- [ ] mih jps participants tsv redcap > sourcedata 
- [x] martin finish setup mihaela jupyterlab 
- [ ] martin deface participants t1w image

## Data analysis
---

### Utilities
- [ ] correct permissions for all project files [change_folder_access.py](analysis_code/utils/change_folder_access.py)
- [ ] backup mesocentre project folder to server [backup_mesocentre.py](analysis_code/utils/backup_mesocentre.py)

### Pre-processing

#### BIDS
- [ ] copy behavioural fMRI data to mesocentre [ ]()
- [ ] copy clinical RedCap data to mesocentre [ ]()
- [x] copy dicoms to mesocentre [dicom2mesocentre.py](analysis_code/preproc/bids/dicom2mesocentre.py)
- [x] check over dicoms [dicom_editor.py](analysis_code/preproc/bids/dicom_editor.py)
- [x] convert dicom to tar and delete dicoms from mesocentre [dicom2tar.py](analysis_code/preproc/bids/dicom2tar.py)
- [x] create bids dataset from tar files [tar2bids.py](analysis_code/preproc/bids/tar2bids.py) (calls bids organisation in [bids_heuristic_file_bio7.py](analysis/code/preproc/bids/bids_heuristic_file_bio7.py))
- [x] edition of json files for tasks and anonymysation [json_editor.py](analysis_code/preproc/bids/json_editor.py)
- [x] update participants.tsv [tsv_editor.py](analysis_code/preproc/bids/tsv_editor.py)
- [ ] create events files with R [events_bio7_retin.R](), [events_bio7_faces.R]()
- [ ] background deletion of T1w images [mp2rage_genUniDen.py](analysis_code/preproc/bids/mp2rage_genUniDen.py) or [presurfer.py]()
- [ ] deal with other files type (penny seems to have it done somewhere)
- [ ] deface participants t1w image [deface_sbatch.py](analysis_code/preproc/bids/deface_sbatch.py)
- [ ] deface participants other image type
- [ ] validation using web [BIDS validator](https://bids-standard.github.io/bids-validator/)

#### Structural preprocessing-

- [ ] manual definition of lesion mapping [lesion_mapping.py](analysis_code/preproc/anatomical/lesion_mapping.py)
- [ ] fMRIprep with anat-only [fmriprep_sbatch.py](analysis_code/preproc/functional/fmriprep_sbatch.py)
- [ ] create sagital view video before and after manual edit [sagital_view.py](analysis_code/preproc/anatomical/sagital_view.py)
- [ ] manual edit of brain segmentation [to_be_define](/asdasd/)
- [ ] re-run freesurfer to include the manual change of the pial surface [to_be_define](/asdasd/)
- [ ] cut the brain and flatten it [to_be_define](/asdasd/)
- [ ] create pycortex dataset [to_be_define](/asdasd/)

#### Functional preprocessing
- [ ] fMRIprep [fmriprep_sbatch.py](analysis_code/preproc/functional/fmriprep_sbatch.py)
- [ ] slow drift correction and z-score [pybest_sbatch.py](analysis_code/preproc/functional/pybest_sbatch.py)

### Post-processing

#### GLM analysis
- to be defined later
- idea : https://fitlins.readthedocs.io/en/latest/usage.html


#### PRF analysis
- [ ] average and leave-one-out averaging of runs together [preproc_end.py](analysis_code/preproc/functional/preproc_end.py)
- [ ] create the visual matrix design [vdm_builder.ipynb](analysis_code/postproc/prf/fit/vdm_builder.ipynb)
- [ ] Fit pRF parameters (eccentricity, size, amplitude, baseline, rsquare)
  - pRF fitting code [prf_fit.py](analysis_code/postproc/prf/fit/prf_fit.py)
  - submit fit [submit_fit_jobs.py](analysis_code/postproc/prf/fit/submit_fit_jobs.py)
- [ ] Compute all pRF parameters [post_fit.py](analysis_code/postproc/prf/post_fit/post_fit.py)
    - [ ] add Dumoulin magnification factor
    - [ ] add pRF coverage
- [ ] make pycortex maps
- [ ] make webgl
- [ ] send index.py to webapp