%% Save Design 

%% Tidying up workspace, removing all separated out variables, leaving any errors or warnings
clearvars -except subject* append design* data* mri rest key scr* stim task time experiment1* error* warning* log*

%%

if subject_MRI == 1

    if exist(fullfile('execution','experiment1_task_design.csv'),'file')

        warning_MRIdesignfile = ('already an existing experiment design file')

        savechoice = input('Dont save new file (0), replace + archive copy of previous (1), replace + delete previous (2): ');

        if savechoice == 0

            disp('new experiment file not saved')
            clear savechoice 
            clear warning_designfile

        elseif savechoice == 1 %make a copy of the old execution file and save new

            disp('saving new file, previous file archived')

            datestamp = date; 

            clear savechoice 
            clear warning_designfile

            copyfile(fullfile('execution','experiment1_design.mat'), fullfile('archive',['experiment1_design_until-' datestamp '.mat']))
            copyfile(fullfile('execution','experiment1_task_design.csv'), fullfile('archive',['experiment1_task_design_until-' datestamp '.csv']))
            copyfile(fullfile('execution','experiment1_task_data.csv'), fullfile('archive',['experiment1_task_data_until-' datestamp '.csv']))
            copyfile('experiment1_design_error_log.txt', fullfile('archive',['experiment1_design_error_log' datestamp '.txt']))

            copyfile(fullfile('execution','experiment1_rest_design.csv'), fullfile('archive',['experiment1_rest_design_until-' datestamp '.csv']))
            copyfile(fullfile('execution','experiment1_rest_data.csv'), fullfile('archive',['experiment1_rest_data_until-' datestamp '.csv']))

            clear datestamp  

            save(fullfile('execution','experiment1_design.mat'));
            writetable(experiment1_task_design, fullfile('execution','experiment1_task_design.csv'));
            writetable(experiment1_task_data, fullfile('execution','experiment1_task_data.csv'));
            copyfile('experiment1_design_error_log.txt', fullfile('execution','experiment1_design_error_log.txt')); 

            writetable(experiment1_rest_design, fullfile('execution','experiment1_rest_design.csv'));
            writetable(experiment1_rest_data, fullfile('execution','experiment1_rest_data.csv'));
            copyfile('experiment1_design_error_log.txt', fullfile('execution','experiment1_design_error_log.txt')); 

        else %% savechoice == 2, overwrite completely and remove 

            disp('saving new file, previous file deleted')
            clear savechoice 
            clear warning_designfile

            save(fullfile('execution','experiment1_design.mat'));
            writetable(experiment1_task_design, fullfile('execution','experiment1_task_design.csv'));
            writetable(experiment1_task_data, fullfile('execution','experiment1_task_data.csv'));
            copyfile('experiment1_design_error_log.txt', fullfile('execution','experiment1_design_error_log.txt'));

            writetable(experiment1_rest_design, fullfile('execution','experiment1_rest_design.csv'));
            writetable(experiment1_rest_data, fullfile('execution','experiment1_rest_data.csv'));
        end




    else
        save(fullfile('execution','experiment1_design.mat'));
        writetable(experiment1_task_design, fullfile('execution','experiment1_task_design.csv'));
        writetable(experiment1_task_data, fullfile('execution','experiment1_task_data.csv'));
        copyfile('experiment1_design_error_log.txt', fullfile('execution','experiment1_design_error_log.txt'));

        writetable(experiment1_rest_design, fullfile('execution','experiment1_rest_design.csv'));
        writetable(experiment1_rest_data, fullfile('execution','experiment1_rest_data.csv'));
        copyfile('experiment1_design_error_log.txt', fullfile('execution','experiment1_design_error_log.txt')); 
    end
    
else %subject MRI == 0  test 

    if exist(fullfile('execution','experiment1_task_design_test.csv'),'file')

        warning_testdesignfile = ('already an existing experiment design file')

        savechoice = input('Dont save new file (0), replace + archive copy of previous (1), replace + delete previous (2): ');

        if savechoice == 0

            disp('new experiment file not saved')
            clear savechoice 
            clear warning_designfile

        elseif savechoice == 1 %make a copy of the old execution file and save new

            disp('saving new file, previous file archived')

            datestamp = date; 

            clear savechoice 
            clear warning_designfile

            copyfile(fullfile('execution','experiment1_design_test.mat'), fullfile('archive',['experiment1_design_test_until-' datestamp '.mat']))
            copyfile(fullfile('execution','experiment1_task_design_test.csv'), fullfile('archive',['experiment1_task_design_test_until-' datestamp '.csv']))
            copyfile(fullfile('execution','experiment1_task_data_test.csv'), fullfile('archive',['experiment1_task_data_test_until-' datestamp '.csv']))
            copyfile('experiment1_design_error_log.txt', fullfile('archive',['experiment1_design_error_log_test_until-' datestamp '.txt']))

            copyfile(fullfile('execution','experiment1_rest_design_test.csv'), fullfile('archive',['experiment1_rest_design_test_until-' datestamp '.csv']))
            copyfile(fullfile('execution','experiment1_rest_data_test.csv'), fullfile('archive',['experiment1_rest_data_test_until-' datestamp '.csv']))

            clear datestamp  

            save(fullfile('execution','experiment1_design_test.mat'));
            writetable(experiment1_task_design, fullfile('execution','experiment1_task_design_test.csv'));
            writetable(experiment1_task_data, fullfile('execution','experiment1_task_data_test.csv'));
            copyfile('experiment1_design_error_log.txt', fullfile('execution','experiment1_design_error_log_test.txt')); 

            writetable(experiment1_rest_design, fullfile('execution','experiment1_rest_design_test.csv'));
            writetable(experiment1_rest_data, fullfile('execution','experiment1_rest_data_test.csv'));

        else %% savechoice == 2, overwrite completely and remove 

            disp('saving new file, previous file deleted')
            clear savechoice 
            clear warning_designfile

            save(fullfile('execution','experiment1_design_test.mat'));
            writetable(experiment1_task_design, fullfile('execution','experiment1_task_design_test.csv'));
            writetable(experiment1_task_data, fullfile('execution','experiment1_task_data_test.csv'));
            copyfile('experiment1_design_error_log.txt', fullfile('execution','experiment1_design_error_log_test.txt'));

            writetable(experiment1_rest_design, fullfile('execution','experiment1_rest_design_test.csv'));
            writetable(experiment1_rest_data, fullfile('execution','experiment1_rest_data_test.csv'));
        end




    else
        save(fullfile('execution','experiment1_design_test.mat'));
        writetable(experiment1_task_design, fullfile('execution','experiment1_task_design_test.csv'));
        writetable(experiment1_task_data, fullfile('execution','experiment1_task_data_test.csv'));
        copyfile('experiment1_design_error_log.txt', fullfile('execution','experiment1_design_error_log_test.txt'));

        writetable(experiment1_rest_design, fullfile('execution','experiment1_rest_design_test.csv'));
        writetable(experiment1_rest_data, fullfile('execution','experiment1_rest_data_test.csv'));
        copyfile('experiment1_design_error_log.txt', fullfile('execution','experiment1_design_error_log_test.txt')); 
    end    
    
end

