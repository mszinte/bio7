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


## Data analysis
---

### Pre-processing

#### BIDS
- [ ] convert dicom to tar and delete dicoms from mesocentre [dicom2tar.py](analysis_code/preproc/bids/dicom2tar.py)
- [ ] create bids dataset from tar files [tar2bids.py](analysis_code/preproc/bids/tar2bids.py)
- [ ] edition of json files for bids [to_name](analysis_code/preproc/bids/to_name.py)
- [ ] create events files [create_events.py](analysis_code/preproc/bids/create_events.py)
- [ ] background deletion of T1w images [mp2rage_genUniDen.py](analysis_code/preproc/bids/mp2rage_genUniDen.py)
- [ ] deface participants t1w image [deface_sbatch.py](analysis_code/preproc/bids/deface_sbatch.py)
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