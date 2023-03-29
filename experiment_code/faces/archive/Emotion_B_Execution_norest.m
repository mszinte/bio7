%% Experiment execution file 
% task: emotion, run experimental runs

%% Clearing anything in the workspace

clear;
sca; 

%% add paths to various folders for scripts, data 
addpath('archive','config','data', 'execution','stimuli');

%% Load experiment workspace

%if the experiment has already been run and re-doing append will exist and
%be more than 0 after input to overwrite has been given 
if exist('append', 'var')
    
    % if no input to overwrite data given, load new workspace 
    if append == 0
        load('experiment1_design.mat');
    
    % else, want to re-run experiment but keep workspace alive, don't reload new workspace 
    else
        %do we need to remove some variables from the workspace? 
    end
else
    load('experiment1_design.mat')
end

%% inputting participant details 

subject_no = input('Subject number?: ');
subject_run = input('Run number?: ');
subject_MRI = input('test(0) or MRI(1)?: ');

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
[screen.main, screenrect] = Screen(screen.number,'OpenWindow',screen.grey); %coords for test mode
% screen.frame_duration_mfitest = Screen('GetFlipInterval', screen.main);
% screen.hz_mfitest = 1/screen.frame_duration_mfitest; 

screen.centerX = screen.rect(3)/2;
screen.centerY = screen.rect(4)/2;
Screen('TextSize', screen.main, screen.txt_size); %Reuter used 36.. 
Screen('TextFont', screen.main, screen.font);

Screen('DrawText',screen.main, '+', screen.centerX-25,screen.centerY-10);
Screen('Flip',screen.main);

%% Waiting for trigger 

commandwindow

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
end 

end

disp('experiment triggered')

RestrictKeysForKbCheck([]);
DisableKeysForKbCheck(key.trigger);

%%


%% Starting experiment
%%


%% Task - Making image texture and presenting images

% Saving timing onset for the task according to run number
data.onset_run(subject_run) = GetSecs;

for b = b_start:b_end
    
    % Saving timing onset for the block according to block number
    data.onset_block(b) = GetSecs;    
    
    %% Preseting cue for emotion choice, 10 seconds 
    
    % Putting cue on screen for 5 seconds 
    Screen('DrawText',screen.main, 'La Joie ou La Peur?', screen.centerX-350,screen.centerY-40);
    Screen('DrawText',screen.main, '(Gauche)  (Droite)', screen.centerX-350,screen.centerY+40);
    Screen('Flip',screen.main);
    WaitSecs(5);
    % Changing to fixation cross for 5 seconds 
    Screen('DrawText',screen.main, '+', screen.centerX-25,screen.centerY-10);
    Screen('Flip',screen.main);
    WaitSecs(5);  
    
    %% Calculating trial number depending on block
    t_start = ((b - 1) * task.trialspblock) + 1; 
    t_end = t_start + task.trialspblock - 1;
    
    for t = t_start:t_end
               
        %% Drawing image textures
          
        % Drawing target texture screen
        % to delete if code OK - target_image = imread(stim.images.(cell2mat(experiment1_design.target_id(t)))(t).name);
        target_image = imread(stim.images.(cell2mat(experiment1_design.target_id(t)))(experiment1_design.image_number_ref(t)).name);
        target_texture = Screen('MakeTexture',screen.main,target_image); 
        
        % Drawing mask texture screen
        mask_image = imread(stim.images.(cell2mat(experiment1_design.mask_id(t)))(experiment1_design.image_number_ref(t)).name);
        mask_texture = Screen('MakeTexture',screen.main,mask_image);
        
        image_size_original = size(target_image); 
        image_size_X = round(image_size_original(2)*stim.ScalingFactor); 
        image_size_Y = round(image_size_original(1)*stim.ScalingFactor);
        
        % Recording which image selected - target
        data.image_name_check(t) = cellstr(stim.images.(cell2mat(experiment1_design.target_id(t)))(experiment1_design.image_number_ref(t)).name);
           
        %% Presenting images 
        
        %% 1. Showing fixation cross for certain amount of jitter 
        data.onset_trial(t) = GetSecs;
        
        jitter_tic = 0;
        
        while jitter_tic < (experiment1_design.jitter_secs(t) - screen.frame_duration_mfitest)
            Screen('DrawText',screen.main, '+', screen.centerX-25,screen.centerY-10);
            jitter_flip = Screen('Flip',screen.main);
            jitter_tic = jitter_flip-data.onset_trial(t);
        end
        
        %% 2. Showing target for different times (soa) 
        data.onset_target(t) = GetSecs; 
        
        soa_tic = 0;
        
        while soa_tic < (experiment1_design.soa_secs(t) - screen.frame_duration_mfitest)
            Screen('DrawTexture',screen.main, target_texture, [],...
                [experiment1_design.location_x(t)-image_size_X...
                experiment1_design.location_y(t)-image_size_Y...
                experiment1_design.location_x(t)+image_size_X...
                experiment1_design.location_y(t)+image_size_Y]);
            Screen('DrawText',screen.main, '+', screen.centerX-25,screen.centerY-10);
            soa_flip = Screen('Flip',screen.main); 
            soa_tic = soa_flip-data.onset_target(t);
        end
        
        %% 3. Showing mask for fixed amount of time 
        
        data.onset_mask(t) = GetSecs;
        
        mask_tic = 0; 
        
        while mask_tic < (experiment1_design.mask_secs(t) - screen.frame_duration_mfitest)
            Screen('DrawTexture',screen.main, mask_texture, [],...
                [experiment1_design.location_x(t)-image_size_X...
                experiment1_design.location_y(t)-image_size_Y...
                experiment1_design.location_x(t)+image_size_X...
                experiment1_design.location_y(t)+image_size_Y]);
            Screen('DrawText',screen.main, '+', screen.centerX-25,screen.centerY-10);
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
        
        while response_tic < (experiment1_design.response_secs(t) - screen.frame_duration_mfitest)
    
            Screen('DrawText',screen.main, '+', screen.centerX-25,screen.centerY-10);
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
         
         %% Closing texture screens          
         Screen('Close', target_texture)
         Screen('Close', mask_texture)
         
         clear target_texture mask_texture target_image mask_image
    end
    %end of all trials in this block 
    
    data.offset_block(b) = GetSecs;
    
    %% Present fixation cross during break between blocks 
    Screen('DrawText',screen.main, '+', screen.centerX-25, screen.centerY-10);
    Screen('Flip', screen.main);
    
    WaitSecs(30);
    
end
%end of all blocks, end of run

data.offset_run(subject_run) = GetSecs; 
    
%% Present screen to tell participant finished 
Screen('DrawText',screen.main, 'Fini', screen.centerX-45, screen.centerY-10);
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
