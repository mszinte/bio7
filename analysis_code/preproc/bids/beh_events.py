"""
-----------------------------------------------------------------------------------------
beh_events.py
-----------------------------------------------------------------------------------------
Goal of the script:
Run freesurfer with new brainmask manually edited
-----------------------------------------------------------------------------------------
Input(s):
sys.argv[1]: bids directory
sys.argv[2]: behavioral raw data directory
sys.argv[3]: subject (e.g. sub-01)
-----------------------------------------------------------------------------------------
Output(s):
new freesurfer segmentation files
-----------------------------------------------------------------------------------------
To run:
1. cd to function
>> ~/projects/bio7/analysis_code/preproc/bids/
2. run python command
python beh_events.py [main directory] [project name] [subject]
-----------------------------------------------------------------------------------------
Exemple:
python beh_events.py /scratch/jstellmann/data/bio7 
                     ~/projects/bio7/experiment_code/retin sub-8761
------------------------------------------------------------------------------------------
Written by Martin Szinte (mail@martinszinte.net)
----------------------------------------------------------------------------------------
"""

# General imports
import os
import sys 

# Get inputs
bids_dir = sys.argv[1]
beh_dir = sys.argv[2]
subject = sys.argv[3]

# Define transfer cmd from repo to sourcedata
repo2sourcedata_cmd = "rsync -avuz {beh}/{sub}/ {bids}/{sub}".format(
    bids=bids_dir, beh=beh_dir, sub=subject)
print(repo2sourcedata_cmd)
#os.sys(repo2sourcedata_cmd)
