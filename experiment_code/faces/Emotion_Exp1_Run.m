%% Experiment execution file 
% task: emotion, run experimental runs

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

        load('experiment1_design.mat');
    
elseif subject_mode == 0
    load('experiment1_design_test.mat')
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

%%


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


%% Task - Making image texture and presenting images

for b = b_start:b_end
    
    %% Calculating trial number depending on block
    t_start = ((b - 1) * task.trialspblock) + 1; 
    t_end = t_start + task.trialspblock - 1;
    
    % Saving timing onset for the block according to block number
    data.onset_block(b) = GetSecs;    
    
%% Preseting cue for emotion choice, 10 seconds 
    
    % Putting cue on screen for 5 seconds 
    Screen('DrawText',screen.main, 'REPONDEZ', screen.centerX-180,screen.centerY-70, screen.txt_colour);
    Screen('DrawText',screen.main, 'Joie  ou  Peur?', screen.centerX-295,screen.centerY-10, screen.txt_colour);
    Screen('DrawText',screen.main, '(Gauche)  (Droite)', screen.centerX-375,screen.centerY+50, screen.txt_colour);
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
        % to delete if code OK - target_image = imread(stim.images.(cell2mat(experiment1_design.target_id(t)))(t).name);
        target_image = imread(stim.images.(cell2mat(experiment1_task_design.target_id(t)))(experiment1_task_design.image_number_ref(t)).name);
        target_texture = Screen('MakeTexture',screen.main,target_image); 
        
        % Drawing mask texture screen
        mask_image = imread(stim.images.(cell2mat(experiment1_task_design.mask_id(t)))(experiment1_task_design.image_number_ref(t)).name);
        mask_texture = Screen('MakeTexture',screen.main,mask_image);
        
        image_size_original = size(target_image); 
        image_size_X = round(image_size_original(2)*stim.ScalingFactor); 
        image_size_Y = round(image_size_original(1)*stim.ScalingFactor);
        
        % Recording which image selected - target
        data.image_name_check(t) = cellstr(stim.images.(cell2mat(experiment1_task_design.target_id(t)))(experiment1_task_design.image_number_ref(t)).name);
 
        %% Presenting images 
        
        %% 1. Showing fixation cross for certain amount of jitter 
        data.onset_trial(t) = GetSecs;
        
        jitter_tic = 0;
        
        while jitter_tic < (experiment1_task_design.jitter_secs(t) - screen.frame_duration_mfitest)
            
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
            
            jitter_flip = Screen('Flip',screen.main);
            jitter_tic = jitter_flip-data.onset_trial(t);
        end
        
        %% 2. Showing target for different times (soa) 
        data.onset_target(t) = GetSecs; 
        
        soa_tic = 0;
        
        while soa_tic < (experiment1_task_design.soa_secs(t) - screen.frame_duration_mfitest)
            
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
                [experiment1_task_design.location_x(t)-(image_size_X/2)...
                experiment1_task_design.location_y(t)-(image_size_Y/2)...
                experiment1_task_design.location_x(t)+(image_size_X/2)...
                experiment1_task_design.location_y(t)+(image_size_Y/2)]);
            
            soa_flip = Screen('Flip',screen.main); 
            soa_tic = soa_flip-data.onset_target(t);
        end
        
        %% 3. Showing mask for fixed amount of time 
        
        data.onset_mask(t) = GetSecs;
        
        mask_tic = 0; 
        
        while mask_tic < (experiment1_task_design.mask_secs(t) - screen.frame_duration_mfitest)
            
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
            
            Screen('DrawTexture',screen.main, mask_texture, [],...
                [experiment1_task_design.location_x(t)-(image_size_X/2)...
                experiment1_task_design.location_y(t)-(image_size_Y/2)...
                experiment1_task_design.location_x(t)+(image_size_X/2)...
                experiment1_task_design.location_y(t)+(image_size_Y/2)]);
            
            mask_flip = Screen('Flip',screen.main);  
            mask_tic = mask_flip - data.onset_mask(t);
        end
        
        %% Clearing kb queue for checks 
        
        while KbCheck 
        end % clear keyboard queue
        FlushEvents('keyDown');
        key_code = [];
        key_pressed = 0;
        
        RestrictKeysForKbCheck([key.left1,key.left2,key.right1,key.right2, key.stop, key.pause]);
        DisableKeysForKbCheck(key.trigger);

        %% Showing fixation cross for fixed response time 

        data.onset_response(t) = GetSecs;
        response_tic = 0;
        
        while response_tic < (experiment1_task_design.response_secs(t) - screen.frame_duration_mfitest)
    
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
            
            response_flip = Screen('Flip',screen.main);    
            response_tic = response_flip-data.onset_response(t);
            
            [key_pressed, key_press_time, key_code] = KbCheck;
            
            FlushEvents('keyDown');   
            
            if key_pressed
                
                %only record the first key press, when data struct is still NaN
                if isnan(data.response_key(t))
                    
                    if key_code(key.left1)||key_code(key.left2)
                        data.response_time(t) = key_press_time;
                        data.reaction_time(t) = (key_press_time - data.onset_response(t));
                        
                        %Define the response key side and assigned code
                        %Keeping left as 1, as for location coding when 2 locations
                        data.response_key(t) = 1;
                        data.response_key_name(t) = cellstr('left');
                        clear key_pressed key_press_time key_code
                        
                    elseif key_code(key.right1)||key_code(key.right2)
                        data.response_time(t) = key_press_time;
                        data.reaction_time(t) = (key_press_time - data.onset_response(t));
                        
                        %Define the response key side and assigned code
                        %Keeping left as 1, as for location coding when 2 locations
                        data.response_key(t) = 2;
                        data.response_key_name(t) = cellstr('right');
                        clear key_pressed key_press_time key_code
                        
                    elseif key_code(key.stop)
                        
                        data.response_time(t) = key_press_time;
                        data.reaction_time(t) = (key_press_time - data.onset_response(t));
                        
                        %Define the response key code for stop, 999                       
                        data.response_key(t) = 999;
                        data.response_key_name(t) = cellstr('stop');

                        Screen('CloseAll');
                        clear key_pressed key_press_time key_code
                        return
                    else
                    end
                    
                else
                    %button has already been pressed
                    
                    %can still stop the experiment even after first response given
                    if key_code(key.stop)
                        
                        data.response_time(t) = key_press_time;
                        data.reaction_time(t) = (data.response_time(t) - data.onset_response(t));
                        
                        %Define the response key code for stop, 999                       
                        data.response_key(t) = 999;
                        data.response_key_name(t) = cellstr('stop');
                        Screen('CloseAll');
                        clear key_pressed key_press_time key_code
                        return
                    else
                    clear key_pressed key_press_time key_code    
                    end
                end
            else
                % no key pressed yet...
            end
        end
        % no more time to respond, end trial 
        
        data.offset_trial(t) = GetSecs;
        
        %% Calculate durations for events 
        data.duration_jitter(t) = jitter_flip - data.onset_trial(t);
        data.duration_target(t) = soa_flip - data.onset_target(t);
        data.duration_mask(t) = mask_flip - data.onset_mask(t);
        data.duration_response(t) = data.offset_trial(t) - data.onset_response(t);
        data.duration_trial(t) = data.offset_trial(t) - data.onset_trial(t);
        
         %% Closing texture screens          
         Screen('Close', target_texture)
         Screen('Close', mask_texture)
         
         clear target_texture mask_texture target_image mask_image
    end
    %end of all trials in this block 
    
    data.offset_block(b) = GetSecs;
    
    %% Calculating trial number depending on block
    r_start = ((b - 1) * rest.trialspblock) + 1; 
    r_end = r_start + rest.trialspblock - 1;
    
    data_rest.onset_block(b) = GetSecs;
    
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
      
    for r = r_start:r_end
        
        data_rest.trial_number_check(r) = r;
        
        %% Drawing image textures
          
        % Drawing target texture screen
        % to delete if code OK - target_image = imread(stim.images.(cell2mat(experiment1_design.target_id(t)))(t).name);
        target_image = imread(stim.images.(cell2mat(experiment1_rest_design.image_id(r)))(experiment1_rest_design.image_number_ref(r)).name);
        target_texture = Screen('MakeTexture',screen.main,target_image); 
        
        mask_image = imread(stim.images_blist.(cell2mat(experiment1_rest_design.image_id(r)))(experiment1_rest_design.image_number_ref(r)).name);
        mask_texture = Screen('MakeTexture',screen.main,mask_image); 
        
        image_size_original = size(target_image); 
        image_size_X = round(image_size_original(2)*stim.ScalingFactor); 
        image_size_Y = round(image_size_original(1)*stim.ScalingFactor);
        
        % Recording which image selected - target
        data_rest.image_name_check(r) = cellstr(stim.images.(cell2mat(experiment1_rest_design.image_id(r)))(experiment1_rest_design.image_number_ref(r)).name);
           
        %% Presenting images 
        
        %% 1. Showing fixation cross for certain amount of jitter 
        data_rest.onset_trial(r) = GetSecs;
        
        jitter_tic = 0;
        
        while jitter_tic < (experiment1_rest_design.jitter_secs(r) - screen.frame_duration_mfitest)
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
            jitter_flip = Screen('Flip',screen.main);
            jitter_tic = jitter_flip-data_rest.onset_trial(r);
        end
        
        %% 2. Showing target for different times (soa) 
        data_rest.onset_target(r) = GetSecs; 
        
        soa_tic = 0;
        
        while soa_tic < (experiment1_rest_design.soa_secs(r) - screen.frame_duration_mfitest)

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
                [experiment1_rest_design.location_x(r)-(image_size_X/2)...
                experiment1_rest_design.location_y(r)-(image_size_Y/2)...
                experiment1_rest_design.location_x(r)+(image_size_X/2)...
                experiment1_rest_design.location_y(r)+(image_size_Y/2)]);

            soa_flip = Screen('Flip',screen.main); 
            soa_tic = soa_flip-data_rest.onset_target(r);
        end
        
        %% 3. Showing mask for fixed amount of time 
        
        data_rest.onset_mask(r) = GetSecs;
        
        mask_tic = 0; 
        
        while mask_tic < (experiment1_rest_design.mask_secs(r) - screen.frame_duration_mfitest)
            
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
            
            Screen('DrawTexture',screen.main, mask_texture, [],...
                [experiment1_rest_design.location_x(r)-(image_size_X/2)...
                experiment1_rest_design.location_y(r)-(image_size_Y/2)...
                experiment1_rest_design.location_x(r)+(image_size_X/2)...
                experiment1_rest_design.location_y(r)+(image_size_Y/2)]);

            mask_flip = Screen('Flip',screen.main);  
            mask_tic = mask_flip - data_rest.onset_mask(r);
        end
         
        %% Showing fixation cross for fixed response time 

        data_rest.onset_response(r) = GetSecs;
        response_tic = 0;
        
        while response_tic < (experiment1_rest_design.response_secs(r) - screen.frame_duration_mfitest)
    
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
            
            response_flip = Screen('Flip',screen.main);    
            response_tic = response_flip-data_rest.onset_response(r);
        end
        
        data_rest.offset_trial(r) = GetSecs;
        
        %% Calculate durations for events 
        data_rest.duration_jitter(r) = jitter_flip - data_rest.onset_trial(r);
        data_rest.duration_target(r) = soa_flip - data_rest.onset_target(r);
        data_rest.duration_mask(r) = mask_flip - data_rest.onset_mask(r);
        data_rest.duration_response(r) = data_rest.offset_trial(r) - data_rest.onset_response(r);
        data_rest.duration_trial(r) = data_rest.offset_trial(r) - data_rest.onset_trial(r); 
         
         %% Closing texture screens          
         Screen('Close', target_texture)
         Screen('Close', mask_texture)
         
         clear target_texture mask_texture target_image mask_image

    end
    
    data_rest.offset_block(b) = GetSecs;
    
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
