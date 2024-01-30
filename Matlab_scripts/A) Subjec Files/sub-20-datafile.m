%% sub-20-datafile.m ====================================================
% +------------------------------------------------------+
% |  Subject: SUB-20                                     |
% |                                                      |
% | Author: Philipp Klocke,Moritz Loeffler               | 
% +------------------------------------------------------+

% This script will serve as the main directory matlab file for sub-20

% Chose the pathway for the SenseFOG-main folder after downloading
subjectdata.generalpath     = uigetdir;                                                                                         % Target file should be the SenseFOG-main file after download
subjectdata.filedir         = 'sub-20';
subjectdata.subjectnr       = '20';
subjectdata.subject_dir     = 'sub-20';
path                        = append(subjectdata.generalpath, '/', subjectdata.filedir);
cd(path)



% SIT - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Sit = [];
subjectdata.signalpoint.Sit.EEG_signal          = 9628;                                                                         % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Sit.LFP_signal          = 8062;                                                                         % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Sit.LFP_signal > subjectdata.signalpoint.Sit.EEG_signal;                                             % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Sit.delay = subjectdata.signalpoint.Sit.LFP_signal - subjectdata.signalpoint.Sit.EEG_signal;         % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Sit.EEG_signal > subjectdata.signalpoint.Sit.LFP_signal;                                           % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Sit.delay = subjectdata.signalpoint.Sit.EEG_signal - subjectdata.signalpoint.Sit.LFP_signal;       % Find time-delay between both EEG and LFP
end 


% STAND - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Stand = [];
subjectdata.signalpoint.Stand.EEG_signal        = 9874;                                                                         % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Stand.LFP_signal        = 8520;                                                                         % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Stand.LFP_signal > subjectdata.signalpoint.Stand.EEG_signal;                                         % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Stand.delay = subjectdata.signalpoint.Stand.LFP_signal - subjectdata.signalpoint.Stand.EEG_signal;   % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Stand.EEG_signal > subjectdata.signalpoint.Stand.LFP_signal;                                       % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Stand.delay = subjectdata.signalpoint.Stand.EEG_signal - subjectdata.signalpoint.Stand.LFP_signal; % Find time-delay between both EEG and LFP
end 

% WALK - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Walk = [];
subjectdata.signalpoint.Walk.EEG_signal         = 9278;                                                                         % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Walk.LFP_signal         = 8329;                                                                         % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Walk.LFP_signal > subjectdata.signalpoint.Walk.EEG_signal;                                           % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Walk.delay = subjectdata.signalpoint.Walk.LFP_signal - subjectdata.signalpoint.Walk.EEG_signal;      % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Walk.EEG_signal > subjectdata.signalpoint.Walk.LFP_signal;                                         % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Walk.delay = subjectdata.signalpoint.Walk.EEG_signal - subjectdata.signalpoint.Walk.LFP_signal;    % Find time-delay between both EEG and LFP
end

% WALK WITH STOPS - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.WalkWS = [];
subjectdata.signalpoint.WalkWS.EEG_signal       = 9091;                                                                         % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.WalkWS.LFP_signal       = 7806;                                                                         % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.WalkWS.LFP_signal > subjectdata.signalpoint.WalkWS.EEG_signal;                                       % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.WalkWS.delay = subjectdata.signalpoint.WalkWS.LFP_signal - subjectdata.signalpoint.WalkWS.EEG_signal;% Find time-delay between both EEG and LFP
else subjectdata.signalpoint.WalkWS.EEG_signal > subjectdata.signalpoint.WalkWS.LFP_signal;                                     % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.WalkWS.delay = subjectdata.signalpoint.WalkWS.EEG_signal - subjectdata.signalpoint.WalkWS.LFP_signal;% Find time-delay between both EEG and LFP
end 


% INTERFERENCE - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.WalkINT = [];
subjectdata.signalpoint.WalkINT.EEG_signal       = 9230;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.WalkINT.LFP_signal       = 7704;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.WalkINT.LFP_signal > subjectdata.signalpoint.WalkINT.EEG_signal;                                       % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.WalkINT.delay = subjectdata.signalpoint.WalkINT.LFP_signal - subjectdata.signalpoint.WalkINT.EEG_signal;% find time-delay between both EEG and LFP
else subjectdata.signalpoint.WalkINT.EEG_signal > subjectdata.signalpoint.WalkINT.LFP_signal;                                     % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.WalkINT.delay = subjectdata.signalpoint.WalkINT.EEG_signal - subjectdata.signalpoint.WalkINT.LFP_signal;% Find time-delay between both EEG and LFP
end 


%=== FILTERED GAIT EVENTS FOR WALK ONLY ===
% Manual input for filtered gait events based on exact timings of heelstrikes (not shown here)
subjectdata.events_filt.Walk = struct;

%Walk 1
subjectdata.events_filt.Walk(1).start = 12.4700; 
subjectdata.events_filt.Walk(1).task = 'Walk';
subjectdata.events_filt.Walk(1).end = 18.4380000000000;

%Walk
subjectdata.events_filt.Walk(4).start =  25.7040000000000;
subjectdata.events_filt.Walk(4).task = 'Walk';
subjectdata.events_filt.Walk(4).end = 32.4300000000000;

