%% Configuration file 
% Image stimuli 

%% Finding stimuli location 

if isfolder('stimuli') == 1
    s = what('stimuli');
    stim.path = s.path;
    clear s
else
    error_path = sprintf('check execution folder is vision')
end


%% Setting desired image shortlist for particular experiment 

% 18.09.2022 image shortlist for faces fear vs. happy 

%Choosing which image set to use - a or b
% list a used in all experiment
% adding only b list for neutral neutral phase
stim.list = '_a.jpg';
stim.listb = '_b.jpg';

%Choosing how many and which emotions to use 

%emotion

%N.B. put emotions to be contrasted first, neutral / control cond at the end.
stim.emotions = {'fear' 'happy' 'neutral'}; 
stim.emotions_id = {'f' 'h' 'n'}; 
stim.emotions_no = length(stim.emotions_id);

%specifying how many emotions will be within the main contrast block
%as neutral will make up its own small block 
stim.emotions_contrast_no = stim.emotions_no - 1;
stim.emotions_contrast = stim.emotions(1:stim.emotions_contrast_no);
stim.emotions_contrast_id = stim.emotions_id(1:stim.emotions_contrast_no);

%sex
stim.sexs = {'male' 'female'};
stim.sexs_id = {'m' 'f'}; 
stim.sexs_no = length(stim.sexs_id); 
%age
stim.ages = {'middle' 'young'};
stim.ages_id = {'m' 'y'}; 
stim.ages_no = length(stim.ages_id); 

%% Inputting FACES database structure / design elements   

%Defining the categories in the database and corresponding naming codes

%emotion
stim.catelog.emotions = {'sad' 'fear' 'happy' 'angry', 'disgust', 'neutral'};
stim.catelog.emotions_id = {'s' 'f' 'h' 'a', 'd', 'n'};
stim.catelog.emotions_tot = length(stim.catelog.emotions); 
%sex
stim.catelog.sexs = {'male' 'female'};
stim.catelog.sexs_id = {'m' 'f'};
stim.catelog.sexs_tot = length(stim.catelog.sexs); 
%age
stim.catelog.ages = {'old' 'middle' 'young'};
stim.catelog.ages_id = {'o' 'm' 'y'};
stim.catelog.ages_tot = length(stim.catelog.ages);

%% Creating categorised complete image directory

disp('Loading desired shortlist of images for experiment...')

%loading all emotion images by group age/sex

[emo,sex,age] = ndgrid(1:stim.emotions_no,1:stim.sexs_no,1:stim.ages_no);
stim.combi_id = strcat(stim.ages_id(age(:)),'_',stim.sexs_id(sex(:)),'_',stim.emotions_id(emo(:)));

stim.combi = strcat(stim.ages(age(:)),'_',stim.sexs(sex(:)),'_',stim.emotions(emo(:)));

clear emo
clear sex
clear age

for i = 1:length(stim.combi_id)
    
    temp_filename = strcat(stim.combi_id{i}, stim.list);
    
stim.images.(stim.combi_id{i}) = dir(fullfile(stim.path,['*' temp_filename '']));
stim.images.(stim.combi_id{i}) = stim.images.(stim.combi_id{i})(~startsWith({stim.images.(stim.combi_id{i}).name}, '.'));

clear temp_filename

end

clear i

%loading all emotion images by group age/sex for images contrasted, control
%neutral condition not present

[emo,sex,age] = ndgrid(1:stim.emotions_contrast_no,1:stim.sexs_no,1:stim.ages_no);
stim.combi_contrast_id = strcat(stim.ages_id(age(:)),'_',stim.sexs_id(sex(:)),'_',stim.emotions_contrast_id(emo(:)));

stim.combi_contrast = strcat(stim.ages(age(:)),'_',stim.sexs(sex(:)),'_',stim.emotions_contrast(emo(:)));

clear emo
clear sex
clear age

[emo,sex,age] = ndgrid(max(stim.emotions_no),1:stim.sexs_no,1:stim.ages_no);
stim.combi_control_id = strcat(stim.ages_id(age(:)),'_',stim.sexs_id(sex(:)),'_',stim.emotions_id(emo(:)));

stim.combi_control = strcat(stim.ages(age(:)),'_',stim.sexs(sex(:)),'_',stim.emotions(emo(:)));

stim.combi_control_id = repelem(stim.combi_control_id,stim.emotions_contrast_no);
stim.combi_control = repelem(stim.combi_control,stim.emotions_contrast_no);

clear emo
clear sex
clear age
%loading the last control neutral condition 

% loading an additional b list neutral condition for the resting task 

for i = 1:length(stim.combi_id)
    
    temp_filename = strcat(stim.combi_id{i}, stim.listb);
    
stim.images_blist.(stim.combi_id{i}) = dir(fullfile(stim.path,['*' temp_filename '']));
stim.images_blist.(stim.combi_id{i}) = stim.images_blist.(stim.combi_id{i})(~startsWith({stim.images_blist.(stim.combi_id{i}).name}, '.'));

clear temp_filename

end

clear i



