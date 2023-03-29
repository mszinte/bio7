
%% Cleanup 
clear;
sca;

commandwindow %pull matlab to command window rather than scripts 
HideCursor; %can uncomment when debugging is finished

%% add paths to various folders for scripts, data 
addpath('archive','config','conversion','data', 'execution','stimuli');

%% load images
config_stimuli

%% test screen and prepare screen parameters
config_screen

%% keyboard and cursor parameters
config_keys

%% Fixed timing parameters
config_trialtimes

%% Task parameters
config_task

config_design

%% Rest parameters
config_rest

config_rest_design

%% Make tables for running the experiment
config_createexperiment

config_rest_createexperiment

%% Make tables for outputting experiment data
config_createdatafile

config_rest_createdatafile

%% MRI parameters
config_MRI

%% Save design files to execution folder 
config_savedesign
