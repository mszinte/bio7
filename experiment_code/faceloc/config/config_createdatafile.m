%% Configuration file 
% Create experiment blank datatable 

%% Should be created only for run 1 unless override 

%% Creating structure for saving data
% column with trial_number index taken from sort id which is 
%linear 1:number of trials as design.trial_number is in randomised ordex 
data.trial_number = design.sort_id;
%making an empty matrix that will fill in trialnumber from execution, to
%double check the above
data.trial_number_check = NaN(task.trials,1);
data.image_name_check = cell(task.trials,1);

%empty columns for recorded onset times
data.onset_run = NaN(task.trials,1);
data.onset_block = NaN(task.trials,1);
data.onset_trial = NaN(task.trials,1);
data.onset_target = NaN(task.trials,1);
data.offset_trial = NaN(task.trials,1);
data.offset_block = NaN(task.trials,1);
data.offset_run = NaN(task.trials,1);

%empty columns for recorded durations for each event 
data.duration_run = NaN(task.trials,1);
data.duration_run_frames = NaN(task.trials,1);
data.duration_block = NaN(task.trials,1);
data.duration_block_frames = NaN(task.trials,1);
data.duration_trial = NaN(task.trials,1);
data.duration_trial_frames = NaN(task.trials,1);
% data.duration_jitter = NaN(task.trials,1);
% data.duration_jitter_frames = NaN(task.trials,1);
data.duration_target = NaN(task.trials,1);
data.duration_target_frames = NaN(task.trials,1);

%% Creating datatable for saving data
trial_number((1:task.trials),:) = data.trial_number;
trial_number_check((1:task.trials),:) = data.trial_number_check;
image_name_check = data.image_name_check; 


%empty columns for recorded onset times
onset_run((1:task.trials),:) = data.onset_run;
onset_block((1:task.trials),:) = data.onset_block;
onset_trial((1:task.trials),:) = data.onset_trial;
onset_target((1:task.trials),:) = data.onset_target;
offset_trial((1:task.trials),:) = data.offset_trial;
offset_block((1:task.trials),:) = data.offset_block;
offset_run((1:task.trials),:) = data.offset_run;

%empty columns for recorded durations for each event 
duration_run((1:task.trials),:) = data.duration_run;
duration_run_frames((1:task.trials),:) = data.duration_run_frames;
duration_block((1:task.trials),:) = data.duration_block;
duration_block_frames((1:task.trials),:) = data.duration_block_frames;
duration_trial((1:task.trials),:) = data.duration_trial;
duration_trial_frames((1:task.trials),:) = data.duration_trial_frames;
% duration_jitter((1:task.trials),:) = data.duration_jitter;
% duration_jitter_frames((1:task.trials),:) = data.duration_jitter_frames;
duration_target((1:task.trials),:) = data.duration_target;
duration_target_frames((1:task.trials),:) = data.duration_target_frames;


experiment2_task_data = table(trial_number,...
    trial_number_check,...
    image_name_check,...
    onset_run,...
    onset_block,...
    onset_trial,...
    onset_target,...
    offset_trial,...
    offset_block,...
    offset_run,...
    duration_run,...
    duration_run_frames,...
    duration_block,...
    duration_block_frames,...
    duration_trial,...
    duration_trial_frames,...
    duration_target,...
    duration_target_frames);

%% Tidying up workspace, removing all separated out variables, leaving any errors or warnings
clearvars -except subject* append design* data* mri rest key scr* stim task time experiment* error* warning* log*

