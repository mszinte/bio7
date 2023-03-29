%% prepare screen parameters and display screen
clear;
sca;

screen = Screen('Screens');
screenNumber = max(screens);
Screen('Preference', 'SkipSyncTests', 1);
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white*0.34;

% running in real full screen mode 
[window, screenrect] = Screen(screenNumber,'OpenWindow',grey);
% running in testing mode - small screen....
%[window, screenrect] = Screen(screenNumber,'OpenWindow',grey,[0 0 900 600]);

Screen('TextSize', window, 30);
Screen('TextFont', window, 'courier new');
Screen('Flip', window);
monitorflipinterval = Screen('GetFlipInterval', window);

%% get screen locations for presentation

x_center = screenrect(3)/2;
y_center = screenrect(4)/2;

loc_R = [(x_center+200) (y_center)];
loc_L = [(x_center-200) (y_center)];

%% keyboard and cursor parameters

commandwindow %preventing random s's and keyboard letters being put in the code window

KbName('UnifyKeyNames')
key_stop = KbName('x');
key_pause = KbName('p');
key_left = KbName('b'); %'b' % left button index (inside)
key_left2 = KbName('a'); %'a' % left button thumb (outside)
key_right = KbName('c'); %'c' % right button index (inside)
key_right2 = KbName('d'); %'d' % right button thumb (outside)
key_trigger = KbName('s');

keypressed = 0; %initialise keyboard press to 0
HideCursor; %can uncomment when debugging is finished 

%% Close Screen

Screen('CloseAll')

%% Task parameters

trials = 40; % if not divisible by 2/4 will get warnings for condn randomisation equality
blocks = 8;

time_mask = 0.100; %ms mask shown on screen 
time_mask_frames = round(time_mask/monitorflipinterval);
time_fix = 1.500;
time_fix_frames = round(time_fix/monitorflipinterval);

soa_zero = 20; %soa min value %was 20 before
soa_lower = 30; %lower boundary of soa step distrib
soa_upper = 250; %upper boundary of soa step distrib
soa_max = 330; %max value for soa check
reps_p_soa = 12; %no of repetitions at each soa value 

jitter_min = 500;
jitter_max = 1000;

image_size_scalingf = 0.05;

%% Setting up image paths 

%face_path = '/Volumes/users/ptilsley/VisualTask/FACES';
%face_path = 'C:\Users\Tilsley\Documents\Visual_Task\VisualTask\FACES';
face_path = 'C:\Users\Penelope\Desktop\Visual_Task\VisualTask\FACES';

if isfolder(face_path) == 1
    %fodler exists, do nothing
else
    %error, need to change path
    PathError = sprintf('Check face folder path') % 
    return
end

%% Loading image list into MATLAB and creating randomised order index

disp('Loading images...')

image_list_sad = dir(fullfile(face_path,'*s_a.jpg'));
image_list_sad = image_list_sad(~startsWith({image_list_sad.name}, '.'));
image_length_sad = length(image_list_sad);

image_list_fea = dir(fullfile(face_path,'*f_a.jpg'));
image_list_fea = image_list_fea(~startsWith({image_list_fea.name}, '.'));
image_length_fea = length(image_list_fea);

image_list_hap = dir(fullfile(face_path,'*h_a.jpg'));
image_list_hap = image_list_hap(~startsWith({image_list_hap.name}, '.'));
image_length_hap = length(image_list_hap);

image_list_neu = dir(fullfile(face_path,'*n_a.jpg'));
image_list_neu = image_list_neu(~startsWith({image_list_neu.name}, '.'));
image_length_neu = length(image_list_neu);

%% Randomising image orders 

%calculating number of shuffles needed 
tot_trials = trials*blocks;
reps = ceil(tot_trials/171); %making extra than needed for simplicity

image_rindexs_fea = zeros(reps, 171);
image_rindexs_hap = zeros(reps, 171);
image_rindexs_sad = zeros(reps, 171);
image_rindexs_neu = zeros(reps, 171);

for i = 1:reps
    
