# -*- coding: utf-8 -*-
"""
Created on Tue Jan 17 11:17:07 2023

@author: Tilsley
-----------------------------------------------------------------------------------------
change_folder_access.py

script location: projects/bio7/analysis_code/preproc/bids/change_folder_access.py
-----------------------------------------------------------------------------------------
Goal of the script:
Make folders accessible to whole team
-----------------------------------------------------------------------------------------
Input(s):
sys.argv[1]: folder to change access for /scratch/jstellmann/data/bio7
-----------------------------------------------------------------------------------------
To run:
On mesocentre

>> cd ~/projects/bio7/analysis_code/preproc/
>> python bids/change_folder_access.py
-----------------------------------------------------------------------------------------
"""

# General imports
# ---------------
import subprocess

# Get inputs
# ----------
input_dir = "/scratch/jstellmann/data/bio7/"

#take out the w (write files) and r (read files) for all users, -R does for all folders below
subprocess.call(["chmod", "-R", "a+wrx", input_dir])

#allow x (view files) for all users, -R does for all folders below
subprocess.call(["chmod", "-R", "o-rw", input_dir])

#change group identifiant to bio7 number, -R does for all folders below
subprocess.call(["chgrp", "-R", "306", input_dir])
