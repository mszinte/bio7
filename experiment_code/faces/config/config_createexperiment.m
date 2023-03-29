%% Configuration file 
% Create final experiment table 

%% Making variables to pull into one table
%trial 
trial_number((1:task.trials),:) = design.trialnumber;

%trial timings 
trial_time_secs((1:task.trials),:) = design.trial_time_secs;
trial_time_frames((1:task.trials),:) = design.trial_time_frames;
%placeholder for cumulative trial time, to calculate after 
cum_trial_time_secs((1:task.trials),:) = NaN(task.trials,1);
cum_trial_time_frames((1:task.trials),:) = NaN(task.trials,1);

%block
%placeholder for cumulative trial time, to calculate after 
block_number((1:task.trials),:) = NaN(task.trials,1);

%block
%placeholder for cumulative trial time, to calculate after 
run_number((1:task.trials),:) = NaN(task.trials,1);

%information on image
image_number((1:task.trials),:) = design.image_photonumber;
image_agesexcat_ref((1:task.trials),:) = design.agesex_ref;
image_agesexemocat_ref((1:task.trials),:) = design.agesexemo_ref; 
image_number_ref((1:task.trials),:) = design.image_ref;
image_age_ref((1:task.trials),:) = design.ages_ref;
image_age((1:task.trials),:) = design.ages_name;
image_sex_ref((1:task.trials),:) = design.sexs_ref;
image_sex((1:task.trials),:) = design.sexs_name;

%location of target-mask
location_name((1:task.trials),:) = design.loc_name;
location((1:task.trials),:) = design.loc_ref; 
location_x((1:task.trials),:) = design.loc_x; 
location_y((1:task.trials),:) = design.loc_y; 

%target paramaters
target_emotion_ref((1:task.trials),:) = design.emotions_ref;
target_emotion((1:task.trials),:) = design.emotions_name;
target_id((1:task.trials),:) = design.agesexemo_id_target;
target_fullid((1:task.trials),:) = design.agesexemo_target;
target_imagename((1:task.trials),:) = strcat(design.target_imagenumber_str,'_',design.agesexemo_id_target, stim.list);
target_pos_ref = design.target_imagepos_ref;

%mask 
mask_secs((1:task.trials),:) = design.mask_secs;
mask_frames((1:task.trials),:) = design.mask_frames;
mask_id((1:task.trials),:) = design.agesexemo_id_mask;
mask_fullid((1:task.trials),:) = design.agesexemo_mask;
mask_imagename((1:task.trials),:) = strcat(design.mask_imagenumber_str,'_',design.agesexemo_id_mask, stim.list);
mask_pos_ref = design.mask_imagepos_ref;

%soas / target time
soa_ref((1:task.trials),:) = design.soa_ref;
soa_secs((1:task.trials),:) = design.soa_secs;
soa_frames((1:task.trials),:) = design.soa_frames;
%jitters
jitter_ref((1:task.trials),:) = design.jitter_ref;
jitter_secs((1:task.trials),:) = design.jitter_secs;
jitter_frames((1:task.trials),:) = design.jitter_frames;
%fixation cross response time
response_secs((1:task.trials),:) = design.response_secs;
response_frames((1:task.trials),:) = design.response_frames;

experiment1_task_design = table(trial_number,...
    trial_time_secs,...
    trial_time_frames,...
    cum_trial_time_secs,...
    cum_trial_time_frames,...
    block_number,...
    run_number,...
    image_number,...
    image_agesexcat_ref,...
    image_agesexemocat_ref,...
    image_number_ref,...
    image_age,...
    image_age_ref,...
    image_sex,...
    image_sex_ref,...
    location_name,...
    location,...
    location_x,...
    location_y,...
    target_emotion,...
    target_emotion_ref,...
    target_id,...
    target_fullid,...
    target_imagename,...
    target_pos_ref,...
    mask_secs,...
    mask_frames,...
    mask_id,...
    mask_fullid,...
    mask_imagename,...
    mask_pos_ref,...
    soa_ref,...
    soa_secs,...
    soa_frames,...
    jitter_ref,...
    jitter_secs,...
    jitter_frames,...
    response_secs,...
    response_frames);


%sort experiment based on trial number
experiment1_task_design = sortrows(experiment1_task_design,'trial_number');

%add run number block number and cumulative experiment time 
cum_trial_time_secs((1:task.trials),:) = cumsum(experiment1_task_design.trial_time_secs);
cum_trial_time_frames((1:task.trials),:) = cumsum(experiment1_task_design.trial_time_frames);
block_number((1:task.trials),:) = design.blocknumber;
run_number((1:task.trials),:) = task.run_number; 

experiment1_task_design.block_number = block_number; 
experiment1_task_design.run_number = run_number; 
experiment1_task_design.cum_trial_time_secs = cum_trial_time_secs; 
experiment1_task_design.cum_trial_time_frames = cum_trial_time_frames; 

%% Logging any errors into text file

log_errors = who("-regexp", '^error', '^warning');

z = fopen('experiment1_design_error_log.txt', 'w');

for i = 1:length(log_errors)
err_name = cell2mat(log_errors(i));
fprintf(z,'%s : %s\n', err_name, eval(err_name));
end

fclose('all');

clear i z

%% Tidying up workspace, removing all separated out variables, leaving any errors or warnings
clearvars -except subject* append design* data* mri rest key scr* stim task time experiment1* error* warning* log*