image_rindex_fea = Shuffle(1:image_length_fea);        
image_rindex_hap = Shuffle(1:image_length_hap);
image_rindex_sad = Shuffle(1:image_length_sad);
image_rindex_neu = Shuffle(1:image_length_neu);

image_rindexs_fea(i,:) = image_rindex_fea;
image_rindexs_hap(i,:) = image_rindex_hap;
image_rindexs_sad(i,:) = image_rindex_sad;
image_rindexs_neu(i,:) = image_rindex_neu;

%Additional pt 2
image_rindex2_neu = Shuffle(1:image_length_neu);
image_rindexs2_neu(i,:) = image_rindex2_neu;

image_rindex3_neu = Shuffle(1:image_length_neu);
image_rindexs3_neu(i,:) = image_rindex3_neu;

end

image_rindexs_fea = image_rindexs_fea(:);
image_rindexs_hap = image_rindexs_hap(:);
image_rindexs_sad = image_rindexs_sad(:);
image_rindexs_neu = image_rindexs_neu(:);
image_rindexs2_neu = image_rindexs2_neu(:);
image_rindexs3_neu = image_rindexs3_neu(:);

% setting image counters for future randomisation pulling index no's
cnt_fea = 0; 
cnt_hap = 0;
cnt_sad = 0;
cnt_neu = 0;
cnt_neu2 =0;

%% Randomising task parameters

disp('Randomising task timing...')

%setting empty matrices of correct length 
soas_s = NaN(blocks,trials);
soas_frames = NaN(blocks,trials);
jitters_s = NaN(blocks,trials);
jitters_frames = NaN(blocks,trials);
targets_s = NaN(blocks,trials);
targets_frames = NaN(blocks,trials);
locs_rand = NaN(blocks,trials);
keys_which  = NaN(blocks,trials);
keys_taps = NaN(blocks,trials); 

onset_trials = NaN(blocks,trials);
onset_jitters = NaN(blocks,trials);
offset_jitters = NaN(blocks,trials);
onset_targets = NaN(blocks,trials);
offset_targets = NaN(blocks,trials);
onset_fix1s = NaN(blocks,trials);
onset_soas = NaN(blocks,trials);
offset_soas = NaN(blocks,trials);   
onset_masks = NaN(blocks,trials);
offset_masks = NaN(blocks,trials);
onset_fix2s = NaN(blocks,trials);
offset_trials = NaN(blocks,trials);

jitter_durations = NaN(blocks,trials);
target_durations = NaN(blocks,trials);
mask_durations = NaN(blocks,trials);
soa_durations = NaN(blocks,trials);
fix_durations = NaN(blocks, trials);

reaction_times = NaN(blocks,trials);

blockcnts = NaN(blocks,trials);

%Additional matrices pt 2
onset2_trials = NaN(blocks,reps_p_soa);
onset2_jitters = NaN(blocks,reps_p_soa);
offset2_jitters = NaN(blocks,reps_p_soa);
onset2_targets = NaN(blocks,reps_p_soa);
offset2_targets = NaN(blocks,reps_p_soa);
onset2_masks = NaN(blocks,reps_p_soa);
offset2_masks = NaN(blocks,reps_p_soa);
onset2_fix2s = NaN(blocks,reps_p_soa);
offset2_trials = NaN(blocks,reps_p_soa);
          
reaction2_times = NaN(blocks, reps_p_soa);
keys2_taps = NaN(blocks, reps_p_soa);
keys2_which = NaN(blocks, reps_p_soa);
locspt2_rand = NaN(blocks, reps_p_soa);
jitters2_s = NaN(blocks, reps_p_soa);
jitters2_frames = NaN(blocks,reps_p_soa);
soas2_s = NaN(blocks, reps_p_soa);
soas2_frames = NaN(blocks,reps_p_soa);

js = 1:12;
js2 = jitter_min + (js * ((jitter_max - jitter_min)/reps_p_soa-1));

%% Need to recalculate this better when more time 

