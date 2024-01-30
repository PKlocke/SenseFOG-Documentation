%%=====  Import_JSON.m ========================================%
% Original author(s): Philipp Klocke, Moritz Loeffler

%This script will import the original raw data of specified LFPs
%and save the data to a pre-determined filepath. We will start by importing
%the files, and resample them according to the EEG sampling rate.
%==============================================================================

close all

LFP                       = struct;
[JSON_file, path]         = uigetfile('*.json')                                                   % Defines the file and the file-path for our JSON file
cd(path)
JSON_filename             = strrep(JSON_file,'.json','');                                         % Creates the filename by cutting off the suffix .json
LFP.rawfile               = jsondecode(fileread(JSON_file));

%Assign the correct side to the LFP dataset
if contains(LFP.rawfile.BrainSenseTimeDomain(1).Channel, "RIGHT") == 1; 
    LFP.raw_lfp_right     = LFP.rawfile.BrainSenseTimeDomain(1).TimeDomainData
    LFP.raw_lfp_left      = LFP.rawfile.BrainSenseTimeDomain(2).TimeDomainData
elseif contains(LFP.rawfile.BrainSenseTimeDomain(1).Channel, "LEFT") == 1;
    LFP.raw_lfp_left      = LFP.rawfile.BrainSenseTimeDomain(1).TimeDomainData
    LFP.raw_lfp_right     = LFP.rawfile.BrainSenseTimeDomain(2).TimeDomainData
end

LFP.fs_lfp            = LFP.rawfile.BrainSenseTimeDomain(1).SampleRateInHz;                       % Sampling Rate in Hz
LFP.lfptime           = (1/LFP.fs_lfp):(1/LFP.fs_lfp):(length(LFP.raw_lfp_right)/LFP.fs_lfp);     % Creating a time vector for our LFP Data 

%Resampling LFP signal to EEG sampling rate
LFP.interp_LFP_right = resample(LFP.raw_lfp_right,1000, LFP.fs_lfp)';                             % EEG sampling rate: 1000 Hz
LFP.interp_LFP_left = resample(LFP.raw_lfp_left,1000, LFP.fs_lfp)';

%Save DATA
save([path JSON_filename '_raw.mat'], 'LFP', '-mat') 

%Clean-UP
clear JSON_filename JSON_file 

% *********************** END OF SCRIPT ************************************************************************************************************************
