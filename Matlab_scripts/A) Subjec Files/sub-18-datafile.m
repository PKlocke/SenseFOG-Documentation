%% sub-18-datafile.m ====================================================
% +------------------------------------------------------+
% |  Subject: SUB-18                                     |
% |                                                      |
% | Author: Philipp Klocke,Moritz Loeffler               | 
% +------------------------------------------------------+

% This script will serve as the main directory matlab file for sub-18

% Chose the pathway for the SenseFOG-main folder after downloading
subjectdata.generalpath     = uigetdir;                                                                                         % Target file should be the SenseFOG-main file after download
subjectdata.filedir         = 'sub-18';
subjectdata.subjectnr       = '18';
subjectdata.subject_dir     = 'sub-18';
path                        = append(subjectdata.generalpath, '/', subjectdata.filedir);
cd(path)



% SIT - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Sit = [];
subjectdata.signalpoint.Sit.EEG_signal          = 16578;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Sit.LFP_signal          = 11547;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Sit.LFP_signal > subjectdata.signalpoint.Sit.EEG_signal;                                             % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Sit.delay = subjectdata.signalpoint.Sit.LFP_signal - subjectdata.signalpoint.Sit.EEG_signal;         % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Sit.EEG_signal > subjectdata.signalpoint.Sit.LFP_signal;                                           % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Sit.delay = subjectdata.signalpoint.Sit.EEG_signal - subjectdata.signalpoint.Sit.LFP_signal;       % Find time-delay between both EEG and LFP
end 


% STAND - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Stand = [];
subjectdata.signalpoint.Stand.EEG_signal        = 11806;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Stand.LFP_signal        = 9621;                                                                         % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Stand.LFP_signal > subjectdata.signalpoint.Stand.EEG_signal;                                         % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Stand.delay = subjectdata.signalpoint.Stand.LFP_signal - subjectdata.signalpoint.Stand.EEG_signal;   % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Stand.EEG_signal > subjectdata.signalpoint.Stand.LFP_signal;                                       % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Stand.delay = subjectdata.signalpoint.Stand.EEG_signal - subjectdata.signalpoint.Stand.LFP_signal; % Find time-delay between both EEG and LFP
end 

% WALK - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Walk = [];
subjectdata.signalpoint.Walk.EEG_signal         = 10127;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Walk.LFP_signal         = 8265;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Walk.LFP_signal > subjectdata.signalpoint.Walk.EEG_signal;                                           % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Walk.delay = subjectdata.signalpoint.Walk.LFP_signal - subjectdata.signalpoint.Walk.EEG_signal;      % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Walk.EEG_signal > subjectdata.signalpoint.Walk.LFP_signal;                                         % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Walk.delay = subjectdata.signalpoint.Walk.EEG_signal - subjectdata.signalpoint.Walk.LFP_signal;    % Find time-delay between both EEG and LFP
end


% INTERFERENCE - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.WalkINT = [];
subjectdata.signalpoint.WalkINT.EEG_signal       = 10520;                                                                       % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.WalkINT.LFP_signal       = 8546;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.WalkINT.LFP_signal > subjectdata.signalpoint.WalkINT.EEG_signal;                                     % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.WalkINT.delay = subjectdata.signalpoint.WalkINT.LFP_signal - subjectdata.signalpoint.WalkINT.EEG_signal;% find time-delay between both EEG and LFP
else subjectdata.signalpoint.WalkINT.EEG_signal > subjectdata.signalpoint.WalkINT.LFP_signal;                                   % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.WalkINT.delay = subjectdata.signalpoint.WalkINT.EEG_signal - subjectdata.signalpoint.WalkINT.LFP_signal;% Find time-delay between both EEG and LFP
end 


%=== FILTERED GAIT EVENTS FOR WALK ONLY ===
% Manual input for filtered gait events based on exact timings of heelstrikes (not shown here)
subjectdata.events_filt.Walk = struct;

%Walk 1
subjectdata.events_filt.Walk(1).start = 12.6810000000000; 
subjectdata.events_filt.Walk(1).task = 'Walk';
subjectdata.events_filt.Walk(1).end = 17.4890000000000;

%Walk 
subjectdata.events_filt.Walk(3).start = 23.1790000000000; 
subjectdata.events_filt.Walk(3).task = 'Walk';
subjectdata.events_filt.Walk(3).end = 28.3260000000000;

%Walk 
subjectdata.events_filt.Walk(5).start = 33.817; 
subjectdata.events_filt.Walk(5).task = 'Walk';
subjectdata.events_filt.Walk(5).end = 38.9890000000000;

%Walk 
subjectdata.events_filt.Walk(7).start = 43.9720000000000; 
subjectdata.events_filt.Walk(7).task = 'Walk';
subjectdata.events_filt.Walk(7).end = 49.4860000000000;

%Walk 
subjectdata.events_filt.Walk(9).start = 55.111; 
subjectdata.events_filt.Walk(9).task = 'Walk';
subjectdata.events_filt.Walk(9).end = 58.9510000000000;

