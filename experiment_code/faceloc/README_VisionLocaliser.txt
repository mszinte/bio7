# BIO7 - Vision Localiser Social Cognition 

## Task Description 
Localiser task of faces (happy, fear, neutral) shown for 1s in block fashion with 20 trials per emotion.

Fear x 20 - Happy x 20 - Neutral x 20 ] block 

## Version Notes 
Version as of 13.10.2022. Fixation cross made to match Retinotopy task and resting state. Pseudo-randomised control of sex, age, emotion, location. Text cues presented for 10 seconds before each emotion as in neutral task. 

## Acquisition Notes 
BOLD Screen must be placed 30cm from the back of the 7T bore. Current codes as of 13.10.2022 for first pilot account based on distance of 30cm. 
Button response system must be put on HID, triggering of task occurs on volume 5. 


-------------- ## How to: ------------------


## Caution ! How to: Creating the task: 
- Don't run Emotion_Exp2Localiser_Design_v3 unless want to create a new task design
- If you do, there will be a prompt anyway saying that there is already an existing design, do you want to not save the new one (0), save it but archive the old design (1), save it and delete the old one (2). Of note, can only archive the old design once a day as this uses a datestamp, if want to archive more than one copy a day will have to do that manually. At worst, if re-run and save will just be like randomising the same task trial order, if nothing changed within the config codes. If changing the task design and config files, will need to run this code after modifying the config codes to get the new design. 

## How to: Running the task: 
1. Navigate to folder Vision_Localiser_v3
2. Run Emotion_Exp2Localiser_Run_v3
3. Input desired parameters: subject_number (1, 2, 3, 4 etc.) subject_run (1), subject_mode (demo/test on laptop = 0, MRI with BOLD screen = 1). FYI: only 1 run for this task. 

NB: - MRI mode will load dedicated workspaces and csv. files in execution/ folder or data/ folder if a previous run has already been run. Test mode will load files with _test in the name. 
NB: - The code will automatically check if existing data with parameters exist or if a previous run has been done. If previous data with the same inputs already exists in data/ prompts will be sent to ask whether to continue and overwrite data or stop. Options to save a copy of the matching data are coded but not working (13.10.2022) so should not be chosen for the moment - manually copy and deplace data if necessary. 

4. Trigger from MRI is 's', in test mode use 's' too, once 's' received experiment starts. Should see 'experiment triggered' in command window once trigger received. 

5. Response buttons are 'q', 'b', 'c', 'd'. Cancel button if want to stop task ever 'x' - only possible during emotive phase. Should see triggers and response buttons in command window if participant is performing task. 
FYI: No responses during this task. 



----------- #### todo: 

Change order to have Neutral first or between? 