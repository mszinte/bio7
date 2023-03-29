%% Configuration file 
% Complete design 

%% Creating elements for experimental categories 

%creating an index for reversing datatable back to original order 
%not for use in experiment as trial number 
design.sort_id = 1:task.trials;

% number of soas, repeated until max trial number
design.soa_ref = repmat((1:time.soa_number),1,(task.trials/time.soa_number)); 
design.soa_secs = time.soa10_secs(design.soa_ref);
design.soa_frames = time.soa10_frames(design.soa_ref);

% specific image id number, repeated until max trial number
design.image_ref = repmat((1:task.trialspsoagroup),1,(task.trials/task.trialspsoagroup));

iter = 1; 

for i = 1:task.number_emocat
    
    for j = 1:(task.trialspsoagroup * task.trialspimage)
          
        if j < 21 
            
        design.image_photoname(iter,:) = stim.images.(char(stim.combi_contrast_id(i)))(j).name;
        design.image_photonumber(iter,:) = stim.images.(char(stim.combi_contrast_id(i)))(j).name(1:3);
        design.image_photoref(iter,:) = j;
        
        design.mask_photoname(iter,:) = stim.images.(char(stim.combi_control_id(i)))(j).name;
        design.mask_photonumber(iter,:) = stim.images.(char(stim.combi_control_id(i)))(j).name(1:3);
        design.mask_photoref(iter,:) = j;
        
        iter = iter + 1;

        else
        
        k = j - 20; 

        design.image_photoname(iter,:) = stim.images.(char(stim.combi_contrast_id(i)))(k).name;
        design.image_photonumber(iter,:) = stim.images.(char(stim.combi_contrast_id(i)))(k).name(1:3);
        design.image_photoref(iter,:) = k;
        
        design.mask_photoname(iter,:) = stim.images.(char(stim.combi_control_id(i)))(k).name;
        design.mask_photonumber(iter,:) = stim.images.(char(stim.combi_control_id(i)))(k).name(1:3);
        design.mask_photoref(iter,:) = k;
        
        iter = iter + 1;

        k = k + 1; 
        end
        

    end
    
end

design.mask_imagename = cellstr(design.mask_photoname);
design.mask_imagenumber_str = cellstr(design.mask_photonumber);
design.mask_imagenumber = cellstr(design.mask_photonumber);
design.mask_imageref = design.mask_photoref;

design.target_imagename = cellstr(design.image_photoname);
design.target_imagenumber_str = cellstr(design.image_photonumber);
design.target_imagenumber = cellstr(design.image_photonumber);
design.target_imageref = design.image_photoref;

design.image_photonumber = str2num(char(design.image_photonumber));

if design.target_imageref == design.mask_photoref 
    
    design.image_ref = design.target_imageref;
    
else
    warning_imageref = ('not same images target and mask ?')
end


clear iter 
clear i 
clear j 
clear k

% splitting no of trials equally into number of sex-age-emo categories 
design.agesexemo_ref = repelem((1:task.number_emocat),(task.trials/task.number_emocat));
design.agesex_ref = repelem((1:task.number_emocat/stim.emotions_contrast_no), (task.trials/(task.number_emocat/stim.emotions_contrast_no)));
%assigning corresponding ids and names for target and contrast mask images
design.agesexemo_id_target = stim.combi_contrast_id(design.agesexemo_ref);
design.agesexemo_target = stim.combi_contrast(design.agesexemo_ref);
design.agesexemo_id_mask = stim.combi_control_id(design.agesexemo_ref);
design.agesexemo_mask = stim.combi_control(design.agesexemo_ref);

%turning age sex refs into numbers based on category number 

for j = 1:stim.emotions_contrast_no
    
    for i = 1:task.trials 

        if contains(design.agesexemo_target(i),stim.emotions_contrast(j))
            design.emotions_ref(i) = j;
        else 
            %donothing
        end
    end 
end

clear i
clear j

for j = 1:stim.sexs_no
    
    jsex = strcat('_',stim.sexs(j));
    
    for i = 1:task.trials 

        if contains(design.agesexemo_target(i),jsex)
            design.sexs_ref(i) = j;
        else 
            %donothing
        end
    end 
end

clear i 
clear j
clear jsex

for j = 1:stim.ages_no
    
    for i = 1:task.trials 

        if contains(design.agesexemo_target(i),stim.ages(j))
            design.ages_ref(i) = j;
        else 
            %donothing
        end
    end 
