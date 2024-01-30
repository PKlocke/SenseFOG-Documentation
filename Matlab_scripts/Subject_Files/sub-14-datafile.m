%% sub-14-datafile.m ====================================================
% +------------------------------------------------------+
% |  Subject: SUB-14                                     |
% |                                                      |
% | Author: Philipp Klocke,Moritz Loeffler               | 
% +------------------------------------------------------+

% This script will serve as the main directory matlab file for sub-14

% Chose the pathway for the SenseFOG-main folder after downloading
subjectdata.generalpath     = uigetdir;                                                                                         % Target file should be the SenseFOG-main file after download
subjectdata.filedir         = 'sub-14';
subjectdata.subjectnr       = '14';
subjectdata.subject_dir     = 'sub-14';
path                        = append(subjectdata.generalpath, '/', subjectdata.filedir);
cd(path)


% SIT - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Sit = [];
subjectdata.signalpoint.Sit.EEG_signal          = 16184;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Sit.LFP_signal          = 12703;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Sit.LFP_signal > subjectdata.signalpoint.Sit.EEG_signal;                                             % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Sit.delay = subjectdata.signalpoint.Sit.LFP_signal - subjectdata.signalpoint.Sit.EEG_signal;         % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Sit.EEG_signal > subjectdata.signalpoint.Sit.LFP_signal;                                           % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Sit.delay = subjectdata.signalpoint.Sit.EEG_signal - subjectdata.signalpoint.Sit.LFP_signal;       % Find time-delay between both EEG and LFP
end 


% STAND - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Stand = [];
subjectdata.signalpoint.Stand.EEG_signal        = 15090;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Stand.LFP_signal        = 12264;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Stand.LFP_signal > subjectdata.signalpoint.Stand.EEG_signal;                                         % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Stand.delay = subjectdata.signalpoint.Stand.LFP_signal - subjectdata.signalpoint.Stand.EEG_signal;   % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Stand.EEG_signal > subjectdata.signalpoint.Stand.LFP_signal;                                       % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Stand.delay = subjectdata.signalpoint.Stand.EEG_signal - subjectdata.signalpoint.Stand.LFP_signal; % Find time-delay between both EEG and LFP
end 


% WALK WITH STOPS - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.WalkWS = [];
subjectdata.signalpoint.WalkWS.EEG_signal       = 11904;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.WalkWS.LFP_signal       = 10230;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.WalkWS.LFP_signal > subjectdata.signalpoint.WalkWS.EEG_signal;                                       % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.WalkWS.delay = subjectdata.signalpoint.WalkWS.LFP_signal - subjectdata.signalpoint.WalkWS.EEG_signal;% Find time-delay between both EEG and LFP
else subjectdata.signalpoint.WalkWS.EEG_signal > subjectdata.signalpoint.WalkWS.LFP_signal;                                     % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.WalkWS.delay = subjectdata.signalpoint.WalkWS.EEG_signal - subjectdata.signalpoint.WalkWS.LFP_signal;% Find time-delay between both EEG and LFP
end 


% INTERFERENCE - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.WalkINT = [];
subjectdata.signalpoint.WalkINT.EEG_signal       = 13379;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.WalkINT.LFP_signal       = 10723;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.WalkINT.LFP_signal > subjectdata.signalpoint.WalkINT.EEG_signal;                                      % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.WalkINT.delay = subjectdata.signalpoint.WalkINT.LFP_signal - subjectdata.signalpoint.WalkINT.EEG_signal;% find time-delay between both EEG and LFP
else subjectdata.signalpoint.WalkINT.EEG_signal > subjectdata.signalpoint.WalkINT.LFP_signal;                                    % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.WalkINT.delay = subjectdata.signalpoint.WalkINT.EEG_signal - subjectdata.signalpoint.WalkINT.LFP_signal;% Find time-delay between both EEG and LFP
end 


% INTERFERENCE 2 - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.WalkINT_new = [];
subjectdata.signalpoint.WalkINT_new.EEG_signal       = 10136;                                                                      % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.WalkINT_new.LFP_signal       = 8012;                                                                       % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.WalkINT_new.LFP_signal > subjectdata.signalpoint.WalkINT_new.EEG_signal;                                % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.WalkINT_new.delay = subjectdata.signalpoint.WalkINT_new.LFP_signal - subjectdata.signalpoint.WalkINT_new.EEG_signal;% find time-delay between both EEG and LFP
else subjectdata.signalpoint.WalkINT_new.EEG_signal > subjectdata.signalpoint.WalkINT_new.LFP_signal;                              % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.WalkINT_new.delay = subjectdata.signalpoint.WalkINT_new.EEG_signal - subjectdata.signalpoint.WalkINT_new.LFP_signal;% Find time-delay between both EEG and LFP
end 



