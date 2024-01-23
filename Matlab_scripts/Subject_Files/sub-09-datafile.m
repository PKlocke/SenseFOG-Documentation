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

%Turn 1
subjectdata.events_filt.Walk(2).start =  37.3150;
subjectdata.events_filt.Walk(2).task = 'Turn';
subjectdata.events_filt.Walk(2).end = 43.6700;

%Freezing while turning 1
subjectdata.events_filt.Walk(3).start = 39.0370;
subjectdata.events_filt.Walk(3).task = 'Freezing_turn';
subjectdata.events_filt.Walk(3).end = 44.3170;

%Walk 2
subjectdata.events_filt.Walk(4).start = 45.5940;
subjectdata.events_filt.Walk(4).task = 'Walk'; 
subjectdata.events_filt.Walk(4).end = 58.6590;

%Turn 2
subjectdata.events_filt.Walk(5).start =  59.9890;
subjectdata.events_filt.Walk(5).task = 'Turn';
subjectdata.events_filt.Walk(5).end = 67.9420000000000;

%Freezing while turning 2
subjectdata.events_filt.Walk(6).start =  61.9540000000000;
subjectdata.events_filt.Walk(6).task = 'Freezing_turn';
subjectdata.events_filt.Walk(6).end = 67.9420000000000;

%Walk 3
subjectdata.events_filt.Walk(7).start = 70.5370000000000; 
subjectdata.events_filt.Walk(7).task = 'Walk';
subjectdata.events_filt.Walk(7).end = 82.8350000000000;

%Turn 3
subjectdata.events_filt.Walk(8).start =  83.6520000000000;
subjectdata.events_filt.Walk(8).task = 'Turn';
subjectdata.events_filt.Walk(8).end = 87.3090;

%Freezing while turning 3
subjectdata.events_filt.Walk(9).start =  85.1400000000000;
subjectdata.events_filt.Walk(9).task = 'Freezing_turn';
subjectdata.events_filt.Walk(9).end = 89.1620000000000;

%Walk 4
subjectdata.events_filt.Walk(10).start = 90.9560000000000;
subjectdata.events_filt.Walk(10).task = 'Walk'; 
subjectdata.events_filt.Walk(10).end = 102.842000000000;

%Turn 4
subjectdata.events_filt.Walk(11).start =  103.645000000000;
subjectdata.events_filt.Walk(11).task = 'Turn';
subjectdata.events_filt.Walk(11).end = 110.108000000000;

%Freezing while turning 4
subjectdata.events_filt.Walk(12).start =  105.518000000000;
subjectdata.events_filt.Walk(12).task = 'Freezing_turn';
subjectdata.events_filt.Walk(12).end = 110.108000000000;

%Freezing while walking 1 % After review, it was decided to omit this Freeze Walk
%as freezing occurs during Turn. This is likely not a pure walk Freeze
%subjectdata.events_filt.Walk(13).start = 110.344000000000; 
%subjectdata.events_filt.Walk(13).task = 'Freezing_walk';
%subjectdata.events_filt.Walk(13).end = 168.101000000000;

%Freezing Walkinitiation 1
%subjectdata.events_filt.Walk(14).start =  [];
%subjectdata.events_filt.Walk(14).task = 'Freezing_walk_initiation';
%subjectdata.events_filt.Walk(14).end = [];

%Walk 5
subjectdata.events_filt.Walk(15).start =  209.055000000000;
subjectdata.events_filt.Walk(15).task = 'Walk';
subjectdata.events_filt.Walk(15).end = 217.899000000000;

%Turn 5
subjectdata.events_filt.Walk(16).start =  219.1230;
subjectdata.events_filt.Walk(16).task = 'Turn';
subjectdata.events_filt.Walk(16).end = 223.2530;

%Walk 6
subjectdata.events_filt.Walk(17).start =  223.584000000000;
subjectdata.events_filt.Walk(17).task = 'Walk';
subjectdata.events_filt.Walk(17).end = 233.389000000000;

%Turn 6
subjectdata.events_filt.Walk(18).start =  234.0920;
subjectdata.events_filt.Walk(18).task = 'Turn';
subjectdata.events_filt.Walk(18).end = 239.1290;

%Freezing while turning 5
subjectdata.events_filt.Walk(19).start =  235.475000000000;
subjectdata.events_filt.Walk(19).task = 'Freezing_turn';
subjectdata.events_filt.Walk(19).end = 237.740000000000;

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

%Turn 1
subjectdata.events_filt.WalkWS(2).task = 'Turn'; 
subjectdata.events_filt.WalkWS(2).start = 39.7190000000000;
subjectdata.events_filt.WalkWS(2).end = 43.8900000000000;

%Freezing while turning 1
subjectdata.events_filt.WalkWS(3).task = 'Freezing_turn'; 
subjectdata.events_filt.WalkWS(3).start = 41.6180;
subjectdata.events_filt.WalkWS(3).end = 44.6490000000000;

%Walk 2
subjectdata.events_filt.WalkWS(4).start = 45.4610000000000;
subjectdata.events_filt.WalkWS(4).task = 'Walk'; 
subjectdata.events_filt.WalkWS(4).end = 54.9450000000000;

%Walk 3
subjectdata.events_filt.WalkWS(5).start = 58.5550000000000;
subjectdata.events_filt.WalkWS(5).task = 'Walk'; 
subjectdata.events_filt.WalkWS(5).end = 67.2740000000000;

%Turn 2
subjectdata.events_filt.WalkWS(6).start = 68.0390000000000;
subjectdata.events_filt.WalkWS(6).task = 'Turn'; 
subjectdata.events_filt.WalkWS(6).end = 72.8670000000000;