%soas
soa_steps_ms = [16.67; 33.33; 50.00; 66.67; 83.33; 100.00; 116.67; 133.33; 150.00; 200.00; 250.00; 350.00];
soa_steps_frame = [1; 2; 3; 4; 5; 6; 7; 8; 9; 12; 15; 21];

if mod(trials,length(soa_steps_frame)) == 0
    soa_steps_frames = repmat(soa_steps_frame,1,(trials/length(soa_steps_frame)));
    soa_frames_rand = (soa_steps_frames(randperm(trials))).';
else 
    trials_ext = trials + 1;
        while mod(trials_ext,length(soa_steps_frame)) ~= 0
        trials_ext = trials_ext +1;
        end
    soa_steps_frames = repmat(soa_steps_frame,1,(trials_ext/length(soa_steps_frame)));
end

%jitters
jitters_ms = [500.00; 566.67; 633.33; 700.00; 766.67; 833.33; 900.00; 966.67; 1033.33; 1100.00];
jitters_frame = [30 ; 34; 38; 42; 46; 50; 54; 58; 62; 66]; 	

if mod(trials,length(jitters_frame)) == 0
    jitter_frames = repmat(jitters_frame,1,(trials/length(jitters_frame)));
else 
    trials_ext = trials + 1;
        while mod(trials_ext,length(jitters_frame)) ~= 0
        trials_ext = trials_ext +1;
        end
    jitter_frames = repmat(jitters_frame,1,(trials_ext/length(jitters_frame)));
end

%target no.; %mask no.
if mod(trials,2) == 0
target_type = [0*ones(trials/2, 1); 1*ones(trials/2, 1)];
mask_type = [0*ones(trials/2, 1); 1*ones(trials/2, 1)];
loc_choices = [ones(trials/2, 1); 2*ones(trials/2, 1)];

else
    trials_ext = trials + 1;
    disp('Warning, trials not multiple of 2...')
    while mod(trials_ext,2) ~= 0
        trials_ext = trials_ext +1;
    end
    
    target_type = [0*ones(trials_ext/2, 1); 1*ones(trials_ext/2, 1)];
    mask_type = [0*ones(trials_ext/2, 1); 1*ones(trials_ext/2, 1)];
    loc_choices = [ones(trials_ext/2, 1); 2*ones(trials_ext/2, 1)];
end 

for b = 1:blocks
    
 %randomising task parameters within block, looping accum block
    loc_rand = (loc_choices(randperm(trials))).';
    mask_rand = (mask_type(randperm(trials))).';    
    target_rand = (target_type(randperm(trials))).';
    jitters_frames_rand = (jitter_frames(randperm(trials))).';
    soa_frames_rand = (soa_steps_frames(randperm(trials))).';
    
% Compiling all calculated parameters according to block/trial for further use 
soas_frames(b,:) = soa_frames_rand(1:trials); 
jitters_frames(b,:) = jitters_frames_rand(1:trials);
locs_rand(b,:) = loc_rand(1:trials); 
targets_s(b,:) = target_rand(1:trials);
masks_s(b,:) = mask_rand(1:trials);

blockcnt = repmat(b,1,trials);
blockcnts(b,:) = blockcnt;


%% Additional pt 2 calcs
locpt2_neu = [ones(reps_p_soa/2, 1); 2*ones(reps_p_soa/2, 1)];
locpt2_rand = locpt2_neu(randperm(reps_p_soa));
locpt2_rand = locpt2_rand.';
locspt2_rand(b,:) = locpt2_rand;

jitters2_frames_rand = (jitter_frames(randperm(reps_p_soa))).';
soa2_frames_rand = (soa_steps_frames(randperm(reps_p_soa))).';

jitters2_frames(b,:) = Shuffle(jitters2_frames_rand);
soa2_frames(b,:) = Shuffle(soa2_frames_rand).';

end

soas_s = soas_frames*monitorflipinterval;
jitters_s = jitters_frames*monitorflipinterval;
jitters2_s = jitters2_frames*monitorflipinterval;
soa2_s = soa2_frames*monitorflipinterval;

%% Calculating estimated task timing

