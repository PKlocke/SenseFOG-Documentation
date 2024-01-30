%% sub-17-datafile.m ====================================================
% +------------------------------------------------------+
% |  Subject: SUB-17                                     |
% |                                                      |
% | Author: Philipp Klocke,Moritz Loeffler               | 
% +------------------------------------------------------+

% This script will serve as the main directory matlab file for sub-17

% Chose the pathway for the SenseFOG-main folder after downloading
subjectdata.generalpath     = uigetdir;                                                                                         % Target file should be the SenseFOG-main file after download
subjectdata.filedir         = 'sub-17';
subjectdata.subjectnr       = '17';
subjectdata.subject_dir     = 'sub-17';
path                        = append(subjectdata.generalpath, '/', subjectdata.filedir);
cd(path)


% SIT - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Sit = [];
subjectdata.signalpoint.Sit.EEG_signal          = 17741;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Sit.LFP_signal          = 15856;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Sit.LFP_signal > subjectdata.signalpoint.Sit.EEG_signal;                                             % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Sit.delay = subjectdata.signalpoint.Sit.LFP_signal - subjectdata.signalpoint.Sit.EEG_signal;         % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Sit.EEG_signal > subjectdata.signalpoint.Sit.LFP_signal;                                           % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Sit.delay = subjectdata.signalpoint.Sit.EEG_signal - subjectdata.signalpoint.Sit.LFP_signal;       % Find time-delay between both EEG and LFP
end 


% STAND - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Stand = [];
subjectdata.signalpoint.Stand.EEG_signal        = 17027;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Stand.LFP_signal        = 14551;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Stand.LFP_signal > subjectdata.signalpoint.Stand.EEG_signal;                                         % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Stand.delay = subjectdata.signalpoint.Stand.LFP_signal - subjectdata.signalpoint.Stand.EEG_signal;   % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Stand.EEG_signal > subjectdata.signalpoint.Stand.LFP_signal;                                       % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Stand.delay = subjectdata.signalpoint.Stand.EEG_signal - subjectdata.signalpoint.Stand.LFP_signal; % Find time-delay between both EEG and LFP
end 

% WALK - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Walk = [];
subjectdata.signalpoint.Walk.EEG_signal         = 14030;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Walk.LFP_signal         = 12028;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Walk.LFP_signal > subjectdata.signalpoint.Walk.EEG_signal;                                           % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Walk.delay = subjectdata.signalpoint.Walk.LFP_signal - subjectdata.signalpoint.Walk.EEG_signal;      % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Walk.EEG_signal > subjectdata.signalpoint.Walk.LFP_signal;                                         % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Walk.delay = subjectdata.signalpoint.Walk.EEG_signal - subjectdata.signalpoint.Walk.LFP_signal;    % Find time-delay between both EEG and LFP
end

% WALK WITH STOPS - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.WalkWS = [];
subjectdata.signalpoint.WalkWS.EEG_signal       = 12974;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.WalkWS.LFP_signal       = 10525;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.WalkWS.LFP_signal > subjectdata.signalpoint.WalkWS.EEG_signal;                                       % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.WalkWS.delay = subjectdata.signalpoint.WalkWS.LFP_signal - subjectdata.signalpoint.WalkWS.EEG_signal;% Find time-delay between both EEG and LFP
else subjectdata.signalpoint.WalkWS.EEG_signal > subjectdata.signalpoint.WalkWS.LFP_signal;                                     % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.WalkWS.delay = subjectdata.signalpoint.WalkWS.EEG_signal - subjectdata.signalpoint.WalkWS.LFP_signal;% Find time-delay between both EEG and LFP
end 


% INTERFERENCE - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Interf = [];
subjectdata.signalpoint.Interf.EEG_signal       = [];                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Interf.LFP_signal       = [];                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Interf.LFP_signal > subjectdata.signalpoint.Interf.EEG_signal;                                       % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Interf.delay = subjectdata.signalpoint.Interf.LFP_signal - subjectdata.signalpoint.Interf.EEG_signal;% find time-delay between both EEG and LFP
else subjectdata.signalpoint.Interf.EEG_signal > subjectdata.signalpoint.Interf.LFP_signal;                                     % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Interf.delay = subjectdata.signalpoint.Interf.EEG_signal - subjectdata.signalpoint.Interf.LFP_signal;% Find time-delay between both EEG and LFP
end 


%=== FILTERED GAIT EVENTS FOR WALK ONLY ===
% Manual input for filtered gait events based on exact timings of heelstrikes (not shown here)
subjectdata.events_filt.Walk = struct;

