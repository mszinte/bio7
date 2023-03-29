%% Experiment execution file 
% task: emotion localiser, run experimental runs

%% Clearing anything in the workspace

clear;
sca; 

%% add paths to various folders for scripts, data 
addpath('archive','config','conversion','data', 'execution','stimuli');

%% inputting participant details 

subject_no = input('Subject number?: ');
subject_run = input('Run number?: ');
subject_mode = input('test(0) or MRI(1)?: ');

%% Load experiment workspace

if subject_mode == 1

        load('experiment2_design.mat');
    
elseif subject_mode == 0
    
    load('experiment2_design_test.mat')

else
    error_input = ('non-valid input for MRI options')
    return

end


if subject_mode == subject_MRI
    %all ok 
else
    mode_error = ('loaded experiment file that does not correspond to input mode test/MRI')
    return
end

%% Check input paramaters and Load/ Create datafile 
% checks if inputs seem valid based on previous data to avoid overlap and 
% will check create or load datafile csv depending on run number/if it exists 

check_inputs

%% Set trial and block loop values based on run number

set_loopvalues

%% Re-test screen parameters
%will bug and stop experiment if screen Hz does not match desired Hz
%when in MRI mode, if in test mode will continue regardless

config_screen

setup_calculations

%% General experiment prep

%preventing random s's and keyboard letters being put in the code window
%commandwindow 
%initialise keyboard press to 0
keypressed = 0; 
%hides cursor from screen
%HideCursor; 


%% Launching experiment Psychtoolbox
%%


