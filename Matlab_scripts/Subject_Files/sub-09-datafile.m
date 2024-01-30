%% sub-09-datafile.m ====================================================
% +------------------------------------------------------+
% |  Subject: SUB-09                                     |
% |                                                      |
% | Author: Philipp Klocke,Moritz Loeffler               | 
% +------------------------------------------------------+

% This script will serve as the main directory matlab file for sub-09

% Chose the pathway for the SenseFOG-main folder after downloading
subjectdata.generalpath     = uigetdir;                                                                                         % Target file should be the SenseFOG-main file after download
subjectdata.filedir         = 'sub-09';
subjectdata.subjectnr       = '09';
subjectdata.subject_dir     = 'sub-09';
path                        = append(subjectdata.generalpath, '/', subjectdata.filedir);
cd(path)


% SIT - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Sit = [];
subjectdata.signalpoint.Sit.EEG_signal          = 16724;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Sit.LFP_signal          = 37128;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Sit.LFP_signal > subjectdata.signalpoint.Sit.EEG_signal;                                             % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Sit.delay = subjectdata.signalpoint.Sit.LFP_signal - subjectdata.signalpoint.Sit.EEG_signal;         % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Sit.EEG_signal > subjectdata.signalpoint.Sit.LFP_signal;                                           % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Sit.delay = subjectdata.signalpoint.Sit.EEG_signal - subjectdata.signalpoint.Sit.LFP_signal;       % Find time-delay between both EEG and LFP
end 


% STAND - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Stand = [];
subjectdata.signalpoint.Stand.EEG_signal        = 16533;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Stand.LFP_signal        = 11648;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Stand.LFP_signal > subjectdata.signalpoint.Stand.EEG_signal;                                         % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Stand.delay = subjectdata.signalpoint.Stand.LFP_signal - subjectdata.signalpoint.Stand.EEG_signal;   % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Stand.EEG_signal > subjectdata.signalpoint.Stand.LFP_signal;                                       % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Stand.delay = subjectdata.signalpoint.Stand.EEG_signal - subjectdata.signalpoint.Stand.LFP_signal; % Find time-delay between both EEG and LFP
end 

% WALK - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Walk = [];
subjectdata.signalpoint.Walk.EEG_signal         = 19377;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Walk.LFP_signal         = 12190;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Walk.LFP_signal > subjectdata.signalpoint.Walk.EEG_signal;                                           % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Walk.delay = subjectdata.signalpoint.Walk.LFP_signal - subjectdata.signalpoint.Walk.EEG_signal;      % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Walk.EEG_signal > subjectdata.signalpoint.Walk.LFP_signal;                                         % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Walk.delay = subjectdata.signalpoint.Walk.EEG_signal - subjectdata.signalpoint.Walk.LFP_signal;    % Find time-delay between both EEG and LFP
end

% WALK WITH STOPS - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.WalkWS = [];
subjectdata.signalpoint.WalkWS.EEG_signal       = 20169;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.WalkWS.LFP_signal       = 16820;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.WalkWS.LFP_signal > subjectdata.signalpoint.WalkWS.EEG_signal;                                       % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.WalkWS.delay = subjectdata.signalpoint.WalkWS.LFP_signal - subjectdata.signalpoint.WalkWS.EEG_signal;% Find time-delay between both EEG and LFP
else subjectdata.signalpoint.WalkWS.EEG_signal > subjectdata.signalpoint.WalkWS.LFP_signal;                                     % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.WalkWS.delay = subjectdata.signalpoint.WalkWS.EEG_signal - subjectdata.signalpoint.WalkWS.LFP_signal;% Find time-delay between both EEG and LFP
end 


%=== FILTERED GAIT EVENTS FOR WALK ONLY ===
% Manual input for filtered gait events based on exact timings of heelstrikes (not shown here)
subjectdata.events_filt.Walk = struct;

%Walk 1
subjectdata.events_filt.Walk(1).start = 26.8560; 
subjectdata.events_filt.Walk(1).task = 'Walk';
subjectdata.events_filt.Walk(1).end = 35.3570;

%Walk 2
subjectdata.events_filt.Walk(4).start = 45.5940;
subjectdata.events_filt.Walk(4).task = 'Walk'; 
subjectdata.events_filt.Walk(4).end = 58.6590;

%Walk 3
subjectdata.events_filt.Walk(7).start = 70.5370000000000; 
subjectdata.events_filt.Walk(7).task = 'Walk';
subjectdata.events_filt.Walk(7).end = 82.8350000000000;