%Walk 1
subjectdata.events_filt.Walk(1).start = 19.9650000000000; 
subjectdata.events_filt.Walk(1).task = 'Walk';
subjectdata.events_filt.Walk(1).end = 26.7380000000000;

%Walk
subjectdata.events_filt.Walk(3).start = 33.7570000000000; 
subjectdata.events_filt.Walk(3).task = 'Walk';
subjectdata.events_filt.Walk(3).end = 42.2290000000000;

%Walk
subjectdata.events_filt.Walk(5).start = 51.6780000000000; 
subjectdata.events_filt.Walk(5).task = 'Walk';
subjectdata.events_filt.Walk(5).end = 59.3310000000000;

%Walk
subjectdata.events_filt.Walk(8).start = 69.4950000000000; 
subjectdata.events_filt.Walk(8).task = 'Walk';
subjectdata.events_filt.Walk(8).end = 76.2170000000000;

%Walk
subjectdata.events_filt.Walk(10).start = 82.7170000000000; 
subjectdata.events_filt.Walk(10).task = 'Walk';
subjectdata.events_filt.Walk(10).end = 92.4740000000000;

%Walk
subjectdata.events_filt.Walk(13).start = 100.906000000000; 
subjectdata.events_filt.Walk(13).task = 'Walk';
subjectdata.events_filt.Walk(13).end = 108.221000000000;

%Freezing while walking
subjectdata.events_filt.Walk(19).start = 152.433000000000; 
subjectdata.events_filt.Walk(19).task = 'Freezing_walk';
subjectdata.events_filt.Walk(19).end = 157.443000000000;

%Walk
subjectdata.events_filt.Walk(20).start = 159.010000000000; 
subjectdata.events_filt.Walk(20).task = 'Walk';
subjectdata.events_filt.Walk(20).end = 161.345000000000;

%Freezing while walking 
subjectdata.events_filt.Walk(23).start = 185.437000000000; 
subjectdata.events_filt.Walk(23).task = 'Freezing_walk';
subjectdata.events_filt.Walk(23).end = 187.300000000000;

%Freezing while walking
subjectdata.events_filt.Walk(24).start = 192.997000000000; 
subjectdata.events_filt.Walk(24).task = 'Freezing_walk';
subjectdata.events_filt.Walk(24).end = 198.465000000000;

%Freezing while walking
subjectdata.events_filt.Walk(27).start = 215.498000000000; 
subjectdata.events_filt.Walk(27).task = 'Freezing_walk';
subjectdata.events_filt.Walk(27).end = 225.591000000000;

%Freezing while walking
subjectdata.events_filt.Walk(28).start = 233.161000000000; 
subjectdata.events_filt.Walk(28).task = 'Freezing_walk';
subjectdata.events_filt.Walk(28).end = 267.123;



%=== FILTERED GAIT EVENTS FOR WALK WITH STOPS ONLY ===
%Manual Input for Filtered Gait Events based on the exact timings of heelstrike events (not shown here)
subjectdata.events_filt.WalkWS = struct;

%Walk 1
subjectdata.events_filt.WalkWS(1).start = 21.7980000000000;
subjectdata.events_filt.WalkWS(1).task = 'Walk'; 
subjectdata.events_filt.WalkWS(1).end = 25.9640000000000;

%Selected_stop  Dauer unter 1s
%subjectdata.events_filt.WalkWS(2).start = 27.6790000000000;
%subjectdata.events_filt.WalkWS(2).task = 'Selected_stop'; 
%subjectdata.events_filt.WalkWS(2).end = [];

%Walk
subjectdata.events_filt.WalkWS(3).start = 29.0630000000000;
subjectdata.events_filt.WalkWS(3).task = 'Walk'; 
subjectdata.events_filt.WalkWS(3).end = 33.1420000000000;

%Walk
subjectdata.events_filt.WalkWS(5).start = 37.8130000000000;
subjectdata.events_filt.WalkWS(5).task = 'Walk'; 
subjectdata.events_filt.WalkWS(5).end = 40.5180000000000;

%Selected stop
subjectdata.events_filt.WalkWS(6).start = 42.9630000000000;
subjectdata.events_filt.WalkWS(6).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(6).end = 44.606;

%Walk
subjectdata.events_filt.WalkWS(7).start = 45.1720000000000;
subjectdata.events_filt.WalkWS(7).task = 'Walk'; 
subjectdata.events_filt.WalkWS(7).end = 49.1470000000000;

%Walk
subjectdata.events_filt.WalkWS(9).start = 55.9270000000000;
subjectdata.events_filt.WalkWS(9).task = 'Walk'; 
subjectdata.events_filt.WalkWS(9).end = 58.5560000000000;

