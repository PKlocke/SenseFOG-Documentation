%% sub-19-datafile.m ====================================================
% +------------------------------------------------------+
% |  Subject: SUB-19                                     |
% |                                                      |
% | Author: Philipp Klocke,Moritz Loeffler               | 
% +------------------------------------------------------+

% This script will serve as the main directory matlab file for sub-19

% Chose the pathway for the SenseFOG-main folder after downloading
subjectdata.generalpath     = uigetdir;                                                                                         % Target file should be the SenseFOG-main file after download
subjectdata.filedir         = 'sub-19';
subjectdata.subjectnr       = '19';
subjectdata.subject_dir     = 'sub-19';
path                        = append(subjectdata.generalpath, '/', subjectdata.filedir);
cd(path)


% SIT - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Sit = [];
subjectdata.signalpoint.Sit.EEG_signal          = 11637;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Sit.LFP_signal          = 8911;                                                                         % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Sit.LFP_signal > subjectdata.signalpoint.Sit.EEG_signal;                                             % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Sit.delay = subjectdata.signalpoint.Sit.LFP_signal - subjectdata.signalpoint.Sit.EEG_signal;         % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Sit.EEG_signal > subjectdata.signalpoint.Sit.LFP_signal;                                           % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Sit.delay = subjectdata.signalpoint.Sit.EEG_signal - subjectdata.signalpoint.Sit.LFP_signal;       % Find time-delay between both EEG and LFP
end 


% STAND - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Stand = [];
subjectdata.signalpoint.Stand.EEG_signal        = 9843;                                                                         % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Stand.LFP_signal        = 8088;                                                                         % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Stand.LFP_signal > subjectdata.signalpoint.Stand.EEG_signal;                                         % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Stand.delay = subjectdata.signalpoint.Stand.LFP_signal - subjectdata.signalpoint.Stand.EEG_signal;   % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Stand.EEG_signal > subjectdata.signalpoint.Stand.LFP_signal;                                       % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Stand.delay = subjectdata.signalpoint.Stand.EEG_signal - subjectdata.signalpoint.Stand.LFP_signal; % Find time-delay between both EEG and LFP
end 

% WALK - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Walk = [];
subjectdata.signalpoint.Walk.EEG_signal         = 9637;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Walk.LFP_signal         = 8382;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Walk.LFP_signal > subjectdata.signalpoint.Walk.EEG_signal;                                          % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Walk.delay = subjectdata.signalpoint.Walk.LFP_signal - subjectdata.signalpoint.Walk.EEG_signal;     % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Walk.EEG_signal > subjectdata.signalpoint.Walk.LFP_signal;                                        % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Walk.delay = subjectdata.signalpoint.Walk.EEG_signal - subjectdata.signalpoint.Walk.LFP_signal;   % Find time-delay between both EEG and LFP
end

% WALK WITH STOPS - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.WalkWS = [];
subjectdata.signalpoint.WalkWS.EEG_signal       = 9467;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.WalkWS.LFP_signal       = 8268;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.WalkWS.LFP_signal > subjectdata.signalpoint.WalkWS.EEG_signal;                                      % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.WalkWS.delay = subjectdata.signalpoint.WalkWS.LFP_signal - subjectdata.signalpoint.WalkWS.EEG_signal;% Find time-delay between both EEG and LFP
else subjectdata.signalpoint.WalkWS.EEG_signal > subjectdata.signalpoint.WalkWS.LFP_signal;                                    % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.WalkWS.delay = subjectdata.signalpoint.WalkWS.EEG_signal - subjectdata.signalpoint.WalkWS.LFP_signal;% Find time-delay between both EEG and LFP
end 

%=== FILTERED GAIT EVENTS FOR WALK ONLY ===
% Manual input for filtered gait events based on exact timings of heelstrikes (not shown here)
subjectdata.events_filt.Walk = struct;

%Walk 1
subjectdata.events_filt.Walk(1).start = 11.9530; 
subjectdata.events_filt.Walk(1).task = 'Walk';
subjectdata.events_filt.Walk(1).end = 19.5580000000000;