%Walk
subjectdata.events_filt.Walk(7).start =  38.1000000000000;
subjectdata.events_filt.Walk(7).task = 'Walk';
subjectdata.events_filt.Walk(7).end = 42.8940000000000;

%Walk
subjectdata.events_filt.Walk(8).start =  50.116;
subjectdata.events_filt.Walk(8).task = 'Walk';
subjectdata.events_filt.Walk(8).end = 55.8940000000000;

%Walk
subjectdata.events_filt.Walk(11).start =  63.7860000000000;
subjectdata.events_filt.Walk(11).task = 'Walk';
subjectdata.events_filt.Walk(11).end = 69.3010000000000;

%Walk
subjectdata.events_filt.Walk(14).start =  78.6910;
subjectdata.events_filt.Walk(14).task = 'Walk';
subjectdata.events_filt.Walk(14).end = 85.2010000000000;

%Walk
subjectdata.events_filt.Walk(17).start =  94.5630000000000;
subjectdata.events_filt.Walk(17).task = 'Walk';
subjectdata.events_filt.Walk(17).end = 99.1570000000000;

%Walk
subjectdata.events_filt.Walk(20).start =  110.969000000000;
subjectdata.events_filt.Walk(20).task = 'Walk';
subjectdata.events_filt.Walk(20).end = 116.027000000000;

%Walk
subjectdata.events_filt.Walk(22).start =  121.114000000000;
subjectdata.events_filt.Walk(22).task = 'Walk';
subjectdata.events_filt.Walk(22).end = 127.201000000000;

%Walk
subjectdata.events_filt.Walk(23).start =  137.091000000000;
subjectdata.events_filt.Walk(23).task = 'Walk';
subjectdata.events_filt.Walk(23).end = 141.648000000000;

%Walk
subjectdata.events_filt.Walk(26).start =  149.362;
subjectdata.events_filt.Walk(26).task = 'Walk';
subjectdata.events_filt.Walk(26).end = 155.030000000000;

%WAalk
subjectdata.events_filt.Walk(29).start =  164.756000000000;
subjectdata.events_filt.Walk(29).task = 'Walk';
subjectdata.events_filt.Walk(29).end = 170.109000000000;

%Walk
subjectdata.events_filt.Walk(32).start =  184.216000000000;
subjectdata.events_filt.Walk(32).task = 'Walk';
subjectdata.events_filt.Walk(32).end = 187.532000000000;

%Walk
subjectdata.events_filt.Walk(35).start =  201.239000000000;
subjectdata.events_filt.Walk(35).task = 'Walk';
subjectdata.events_filt.Walk(35).end = 206.580000000000;

%Walk
subjectdata.events_filt.Walk(38).start =  215.919000000000;
subjectdata.events_filt.Walk(38).task = 'Walk';
subjectdata.events_filt.Walk(38).end = 221.263000000000;

%Freezing while walking
subjectdata.events_filt.Walk(41).start =  128.930000000000;
subjectdata.events_filt.Walk(41).task = 'Freezing_walk';
subjectdata.events_filt.Walk(41).end = 131.174000000000;



%=== FILTERED GAIT EVENTS FOR WALK WITH INTERFERENCE ONLY ===
%Manual Input for Filtered Gait Events based on the exact timings of heelstrike events (not shown here)
subjectdata.events_filt.WalkINT = struct;

%Walk
subjectdata.events_filt.WalkINT(1).task = 'Walk'; 
subjectdata.events_filt.WalkINT(1).start = 11.5890000000000; 
subjectdata.events_filt.WalkINT(1).end = 19;

%Walk
subjectdata.events_filt.WalkINT(4).task = 'Walk'; 
subjectdata.events_filt.WalkINT(4).start = 32.2470000000000; 
subjectdata.events_filt.WalkINT(4).end = 42.0990000000000;

%Walk
subjectdata.events_filt.WalkINT(7).task = 'Walk'; 
subjectdata.events_filt.WalkINT(7).start = 55.0730000000000; 
subjectdata.events_filt.WalkINT(7).end = 63.0680000000000;

%Freezing while walking
subjectdata.events_filt.WalkINT(10).task = 'Freezing_walk'; 
subjectdata.events_filt.WalkINT(10).start = 86.5300000000000; 
subjectdata.events_filt.WalkINT(10).end = 88.5740000000000;

%Walk
subjectdata.events_filt.WalkINT(11).task = 'Walk'; 
subjectdata.events_filt.WalkINT(11).start = 117.675000000000; 
subjectdata.events_filt.WalkINT(11).end = 125.290000000000;

%Walk
subjectdata.events_filt.WalkINT(12).task = 'Walk'; 
subjectdata.events_filt.WalkINT(12).start = 150.015000000000; 
subjectdata.events_filt.WalkINT(12).end = 157.082000000000;

%Walk
subjectdata.events_filt.WalkINT(19).task = 'Walk'; 
subjectdata.events_filt.WalkINT(19).start = 292.374000000000; 
subjectdata.events_filt.WalkINT(19).end = 301.615000000000;


% ===== Save DATA ====================================================================================================
save([path filesep subjectdata.subject_dir '_datafile.mat'], 'subjectdata', '-mat')

% *********************** END OF SCRIPT *******************************************************************************************************************
