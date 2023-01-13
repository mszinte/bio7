printf ("%s\n", program_name ())
arg_list = argv ();

if nargin != 2
  disp("Not enough or wrong arguments: please use: octave_presurf.m <full path to UNI image> <full path to INV2 image>\n");
  disp ("\n");
  exit;
end

UNI=arg_list{1};
printf ("UNI: %s\n", UNI)
if exist(UNI, "file")
 printf("UNI file found.\n")
else
 printf("UNI file not found. exit.\n")
 exit
end

INV2=arg_list{2};
printf ("INV2: %s\n", INV2)
if exist(INV2, "file")
 printf("INV2 file found.\n")
else
 printf("INV2 file not found. exit.\n")
 exit
end
% ########################################################################
% STEP - 0 : (optional) MPRAGEise UNI
% ########################################################################
printf("STEP 0\n")
UNI_out = presurf_MPRAGEise(INV2,UNI); % Outputs presurf_MPRAGEise directory

% ########################################################################
% STEP - 1 : Pre-process INV2 to get STRIPMASK
% ########################################################################
printf("STEP 1\n")
presurf_INV2(INV2); % Outputs presurf_INV2 directory

% ########################################################################
% STEP - 3 : Pre-process UNI to get BRAINMASK
% ########################################################################
% Change UNI path to that of the MPRAGEised UNI if Step-0 was done
printf("STEP 3\n")
if exist('UNI_out','var')
    presurf_UNI(UNI_out); % Outputs presurf_UNI directory
else
    presurf_UNI(UNI);
end

% ########################################################################
% STEP - 4 : Prepare for Freesurfer
% ########################################################################

% Load the MPRAGEised UNI image and STRIPMASK in ITK-SNAP
% Clean the mask in the regions-of-interest and save
% Multiply the MPRAGEised UNI with the manually edited STRIPMASK
% Supply to recon-all