%Walk
subjectdata.events_filt.Walk(3).start =  25.7240000000000;
subjectdata.events_filt.Walk(3).task = 'Walk';
subjectdata.events_filt.Walk(3).end = 31.8630000000000;

%Walk
subjectdata.events_filt.Walk(6).start =  39.2570000000000;
subjectdata.events_filt.Walk(6).task = 'Walk';
subjectdata.events_filt.Walk(6).end = 45.2510000000000;

%Walk
subjectdata.events_filt.Walk(9).start =  53.5800000000000;
subjectdata.events_filt.Walk(9).task = 'Walk';
subjectdata.events_filt.Walk(9).end = 57.0250000000000;

%Walk
subjectdata.events_filt.Walk(11).start =  69.419;
subjectdata.events_filt.Walk(11).task = 'Walk';
subjectdata.events_filt.Walk(11).end = 75.5620000000000;

%Walk
subjectdata.events_filt.Walk(14).start =  91.4090000000000;
subjectdata.events_filt.Walk(14).task = 'Walk';
subjectdata.events_filt.Walk(14).end = 97.0690000000000;

%Walk
subjectdata.events_filt.Walk(17).start =  112.315000000000;
subjectdata.events_filt.Walk(17).task = 'Walk';
subjectdata.events_filt.Walk(17).end = 117.033000000000;

%Walk
subjectdata.events_filt.Walk(19).start =  124.130000000000;
subjectdata.events_filt.Walk(19).task = 'Walk';
subjectdata.events_filt.Walk(19).end = 127.764000000000;

%Walk
subjectdata.events_filt.Walk(22).start =  143.182000000000;
subjectdata.events_filt.Walk(22).task = 'Walk';
subjectdata.events_filt.Walk(22).end = 149.010000000000;

%Walk
subjectdata.events_filt.Walk(25).start =  160.409000000000;
subjectdata.events_filt.Walk(25).task = 'Walk';
subjectdata.events_filt.Walk(25).end = 167.473000000000;

%Walk
subjectdata.events_filt.Walk(28).start =  188.775000000000;
subjectdata.events_filt.Walk(28).task = 'Walk';
subjectdata.events_filt.Walk(28).end = 193.250000000000;

%Walk
subjectdata.events_filt.Walk(31).start =  204.474000000000;
subjectdata.events_filt.Walk(31).task = 'Walk';
subjectdata.events_filt.Walk(31).end = 211.639000000000;


%=== FILTERED GAIT EVENTS FOR WALK WITH STOPS ONLY ===
%Manual Input for Filtered Gait Events based on the exact timings of heelstrike events (not shown here)
subjectdata.events_filt.WalkWS = struct;

%Walk 1
subjectdata.events_filt.WalkWS(1).task = 'Walk'; 
subjectdata.events_filt.WalkWS(1).start = 10.6970000000000;
subjectdata.events_filt.WalkWS(1).end = 14.4800000000000;

%Walk
subjectdata.events_filt.WalkWS(2).task = 'Walk'; 
subjectdata.events_filt.WalkWS(2).start = 20.2180000000000;
subjectdata.events_filt.WalkWS(2).end = 22.6800000000000;

%Walk
subjectdata.events_filt.WalkWS(4).task = 'Walk'; 
subjectdata.events_filt.WalkWS(4).start = 29.6350000000000;
subjectdata.events_filt.WalkWS(4).end = 30.8950000000000;

%Walk
subjectdata.events_filt.WalkWS(5).task = 'Walk'; 
subjectdata.events_filt.WalkWS(5).start = 36.1430000000000;
subjectdata.events_filt.WalkWS(5).end = 38.6740000000000;

%Walk
subjectdata.events_filt.WalkWS(8).task = 'Walk'; 
subjectdata.events_filt.WalkWS(8).start = 51.5540000000000;
subjectdata.events_filt.WalkWS(8).end = 54.0030000000000;

