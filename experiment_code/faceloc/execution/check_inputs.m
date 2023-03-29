%% Task execution setup file
% Check input experiment parameters


%% Check if there is already a matlab datafile corresponding to inputs
% if not file will be created at end of run
append = 0;

if subject_MRI == 1

    if exist((fullfile('data',['sub-00' int2str(subject_no) '_task-localiseremo_run-00' int2str(subject_run) '.mat'])),'file')

        warning_input = ('MRI data with specified paramaters already exists')

        exp_overwrite = input('stop, (0), append number (1) or overwrite (2) data?: ');

        if exp_overwrite == 0
             error_data = ('experiment stopped, check existing data files or redefine inputs')
             return
        elseif exp_overwrite == 1
            append = append + 1; 
            %make append index which will be added to saved filename 
        elseif exp_overwrite == 2
            %do nothing to filename, data will be overwritten
        else
            error_input2 = ('non-valid input for file options, try again')
            return 
        end
        
    else
        %all ok, go head, mat file will be created at the end of the
        %experiment with save_data
        
    end
    
else %subject_MRI == 0 % test mode 
    if exist((fullfile('data',['sub-00' int2str(subject_no) '_task-localiseremo_run-00' int2str(subject_run) '_test.mat'])),'file')
        
        warning_input = ('test data with specified paramaters already exists')

        exp_overwrite = input('stop, (0), append number (1) or overwrite (2) data?: ');

        if exp_overwrite == 0
             error_data = ('experiment stopped, check existing data files or redefine inputs')
             return
        elseif exp_overwrite == 1
            append = append + 1; 
            %make append index which will be added to saved filename 
        elseif exp_overwrite == 2
            %do nothing to filename, data will be overwritten
        else
            error_input2 = ('non-valid input for file options, try again')
            return 
        end
    else
        %all ok, go head, mat file will be created at the end of the
        %experiment with save_data
    end
end




%% Checking if there is already an existing csv datafile from previous runs 

if subject_MRI == 0 %test 
   
    % If file exists already, open the datafile and read into workspace 
    
    if exist((fullfile('data',['sub-00' int2str(subject_no) '_task-localiseremo_data_test.csv'])),'file')

        %file exists, but, if it is run 1, question to experimentator
        if subject_run == 1
            
            warning_datafile = ('Starting run 1 but data with these parameters exists already?')
            
            create = input('Load existing csv datafile and overwrite data? No - Stop (0), Yes (1): ');           
            
            if create == 0
                disp('check data files before continuing or change inputs');
                return 
            else
                experiment2_task_data = readtable(fullfile('data',['sub-00' int2str(subject_no) '_task-localiseremo_data_test.csv']));
            end
        
            clear create
            
        else
            %ok to load previous datafile 
            
            disp('loading previous csv')
            experiment2_task_data = readtable(fullfile('data',['sub-00' int2str(subject_no) '_task-localiseremo_data_test.csv']));
        end
     
     
    else
       
        %file doesnt exists, but, if it is not run 1, question to experimentator
        if subject_run ~= 1
            
            warning_datafile = ('Starting a run > run 1 but no previous data with these parameters exists?')
            
            create = input('Continue anyway despite no run 1 data? No - Stop (0), Yes (1): ');           
            
            if create == 0
                disp('check data files before continuing or change inputs');
                return 
            else
                %no previous datafile and run 1 but still
                % continue with blank raw datafile 
            end
            
            clear create
          
        else
            % no previous data file and is run 1
            % continue with blank raw datafile   
        end
    end
    
    
    
else %MRI condition == 1 MRI
    
    % If file exists already, open the datafile and read into workspace 
    
    if exist((fullfile('data',['sub-00' int2str(subject_no) '_task-localiseremo_data.csv'])),'file')

        %file exists, but, if it is run 1, question to experimentator
        if subject_run == 1
            
            warning_datafile = ('Starting run 1 but data with these parameters exists already?')
            
            create = input('Load existing csv datafile and overwrite data? No - Stop (0), Yes (1): ');           
            
            if create == 0
                disp('check data files before continuing or change inputs');
                return 
            else
                experiment2_task_data = readtable(fullfile('data',['sub-00' int2str(subject_no) '_task-localiseremo_data.csv']));
            end
        
            clear create
            
        else
            %ok to load previous datafile 
            experiment2_task_data = readtable(fullfile('data',['sub-00' int2str(subject_no) '_task-localiseremo_data.csv']));
        end
     
     
    else
       
        %file doesnt exists, but, if it is not run 1, question to experimentator
        if subject_run ~= 1
            
            warning_datafile = ('Starting a run > run 1 but no previous data with these parameters exists?')
            
            create = input('Continue anyway despite no run 1 data? No - Stop (0), Yes (1): ');           
            
            if create == 0
                disp('check data files before continuing or change inputs');
                return 
            else
                %no previous datafile and run 1 but still
                % continue with blank raw datafile 
            end
            
            clear create
        
        else
            % no previous data file and is run 1
            % continue with blank raw datafile 
        end
    end

end
