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

%% Preseting cue for emotion choice, 10 seconds 
    
    % Putting cue on screen for 5 seconds 
    Screen('DrawText',screen.main, '+', screen.centerX-25,screen.centerY-10);
    Screen('DrawText',screen.main, 'REPONDEZ', screen.centerX-180,screen.centerY-70);
    Screen('DrawText',screen.main, 'Joie  ou  Peur?', screen.centerX-295,screen.centerY-10);
    Screen('DrawText',screen.main, '(Gauche)  (Droite)', screen.centerX-375,screen.centerY+50);
    Screen('Flip',screen.main);
    WaitSecs(5);
    % Changing to fixation cross for 5 seconds 
    Screen('DrawText',screen.main, '+', screen.centerX-25,screen.centerY-10);
    Screen('Flip',screen.main);
    WaitSecs(5); 
    
    
        %% Preseting cue for resting block task, 10 seconds 
    
    % Putting cue on screen for 5 seconds 
    Screen('DrawText',screen.main, '+', screen.centerX-25,screen.centerY-10);
    Screen('DrawText',screen.main, 'REGARDEZ', screen.centerX-180,screen.centerY-35);
    Screen('DrawText',screen.main, 'Ne Repondez Pas', screen.centerX-320,screen.centerY+25);
    Screen('Flip',screen.main);
    WaitSecs(5);
    % Changing to fixation cross for 5 seconds 
    Screen('DrawText',screen.main, '+', screen.centerX-25,screen.centerY-10);
    Screen('Flip',screen.main);
    WaitSecs(5);  
    
    Screen('CloseAll');