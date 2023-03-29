%% Configuration file 
% Task timings

%% Desired inputs for experimental trial timings

time.des.jitters_number = 8;
time.des.jitters_min_secs = 0.025; 
time.des.jitters_max_secs = 0.750; 
time.des.jitters_secs = linspace(time.des.jitters_min_secs,time.des.jitters_max_secs, time.des.jitters_number);
time.des.jitters_max_frames = time.des.jitters_max_secs/screen.frame_duration_mfitest;
time.des.jitters_min_frames = time.des.jitters_min_secs/screen.frame_duration_mfitest;

%Choosing number of soas
time.des.soa_secs = 1; %8 different soas, sample choices further down

time.des.soa_frames = time.des.soa_secs / screen.frame_duration_mfitest;

%
%% Setting Soa Timing

if round(time.des.soa_secs/(1/screen.hz_mfitest)) == round(time.des.soa_secs/screen.frame_duration_mfitest)
    time.des.soa_frames = time.des.soa_secs/screen.frame_duration_mfitest;
else 
    error_resptime = sprintf('error resp time hz vs framerate');
    return 
end

if round(time.des.soa_frames)*screen.frame_duration_mfitest < time.des.soa_secs  
    time.soa_frames = ceil(time.des.soa_frames);
    time.soa_secs = time.soa_frames*screen.frame_duration_mfitest;
else
    time.soa_frames = round(time.des.soa_frames);
    time.soa_secs = time.soa_frames*screen.frame_duration_mfitest;
end

%% Setting Jitter Timing

time.jitters_frames = linspace(round(time.des.jitters_min_frames), round(time.des.jitters_max_frames), time.des.jitters_number);
time.jitters_frames = round(time.jitters_frames);
time.jitters_secs = time.jitters_frames * screen.frame_duration_mfitest; 
