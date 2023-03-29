%% Configuration file 
% Task timings

%% Desired inputs for experimental trial timings

time.des.mask_secs = 0.100; %100ms mask
time.des.response_secs = 1.500; %1500ms response

time.des.jitters_number = 8;
time.des.jitters_min_secs = 0.025; 
time.des.jitters_max_secs = 0.750; 
time.des.jitters_secs = linspace(time.des.jitters_min_secs,time.des.jitters_max_secs, time.des.jitters_number);
time.des.jitters_max_frames = time.des.jitters_max_secs/screen.frame_duration_mfitest;
time.des.jitters_min_frames = time.des.jitters_min_secs/screen.frame_duration_mfitest;

%Choosing number of soas
time.des.soa_number = 10; %8 different soas, sample choices further down

%Setting minimum soa in frames as 1 frame, max in secs to see poss range
time.des.soa_min_frames = 1;
time.des.soa_min_secs = screen.frame_duration_mfitest;

time.soa_min_frames = time.des.soa_min_frames;
time.soa_min_secs = time.des.soa_min_secs; 

time.des.soa_max_secs = 0.250;

time.des.soa_max_frames = time.des.soa_max_secs / screen.frame_duration_mfitest;

%% Setting Mask Timing

if round(time.des.mask_secs/(1/screen.hz_mfitest)) == round(time.des.mask_secs/screen.frame_duration_mfitest)
    time.des.mask_frames = time.des.mask_secs/screen.frame_duration_mfitest;
else 
    error_masktime = ('error mask time hz vs framerate')
    return 
end

if round(time.des.mask_frames)*screen.frame_duration_mfitest < time.des.mask_secs  
    time.mask_frames = ceil(time.des.mask_frames);
    time.mask_secs = time.mask_frames*screen.frame_duration_mfitest;
else
    time.mask_frames = round(time.des.mask_frames);
    time.mask_secs = time.mask_frames*screen.frame_duration_mfitest;
end

%% Setting Response Timing

if round(time.des.response_secs/(1/screen.hz_mfitest)) == round(time.des.response_secs/screen.frame_duration_mfitest)
    time.des.response_frames = time.des.response_secs/screen.frame_duration_mfitest;
else 
    error_resptime = sprintf('error resp time hz vs framerate');
    return 
end

if round(time.des.response_frames)*screen.frame_duration_mfitest < time.des.response_secs  
    time.response_frames = ceil(time.des.response_frames);
    time.response_secs = time.response_frames*screen.frame_duration_mfitest;
else
    time.response_frames = round(time.des.response_frames);
    time.response_secs = time.response_frames*screen.frame_duration_mfitest;
end


%% Setting Target SOA Timing 

%Seeing all the possible soas in the given range specified 
if round(time.des.soa_max_frames)*screen.frame_duration_mfitest < time.des.soa_max_secs  
    time.soa_max_frames = ceil(time.des.soa_max_frames);
    time.soa_max_secs = time.soa_max_frames*screen.frame_duration_mfitest;
else
    time.soa_max_frames = round(time.des.soa_max_frames);
    time.soa_max_secs = time.soa_max_frames*screen.frame_duration_mfitest;
end

time.soa_opts_frames = (time.des.soa_min_frames:time.soa_max_frames);
time.soa_opts_secs = time.soa_opts_frames * screen.frame_duration_mfitest;

% soas in haz et al 2021 for reference 
% time.soa_haz_frames = [1, 2, 4, 6, 8, 10, 12, 18];
% time.soa_haz_secs = time.soa_haz_frames * screen.frame_duration; 

if time.des.soa_number == 10
    
%soa frames based on 12OHz calculation 
time.des.soa10_frames = [2, 3, 4, 5, 6, 9, 12, 18, 24, 30];
%soa seconds based on 120Hz calculation
time.soa10_secs = time.des.soa10_frames * screen.des.framerate; 
%back calculation of soa in frames depending on given refresh rate
time.soa10_frames = time.soa10_secs / screen.frame_duration_mfitest;
time.soa10_frames = round(time.soa10_frames);
time.soa10_secs = time.soa10_frames * screen.frame_duration_mfitest;

time.soa_number = time.des.soa_number;
time.soa10_max_frames = max(time.soa10_frames);
time.soa10_max_secs = time.soa10_max_frames * screen.frame_duration_mfitest; 
time.soa10_min_frames = min(time.soa10_frames);
time.soa10_min_secs = time.soa10_min_frames * screen.frame_duration_mfitest; 
% %plotting defined soas vs options available
figure
scatter(time.soa_opts_secs*1000, time.soa_opts_frames)
hold on 
scatter(time.soa10_secs*1000, time.soa10_frames, 'b','filled','MarkerFaceAlpha', 0.8);

elseif time.des.soa_number == 8
%soa8_frames = [2, 3, 4, 6, 8, 11, 14, 24]; %idea for 8 soas, decided non
time.des.soa8_frames = [2, 3, 4, 6, 9, 12, 18, 30];
time.soa8_secs = time.des.soa8_frames * screen.frame_duration_mfitest; 
%back calculation of soas based on framerate 
time.soa8_frames = time.soa8_secs/screen.frame_duration_mfitest;
time.soa8_frames = round(time.soa8_frames);
time.soa8_secs = time.soa8_frames * screen.frame_duration_mfitest;

time.soa_number = time.des.soa_number;
time.soa8_max_frames = max(time.soa8_frames);
time.soa8_max_secs = time.soa8_max_frames * screen.frame_duration_mfitest; 
time.soa8_min_frames = min(time.soa8_frames);
time.soa8_min_secs = time.soa8_min_frames * screen.frame_duration_mfitest; 
% %plotting defined soas vs options available
figure
scatter(time.soa_opts_secs*1000, time.soa_opts_frames)
hold on 
scatter(time.soa8_secs*1000, time.soa8_frames, 'b','filled','MarkerFaceAlpha', 0.8);

else 
error_soas2 = ('number of chosen soas not pre-defined')
end


%% Setting Jitter Timing

time.jitters_frames = linspace(round(time.des.jitters_min_frames), round(time.des.jitters_max_frames), time.des.jitters_number);
time.jitters_frames = round(time.jitters_frames);
time.jitters_secs = time.jitters_frames * screen.frame_duration_mfitest; 

