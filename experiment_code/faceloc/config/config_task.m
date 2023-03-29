%% Configuration file 
% Task design

%% Inputting desired number of trials and blocks 

task.des.blocks = 3;
task.des.trialspblock = 20; 
task.des.trials = task.des.trialspblock * task.des.blocks;

task.runs = 1;  

%% Calculating number of trials per category emotion for sex/age 

task.des.trialspemo = task.des.trials / stim.emotions_contrast_no;
task.des.trialspemocat = task.des.trialspemo / (stim.sexs_no * stim.ages_no);

%% Check if number of trials per category can be equal across experiment 
%make trials per cat integer, if not already
task.trialspemocat = round(task.des.trialspemocat);

%if wasn't integer else calculate with integer value for trials per emotion category
if task.trialspemocat ~= task.des.trialspemocat

    task.trialspemo = task.trialspemocat * (stim.sexs_no * stim.ages_no);
    
    %new number of trials necessary to satisfy equal conditions 
    task.trials = task.trialspemo  * stim.emotions_contrast;
    
    %checking if trial number divides into desired number of blocks equally
    task.trialspblock = task.trials / task.des.blocks; 
    
    warning_trialno1 = ('trial number changed as trials per emotion category not equal based on desired trial number')
else
    task.trialspemo = task.des.trialspemo;
    task.trials = task.des.trials; 
    task.trialspblock = task.des.trialspblock; 
    
    %find all ways in which trials divides into equal blocks 
    task.blockopts = calc_division(task.trials);
    
end

task.number_emocat = task.trials/task.trialspemocat;

%% Check if number of blocks can be equal based on category constraints (if changed by above)

 if task.trialspblock ~= task.des.trialspblock

    %find all ways in which trials divides into equal blocks 
    task.blockopts = calc_division(task.trials);
    %find division which is closest to the desired block number
    task.blockdif    = abs(task.blockopts - task.des.blocks);
    task.blockdifmin  = min(task.blockdif);
    task.blockdifmin_index  = (task.blockdif == task.blockdifmin);

    %select out block number closest to desired blocks 
    task.blocks  = task.blockopts(task.blockdifmin_index);

    %calculating new proposed trial number
    task.trialspblock = task.trials / task.blocks;
   
    warning_trialno2 = ('number of blocks changed as desired blocks not divisible by new proposed trial number')
    
 else 
    %ok 
    task.blocks = task.des.blocks;
 end
 
 %% Check if number of runs is divisible across trials>blocks 
 
 task.run_number = repelem(1:task.runs, (task.trials / task.runs));
 task.trialsprun = task.trials / task.runs;  
 task.blocksprun = task.blocks / task.runs;
 
 if mod(task.trials, task.runs) ~= 0 | mod(task.blocks, task.runs)
     
     error_runs = ('run number not divisible for trials or blocks, consider changing?')
 else
 end


%% Check if number of available images is sufficient for experimental design, if not, reduced and oblige repeated images 

 fn = fieldnames(stim.images);

 % Finding minimum number of images across all set used 
 for i = 1:length(fieldnames(stim.images))
     
 minimages(i) = length(stim.images.(fn{i}));
 
 end 
 
 % Taking the smallest set of images as reference 
stim.images_maxpemocat = min(minimages);

 clear fn
 clear minimages
 clear i
 
 % If number of images less than neceesary, reduce by 1 image at a time
 % until factor of number of trials per category
 if stim.images_maxpemocat < task.trialspemocat
     
     warning_images1 = ('not enough images per emo categories for no of trials, reducing number and forcing repeated images') 
     stim.images_numberpemocat = stim.images_maxpemocat;
     
 while round(task.trialspemocat/stim.images_numberpemocat) ~= (task.trialspemocat/stim.images_numberpemocat)
     
     %reducing number of images by 1 until integer division obtained 
     stim.images_numberpemocat = stim.images_numberpemocat - 1;
      
 end
 
 stim.images_repititionspemocat = task.trialspemocat / stim.images_numberpemocat; 

 else 
    % no problem with number of available images
    stim.images_repititionspemocat = 1; 
 end
 

 % Summarising final task parameter divisions 
 task.trialspimage = stim.images_repititionspemocat;