%Walk 
subjectdata.events_filt.Walk(11).start = 64.3960000000000; 
subjectdata.events_filt.Walk(11).task = 'Walk';
subjectdata.events_filt.Walk(11).end = 68.6220000000000;

%Walk 
subjectdata.events_filt.Walk(13).start = 73.8010000000000; 
subjectdata.events_filt.Walk(13).task = 'Walk';
subjectdata.events_filt.Walk(13).end = 78.8320000000000;

%Walk 
subjectdata.events_filt.Walk(15).start = 84.2300000000000; 
subjectdata.events_filt.Walk(15).task = 'Walk';
subjectdata.events_filt.Walk(15).end = 89.9470000000000;

%Walk 
subjectdata.events_filt.Walk(17).start = 94.9800000000000; 
subjectdata.events_filt.Walk(17).task = 'Walk';
subjectdata.events_filt.Walk(17).end = 100.312000000000;

%Walk 
subjectdata.events_filt.Walk(19).start = 105.150000000000; 
subjectdata.events_filt.Walk(19).task = 'Walk';
subjectdata.events_filt.Walk(19).end = 110.736000000000;

%Walk 
subjectdata.events_filt.Walk(21).start = 117.194; 
subjectdata.events_filt.Walk(21).task = 'Walk';
subjectdata.events_filt.Walk(21).end = 122.540000000000;

%Walk 
subjectdata.events_filt.Walk(24).start = 139.361000000000; 
subjectdata.events_filt.Walk(24).task = 'Walk';
subjectdata.events_filt.Walk(24).end = 145.032000000000;

%Walk 
subjectdata.events_filt.Walk(26).start = 149.624000000000; 
subjectdata.events_filt.Walk(26).task = 'Walk';
subjectdata.events_filt.Walk(26).end = 153.827000000000;

%Walk 
subjectdata.events_filt.Walk(28).start = 159.032000000000; 
subjectdata.events_filt.Walk(28).task = 'Walk';
subjectdata.events_filt.Walk(28).end = 162.814000000000;

%Walk 
subjectdata.events_filt.Walk(29).start = 167.171000000000; 
subjectdata.events_filt.Walk(29).task = 'Walk';
subjectdata.events_filt.Walk(29).end = 172.847000000000;

%Walk 
subjectdata.events_filt.Walk(31).start = 177.924000000000; 
subjectdata.events_filt.Walk(31).task = 'Walk';
subjectdata.events_filt.Walk(31).end = 182.013000000000;

%Walk 
subjectdata.events_filt.Walk(33).start = 186.546000000000; 
subjectdata.events_filt.Walk(33).task = 'Walk';
subjectdata.events_filt.Walk(33).end = 190.728000000000;

%Walk 
subjectdata.events_filt.Walk(35).start = 195.673000000000; 
subjectdata.events_filt.Walk(35).task = 'Walk';
subjectdata.events_filt.Walk(35).end = 199.043000000000;

%Walk 
subjectdata.events_filt.Walk(37).start = 204.718000000000; 
subjectdata.events_filt.Walk(37).task = 'Walk';
subjectdata.events_filt.Walk(37).end = 207.653000000000;

%Walk 
subjectdata.events_filt.Walk(39).start = 214.521000000000; 
subjectdata.events_filt.Walk(39).task = 'Walk';
subjectdata.events_filt.Walk(39).end = 217.285000000000;

%Walk 
subjectdata.events_filt.Walk(41).start = 222.124000000000; 
subjectdata.events_filt.Walk(41).task = 'Walk';
subjectdata.events_filt.Walk(41).end = 226.336000000000;

%Walk 
subjectdata.events_filt.Walk(43).start = 231.661000000000; 
subjectdata.events_filt.Walk(43).task = 'Walk';
subjectdata.events_filt.Walk(43).end = 236.063000000000;

%Walk 
subjectdata.events_filt.Walk(45).start = 241.291000000000; 
subjectdata.events_filt.Walk(45).task = 'Walk';
subjectdata.events_filt.Walk(45).end = 245.616000000000;

%Walk 
subjectdata.events_filt.Walk(47).start = 250.603000000000; 
subjectdata.events_filt.Walk(47).task = 'Walk';
subjectdata.events_filt.Walk(47).end = 253.562000000000;

%Walk 
subjectdata.events_filt.Walk(49).start = 258.957000000000; 
subjectdata.events_filt.Walk(49).task = 'Walk';
subjectdata.events_filt.Walk(49).end = 263.249000000000;

%Walk 
subjectdata.events_filt.Walk(51).start = 268.078000000000; 
subjectdata.events_filt.Walk(51).task = 'Walk';
subjectdata.events_filt.Walk(51).end = 270.894000000000;

%Walk 
subjectdata.events_filt.Walk(53).start = 276.855000000000; 
subjectdata.events_filt.Walk(53).task = 'Walk';
subjectdata.events_filt.Walk(53).end = 280.963000000000;