task_timest_sec = sum(jitters_s(:,:),'all') + sum(soas_s(:,:),'all') + (time_mask*trials*blocks) + (time_fix*trials*blocks); 
task_timest_frames = sum(jitters_frames(:,:),'all') + sum(soas_frames(:,:),'all') + (time_mask_frames*trials*blocks) + (time_fix_frames*trials*blocks); 
task_timest_secs = task_timest_frames/60;
task_timest_mins = task_timest_secs/60;
taskrest_timest_mins = blocks*0.5; 

tasktot_timest_mins = taskrest_timest_mins + task_timest_mins;
tasktot_timest_secs = tasktot_timest_mins * 60;

task2_timest_sec = sum(jitters2_s(:,:),'all') + sum(soa2_s(:,:),'all') + (time_mask*reps_p_soa*blocks) + (time_fix*reps_p_soa*blocks); 
task2_timest_frames = sum(jitters2_frames(:,:),'all') + sum(soa2_frames(:,:),'all') + (time_mask_frames*trials*blocks) + (time_fix_frames*trials*blocks); 
task2_timest_secs = task2_timest_frames/60;
task2_timest_mins = task2_timest_secs/60;
task2rest_timest_mins = blocks*0.5; 

task2tot_timest_mins = task2rest_timest_mins + task2_timest_mins;
task2tot_timest_secs = task2tot_timest_mins * 60;



%% Verifying responses - correct or not 

disp('Calculating success rates...');

keys_correct = NaN(size(keys_which,1),size(keys_which,2));

for b = 1:size(keys_which,1)
    for t = 1:size(keys_which,2)
        
        if keys_taps(b,t) == 0 || isnan(keys_taps(b,t))
        %participant didn't press a key 
        keys_correct(b,t) = NaN;
        else
        
        compare = isequal(keys_which(b,t), targets_s(b,t));
        keys_correct(b,t) = compare;
        end
        
    end
end

%% Exporting variables of interest into csv table for stats analysis

disp('Exporting data to csv...');

%Formatting all data of interest into 1 col vector length of trial no. 
trialno = 1:(blocks*trials);
trialno = trialno.';
datatable(:,1) = trialno;
datahead(:,1) = {'trialno'};

for b = 1:blocks
    blockcnt = repmat(b,trials,1);
    blockcnts(b,:) = blockcnt;
end

tmp = blockcnts.';
blockno = tmp(:);
datatable(:,2) = blockno;
datahead(:,2) = {'blockno'};

tmp = jitters_s.';    
jitters_s_v = tmp(:);
jitter = jitters_s_v(1:max(trialno));
datatable(:,3) = jitter;
datahead(:,3) = {'jitter'};

tmp = soas_s.'; 
soas_s_v = tmp(:);
soa = soas_s_v(1:max(trialno));
datatable(:,4) = soa;
datahead(:,4) = {'soa'};

tmp = targets_s.';     
targets_s_v = tmp(:);
targettype = targets_s_v(1:max(trialno));
datatable(:,5) = targettype;
datahead(:,5) = {'targettype'};

targetno_hap_v = image_rindexs_hap(:);
targetno_hap = targetno_hap_v(1:max(trialno));
targetno_fea_v = image_rindexs_fea(:);
targetno_fea = targetno_fea_v(1:max(trialno));

cntr1 = 0;
cntr2 = 0;
targetnumber = zeros(max(trialno),1);
targetage = zeros(max(trialno),1);
targetgender = zeros(max(trialno),1);
maskage = zeros(max(trialno),1);
maskgender = zeros(max(trialno),1);