%Walk 4
subjectdata.events_filt.Walk(10).start = 90.9560000000000;
subjectdata.events_filt.Walk(10).task = 'Walk'; 
subjectdata.events_filt.Walk(10).end = 102.842000000000;

%Freezing Walkinitiation 1
%subjectdata.events_filt.Walk(14).start =  [];
%subjectdata.events_filt.Walk(14).task = 'Freezing_walk_initiation';
%subjectdata.events_filt.Walk(14).end = [];

%Walk 5
subjectdata.events_filt.Walk(15).start =  209.055000000000;
subjectdata.events_filt.Walk(15).task = 'Walk';
subjectdata.events_filt.Walk(15).end = 217.899000000000;

%Walk 6
subjectdata.events_filt.Walk(17).start =  223.584000000000;
subjectdata.events_filt.Walk(17).task = 'Walk';
subjectdata.events_filt.Walk(17).end = 233.389000000000;

%Walk 7
subjectdata.events_filt.Walk(20).start = 239.129000000000;
subjectdata.events_filt.Walk(20).task = 'Walk';
subjectdata.events_filt.Walk(20).end = 246.781000000000;


%=== FILTERED GAIT EVENTS FOR WALK WITH STOPS ONLY ===
%Manual Input for Filtered Gait Events based on the exact timings of heelstrike events (not shown here)
subjectdata.events_filt.WalkWS = struct;

%Walk 1
subjectdata.events_filt.WalkWS(1).task = 'Walk'; 
subjectdata.events_filt.WalkWS(1).start = 26.5090000000000;
subjectdata.events_filt.WalkWS(1).end = 38.9220;

%Walk 2
subjectdata.events_filt.WalkWS(4).start = 45.4610000000000;
subjectdata.events_filt.WalkWS(4).task = 'Walk'; 
subjectdata.events_filt.WalkWS(4).end = 54.9450000000000;

%Walk 3
subjectdata.events_filt.WalkWS(5).start = 58.5550000000000;
subjectdata.events_filt.WalkWS(5).task = 'Walk'; 
subjectdata.events_filt.WalkWS(5).end = 67.2740000000000;

%Walk 4
subjectdata.events_filt.WalkWS(8).start = 73.5860000000000;
subjectdata.events_filt.WalkWS(8).task = 'Walk'; 
subjectdata.events_filt.WalkWS(8).end = 75.00;

%Selected Stop 1
subjectdata.events_filt.WalkWS(9).start = 76.54700000;
subjectdata.events_filt.WalkWS(9).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(9).end = 79.796;
 
%Walk 5
subjectdata.events_filt.WalkWS(10).start = 97.1560000000000;
subjectdata.events_filt.WalkWS(10).task = 'Walk'; 
subjectdata.events_filt.WalkWS(10).end = 101.531000000000;

%Walk 7
subjectdata.events_filt.WalkWS(14).start = 114.102000000000;
subjectdata.events_filt.WalkWS(14).task = 'Walk'; 
subjectdata.events_filt.WalkWS(14).end = 117.922000000000;

%Walk 8
subjectdata.events_filt.WalkWS(17).start = 124.305000000000;
subjectdata.events_filt.WalkWS(17).task = 'Walk'; 
subjectdata.events_filt.WalkWS(17).end = 126.156000000000;

%Selected stop 9
subjectdata.events_filt.WalkWS(19).start = 127.774;
subjectdata.events_filt.WalkWS(19).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(19).end = 130.016;

%Walk 9
subjectdata.events_filt.WalkWS(20).start = 135.679000000000; 
subjectdata.events_filt.WalkWS(20).task = 'Walk'; 
subjectdata.events_filt.WalkWS(20).end = 137.024000000000;

%Walk 10
subjectdata.events_filt.WalkWS(23).start = 143.945000000000;
subjectdata.events_filt.WalkWS(23).task = 'Walk'; 
subjectdata.events_filt.WalkWS(23).end = 146.523000000000;

%Walk
subjectdata.events_filt.WalkWS(28).start = 161.7500;
subjectdata.events_filt.WalkWS(28).task= 'Walk'; 
subjectdata.events_filt.WalkWS(28).end = 162.383000000000;

%Selected stop
subjectdata.events_filt.WalkWS(30).start = 163.906;
subjectdata.events_filt.WalkWS(30).task= 'Selected_stop'; 
subjectdata.events_filt.WalkWS(30).end = 166.211;

% ===== Save DATA ====================================================================================================
save([path filesep subjectdata.subject_dir '_datafile.mat'], 'subjectdata', '-mat')

% *********************** END OF SCRIPT *******************************************************************************************************************