%=== FILTERED GAIT EVENTS FOR WALK WITH STOPS ONLY ===
%Manual Input for Filtered Gait Events based on the exact timings of heelstrike events (not shown here)
subjectdata.events_filt.WalkWS = struct;

%Walk 1
subjectdata.events_filt.WalkWS(1).task = 'Walk'; 
subjectdata.events_filt.WalkWS(1).start = 14.9830000000000;
subjectdata.events_filt.WalkWS(1).end = 17.4490000000000;

%Selected_stop 1
subjectdata.events_filt.WalkWS(2).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(2).start = 18.4220000000000;
subjectdata.events_filt.WalkWS(2).end = 20.954;

%Walk 2
subjectdata.events_filt.WalkWS(3).task = 'Walk'; 
subjectdata.events_filt.WalkWS(3).start = 22.4530000000000;
subjectdata.events_filt.WalkWS(3).end = 24.8400000000000;

%Selected_stop 2
subjectdata.events_filt.WalkWS(4).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(4).start = 26.3050000000000;
subjectdata.events_filt.WalkWS(4).end = 29.823;

%Walk 3
subjectdata.events_filt.WalkWS(6).task = 'Walk'; 
subjectdata.events_filt.WalkWS(6).start = 36.7480000000000;
subjectdata.events_filt.WalkWS(6).end = 37.9330000000000;

%Selected stop 3 %Include after review 07/23
subjectdata.events_filt.WalkWS(7).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(7).start = 39.5960000000000;
subjectdata.events_filt.WalkWS(7).end = 40.819000;

%Walk 4
subjectdata.events_filt.WalkWS(8).task = 'Walk'; 
subjectdata.events_filt.WalkWS(8).start = 42.0130000000000;
subjectdata.events_filt.WalkWS(8).end = 45.6570000000000;

%Selected_stop 4
subjectdata.events_filt.WalkWS(9).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(9).start = 46.8060000000000;
subjectdata.events_filt.WalkWS(9).end = 49.425;

%Walk 5
subjectdata.events_filt.WalkWS(10).task = 'Walk'; 
subjectdata.events_filt.WalkWS(10).start = 50.4750000000000;
subjectdata.events_filt.WalkWS(10).end = 51.7020000000000;

%Selected Stop
subjectdata.events_filt.WalkWS(13).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(13).start = 61.8100000000000;
subjectdata.events_filt.WalkWS(13).end = 64.782;

%Walk 6
subjectdata.events_filt.WalkWS(14).task = 'Walk'; 
subjectdata.events_filt.WalkWS(14).start = 65.8890000000000;
subjectdata.events_filt.WalkWS(14).end = 69.5330000000000;

%Selected stop
subjectdata.events_filt.WalkWS(15).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(15).start = 71.2280000000000;
subjectdata.events_filt.WalkWS(15).end = 74.714;

%Walk 7
subjectdata.events_filt.WalkWS(16).task = 'Walk'; 
subjectdata.events_filt.WalkWS(16).start = 75.9970000000000;
subjectdata.events_filt.WalkWS(16).end = 77.2780000000000;

%Walk 8
subjectdata.events_filt.WalkWS(18).task = 'Walk'; 
subjectdata.events_filt.WalkWS(18).start = 83.1420000000000;
subjectdata.events_filt.WalkWS(18).end = 84.3690000000000;

%Selected stop
subjectdata.events_filt.WalkWS(19).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(19).start = 86.0570000000000;
subjectdata.events_filt.WalkWS(19).end = 89.470;

%Walk 9
subjectdata.events_filt.WalkWS(20).task = 'Walk'; 
subjectdata.events_filt.WalkWS(20).start = 90.5880000000000;
subjectdata.events_filt.WalkWS(20).end = 95.2630000000000;

%Selected stop
subjectdata.events_filt.WalkWS(21).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(21).start = 96.4450000000000;
subjectdata.events_filt.WalkWS(21).end = 100.064;

