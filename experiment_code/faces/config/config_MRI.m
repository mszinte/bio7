%% Configuration file 
% MRI parameters and timing

% PROTOCOLE_CERVEAU\mbep2d_bold_LR_HCP_1p6

mri.TR = 1.080; %seconds 
mri.TE = 0.02525; %seconds  
mri.slicethickness = 1.60; %mm


%% Calculate MRI time acquisition based on input parameters

for iter = 1:task.runs
    
    idx = experiment1_task_design.run_number==iter; 
    mri.time_task(iter) = sum(experiment1_task_design.trial_time_secs(idx));
    
    idx_r = experiment1_rest_design.run_number==iter; 
    mri.time_rest(iter) = sum(experiment1_rest_design.trial_time_secs(idx_r));
    
    mri.time_cues(iter) = ((10 + screen.frame_duration_mfitest)*2)*task.blocksprun;
    
    mri.time_run_secs(iter) = mri.time_cues(iter) +  mri.time_rest(iter) + mri.time_task(iter); 
    
    mri.time_run_vol(iter) = mri.time_run_secs(iter)/mri.TR; 
    
    %Adding 5 volumes because the trigger device triggers the experiment on
    %the 5th volume only, not the first 
    mri.TA_vol(iter) = ceil(mri.time_run_vol(iter)) + 5; 
    
    mri.TA_mins(iter) = (mri.TA_vol(iter)*mri.TR)/60; 
    
end

mri.time_task_tot = sum(mri.TA_mins); 
