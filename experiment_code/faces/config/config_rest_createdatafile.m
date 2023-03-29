%% Configuration file 
% Create experiment blank datatable 

%% Should be created only for run 1 unless override 

%% Creating structure for saving data
% column with trial_number index taken from sort id which is 
%linear 1:number of trials as design.trial_number is in randomised ordex 
data_rest.trial_number = design_rest.sort_id;
%making an empty matrix that will fill in trialnumber from execution, to
%double check the above
data_rest.trial_number_check = NaN(rest.trials,1);
data_rest.image_name_check = cell(rest.trials,1);

%empty columns for recorded onset times
data_rest.onset_run = NaN(rest.trials,1);
data_rest.onset_block = NaN(rest.trials,1);
data_rest.onset_trial = NaN(rest.trials,1);
data_rest.onset_target = NaN(rest.trials,1);
data_rest.onset_mask = NaN(rest.trials,1);
data_rest.onset_response = NaN(rest.trials,1);
data_rest.offset_trial = NaN(rest.trials,1);
data_rest.offset_block = NaN(rest.trials,1);
data_rest.offset_run = NaN(rest.trials,1);

%empty columns for recorded durations for each event 
data_rest.duration_run = NaN(rest.trials,1);
data_rest.duration_run_frames = NaN(rest.trials,1);
data_rest.duration_block = NaN(rest.trials,1);
data_rest.duration_block_frames = NaN(rest.trials,1);
data_rest.duration_trial = NaN(rest.trials,1);
data_rest.duration_trial_frames = NaN(rest.trials,1);
data_rest.duration_jitter = NaN(rest.trials,1);
data_rest.duration_jitter_frames = NaN(rest.trials,1);
data_rest.duration_target = NaN(rest.trials,1);
data_rest.duration_target_frames = NaN(rest.trials,1);
data_rest.duration_mask = NaN(rest.trials,1);
data_rest.duration_mask_frames = NaN(rest.trials,1);
data_rest.duration_response = NaN(rest.trials,1);
data_rest.duration_response_frames = NaN(rest.trials,1);

%empty columns for responses
data_rest.response_time = NaN(rest.trials,1);
data_rest.response_key = NaN(rest.trials,1);
data_rest.response_key_name = cell(rest.trials,1);
data_rest.response_correct = NaN(rest.trials,1);
data_rest.reaction_time = NaN(rest.trials,1);

%% Creating datatable for saving data
trial_number((1:rest.trials),:) = data_rest.trial_number;
trial_number_check((1:rest.trials),:) = data_rest.trial_number_check;
image_name_check = data_rest.image_name_check; 

%empty columns for responses
response_time((1:rest.trials),:) = data_rest.response_time;
response_key((1:rest.trials),:) = data_rest.response_key;
response_key_name((1:rest.trials),:) = data_rest.response_key_name;
response_correct((1:rest.trials),:) = data_rest.response_correct;
reaction_time((1:rest.trials),:) = data_rest.reaction_time;

%empty columns for recorded onset times
onset_run((1:rest.trials),:) = data_rest.onset_run;
onset_block((1:rest.trials),:) = data_rest.onset_block;
onset_trial((1:rest.trials),:) = data_rest.onset_trial;
onset_target((1:rest.trials),:) = data_rest.onset_target;
onset_mask((1:rest.trials),:) = data_rest.onset_mask;
onset_response((1:rest.trials),:) = data_rest.onset_response;
offset_trial((1:rest.trials),:) = data_rest.offset_trial;
offset_block((1:rest.trials),:) = data_rest.offset_block;
offset_run((1:rest.trials),:) = data_rest.offset_run;

%empty columns for recorded durations for each event 
duration_run((1:rest.trials),:) = data_rest.duration_run;
duration_run_frames((1:rest.trials),:) = data_rest.duration_run_frames;
duration_block((1:rest.trials),:) = data_rest.duration_block;
duration_block_frames((1:rest.trials),:) = data_rest.duration_block_frames;
duration_trial((1:rest.trials),:) = data_rest.duration_trial;
duration_trial_frames((1:rest.trials),:) = data_rest.duration_trial_frames;
duration_jitter((1:rest.trials),:) = data_rest.duration_jitter;
duration_jitter_frames((1:rest.trials),:) = data_rest.duration_jitter_frames;
duration_target((1:rest.trials),:) = data_rest.duration_target;
duration_target_frames((1:rest.trials),:) = data_rest.duration_target_frames;
duration_mask((1:rest.trials),:) = data_rest.duration_mask;
duration_mask_frames((1:rest.trials),:) = data_rest.duration_mask_frames;
duration_response((1:rest.trials),:) = data_rest.duration_response;
duration_response_frames((1:rest.trials),:) = data_rest.duration_response_frames;

experiment1_rest_data = table(trial_number,...
    trial_number_check,...
    image_name_check,...
    response_time,...
    response_key,...
    response_key_name,...
    response_correct,...
    reaction_time,...
    onset_run,...
    onset_block,...
    onset_trial,...
    onset_target,...
    onset_mask,...
    onset_response,...
    offset_trial,...
    offset_block,...
    offset_run,...
    duration_run,...
    duration_run_frames,...
    duration_block,...
    duration_block_frames,...
    duration_trial,...
    duration_trial_frames,...
    duration_jitter,...
    duration_jitter_frames,...
    duration_target,...
    duration_target_frames,...
    duration_mask,...
    duration_mask_frames,...
    duration_response,...
    duration_response_frames);

%% Tidying up workspace, removing all separated out variables, leaving any errors or warnings
clearvars -except subject* append design* data* mri rest key scr* stim task time experiment1* error* warning* log*