%Freezing while turning
subjectdata.events_filt.WalkWS(7).start = 69.9840;
subjectdata.events_filt.WalkWS(7).task = 'Freezing_turn'; 
subjectdata.events_filt.WalkWS(7).end = 72.8670000000000;

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

%Turn 3, omit after discussion
%subjectdata.events_filt.WalkWS(11).start = 102.250000000000; 
%subjectdata.events_filt.WalkWS(11).task = 'Turn' ; 
%subjectdata.events_filt.WalkWS(11).end = 105.789000000000; 


%Freezing upon walk initiation %Questionable, after review 04/23 we wont
%use this for the currenct project
%subjectdata.events_filt.WalkWS(12).start = 109.1560;
%subjectdata.events_filt.WalkWS(12).task = 'Freezing_walk_initiation' ; 
%subjectdata.events_filt.WalkWS(12).end = 111.2030;


%Freezing upon turning, omit after discussion
%subjectdata.events_filt.WalkWS(13).start = 103.4920;
%subjectdata.events_filt.WalkWS(13).task = 'Freezing_turn'; 
%subjectdata.events_filt.WalkWS(13).end = 106.4140;

%Walk 7
subjectdata.events_filt.WalkWS(14).start = 114.102000000000;
subjectdata.events_filt.WalkWS(14).task = 'Walk'; 
subjectdata.events_filt.WalkWS(14).end = 117.922000000000;


%Turn 4
subjectdata.events_filt.WalkWS(15).start = 118.703000000000;
subjectdata.events_filt.WalkWS(15).task = 'Turn'; 
subjectdata.events_filt.WalkWS(15).end = 123.6640;

%Freezing upon turning
subjectdata.events_filt.WalkWS(16).start = 121.1100; 
subjectdata.events_filt.WalkWS(16).task = 'Freezing_turn'; 
subjectdata.events_filt.WalkWS(16).end = 123.078000000000;

%Walk 8
subjectdata.events_filt.WalkWS(17).start = 124.305000000000;
subjectdata.events_filt.WalkWS(17).task = 'Walk'; 
subjectdata.events_filt.WalkWS(17).end = 126.156000000000;

%Freezing_walk_initiation %Questionable, after review 04/23 we wont
%use this for the currenct project
%subjectdata.events_filt.WalkWS(18).start = 130.0150;
%subjectdata.events_filt.WalkWS(18).task = 'Freezing_walk_initiation'; 
%subjectdata.events_filt.WalkWS(18).end = 131.125000000000;

%Selected stop 9
subjectdata.events_filt.WalkWS(19).start = 127.774;
subjectdata.events_filt.WalkWS(19).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(19).end = 130.016;

%Walk 9
subjectdata.events_filt.WalkWS(20).start = 135.679000000000; 
subjectdata.events_filt.WalkWS(20).task = 'Walk'; 
subjectdata.events_filt.WalkWS(20).end = 137.024000000000;

%Turn
subjectdata.events_filt.WalkWS(21).start = 137.688000000000;
subjectdata.events_filt.WalkWS(21).task = 'Turn'; 
subjectdata.events_filt.WalkWS(21).end = 141.680000000000;

%Freezing upon turning
subjectdata.events_filt.WalkWS(22).start = 138.7340; 
subjectdata.events_filt.WalkWS(22).task = 'Freezing_turn'; 
subjectdata.events_filt.WalkWS(22).end = 142.5080;

%Walk 10
subjectdata.events_filt.WalkWS(23).start = 143.945000000000;
subjectdata.events_filt.WalkWS(23).task = 'Walk'; 
subjectdata.events_filt.WalkWS(23).end = 146.523000000000;

%Freezing upon walking %OMit this Freeze after review 04/23
%subjectdata.events_filt.WalkWS(24).start = 146.5230;
%subjectdata.events_filt.WalkWS(24).task = 'Freezing_walk'; 
%subjectdata.events_filt.WalkWS(24).end = 149.5080;

%Freezing upon walk initiation 3 %Questionable, after review 04/23 we wont
%use this for the currenct project
%subjectdata.events_filt.WalkWS(25).start = 151.9450;
%subjectdata.events_filt.WalkWS(25).task = 'Freezing_walk_initiation'; 
%subjectdata.events_filt.WalkWS(25).end = 153.641000000000;

% Turn
subjectdata.events_filt.WalkWS(26).start = 155.000;
subjectdata.events_filt.WalkWS(26).task = 'Turn'; 
subjectdata.events_filt.WalkWS(26).end = 160.469000000000;

%Freezing upon turning
subjectdata.events_filt.WalkWS(27).start = 157.453000000000; 
subjectdata.events_filt.WalkWS(27).task = 'Freezing_turn'; 
subjectdata.events_filt.WalkWS(27).end = 161.157000000000;

%Walk
subjectdata.events_filt.WalkWS(28).start = 161.7500;
subjectdata.events_filt.WalkWS(28).task= 'Walk'; 
subjectdata.events_filt.WalkWS(28).end = 162.383000000000;

%Freezing upon walk initiation %Questionable, after review 04/23 we wont
%use this for the currenct project
%subjectdata.events_filt.WalkWS(29).start = 166.211000000000;
%subjectdata.events_filt.WalkWS(29).task= 'Freezing_walk_initiation'; 
%subjectdata.events_filt.WalkWS(29).end = 167.5000;

%Selected stop
subjectdata.events_filt.WalkWS(30).start = 163.906;
subjectdata.events_filt.WalkWS(30).task= 'Selected_stop'; 
subjectdata.events_filt.WalkWS(30).end = 166.211;

% ===== Save DATA ====================================================================================================
save([path filesep subjectdata.subject_dir '_datafile.mat'], 'subjectdata', '-mat')

% *********************** END OF SCRIPT *******************************************************************************************************************
