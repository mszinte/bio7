%% Experiment save file 
% task: emotion, save matlab data workspaces and csv files 

%% Saving data only for executed runs

sv_t1 = ((b_start - 1) * task.trialspblock + 1);
sv_tn = t_end; 


%% attribute data to experiment2_data

data.duration_trial_frames = data.duration_trial / screen.frame_duration_mfitest;
data.duration_target_frames = data.duration_target / screen.frame_duration_mfitest;

%runs and blocks 
experiment2_task_data.onset_run(sv_t1) = data.onset_run(subject_run);
experiment2_task_data.offset_run(sv_tn) = data.offset_run(subject_run);

% this works when only 2 blocks in  a run, would need to make a loop
% otherwise 
for b = 1:task.blocks
    
        %% Calculating trial number depending on block
    sv_t_onset = ((b - 1) * task.trialspblock) + 1; 
    sv_t_offset = sv_t_onset + task.trialspblock - 1;
    
experiment2_task_data.onset_block(sv_t_onset) = data.onset_block(b);
experiment2_task_data.offset_block(sv_t_offset) = data.offset_block(b);

end



experiment2_task_data.trial_number_check(sv_t1:sv_tn) = data.trial_number_check(sv_t1:sv_tn);
experiment2_task_data.image_name_check(sv_t1:sv_tn) = data.image_name_check(sv_t1:sv_tn);

experiment2_task_data.onset_trial(sv_t1:sv_tn) = data.onset_trial(sv_t1:sv_tn);
experiment2_task_data.onset_target(sv_t1:sv_tn) = data.onset_target(sv_t1:sv_tn);
experiment2_task_data.offset_trial(sv_t1:sv_tn) = data.offset_trial(sv_t1:sv_tn);

experiment2_task_data.duration_trial(sv_t1:sv_tn) = data.duration_trial(sv_t1:sv_tn);
experiment2_task_data.duration_trial_frames(sv_t1:sv_tn) = data.duration_trial_frames(sv_t1:sv_tn);
experiment2_task_data.duration_target(sv_t1:sv_tn) = data.duration_target(sv_t1:sv_tn); 
experiment2_task_data.duration_target_frames(sv_t1:sv_tn) = data.duration_target_frames(sv_t1:sv_tn); 


%% Save data; named depending on different conditions 
if exist('exp_overwrite','var')
    
    if exp_overwrite == 1 %dont overwrite, append
        % file already existed, chose to make new file with appended rerun-(number) 
        if subject_MRI == 0 %test
        save(fullfile('data',['sub-00' int2str(subject_no) '_task-localiseremo_run-00' int2str(subject_run) '_test_rerun-' int2str(append) '.mat']));
        writetable(experiment2_task_data,fullfile('data',['sub-00' int2str(subject_no) '_task-localiseremo_data_test.csv']));

        else %MRI condition == 1 MRI
        save(fullfile('data',['sub-00' int2str(subject_no) '_task-localiseremo_run-00' int2str(subject_run) '_rerun-' int2str(append) '.mat']));
        writetable(experiment2_task_data, fullfile('data',['sub-00' int2str(subject_no) '_task-localiseremo_data.csv']));

        end

    else %exp_overwrite == 2 overwrite OR not asked about overwriting, no conflict, save normally

        % no file previously existed, or overwriting, making new file 
        if subject_MRI == 0 %test
        save(fullfile('data',['sub-00' int2str(subject_no) '_task-localiseremo_run-00' int2str(subject_run) '_test.mat']));
        writetable(experiment2_task_data, fullfile('data',['sub-00' int2str(subject_no) '_task-localiseremo_data_test.csv']));

        else %MRI condition == 1 MRI
        save(fullfile('data',['sub-00' int2str(subject_no) '_task-localiseremo_run-00' int2str(subject_run) '.mat']));
        writetable(experiment2_task_data, fullfile('data',['sub-00' int2str(subject_no) '_task-localiseremo_data.csv']));

        end
    end

else
        % no file previously existed, or overwriting, making new file 
    if subject_MRI == 0 %test
    save(fullfile('data',['sub-00' int2str(subject_no) '_task-localiseremo_run-00' int2str(subject_run) '_test.mat']));
    writetable(experiment2_task_data, fullfile('data',['sub-00' int2str(subject_no) '_task-localiseremo_data_test.csv']));

    else %MRI condition == 1 MRI
    save(fullfile('data',['sub-00' int2str(subject_no) '_task-localiseremo_run-00' int2str(subject_run) '.mat']));
    writetable(experiment2_task_data, fullfile('data',['sub-00' int2str(subject_no) '_task-localiseremo_data.csv']));

    end
end

    