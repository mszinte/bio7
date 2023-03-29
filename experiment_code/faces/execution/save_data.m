%% Experiment save file 
% task: emotion, save matlab data workspaces and csv files 

%% Saving data only for executed runs

sv_t1 = ((b_start - 1) * task.trialspblock + 1);
sv_tn = t_end; 

sv_r1 = ((b_start - 1) * rest.trialspblock + 1);
sv_rn = r_end; 


%% attribute data to experiment1_data

data.duration_trial_frames = data.duration_trial / screen.frame_duration_mfitest;
data.duration_jitter_frames = data.duration_jitter / screen.frame_duration_mfitest;
data.duration_target_frames = data.duration_target / screen.frame_duration_mfitest;
data.duration_mask_frames = data.duration_mask / screen.frame_duration_mfitest;
data.duration_response_frames = data.duration_response / screen.frame_duration_mfitest;

%runs and blocks 
experiment1_task_data.onset_run(sv_t1) = data.onset_run(subject_run);
experiment1_task_data.offset_run(sv_tn) = data.offset_run(subject_run);

% this works when only 2 blocks in  a run, would need to make a loop
% otherwise 
experiment1_task_data.onset_block(sv_t1) = data.onset_block(b_start);
experiment1_task_data.onset_block(t_start) = data.onset_block(b_end);
experiment1_task_data.offset_block(t_start - 1) = data.offset_block(b_start);
experiment1_task_data.offset_block(sv_tn) = data.offset_block(b_end);



experiment1_task_data.trial_number_check(sv_t1:sv_tn) = data.trial_number_check(sv_t1:sv_tn);
experiment1_task_data.image_name_check(sv_t1:sv_tn) = data.image_name_check(sv_t1:sv_tn);

experiment1_task_data.response_time(sv_t1:sv_tn) = data.response_time(sv_t1:sv_tn);
experiment1_task_data.response_key(sv_t1:sv_tn) = data.response_key(sv_t1:sv_tn);
experiment1_task_data.response_key_name(sv_t1:sv_tn) = data.response_key_name(sv_t1:sv_tn);
experiment1_task_data.response_correct(sv_t1:sv_tn) = data.response_correct(sv_t1:sv_tn);
experiment1_task_data.reaction_time(sv_t1:sv_tn) = data.reaction_time(sv_t1:sv_tn);

experiment1_task_data.onset_trial(sv_t1:sv_tn) = data.onset_trial(sv_t1:sv_tn);
experiment1_task_data.onset_target(sv_t1:sv_tn) = data.onset_target(sv_t1:sv_tn);
experiment1_task_data.onset_mask(sv_t1:sv_tn) = data.onset_mask(sv_t1:sv_tn);
experiment1_task_data.onset_response(sv_t1:sv_tn) = data.onset_response(sv_t1:sv_tn);
experiment1_task_data.offset_trial(sv_t1:sv_tn) = data.offset_trial(sv_t1:sv_tn);

experiment1_task_data.duration_trial(sv_t1:sv_tn) = data.duration_trial(sv_t1:sv_tn);
experiment1_task_data.duration_trial_frames(sv_t1:sv_tn) = data.duration_trial_frames(sv_t1:sv_tn);
experiment1_task_data.duration_jitter(sv_t1:sv_tn) = data.duration_jitter(sv_t1:sv_tn);
experiment1_task_data.duration_jitter_frames(sv_t1:sv_tn) = data.duration_jitter_frames(sv_t1:sv_tn);
experiment1_task_data.duration_target(sv_t1:sv_tn) = data.duration_target(sv_t1:sv_tn); 
experiment1_task_data.duration_target_frames(sv_t1:sv_tn) = data.duration_target_frames(sv_t1:sv_tn); 
experiment1_task_data.duration_mask(sv_t1:sv_tn) = data.duration_mask(sv_t1:sv_tn);
experiment1_task_data.duration_mask_frames(sv_t1:sv_tn) = data.duration_mask_frames(sv_t1:sv_tn);
experiment1_task_data.duration_response(sv_t1:sv_tn) = data.duration_response(sv_t1:sv_tn);
experiment1_task_data.duration_response_frames(sv_t1:sv_tn) = data.duration_response_frames(sv_t1:sv_tn);


%% attribute data to experiment1_rest_data

data_rest.duration_trial_frames = data_rest.duration_trial / screen.frame_duration_mfitest;
data_rest.duration_jitter_frames = data_rest.duration_jitter / screen.frame_duration_mfitest;
data_rest.duration_target_frames = data_rest.duration_target / screen.frame_duration_mfitest;
data_rest.duration_mask_frames = data_rest.duration_mask / screen.frame_duration_mfitest;
data_rest.duration_response_frames = data_rest.duration_response / screen.frame_duration_mfitest;

%runs and blocks 
experiment1_rest_data.onset_run(sv_r1) = data.onset_run(subject_run);
experiment1_rest_data.offset_run(sv_rn) = data.offset_run(subject_run);

% this works when only 2 blocks in  a run, would need to make a loop
% otherwise 
experiment1_rest_data.onset_block(sv_r1) = data.onset_block(b_start);
experiment1_rest_data.onset_block(r_start) = data.onset_block(b_end);
experiment1_rest_data.offset_block(r_start - 1) = data.offset_block(b_start);
experiment1_rest_data.offset_block(sv_rn) = data.offset_block(b_end);

experiment1_rest_data.trial_number_check(sv_r1:sv_rn) = data_rest.trial_number_check(sv_r1:sv_rn);
experiment1_rest_data.image_name_check(sv_r1:sv_rn) = data_rest.image_name_check(sv_r1:sv_rn);

