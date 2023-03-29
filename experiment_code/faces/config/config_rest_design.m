%% Configuration file 
% Complete design 

%% Creating elements for experimental categories 

%creating an index for reversing datatable back to original order 
%not for use in experiment as trial number 
design_rest.sort_id = 1:rest.trials;

% number of soas, repeated until max trial number
design_rest.soa_ref = repmat((1:time.soa_number),1,(rest.trials/time.soa_number)); 
design_rest.soa_secs = time.soa10_secs(design_rest.soa_ref);
design_rest.soa_frames = time.soa10_frames(design_rest.soa_ref);

% specific image id number, repeated until max trial number
design_rest.image_ref = repmat((1:rest.images_numberpemocat),1,(rest.trials/rest.images_numberpemocat));

iter = 1; 

l=0; 

for i = 1:(rest.number_emocat * 2)
    
 for j = 1:(rest.trialspemocat/rest.trialspemocatpsoa)
     
     
        k = design_rest.image_ref(iter);

        design_rest.image_photoname(iter,:) = stim.images.(char(stim.combi_control_id(i)))(k).name;
        design_rest.image_photonumber(iter,:) = stim.images.(char(stim.combi_control_id(i)))(k).name(1:3);
        design_rest.image_photoref(iter,:) = k;
        
        design_rest.mask_photoname(iter,:) = stim.images_blist.(char(stim.combi_control_id(i)))(k).name;
        design_rest.mask_photonumber(iter,:) = stim.images_blist.(char(stim.combi_control_id(i)))(k).name(1:3);
        design_rest.mask_photoref(iter,:) = k;
        
        iter = iter + 1;

 end
    
end

design_rest.target_imagename = cellstr(design_rest.image_photoname);
design_rest.target_imagenumber_str = cellstr(design_rest.image_photonumber);
design_rest.target_imagenumber = cellstr(design_rest.image_photonumber);
design_rest.target_imagenumber = str2num(char(design_rest.target_imagenumber));
design_rest.target_imageref = design_rest.image_photoref;

design_rest.mask_imagename = cellstr(design_rest.mask_photoname);
design_rest.mask_imagenumber_str = cellstr(design_rest.mask_photonumber);
design_rest.mask_imagenumber = cellstr(design_rest.mask_photonumber);
design_rest.mask_imagenumber = str2num(char(design_rest.mask_imagenumber));
design_rest.mask_imageref = design_rest.mask_photoref;

% splitting no of trials equally into number of sex-age-emo categories 
design_rest.agesexemo_ref = repelem((1:rest.number_emocat),(rest.trials/rest.number_emocat));
design_rest.agesex_ref = repelem(1:rest.number_emocat, rest.trials/(rest.number_emocat));
%assigning corresponding ids and names for target and contrast mask images

% because control_id has doubled up categories 

id_sort = repelem(1:rest.number_emocat*2, rest.trials/(rest.number_emocat*2));

design_rest.agesexemo_id = stim.combi_control_id(id_sort);
design_rest.agesexemo = stim.combi_control(id_sort);


%turning age sex refs into numbers based on category number 

for i = 1:rest.trials 

      if contains(design_rest.agesexemo(i),stim.emotions(length(stim.emotions)))
            design_rest.emotions_ref(i) = length(stim.emotions);
      else 
            %donothing
      end
end 

clear i

for j = 1:stim.sexs_no
    
    jsex = strcat('_',stim.sexs(j));
    
    for i = 1:rest.trials 

        if contains(design_rest.agesexemo(i),jsex)
            design_rest.sexs_ref(i) = j;
        else 
            %donothing
        end
    end 
end

clear i 
clear j
clear jsex

for j = 1:stim.ages_no
    
    for i = 1:rest.trials 

        if contains(design_rest.agesexemo(i),stim.ages(j))
            design_rest.ages_ref(i) = j;
        else 
            %donothing
        end
    end 
end

design_rest.emotions_name = stim.emotions(length(stim.emotions));
design_rest.sexs_name = stim.sexs(design_rest.sexs_ref);
design_rest.ages_name = stim.ages(design_rest.ages_ref);

% Calculating the image position reference 
design_rest.imagepos_ref = design_rest.agesex_ref * stim.emotions_no;

clear i 
clear j

%% Some safety checks