%% Opening screen utting up fixation cross screen
[screen.main, screenrect] = Screen(screen.number,'OpenWindow',screen.grey,[]); %coords for test mode
[~] = Screen('BlendFunction', screen.main, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
% screen.frame_duration_mfitest = Screen('GetFlipInterval', screen.main);
% screen.hz_mfitest = 1/screen.frame_duration_mfitest; 

screen.centerX = screen.rect(3)/2;
screen.centerY = screen.rect(4)/2;
Screen('TextSize', screen.main, screen.txt_size); %Reuter used 36.. 
Screen('TextFont', screen.main, screen.font);

Screen('DrawLines',screen.main, screen.line_fix_up_left, screen.line_width, screen.line_color, [], 1);
Screen('DrawLines',screen.main, screen.line_fix_up_right, screen.line_width, screen.line_color, [], 1);
Screen('DrawLines',screen.main, screen.line_fix_down_left, screen.line_width, screen.line_color, [], 1);
Screen('DrawLines',screen.main, screen.line_fix_down_right, screen.line_width, screen.line_color, [], 1);
Screen('FrameOval',screen.main,screen.line_color,...
    [screen.centerX-screen.fix_out_rim_rad...
    screen.centerY-screen.fix_out_rim_rad...
    screen.centerX+screen.fix_out_rim_rad...
    screen.centerY+screen.fix_out_rim_rad],...
    screen.line_width);
Screen('FrameOval',screen.main,screen.line_color,...
    [screen.centerX-screen.fix_rad ...
    screen.centerY-screen.fix_rad ...
    screen.centerX+screen.fix_rad ...
    screen.centerY+screen.fix_rad ],...
    screen.line_width);
Screen('Flip',screen.main);

%% Waiting for trigger 

commandwindow
HideCursor

disp('Waiting for trigger...')

% clear keyboard queue
while KbCheck 
end 

% wait for trigger
while ~KbCheck

DisableKeysForKbCheck([key.left1,key.left2,key.right1,key.right2]);

RestrictKeysForKbCheck([key.trigger, key.stop]);

[key_pressed, key_press_time, key_code] = KbCheck;

if key_code(key.stop)
    Screen('CloseAll');
    return
else
    %key_trigger
    %Saving timing onset for the run according to trigger time
    data.onset_run(subject_run) = key_press_time; 
end 

end

disp('experiment triggered')

RestrictKeysForKbCheck([]);
DisableKeysForKbCheck(key.trigger);

%%


%% Starting experiment
%%

onset_task = GetSecs;

for b = b_start:b_end
    
    %% Calculating trial number depending on block
    t_start = ((b - 1) * task.trialspblock) + 1; 
    t_end = t_start + task.trialspblock - 1;
    
    % Saving timing onset for the block according to block number
    data.onset_block(b) = GetSecs;    
    
    %% Preseting cue for resting block task, 10 seconds 
    
    % Putting cue on screen for 5 seconds 
    Screen('DrawText',screen.main, 'REGARDEZ', screen.centerX-180,screen.centerY-35, screen.txt_colour);
    Screen('DrawText',screen.main, 'Ne Repondez Pas', screen.centerX-320,screen.centerY+25, screen.txt_colour);
    Screen('Flip',screen.main);
    WaitSecs(5);
    
    % Changing to fixation cross for 5 seconds 
    Screen('DrawLines',screen.main, screen.line_fix_up_left, screen.line_width, screen.line_color, [], 1);
    Screen('DrawLines',screen.main, screen.line_fix_up_right, screen.line_width, screen.line_color, [], 1);
    Screen('DrawLines',screen.main, screen.line_fix_down_left, screen.line_width, screen.line_color, [], 1);
    Screen('DrawLines',screen.main, screen.line_fix_down_right, screen.line_width, screen.line_color, [], 1);
    Screen('FrameOval',screen.main,screen.line_color,...
        [screen.centerX-screen.fix_out_rim_rad...
        screen.centerY-screen.fix_out_rim_rad...
        screen.centerX+screen.fix_out_rim_rad... 
        screen.centerY+screen.fix_out_rim_rad],...
        screen.line_width);
    Screen('FrameOval',screen.main,screen.line_color,...
        [screen.centerX-screen.fix_rad ...
        screen.centerY-screen.fix_rad ...
        screen.centerX+screen.fix_rad ...
        screen.centerY+screen.fix_rad],...
        screen.line_width);
    Screen('Flip',screen.main);
    WaitSecs(5);  
    
   for t = t_start:t_end
       
       data.trial_number_check(t) = t; 
       
       %% Drawing image textures
          
        % Drawing target texture screen
        target_image = imread(stim.images.(cell2mat(experiment2_task_design.target_id(t)))(experiment2_task_design.image_number_ref(t)).name);
        target_texture = Screen('MakeTexture',screen.main,target_image); 

        image_size_original = size(target_image); 
        image_size_X = round(image_size_original(2)*stim.ScalingFactor); 
        image_size_Y = round(image_size_original(1)*stim.ScalingFactor);
        
        % Recording which image selected - target
        data.image_name_check(t) = cellstr(stim.images.(cell2mat(experiment2_task_design.target_id(t)))(experiment2_task_design.image_number_ref(t)).name);
    
        %% Presenting images 
        
        data.onset_trial(t) = GetSecs;

        %% 1. Showing target for different times (soa) 
        data.onset_target(t) = GetSecs; 
        
        soa_tic = 0;
        
        while soa_tic < (experiment2_task_design.soa_secs(t) - screen.frame_duration_mfitest)
            
            Screen('DrawLines',screen.main, screen.line_fix_up_left, screen.line_width, screen.line_color, [], 1);
            Screen('DrawLines',screen.main, screen.line_fix_up_right, screen.line_width, screen.line_color, [], 1);
            Screen('DrawLines',screen.main, screen.line_fix_down_left, screen.line_width, screen.line_color, [], 1);
            Screen('DrawLines',screen.main, screen.line_fix_down_right, screen.line_width, screen.line_color, [], 1);
            Screen('FrameOval',screen.main,screen.line_color,...
                [screen.centerX-screen.fix_out_rim_rad...
                screen.centerY-screen.fix_out_rim_rad...
                screen.centerX+screen.fix_out_rim_rad... 
                screen.centerY+screen.fix_out_rim_rad],...
                screen.line_width);
            Screen('FrameOval',screen.main,screen.line_color,...
                [screen.centerX-screen.fix_rad ...
                screen.centerY-screen.fix_rad ...
                screen.centerX+screen.fix_rad ...
                screen.centerY+screen.fix_rad],...
                screen.line_width);
            
            Screen('DrawTexture',screen.main, target_texture, [],...
                [experiment2_task_design.location_x(t)-(image_size_X/2)...
                experiment2_task_design.location_y(t)-(image_size_Y/2)...
                experiment2_task_design.location_x(t)+(image_size_X/2)...
                experiment2_task_design.location_y(t)+(image_size_Y/2)]);
            
            soa_flip = Screen('Flip',screen.main); 
            soa_tic = soa_flip-data.onset_target(t);
        end

        data.offset_trial(t) = GetSecs;
        
        %% Calculate durations for events 
        data.duration_target(t) = soa_flip - data.onset_target(t);
        data.duration_trial(t) = data.offset_trial(t) - data.onset_trial(t);
        
         %% Closing texture screens          
         Screen('Close', target_texture)
         
         clear target_texture target_image
   end

    %end of all trials in this block 
    
    data.offset_block(b) = GetSecs;
    
    % Changing to fixation cross for 5 seconds 
    Screen('DrawLines',screen.main, screen.line_fix_up_left, screen.line_width, screen.line_color, [], 1);
    Screen('DrawLines',screen.main, screen.line_fix_up_right, screen.line_width, screen.line_color, [], 1);
    Screen('DrawLines',screen.main, screen.line_fix_down_left, screen.line_width, screen.line_color, [], 1);
    Screen('DrawLines',screen.main, screen.line_fix_down_right, screen.line_width, screen.line_color, [], 1);
    Screen('FrameOval',screen.main,screen.line_color,...
        [screen.centerX-screen.fix_out_rim_rad...
        screen.centerY-screen.fix_out_rim_rad...
        screen.centerX+screen.fix_out_rim_rad... 
        screen.centerY+screen.fix_out_rim_rad],...
        screen.line_width);
    Screen('FrameOval',screen.main,screen.line_color,...
        [screen.centerX-screen.fix_rad ...
        screen.centerY-screen.fix_rad ...
        screen.centerX+screen.fix_rad ...
        screen.centerY+screen.fix_rad],...
        screen.line_width);
    Screen('Flip',screen.main);
    WaitSecs(20);


end

%end of all blocks, end of run

data.offset_run(subject_run) = GetSecs; 

%% Present screen to tell participant finished 
Screen('DrawText',screen.main, 'Fini', screen.centerX-45, screen.centerY-10, screen.txt_colour);
Screen('Flip', screen.main);

%% Saving the datafile into data 

save_data

%% Removes screen when any keyboard press 

disp('Experiment finished, waiting for stop key...');

RestrictKeysForKbCheck(key.stop);
DisableKeysForKbCheck(key.trigger);

while KbCheck 
    % clear keyboard queue
end 

while ~KbCheck 
    % wait for a stop key press
end

Screen('CloseAll');