experiment1_rest_data.onset_trial(sv_r1:sv_rn) = data_rest.onset_trial(sv_r1:sv_rn);
experiment1_rest_data.onset_target(sv_r1:sv_rn) = data_rest.onset_target(sv_r1:sv_rn);
experiment1_rest_data.onset_mask(sv_r1:sv_rn) = data_rest.onset_mask(sv_r1:sv_rn);
experiment1_rest_data.onset_response(sv_r1:sv_rn) = data_rest.onset_response(sv_r1:sv_rn);
experiment1_rest_data.offset_trial(sv_r1:sv_rn) = data_rest.offset_trial(sv_r1:sv_rn);

experiment1_rest_data.duration_run(sv_r1:sv_rn) = data_rest.duration_run(sv_r1:sv_rn);
experiment1_rest_data.duration_run_frames(sv_r1:sv_rn) = data_rest.duration_run_frames(sv_r1:sv_rn);
experiment1_rest_data.duration_block(sv_r1:sv_rn) = data_rest.duration_block(sv_r1:sv_rn);
experiment1_rest_data.duration_block_frames(sv_r1:sv_rn) = data_rest.duration_block_frames(sv_r1:sv_rn);
experiment1_rest_data.duration_trial(sv_r1:sv_rn) = data_rest.duration_trial(sv_r1:sv_rn);
experiment1_rest_data.duration_trial_frames(sv_r1:sv_rn) = data_rest.duration_trial_frames(sv_r1:sv_rn);
experiment1_rest_data.duration_jitter(sv_r1:sv_rn) = data_rest.duration_jitter(sv_r1:sv_rn);
experiment1_rest_data.duration_jitter_frames(sv_r1:sv_rn) = data_rest.duration_jitter_frames(sv_r1:sv_rn);
experiment1_rest_data.duration_target(sv_r1:sv_rn) = data_rest.duration_target(sv_r1:sv_rn); 
experiment1_rest_data.duration_target_frames(sv_r1:sv_rn) = data_rest.duration_target_frames(sv_r1:sv_rn); 
experiment1_rest_data.duration_mask(sv_r1:sv_rn) = data_rest.duration_mask(sv_r1:sv_rn);
experiment1_rest_data.duration_mask_frames(sv_r1:sv_rn) = data_rest.duration_mask_frames(sv_r1:sv_rn);
experiment1_rest_data.duration_response(sv_r1:sv_rn) = data_rest.duration_response(sv_r1:sv_rn);
experiment1_rest_data.duration_response_frames(sv_r1:sv_rn) = data_rest.duration_response_frames(sv_r1:sv_rn);
    

%% Save data; named depending on different conditions 
if exist('exp_overwrite','var')
    
    if exp_overwrite == 1 %dont overwrite, append
        % file already existed, chose to make new file with appended rerun-(number) 
        if subject_MRI == 0 %test
        save(fullfile('data',['sub-00' int2str(subject_no) '_task-emotion_run-00' int2str(subject_run) '_test_rerun-' int2str(append) '.mat']));
        writetable(experiment1_task_data,fullfile('data',['sub-00' int2str(subject_no) '_task-emotion_data_test.csv']));
        writetable(experiment1_rest_data,fullfile('data',['sub-00' int2str(subject_no) '_task-emotion_rest_data_test.csv']));
        else %MRI condition == 1 MRI
        save(fullfile('data',['sub-00' int2str(subject_no) '_task-emotion_run-00' int2str(subject_run) '_rerun-' int2str(append) '.mat']));
        writetable(experiment1_task_data, fullfile('data',['sub-00' int2str(subject_no) '_task-emotion_data.csv']));
        writetable(experiment1_rest_data,fullfile('data',['sub-00' int2str(subject_no) '_task-emotion_rest_data.csv']));
        end

    else %exp_overwrite == 2 overwrite OR not asked about overwriting, no conflict, save normally

        % no file previously existed, or overwriting, making new file 
        if subject_MRI == 0 %test
        save(fullfile('data',['sub-00' int2str(subject_no) '_task-emotion_run-00' int2str(subject_run) '_test.mat']));
        writetable(experiment1_task_data, fullfile('data',['sub-00' int2str(subject_no) '_task-emotion_data_test.csv']));
        writetable(experiment1_rest_data,fullfile('data',['sub-00' int2str(subject_no) '_task-emotion_rest_data_test.csv']));
        else %MRI condition == 1 MRI
        save(fullfile('data',['sub-00' int2str(subject_no) '_task-emotion_run-00' int2str(subject_run) '.mat']));
        writetable(experiment1_task_data, fullfile('data',['sub-00' int2str(subject_no) '_task-emotion_data.csv']));
        writetable(experiment1_rest_data,fullfile('data',['sub-00' int2str(subject_no) '_task-emotion_rest_data.csv']));
        end
    end

else
        % no file previously existed, or overwriting, making new file 
    if subject_MRI == 0 %test
    save(fullfile('data',['sub-00' int2str(subject_no) '_task-emotion_run-00' int2str(subject_run) '_test.mat']));
    writetable(experiment1_task_data, fullfile('data',['sub-00' int2str(subject_no) '_task-emotion_data_test.csv']));
    writetable(experiment1_rest_data,fullfile('data',['sub-00' int2str(subject_no) '_task-emotion_rest_data_test.csv']));
    else %MRI condition == 1 MRI
    save(fullfile('data',['sub-00' int2str(subject_no) '_task-emotion_run-00' int2str(subject_run) '.mat']));
    writetable(experiment1_task_data, fullfile('data',['sub-00' int2str(subject_no) '_task-emotion_data.csv']));
    writetable(experiment1_rest_data,fullfile('data',['sub-00' int2str(subject_no) '_task-emotion_rest_data.csv']));
    end
end

    