if (rest.images_numberpemocat*(stim.ages_no * stim.sexs_no)/rest.images_repititionspemocat * rest.imagespsoa) ~= length(unique(design_rest.image_photonumber))
    
    error_categ1 = ('unique images doesnt match desired number, may have drawn different models')
else
end


if mean(1:stim.sexs_no) ~= mean(design_rest.sexs_ref)
    error_categ3 = ('avg number of eachsex doesnt match desired number, error?')
else
end

if mean(1:stim.ages_no) ~= mean(design_rest.ages_ref)
    error_categ4 = ('avg number of ages doesnt match desired number, error?')
else
end

% stim.images.(char(stim.combi_id(5)));


%% Making sure new data still in same orientation 

[fn] = fieldnames(design_rest);
fn_char = char(fn);

for i = 1:length(fieldnames(design_rest))
    
fn_str = strtrim(fn_char(i,:));

% make sure data all in the same orientation 
if iscolumn(design_rest.(fn_str))
    %leave as column vector 
else
    design_rest.(fn_str) = design_rest.(fn_str)';
end
end

clear fn
clear fn_str
clear fn_char
clear i

%% Creating output datatable and table

[fn] = fieldnames(design_rest);
fn_char = char(fn);
fn_i = 1;


for i = 1:length(fieldnames(design_rest))
    
fn_str = strtrim(fn_char(i,:));

if isa(design_rest.(fn_str),'cell')
    
%     for j = 1:task.trials
%         
%     datatable(j,i) = str2num(cell2mat(design.(fn_str)(i)));
%    
%     end 
   
elseif isa(design_rest.(fn_str),'double')
    
design_rest.datatable_constants((1:rest.trials),(fn_i)) = design_rest.(fn_str);

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
design_rest.jitter_ref = repmat((1:length(time.jitters_frames)),1,(rest.trials/length(time.jitters_frames))); 
design_rest.jitter_ref = Shuffle(design_rest.jitter_ref);
% converting jitter reference to actual values 
design_rest.jitter_secs = time.jitters_secs(design_rest.jitter_ref(1:rest.trials));
design_rest.jitter_frames = time.jitters_frames(design_rest.jitter_ref(1:rest.trials));

design_rest.loc_ref = repelem(1:stim.loc_number,rest.trials/stim.loc_number);
design_rest.loc_ref = Shuffle(design_rest.loc_ref);
design_rest.loc_name = stim.loc_name(design_rest.loc_ref);
design_rest.loc_x = stim.loc_coord(design_rest.loc_ref);
design_rest.loc_y = stim.loc_coord(design_rest.loc_ref + 2);

%shuffling trialnumber
design_rest.trialnumber = 1:rest.trials;
design_rest.trialnumber = Shuffle(design_rest.trialnumber);

%making repeated elements blocks 
design_rest.blocknumber = repelem(1:rest.blocks,rest.trials/rest.blocks);
design_rest.run_number = repelem(1:task.runs,rest.trials/task.runs);

design_rest.mask_secs = repelem(time.mask_secs, rest.trials);
design_rest.mask_frames = repelem(time.mask_frames, rest.trials);

design_rest.response_secs = repelem(time.response_secs, rest.trials);
design_rest.response_frames = repelem(time.response_frames, rest.trials);

%% Making sure new data still in same orientation 

[fn] = fieldnames(design_rest);
fn_char = char(fn);

for i = 1:length(fieldnames(design_rest))
    
fn_str = strtrim(fn_char(i,:));

% make sure data all in the same orientation 
if iscolumn(design_rest.(fn_str))
    %leave as column vector 
else
    design_rest.(fn_str) = design_rest.(fn_str)';
end
end

clear fn
clear fn_str
clear fn_char
clear i

%% Calculating task timings 

design_rest.trial_time_secs = design_rest.soa_secs + design_rest.mask_secs + design_rest.jitter_secs + design_rest.response_secs;
design_rest.trial_time_frames = design_rest.soa_frames + design_rest.mask_frames + design_rest.jitter_frames + design_rest.response_frames;
design_rest.cum_trial_time_secs = cumsum(design_rest.trial_time_secs);
design_rest.cum_trial_time_frames = cumsum(design_rest.trial_time_frames);
design_rest.tot_rest_time_secs = max(design_rest.cum_trial_time_secs);
design_rest.tot_rest_time_mins = design_rest.tot_rest_time_secs / 60; 
