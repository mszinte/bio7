# -*- coding: utf-8 -*-
"""
Created on Tue Jan 17 11:17:07 2023

@author: Tilsley
-----------------------------------------------------------------------------------------
change_folder_access.py

script location: projects/bio7/analysis_code/preproc/bids/change_folder_access.py
-----------------------------------------------------------------------------------------
Goal of the script:
Make folders accessible to whole bio7 team. Defaults to data/bio7 folder. Change input -i
-----------------------------------------------------------------------------------------
Optional input(s):
-i, folder to change access for. Default if empty: /scratch/jstellmann/data/bio7
-----------------------------------------------------------------------------------------
To run:
On mesocentre

>> cd ~/projects/bio7/analysis_code/preproc/utils
>> python change_folder_access.py
-----------------------------------------------------------------------------------------
"""

# General imports
# ---------------
import subprocess

# Defining Help Messages
#-----------------------
import argparse
parser = argparse.ArgumentParser(
    description = 'Correct permissions for folders and contents',
    epilog = ' ')
parser.add_argument('-i', '--input', default="/scratch/jstellmann/data/bio7/", help='path to data project directory on mesocentre or other to change permissions for. e.g., /scratch/{user}/data/{project}')
args = parser.parse_args()

# Get inputs
# ----------
input_dir = args.input

#take out the w (write files) and r (read files) for all users, -R does for all folders below
subprocess.call(["chmod", "-R", "a+wrx", input_dir])

#allow x (view files) for all users, -R does for all folders below
subprocess.call(["chmod", "-R", "o-rw", input_dir])

#change group identifiant to bio7 number, -R does for all folders below
subprocess.call(["chgrp", "-R", "306", input_dir])