%Walk 10
subjectdata.events_filt.WalkWS(22).task = 'Walk'; 
subjectdata.events_filt.WalkWS(22).start = 101.213000000000;
subjectdata.events_filt.WalkWS(22).end = 102.360000000000;

%Walk 11
subjectdata.events_filt.WalkWS(24).task = 'Walk'; 
subjectdata.events_filt.WalkWS(24).start = 109.134000000000;
subjectdata.events_filt.WalkWS(24).end = 111.475000000000;

%Selected stop
subjectdata.events_filt.WalkWS(25).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(25).start = 113.064000000000;
subjectdata.events_filt.WalkWS(25).end = 115.064;

%Walk 12
subjectdata.events_filt.WalkWS(26).task = 'Walk'; 
subjectdata.events_filt.WalkWS(26).start = 116.732000000000;
subjectdata.events_filt.WalkWS(26).end = 119.146000000000;

%Selected stop
subjectdata.events_filt.WalkWS(29).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(29).start = 121.863000000000;
subjectdata.events_filt.WalkWS(29).end = 124.909;

%Walk 13
subjectdata.events_filt.WalkWS(30).task = 'Walk'; 
subjectdata.events_filt.WalkWS(30).start = 133.226000000000;
subjectdata.events_filt.WalkWS(30).end = 135.556000000000;

%Selected stop
subjectdata.events_filt.WalkWS(31).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(31).start = 137.923000000000;
subjectdata.events_filt.WalkWS(31).end = 139.772;

%Walk 14
subjectdata.events_filt.WalkWS(32).task = 'Walk'; 
subjectdata.events_filt.WalkWS(32).start = 140.837000000000;
subjectdata.events_filt.WalkWS(32).end = 143.174000000000;

%Selected stop
subjectdata.events_filt.WalkWS(33).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(33).start = 144.625000000000;
subjectdata.events_filt.WalkWS(33).end = 146.970;

%Walk 15
subjectdata.events_filt.WalkWS(34).task = 'Walk'; 
subjectdata.events_filt.WalkWS(34).start = 148.539000000000;
subjectdata.events_filt.WalkWS(34).end = 149.577000000000;

%Walk 16
subjectdata.events_filt.WalkWS(35).task = 'Walk'; 
subjectdata.events_filt.WalkWS(35).start = 161.382000000000;
subjectdata.events_filt.WalkWS(35).end = 163.868000000000;

%Selected stop
subjectdata.events_filt.WalkWS(36).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(36).start = 166.367000000000;
subjectdata.events_filt.WalkWS(36).end = 168.696;

%Walk
subjectdata.events_filt.WalkWS(37).task = 'Walk'; 
subjectdata.events_filt.WalkWS(37).start = 169.915000000000;
subjectdata.events_filt.WalkWS(37).end = 172.382000000000;

%Selected stop
subjectdata.events_filt.WalkWS(38).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(38).start = 174.499;
subjectdata.events_filt.WalkWS(38).end = 177.929;

%Walk
subjectdata.events_filt.WalkWS(39).task = 'Walk'; 
subjectdata.events_filt.WalkWS(39).start = 178.917000000000;
subjectdata.events_filt.WalkWS(39).end = 180.085000000000;

%Selected stop
subjectdata.events_filt.WalkWS(41).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(41).start = 188.499000000000;
subjectdata.events_filt.WalkWS(41).end = 189.8750;

%Walk
subjectdata.events_filt.WalkWS(42).task = 'Walk'; 
subjectdata.events_filt.WalkWS(42).start = 185.633000000000;
subjectdata.events_filt.WalkWS(42).end = 186.856000000000;

%Walk
subjectdata.events_filt.WalkWS(43).task = 'Walk'; 
subjectdata.events_filt.WalkWS(43).start = 190.180000000000;
subjectdata.events_filt.WalkWS(43).end = 194.881000000000;

%Selected stop
subjectdata.events_filt.WalkWS(44).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(44).start = 196.484000000000;
subjectdata.events_filt.WalkWS(44).end = 198.868;


%=== FILTERED GAIT EVENTS FOR WALK WITH INTERFERENCE ONLY ===
%Manual Input for Filtered Gait Events based on the exact timings of heelstrike events (not shown here)
subjectdata.events_filt.WalkINT = struct;