%Walk
subjectdata.events_filt.WalkWS(9).task = 'Walk'; 
subjectdata.events_filt.WalkWS(9).start = 58.6280000000000;
subjectdata.events_filt.WalkWS(9).end = 61.087;

%Walk
subjectdata.events_filt.WalkWS(12).task = 'Walk'; 
subjectdata.events_filt.WalkWS(12).start = 82.3750000000000;
subjectdata.events_filt.WalkWS(12).end = 86.5050000000000;

%Walk
subjectdata.events_filt.WalkWS(15).task = 'Walk'; 
subjectdata.events_filt.WalkWS(15).start = 104.035000000000;
subjectdata.events_filt.WalkWS(15).end = 106.714000000000;

%Walk
subjectdata.events_filt.WalkWS(18).task = 'Walk'; 
subjectdata.events_filt.WalkWS(18).start = 121.691000000000;
subjectdata.events_filt.WalkWS(18).end = 124.127000000000;

%Walk
subjectdata.events_filt.WalkWS(21).task = 'Walk'; 
subjectdata.events_filt.WalkWS(21).start = 147.731000000000;
subjectdata.events_filt.WalkWS(21).end = 151.118000000000;

%Walk
subjectdata.events_filt.WalkWS(22).task = 'Walk'; 
subjectdata.events_filt.WalkWS(22).start = 155.337000000000;
subjectdata.events_filt.WalkWS(22).end = 157.928000000000;

%Walk
subjectdata.events_filt.WalkWS(25).task = 'Walk'; 
subjectdata.events_filt.WalkWS(25).start = 183.915000000000;
subjectdata.events_filt.WalkWS(25).end = 187.814000000000;

%Walk
subjectdata.events_filt.WalkWS(28).task = 'Walk'; 
subjectdata.events_filt.WalkWS(28).start = 203.371000000000;
subjectdata.events_filt.WalkWS(28).end = 205.602000000000;

%Walk
subjectdata.events_filt.WalkWS(29).task = 'Walk'; 
subjectdata.events_filt.WalkWS(29).start = 210.373000000000;
subjectdata.events_filt.WalkWS(29).end = 212.958000000000;

%Walk
subjectdata.events_filt.WalkWS(32).task = 'Walk'; 
subjectdata.events_filt.WalkWS(32).start = 244.225000000000;
subjectdata.events_filt.WalkWS(32).end = 247.913000000000;

%Selected stop
subjectdata.events_filt.WalkWS(33).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(33).start = 16.2090000000000;
subjectdata.events_filt.WalkWS(33).end = 19.236;

%Selected stop
subjectdata.events_filt.WalkWS(34).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(34).start = 32.7530000000000;
subjectdata.events_filt.WalkWS(34).end = 35.081;

%Selected stop
subjectdata.events_filt.WalkWS(35).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(35).start = 55.8910000000000;
subjectdata.events_filt.WalkWS(35).end = 57.6;

%Selected stop
subjectdata.events_filt.WalkWS(36).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(36).start = 80;
subjectdata.events_filt.WalkWS(36).end = 81.995;

%Selected stop
subjectdata.events_filt.WalkWS(38).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(38).start = 125.390000000000;
subjectdata.events_filt.WalkWS(38).end = 127.291;

%Selected stop
subjectdata.events_filt.WalkWS(39).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(39).start = 152.271000000000;
subjectdata.events_filt.WalkWS(39).end = 154.993;

%Selected stop
subjectdata.events_filt.WalkWS(40).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(40).start = 181.285000000000;
subjectdata.events_filt.WalkWS(40).end = 182.845;

%Selected stop
subjectdata.events_filt.WalkWS(41).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(41).start = 207.462000000000;
subjectdata.events_filt.WalkWS(41).end = 209.293;

%Selected stop
subjectdata.events_filt.WalkWS(42).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(42).start = 239.716000000000;
subjectdata.events_filt.WalkWS(42).end = 242.132;


% ===== Save DATA ====================================================================================================
save([path filesep subjectdata.subject_dir '_datafile.mat'], 'subjectdata', '-mat')

% *********************** END OF SCRIPT *******************************************************************************************************************