%Selected stop
subjectdata.events_filt.WalkWS(10).start = 60.9750000000000;
subjectdata.events_filt.WalkWS(10).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(10).end = 62.096;

%Walk 
subjectdata.events_filt.WalkWS(11).start = 62.8830000000000;
subjectdata.events_filt.WalkWS(11).task = 'Walk'; 
subjectdata.events_filt.WalkWS(11).end = 67.8880000000000;

%Walk
subjectdata.events_filt.WalkWS(13).start = 73.3680000000000;
subjectdata.events_filt.WalkWS(13).task = 'Walk'; 
subjectdata.events_filt.WalkWS(13).end = 78.1010000000000;

%Selected stop
subjectdata.events_filt.WalkWS(14).start = 79.7090000000000;
subjectdata.events_filt.WalkWS(14).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(14).end = 81.441;

%Walk
subjectdata.events_filt.WalkWS(15).start = 81.9850000000000;
subjectdata.events_filt.WalkWS(15).task = 'Walk'; 
subjectdata.events_filt.WalkWS(15).end = 87.0450000000000;

%Walk
subjectdata.events_filt.WalkWS(17).start = 93.0030000000000;
subjectdata.events_filt.WalkWS(17).task = 'Walk'; 
subjectdata.events_filt.WalkWS(17).end = 96.6010000000000;

%Selected stop
subjectdata.events_filt.WalkWS(18).start = 97.7110000000000;
subjectdata.events_filt.WalkWS(18).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(18).end = 99.371;

%Walk
subjectdata.events_filt.WalkWS(19).start = 101.691000000000;
subjectdata.events_filt.WalkWS(19).task = 'Walk'; 
subjectdata.events_filt.WalkWS(19).end = 104.104000000000;

%Selected stop
subjectdata.events_filt.WalkWS(20).start = 119.491;
subjectdata.events_filt.WalkWS(20).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(20).end = 121.205;

%Walk
subjectdata.events_filt.WalkWS(21).start = 121.762000000000;
subjectdata.events_filt.WalkWS(21).task = 'Walk'; 
subjectdata.events_filt.WalkWS(21).end = 125.820000000000;

%Walk
subjectdata.events_filt.WalkWS(23).start = 144.018000000000;
subjectdata.events_filt.WalkWS(23).task = 'Walk'; 
subjectdata.events_filt.WalkWS(23).end = 148.016000000000;

%Selected stop 
subjectdata.events_filt.WalkWS(24).start = 150.953000000000;
subjectdata.events_filt.WalkWS(24).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(24).end = 152.509;

%Walk
subjectdata.events_filt.WalkWS(25).start = 153.076000000000;
subjectdata.events_filt.WalkWS(25).task = 'Walk'; 
subjectdata.events_filt.WalkWS(25).end = 158.123000000000;

%Walk
subjectdata.events_filt.WalkWS(28).start = 168.720000000000;
subjectdata.events_filt.WalkWS(28).task = 'Walk'; 
subjectdata.events_filt.WalkWS(28).end = 172.391000000000;

%Selected stop
subjectdata.events_filt.WalkWS(29).start = 175.371000000000;
subjectdata.events_filt.WalkWS(29).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(29).end = 176.7630;

%Walk
subjectdata.events_filt.WalkWS(30).start = 179.064000000000;
subjectdata.events_filt.WalkWS(30).task = 'Walk'; 
subjectdata.events_filt.WalkWS(30).end = 181.758000000000;

%Selected stop
subjectdata.events_filt.WalkWS(33).start = 196.530000000000;
subjectdata.events_filt.WalkWS(33).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(33).end = 198.371;

%Walk
subjectdata.events_filt.WalkWS(34).start = 199.099000000000;
subjectdata.events_filt.WalkWS(34).task = 'Walk'; 
subjectdata.events_filt.WalkWS(34).end = 204.215000000000;

%Selected stop
subjectdata.events_filt.WalkWS(37).start = 221.206;
subjectdata.events_filt.WalkWS(37).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(37).end = 223.565;

%Walk
subjectdata.events_filt.WalkWS(38).start = 225.771000000000;
subjectdata.events_filt.WalkWS(38).task = 'Walk'; 
subjectdata.events_filt.WalkWS(38).end = 228.138000000000;

%Freezing while walking 
subjectdata.events_filt.WalkWS(39).start = 230.045000000000;
subjectdata.events_filt.WalkWS(39).task = 'Freezing_walk'; 
subjectdata.events_filt.WalkWS(39).end = 233.74;


% ===== Save DATA ====================================================================================================
save([path filesep subjectdata.subject_dir '_datafile.mat'], 'subjectdata', '-mat')

% *********************** END OF SCRIPT *******************************************************************************************************************
