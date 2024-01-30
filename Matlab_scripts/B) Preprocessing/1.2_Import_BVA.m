%%=====  Import_BVA.m ========================================%
%Original author(s): Philipp Klocke, Moritz Loeffler

%This script will import the original raw data of specified EEG data and save the data to a pre-determined filepath. 
%==============================================================================
close all

EEG_File            = struct;                                            % Create a file structure
[EEG_file,path]     = uigetfile('*.eeg');                                % Choose the desired EEG File
cd(path)
EEG_File.filename   = strrep(EEG_file,'.eeg','');                        % Creates the filename by cutting off the suffix (.eeg or .vmrk or .vhdr)
EEG_File.eeg        = [EEG_File.filename,'.eeg'];                        % Read the data, header, and marker file.
EEG_File.vhdr       = ft_read_header([EEG_File.filename,'.vhdr']);
EEG_File.vmrk       = ft_read_event([EEG_File.filename,'.vmrk']);
EEG_File.fs_eeg     = EEG_File.vhdr.Fs;
dat.dataset         = ft_read_data(EEG_File.eeg,'header', EEG_File.vhdr);
dat.label           = EEG_File.vhdr.label;

findTrial           = [];
findTime            = [];

for n = 1:length(EEG_File.vmrk)
    t = EEG_File.vmrk(n).type;                                            % Examine the marker file to find the length of each trial
    if strcmp(t,'New Segment')                                            % and the start/end time.
      findTrial = [findTrial;EEG_File.vmrk(n).sample]; 
    end
    if strcmp(t,'Time 0')
      findTime = [findTime;EEG_File.vmrk(n).sample]; 
    end    
end

if length(findTrial) == 1
   trialLength = size(dat.dataset,2);                                      % Check if the data is 1 trial long (ERP), or greater than 1 trial long  
   numTrial = 1;                                                           % (time-frequency analyses).
else                                                                        
   trialLength = findTrial(2) - findTrial(1);  
   numTrial = size(dat.dataset,2)/trialLength; 
end


StartTime           = -(0 - 1)/EEG_File.vhdr.Fs;
EndTime             = StartTime + (trialLength/EEG_File.vhdr.Fs); 

ftTime              = [];
ftTrial             = [];
EEG_File.eegtime    = StartTime:(1/EEG_File.vhdr.Fs):(EndTime - (1/EEG_File.vhdr.Fs)); 


for t = 1:numTrial
    trl = dat.dataset(:,(1 + trialLength*(t-1)):trialLength*t);             % Match the time and trials with Fieldtrip's format
    ftTrial{1,t} = trl;  
    ftTime{1,t} = EEG_File.eegtime;
end
                                                                            % Create a data structure with all the relevant fields
dat.time           = ftTime;
dat.trial          = ftTrial;
data               = ft_preprocessing([], dat);

EEG_File.dat       = dat;
EEG_File.data      = data;
EEG_File.channels  = cell2table(EEG_File.vhdr.label);                       % Creates a list of all EEG Channel electrode names


%Clean-UP
clear EndTime findTime ftTime ftTrial n numTrial StartTime t trialLength trl dat data EEG_file findTrial

%Save DATA
save([path EEG_File.filename '_raw.mat'], 'EEG_File', '-mat')       

% *********************** END OF SCRIPT ************************************************************************************************************************