end

design.emotions_name = stim.emotions_contrast(design.emotions_ref);
design.sexs_name = stim.sexs(design.sexs_ref);
design.ages_name = stim.ages(design.ages_ref);

% Calculating the image position reference 
design.target_imagepos_ref = ((design.agesex_ref - 1)*stim.emotions_no) + design.emotions_ref;
design.mask_imagepos_ref = design.agesex_ref * stim.emotions_no;

clear i 
clear j

%% Some safety checks

if stim.images_numberpemocat*(stim.ages_no * stim.sexs_no) ~= length(unique(design.image_photonumber))
    
    error_categ1 = ('unique images doesnt match desired number, may have drawn different models')
else
end

if mean(1:stim.emotions_contrast_no) ~= mean(design.emotions_ref)
    error_categ2 = ('avg number of emotions doesnt match desired number, error?')
else
end

if mean(1:stim.sexs_no) ~= mean(design.sexs_ref)
    error_categ3 = ('avg number of eachsex doesnt match desired number, error?')
else
end

if mean(1:stim.ages_no) ~= mean(design.ages_ref)
    error_categ4 = ('avg number of ages doesnt match desired number, error?')
else
end

% stim.images.(char(stim.combi_id(5)));

%% Creating output datatable and table

[fn] = fieldnames(design);
fn_char = char(fn);
fn_i = 1;


for i = 1:length(fieldnames(design))
    
fn_str = strtrim(fn_char(i,:));

% make sure data all in the same orientation 
if iscolumn(design.(fn_str))
    %leave as column vector 
else
    design.(fn_str) = design.(fn_str)';
end


if isa(design.(fn_str),'cell')
    
%     for j = 1:task.trials
%         
%     datatable(j,i) = str2num(cell2mat(design.(fn_str)(i)));
%    
%     end 
   
elseif isa(design.(fn_str),'double')
    
design.datatable_constants((1:task.trials),(fn_i)) = design.(fn_str);

fn_i = fn_i + 1;

else
    %unspecified datatype 
end

end

% design_table = table(design., 'VariableNames',cellstr(fn_char));


clear i
clear fn_str
clear fn
clear fn_i
clear fn_char
clear fn_integrated


%% Shuffling and adding trial number, block and random set of jitters

% number of jitters, repeated until max trial number and shuffled
design.jitter_ref = repmat((1:length(time.jitters_frames)),1,(task.trials/length(time.jitters_frames))); 
design.jitter_ref = Shuffle(design.jitter_ref);
% converting jitter reference to actual values 
design.jitter_secs = time.jitters_secs(design.jitter_ref(1:task.trials));
design.jitter_frames = time.jitters_frames(design.jitter_ref(1:task.trials));

design.loc_ref = repelem(1:stim.loc_number,task.trials/stim.loc_number);
design.loc_ref = Shuffle(design.loc_ref);
design.loc_name = stim.loc_name(design.loc_ref);
design.loc_x = stim.loc_coord(design.loc_ref);
design.loc_y = stim.loc_coord(design.loc_ref + 2);

%shuffling trialnumber
design.trialnumber = 1:task.trials;
design.trialnumber = Shuffle(design.trialnumber);

%making repeated elements blocks 
design.blocknumber = repelem(1:8,task.trials/task.blocks);
design.run_number = task.run_number;

design.mask_secs = repelem(time.mask_secs, task.trials);
design.mask_frames = repelem(time.mask_frames, task.trials);

design.response_secs = repelem(time.response_secs, task.trials);
design.response_frames = repelem(time.response_frames, task.trials);

%% Making sure new data still in same orientation 

[fn] = fieldnames(design);
fn_char = char(fn);

for i = 1:length(fieldnames(design))
    
fn_str = strtrim(fn_char(i,:));

% make sure data all in the same orientation 
if iscolumn(design.(fn_str))
    %leave as column vector 
else
    design.(fn_str) = design.(fn_str)';
end
end

clear fn
clear fn_str
clear fn_char
clear i

%% Calculating task timings 

design.trial_time_secs = design.soa_secs + design.mask_secs + design.jitter_secs + design.response_secs;
design.trial_time_frames = design.soa_frames + design.mask_frames + design.jitter_frames + design.response_frames;