for select = 1:max(trialno)
    if targettype(select) == 0 %fear
        cntr1 = cntr1 + 1;
        targetnumber(select) = targetno_fea(cntr1); 
        whichfile = image_list_fea(targetno_fea(cntr1)).name;
        
        %classifying fear need to add _f at end also to stop
        %over-classifaction as targetage == 2 
            if contains(whichfile,'_o_m_f') || contains(whichfile,'_o_f_f') 
            targetage(select) = 3;
            else
                if contains(whichfile,'_m_m_f') || contains(whichfile,'_m_f_f') 
                    targetage(select) = 2;
                else %contains(whichfile,'_y_m_f') || contains(whichfile,'_y_f_f')
                    targetage(select) = 1;
                end
            end
        
        
            if contains(whichfile,'_o_m') || contains(whichfile,'_m_m') || contains(whichfile,'_y_m')
            targetgender(select) = 0;
            else 
                targetgender(select) = 1;
            end
        
        
        
    else %targettype(select) == 1 %happy 
        cntr2 = cntr2 + 1;
        targetnumber(select) = targetno_hap(cntr2);
        whichfile = image_list_hap(targetno_hap(cntr2)).name;
        
            if contains(whichfile,'_o_m') || contains(whichfile,'_o_f') 
            targetage(select) = 3;
            else
                if contains(whichfile,'_m_m') || contains(whichfile,'_m_f') 
                    targetage(select) = 2;
                else %contains(whichfile,'_y_m') || contains(whichfile,'_y_f')
                    targetage(select) = 1;
                end
            end


            if contains(whichfile,'_o_m') || contains(whichfile,'_m_m') || contains(whichfile,'_y_m')
            targetgender(select) = 0;
            else 
                targetgender(select) = 1;
            end
        
        
    end
end
datatable(:,6) = targetnumber;
datahead(:,6) = {'targetnumber'};
datatable(:,7) = targetage;
datahead(:,7) = {'targetage'};
datatable(:,8) = targetgender;
datahead(:,8) = {'targetgender'};

maskno_v = image_rindexs_neu(:);
masknumber = maskno_v(1:max(trialno));

for select2 = 1:max(trialno)
    
        whichfile = image_list_neu(masknumber(select2)).name;
        
            if contains(whichfile,'_o_m') || contains(whichfile,'_o_f') 
            maskage(select2) = 3;
            else
                if contains(whichfile,'_m_m') || contains(whichfile,'_m_f') 
                    maskage(select2) = 2;
                else %contains(whichfile,'_y_m') || contains(whichfile,'_y_f')
                    maskage(select2) = 1;
                end
            end
        
        
            if contains(whichfile,'_o_m') || contains(whichfile,'_m_m') || contains(whichfile,'_y_m')
            maskgender(select2) = 0;
            else 
                maskgender(select2) = 1;
            end
end

datatable(:,9) = masknumber;
datahead(:,9) = {'masknumber'};
datatable(:,10) = maskage;
datahead(:,10) = {'maskage'};
datatable(:,11) = maskgender;
datahead(:,11) = {'maskgender'};

tmp = locs_rand.';   
locs_rand_v = tmp(:);
location = locs_rand_v(1:max(trialno));
datatable(:,12) = location;
datahead(:,12) = {'location'};

tmp = reaction_times.';   
reaction_times_v = tmp(:);
responsetime = reaction_times_v(1:max(trialno));
datatable(:,13) = responsetime;
datahead(:,13) = {'responsetime'};

tmp = keys_which.';   
keys_which_v = tmp(:);
responsekey = keys_which_v(1:max(trialno));
datatable(:,14) = responsekey;
datahead(:,14) = {'responsekey'};

tmp = keys_correct.';  
keys_correct_v = tmp(:);
responsecorrect = keys_correct_v(1:max(trialno));
datatable(:,15) = responsecorrect;
datahead(:,15) = {'responsecorrect'};
disp('OK');

datatable_header = table(trialno,blockno,jitter,soa,targettype,targetnumber,targetage,targetgender,masknumber,maskage,maskgender,location,responsetime,responsekey,responsecorrect);
csvwrite('FACES_task_design_workspace_framerate.csv',datatable)
writetable(datatable_header,'FACES_task_design_workspace_framerate_l.csv')




if exist('FACES_task_design_workspace_framerate.mat','file')
 disp('task file exists');
 choose = input('Save new design mat (will overwrite previous - 0=no, 1=yes)?: ');
else
    disp('no task file exists');
    choose = 1;
end

if choose == 0 
else %choose ==1 (yes)   
save('FACES_task_design_workspace_framerate.mat')
end

