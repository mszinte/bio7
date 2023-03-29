%% Configuration file 
% Create final experiment table 

%% Making variables to pull into one table
%trial 
trial_number((1:rest.trials),:) = design_rest.trialnumber;

%trial timings 
trial_time_secs((1:rest.trials),:) = design_rest.trial_time_secs;
trial_time_frames((1:rest.trials),:) = design_rest.trial_time_frames;
%placeholder for cumulative trial time, to calculate after 
cum_trial_time_secs((1:rest.trials),:) = NaN(rest.trials,1);
cum_trial_time_frames((1:rest.trials),:) = NaN(rest.trials,1);

%block
%placeholder for cumulative trial time, to calculate after 
block_number((1:rest.trials),:) = NaN(rest.trials,1);

%block
%placeholder for cumulative trial time, to calculate after 
run_number((1:rest.trials),:) = NaN(rest.trials,1);

%information on image
image_number((1:rest.trials),:) = design_rest.target_imagenumber;
image_agesexcat_ref((1:rest.trials),:) = design_rest.agesex_ref;
image_agesexemocat_ref((1:rest.trials),:) = design_rest.agesexemo_ref; 
image_number_ref((1:rest.trials),:) = design_rest.image_ref;
image_age_ref((1:rest.trials),:) = design_rest.ages_ref;
image_age((1:rest.trials),:) = design_rest.ages_name;
image_sex_ref((1:rest.trials),:) = design_rest.sexs_ref;
image_sex((1:rest.trials),:) = design_rest.sexs_name;
image_emotion_ref((1:rest.trials),:) = design_rest.emotions_ref;
image_emotion((1:rest.trials),:) = design_rest.emotions_name;
image_id((1:rest.trials),:) = design_rest.agesexemo_id;
image_fullid((1:rest.trials),:) = design_rest.agesexemo;
image_pos_ref = design_rest.imagepos_ref;

target_imagename((1:rest.trials),:) = strcat(design_rest.target_imagenumber_str,'_',design_rest.agesexemo_id, stim.list);
mask_imagename((1:rest.trials),:) = strcat(design_rest.mask_imagenumber_str,'_',design_rest.agesexemo_id, stim.listb);


%location of target-mask
location_name((1:rest.trials),:) = design_rest.loc_name;
location((1:rest.trials),:) = design_rest.loc_ref; 
location_x((1:rest.trials),:) = design_rest.loc_x; 
location_y((1:rest.trials),:) = design_rest.loc_y; 


%soas / target time
soa_ref((1:rest.trials),:) = design_rest.soa_ref;
soa_secs((1:rest.trials),:) = design_rest.soa_secs;
soa_frames((1:rest.trials),:) = design_rest.soa_frames;
%mask time
mask_secs((1:rest.trials),:) = design_rest.mask_secs;
mask_frames((1:rest.trials),:) = design_rest.mask_frames;
%jitters
jitter_ref((1:rest.trials),:) = design_rest.jitter_ref;
jitter_secs((1:rest.trials),:) = design_rest.jitter_secs;
jitter_frames((1:rest.trials),:) = design_rest.jitter_frames;
%fixation cross response time
response_secs((1:rest.trials),:) = design_rest.response_secs;
response_frames((1:rest.trials),:) = design_rest.response_frames;

experiment1_rest_design = table(trial_number,...
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
    image_emotion,...
    image_emotion_ref,...
    image_id,...
    image_fullid,...
    target_imagename,...
    mask_imagename,...
    image_pos_ref,...
    location_name,...
    location,...
    location_x,...
    location_y,...
    soa_ref,...
    soa_secs,...
    soa_frames,...
    mask_secs,...
    mask_frames,...
    jitter_ref,...
    jitter_secs,...
    jitter_frames,...
    response_secs,...
    response_frames);


%sort experiment based on trial number
experiment1_rest_design = sortrows(experiment1_rest_design,'trial_number');

%add run number block number and cumulative experiment time 
cum_trial_time_secs((1:rest.trials),:) = cumsum(experiment1_rest_design.trial_time_secs);
cum_trial_time_frames((1:rest.trials),:) = cumsum(experiment1_rest_design.trial_time_frames);

experiment1_rest_design.block_number = design_rest.blocknumber; 
experiment1_rest_design.run_number = design_rest.run_number; 
experiment1_rest_design.cum_trial_time_secs = cum_trial_time_secs; 
experiment1_rest_design.cum_trial_time_frames = cum_trial_time_frames; 

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

