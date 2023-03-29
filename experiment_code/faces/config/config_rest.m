%% Configuration file 
% Rest block design

%% Inputting desired number of trials and blocks 

rest.blocks = task.blocks;
rest.trials = task.trialsprun; 
rest.trialspblock = rest.trials / rest.blocks;
rest.trialsprun = rest.trials / task.runs; 
rest.blocksprun = task.blocksprun;

%% Calculating number of trials per category emotion for sex/age 

rest.trialspemo = rest.trials / (stim.emotions_no - stim.emotions_contrast_no);
rest.trialspemocat = rest.trialspemo / (stim.sexs_no * stim.ages_no);
rest.number_emocat = rest.trials/rest.trialspemocat;

%% Check if can get equal number of soas from trial per category 
 
if mod(rest.trialspemocat,time.soa_number) ~= 0
    
error_restsoas1 = ('number of soas not equal across categories')

rest.trialspemocatpsoa = rest.trialspemocat / time.soa_number;

else
    
rest.trialspemocatpsoa = rest.trialspemocat / time.soa_number;
    
end

%% Check if number of available images is sufficient for experimental design, if not, reduced and oblige repeated images 

rest.images_maxpemocat = stim.images_maxpemocat - stim.images_numberpemocat;

 % If number of images less than neceesary, reduce by 1 image at a time
 % until factor of number of trials per category
 if rest.images_maxpemocat < rest.trialspemocat
     
     warning_restimages1 = ('not enough images per emo categories for no of trials, reducing number and forcing repeated images') 
     rest.images_numberpemocat = rest.images_maxpemocat;
     
 while round(rest.trialspemocat/rest.images_numberpemocat) ~= (rest.trialspemocat/rest.images_numberpemocat)
     
     %reducing number of images by 1 until integer division obtained 
     rest.images_numberpemocat = rest.images_numberpemocat - 1;
      
 end
 
 rest.images_repititionspemocat = rest.trialspemocat / rest.images_numberpemocat; 

 else 
    % no problem with number of available images
    rest.images_repititionspemocat = 1; 
    rest.images_numberpemocat = rest.images_maxpemocat;
 end
 
 rest.imagespsoa = rest.images_numberpemocat * rest.images_repititionspemocat / time.soa_number;  
 rest.trialspsoagroup = rest.images_numberpemocat * rest.images_repititionspemocat;
 
 if  round(rest.imagespsoa) == rest.imagespsoa
     % images per soa is integer 
 else
     warning_restimagessoa = ('number of images for each soa doesnt divide, may be problematic to design')
 end