%Freezing while walking
subjectdata.events_filt.WalkINT(2).task = 'Freezing_walk'; 
subjectdata.events_filt.WalkINT(2).start = 32.7710000000000;
subjectdata.events_filt.WalkINT(2).end = 45.2970000000000;

%Freezing while walking
subjectdata.events_filt.WalkINT(4).task = 'Freezing_walk'; 
subjectdata.events_filt.WalkINT(4).start = 111.17500000;
subjectdata.events_filt.WalkINT(4).end = 123.024000000000;

%Freezing while walking
subjectdata.events_filt.WalkINT(5).task = 'Freezing_walk'; 
subjectdata.events_filt.WalkINT(5).start = 134.051000000000;
subjectdata.events_filt.WalkINT(5).end = 139.251000000000;

%Freezing while walking 
subjectdata.events_filt.WalkINT(7).task = 'Freezing_walk'; 
subjectdata.events_filt.WalkINT(7).start = 157.75400000000;
subjectdata.events_filt.WalkINT(7).end = 171.82200000000000;

%Freezing while walking
subjectdata.events_filt.WalkINT(8).task = 'Freezing_walk'; 
subjectdata.events_filt.WalkINT(8).start = 204.511000000000;
subjectdata.events_filt.WalkINT(8).end = 207.641000000000;

%=== FILTERED GAIT EVENTS FOR WALK WITH INTERFERENCE 2 ONLY ===
%Manual Input for Filtered Gait Events based on the exact timings of heelstrike events (not shown here)
subjectdata.events_filt.WalkINT_new = struct;

%Walk 1
subjectdata.events_filt.WalkINT_new(1).task = 'Walk'; 
subjectdata.events_filt.WalkINT_new(1).start = 13.6550000000000;
subjectdata.events_filt.WalkINT_new(1).end = 29.8730000000000;

%Walk 
subjectdata.events_filt.WalkINT_new(4).task = 'Walk'; 
subjectdata.events_filt.WalkINT_new(4).start = 50.9250000000000;
subjectdata.events_filt.WalkINT_new(4).end = 55.3770000000000;

%Freezing while walking
subjectdata.events_filt.WalkINT_new(5).task = 'Freezing_walk'; 
subjectdata.events_filt.WalkINT_new(5).start = 56.3630000000000;
subjectdata.events_filt.WalkINT_new(5).end = 69.1280000000000;

%Freezing while walking
subjectdata.events_filt.WalkINT_new(6).task = 'Freezing_walk'; 
subjectdata.events_filt.WalkINT_new(6).start = 75.65500000000;
subjectdata.events_filt.WalkINT_new(6).end = 79.270000000000;

%Freezing while waling
subjectdata.events_filt.WalkINT_new(7).task = 'Freezing_walk'; 
subjectdata.events_filt.WalkINT_new(7).start = 85.063000000000;
subjectdata.events_filt.WalkINT_new(7).end = 90.2420000000000;

%Freezing while walking
subjectdata.events_filt.WalkINT_new(9).task = 'Freezing_walk'; 
subjectdata.events_filt.WalkINT_new(9).start = 97.4450000000000;
subjectdata.events_filt.WalkINT_new(9).end = 109.025000000000;

%Freezing while walking
subjectdata.events_filt.WalkINT_new(10).task = 'Freezing_walk'; 
subjectdata.events_filt.WalkINT_new(10).start = 116.4670000000;
subjectdata.events_filt.WalkINT_new(10).end = 120.870000000000;

%Walk
subjectdata.events_filt.WalkINT_new(11).task = 'Walk'; 
subjectdata.events_filt.WalkINT_new(11).start = 130.856000000000;
subjectdata.events_filt.WalkINT_new(11).end = 136.981000000000;

%Walk
subjectdata.events_filt.WalkINT_new(14).task = 'Walk'; 
subjectdata.events_filt.WalkINT_new(14).start = 158.944000000000;
subjectdata.events_filt.WalkINT_new(14).end = 162.927000000000;

%Freezing while walking
subjectdata.events_filt.WalkINT_new(15).task = 'Freezing_walk'; 
subjectdata.events_filt.WalkINT_new(15).start = 163.410000000000;
subjectdata.events_filt.WalkINT_new(15).end = 169.210000000000;


% ===== Save DATA ====================================================================================================
save([path filesep subjectdata.subject_dir '_datafile.mat'], 'subjectdata', '-mat')

% *********************** END OF SCRIPT *******************************************************************************************************************