%=== FILTERED GAIT EVENTS FOR WALK WITH INTERFERENCE ONLY ===
%Manual Input for Filtered Gait Events based on the exact timings of heelstrike events (not shown here)
subjectdata.events_filt.WalkINT = struct;


%Walk
subjectdata.events_filt.WalkINT(1).task = 'Walk'; 
subjectdata.events_filt.WalkINT(1).start = 11.6900000000000; 
subjectdata.events_filt.WalkINT(1).end = 17.9750000000000;

%Walk
subjectdata.events_filt.WalkINT(3).task = 'Walk'; 
subjectdata.events_filt.WalkINT(3).start = 22.5590000000000; 
subjectdata.events_filt.WalkINT(3).end = 26.7770000000000;

%Walk
subjectdata.events_filt.WalkINT(5).task = 'Walk'; 
subjectdata.events_filt.WalkINT(5).start = 32.1400000000000; 
subjectdata.events_filt.WalkINT(5).end = 34.9170000000000;

%Walk
subjectdata.events_filt.WalkINT(7).task = 'Walk'; 
subjectdata.events_filt.WalkINT(7).start = 41.6780000000000; 
subjectdata.events_filt.WalkINT(7).end = 45.0410000000000;

%Walk
subjectdata.events_filt.WalkINT(9).task = 'Walk'; 
subjectdata.events_filt.WalkINT(9).start = 52.125; 
subjectdata.events_filt.WalkINT(9).end = 53.8860000000000;

%Walk
subjectdata.events_filt.WalkINT(11).task = 'Walk'; 
subjectdata.events_filt.WalkINT(11).start = 64.8800000000000; 
subjectdata.events_filt.WalkINT(11).end = 67.9420000000000;

%Walk
subjectdata.events_filt.WalkINT(13).task = 'Walk'; 
subjectdata.events_filt.WalkINT(13).start = 73.6050000000000; 
subjectdata.events_filt.WalkINT(13).end = 78.3140000000000;

%WAlk
subjectdata.events_filt.WalkINT(15).task = 'Walk'; 
subjectdata.events_filt.WalkINT(15).start = 84.2150000000000; 
subjectdata.events_filt.WalkINT(15).end = 88.8790000000000;

%Walk
subjectdata.events_filt.WalkINT(17).task = 'Walk'; 
subjectdata.events_filt.WalkINT(17).start = 94.7970; 
subjectdata.events_filt.WalkINT(17).end = 99.3490000000000;

%Walk
subjectdata.events_filt.WalkINT(19).task = 'Walk'; 
subjectdata.events_filt.WalkINT(19).start = 104.934000000000; 
subjectdata.events_filt.WalkINT(19).end = 109.725000000000;

%WAlk
subjectdata.events_filt.WalkINT(21).task = 'Walk'; 
subjectdata.events_filt.WalkINT(21).start = 115.628000000000; 
subjectdata.events_filt.WalkINT(21).end = 120.554000000000;

%Walk
subjectdata.events_filt.WalkINT(23).task = 'Walk'; 
subjectdata.events_filt.WalkINT(23).start = 126.760000000000; 
subjectdata.events_filt.WalkINT(23).end = 131.802000000000;

%Walk
subjectdata.events_filt.WalkINT(25).task = 'Walk'; 
subjectdata.events_filt.WalkINT(25).start = 139.466000000000; 
subjectdata.events_filt.WalkINT(25).end = 144.240000000000;

%Walk
subjectdata.events_filt.WalkINT(26).task = 'Walk'; 
subjectdata.events_filt.WalkINT(26).start = 152.748000000000; 
subjectdata.events_filt.WalkINT(26).end = 157.713000000000;

%Walk
subjectdata.events_filt.WalkINT(28).task = 'Walk'; 
subjectdata.events_filt.WalkINT(28).start = 165.937000000000; 
subjectdata.events_filt.WalkINT(28).end = 170.848000000000;

%Walk
subjectdata.events_filt.WalkINT(30).task = 'Walk'; 
subjectdata.events_filt.WalkINT(30).start = 176.566000000000; 
subjectdata.events_filt.WalkINT(30).end = 182.601000000000;

%WAlk
subjectdata.events_filt.WalkINT(32).task = 'Walk'; 
subjectdata.events_filt.WalkINT(32).start = 188.534; 
subjectdata.events_filt.WalkINT(32).end = 191.557000000000;

%Walk
subjectdata.events_filt.WalkINT(34).task = 'Walk'; 
subjectdata.events_filt.WalkINT(34).start = 197.950000000000; 
subjectdata.events_filt.WalkINT(34).end = 202.736000000000;


% ===== Save DATA ====================================================================================================
save([path filesep subjectdata.subject_dir '_datafile.mat'], 'subjectdata', '-mat')

% *********************** END OF SCRIPT *******************************************************************************************************************
