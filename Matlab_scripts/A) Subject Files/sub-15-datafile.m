%% sub-15-datafile.m ====================================================
% +------------------------------------------------------+
% |  Subject: SUB-15                                     |
% |                                                      |
% | Author: Philipp Klocke,Moritz Loeffler               | 
% +------------------------------------------------------+

% This script will serve as the main directory matlab file for sub-15

% Chose the pathway for the SenseFOG-main folder after downloading
subjectdata.generalpath     = uigetdir;                                                                                         % Target file should be the SenseFOG-main file after download
subjectdata.filedir         = 'sub-15';
subjectdata.subjectnr       = '15';
subjectdata.subject_dir     = 'sub-15';
path                        = append(subjectdata.generalpath, '/', subjectdata.filedir);
cd(path)



% SIT - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Sit = [];
subjectdata.signalpoint.Sit.EEG_signal          = 9836;                                                                         % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Sit.LFP_signal          = 8023;                                                                         % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Sit.LFP_signal > subjectdata.signalpoint.Sit.EEG_signal;                                             % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Sit.delay = subjectdata.signalpoint.Sit.LFP_signal - subjectdata.signalpoint.Sit.EEG_signal;         % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Sit.EEG_signal > subjectdata.signalpoint.Sit.LFP_signal;                                           % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Sit.delay = subjectdata.signalpoint.Sit.EEG_signal - subjectdata.signalpoint.Sit.LFP_signal;       % Find time-delay between both EEG and LFP
end 


% STAND - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Stand = [];
subjectdata.signalpoint.Stand.EEG_signal        = 13544;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Stand.LFP_signal        = 9270;                                                                         % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Stand.LFP_signal > subjectdata.signalpoint.Stand.EEG_signal;                                         % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Stand.delay = subjectdata.signalpoint.Stand.LFP_signal - subjectdata.signalpoint.Stand.EEG_signal;   % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Stand.EEG_signal > subjectdata.signalpoint.Stand.LFP_signal;                                       % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Stand.delay = subjectdata.signalpoint.Stand.EEG_signal - subjectdata.signalpoint.Stand.LFP_signal; % Find time-delay between both EEG and LFP
end 

% WALK - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Walk = [];
subjectdata.signalpoint.Walk.EEG_signal         = 13170;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Walk.LFP_signal         = 9815;                                                                         % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Walk.LFP_signal > subjectdata.signalpoint.Walk.EEG_signal;                                           % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Walk.delay = subjectdata.signalpoint.Walk.LFP_signal - subjectdata.signalpoint.Walk.EEG_signal;      % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Walk.EEG_signal > subjectdata.signalpoint.Walk.LFP_signal;                                         % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Walk.delay = subjectdata.signalpoint.Walk.EEG_signal - subjectdata.signalpoint.Walk.LFP_signal;    % Find time-delay between both EEG and LFP
end

% WALK WITH STOPS - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.WalkWS = [];
subjectdata.signalpoint.WalkWS.EEG_signal       = 12428;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.WalkWS.LFP_signal       = 10702;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.WalkWS.LFP_signal > subjectdata.signalpoint.WalkWS.EEG_signal;                                       % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.WalkWS.delay = subjectdata.signalpoint.WalkWS.LFP_signal - subjectdata.signalpoint.WalkWS.EEG_signal;% Find time-delay between both EEG and LFP
else subjectdata.signalpoint.WalkWS.EEG_signal > subjectdata.signalpoint.WalkWS.LFP_signal;                                     % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.WalkWS.delay = subjectdata.signalpoint.WalkWS.EEG_signal - subjectdata.signalpoint.WalkWS.LFP_signal;% Find time-delay between both EEG and LFP
end 


% INTERFERENCE - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.WalkINT = [];
subjectdata.signalpoint.WalkINT.EEG_signal       = 11455;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.WalkINT.LFP_signal       = 8753;                                                                         % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.WalkINT.LFP_signal > subjectdata.signalpoint.WalkINT.EEG_signal;                                      % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.WalkINT.delay = subjectdata.signalpoint.WalkINT.LFP_signal - subjectdata.signalpoint.WalkINT.EEG_signal;% find time-delay between both EEG and LFP
else subjectdata.signalpoint.WalkINT.EEG_signal > subjectdata.signalpoint.WalkINT.LFP_signal;                                    % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.WalkINT.delay = subjectdata.signalpoint.WalkINT.EEG_signal - subjectdata.signalpoint.WalkINT.LFP_signal;% Find time-delay between both EEG and LFP
end 


%=== FILTERED GAIT EVENTS FOR WALK ONLY ===
% Manual input for filtered gait events based on exact timings of heelstrikes (not shown here)
subjectdata.events_filt.Walk = struct;

%Walk 1
subjectdata.events_filt.Walk(1).start = 15.9020000000000; 
subjectdata.events_filt.Walk(1).task = 'Walk';
subjectdata.events_filt.Walk(1).end = 25.473000000000;

%Walk
subjectdata.events_filt.Walk(2).start = 42.5940000000000;
subjectdata.events_filt.Walk(2).task = 'Walk';
subjectdata.events_filt.Walk(2).end = 51.7190000000000;

%Walk
subjectdata.events_filt.Walk(4).start =  59.8210000000000;
subjectdata.events_filt.Walk(4).task = 'Walk';
subjectdata.events_filt.Walk(4).end = 72.9060000000000;

%Walk
subjectdata.events_filt.Walk(6).start =  81.6750000000000;
subjectdata.events_filt.Walk(6).task = 'Walk';
subjectdata.events_filt.Walk(6).end = 90.9770000000000;

%Freezing while walking
subjectdata.events_filt.Walk(7).start = 92.4270000000000; 
subjectdata.events_filt.Walk(7).task = 'Freezing_walk';
subjectdata.events_filt.Walk(7).end = 96.0430000000000;

%Walk
subjectdata.events_filt.Walk(8).start =  100.892000000000;
subjectdata.events_filt.Walk(8).task = 'Walk';
subjectdata.events_filt.Walk(8).end = 112.584000000000;

%Freezing while walking 
subjectdata.events_filt.Walk(9).start = 113.138000000000; 
subjectdata.events_filt.Walk(9).task = 'Freezing_walk';
subjectdata.events_filt.Walk(9).end = 118.195000000000;

%Walk
subjectdata.events_filt.Walk(10).start =  123.777000000000;
subjectdata.events_filt.Walk(10).task = 'Walk';
subjectdata.events_filt.Walk(10).end = 136.024000000000;

%Walk
subjectdata.events_filt.Walk(12).start =  157.065000000000;
subjectdata.events_filt.Walk(12).task = 'Walk';
subjectdata.events_filt.Walk(12).end = 163.317000000000;

%Freezing while walking
subjectdata.events_filt.Walk(13).start = 146.675000000000; 
subjectdata.events_filt.Walk(13).task = 'Freezing_walk';
subjectdata.events_filt.Walk(13).end = 154.620000000000;

%Freezing while walking
subjectdata.events_filt.Walk(15).start = 165.482000000000; 
subjectdata.events_filt.Walk(15).task = 'Freezing_walk';
subjectdata.events_filt.Walk(15).end = 167.503000000000;

%Walk
subjectdata.events_filt.Walk(16).start =  174.500000000000;
subjectdata.events_filt.Walk(16).task = 'Walk';
subjectdata.events_filt.Walk(16).end = 185.658000000000;

%Walk
subjectdata.events_filt.Walk(18).start =  193.047000000000;
subjectdata.events_filt.Walk(18).task = 'Walk';
subjectdata.events_filt.Walk(18).end = 194.250000000000;

%Freezing while walking
subjectdata.events_filt.Walk(19).start = 195.881000000000; 
subjectdata.events_filt.Walk(19).task = 'Freezing_walk';
subjectdata.events_filt.Walk(19).end = 200.017000000000;

%Walk
subjectdata.events_filt.Walk(20).start =  201.680000000000;
subjectdata.events_filt.Walk(20).task = 'Walk';
subjectdata.events_filt.Walk(20).end = 205.026000000000;

%Freezing while walking
subjectdata.events_filt.Walk(22).start =  207.164000000000;
subjectdata.events_filt.Walk(22).task = 'Freezing_walk';
subjectdata.events_filt.Walk(22).end = 208.983000000000;

%walk
subjectdata.events_filt.Walk(23).start = 214.436000000000; 
subjectdata.events_filt.Walk(23).task = 'Walk';
subjectdata.events_filt.Walk(23).end = 225.690000000000;

%Walk
subjectdata.events_filt.Walk(25).start = 233.738000000000; 
subjectdata.events_filt.Walk(25).task = 'Walk';
subjectdata.events_filt.Walk(25).end = 243.976000000000;

%Walk
subjectdata.events_filt.Walk(28).start =  256.206000000000;
subjectdata.events_filt.Walk(28).task = 'Walk';
subjectdata.events_filt.Walk(28).end = 264.924000000000;

%Walk
subjectdata.events_filt.Walk(30).start =  271.711000000000;
subjectdata.events_filt.Walk(30).task = 'Walk';
subjectdata.events_filt.Walk(30).end = 284.784000000000;

%Walk
subjectdata.events_filt.Walk(32).start =  292.344000000000;
subjectdata.events_filt.Walk(32).task = 'Walk';
subjectdata.events_filt.Walk(32).end = 296.937000000000;


%=== FILTERED GAIT EVENTS FOR WALK WITH STOPS ONLY ===
%Manual Input for Filtered Gait Events based on the exact timings of heelstrike events (not shown here)
subjectdata.events_filt.WalkWS = struct;

%Walk 1
subjectdata.events_filt.WalkWS(1).task = 'Walk'; 
subjectdata.events_filt.WalkWS(1).start = 15.4420000000000;
subjectdata.events_filt.WalkWS(1).end = 17.8660000000000;

%Selected stop
subjectdata.events_filt.WalkWS(2).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(2).start = 20.3890000000000;
subjectdata.events_filt.WalkWS(2).end = 23.505;

%Walk 
subjectdata.events_filt.WalkWS(3).task = 'Walk'; 
subjectdata.events_filt.WalkWS(3).start = 24.7220000000000;
subjectdata.events_filt.WalkWS(3).end = 28.1010000000000;

%Walk
subjectdata.events_filt.WalkWS(5).task = 'Walk'; 
subjectdata.events_filt.WalkWS(5).start = 34.6940000000000;
subjectdata.events_filt.WalkWS(5).end = 37.1130000000000;

%Selected stop
subjectdata.events_filt.WalkWS(6).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(6).start = 39.9420000000000;
subjectdata.events_filt.WalkWS(6).end = 42.023;

%Walk
subjectdata.events_filt.WalkWS(7).task = 'Walk'; 
subjectdata.events_filt.WalkWS(7).start = 43.1780000000000;
subjectdata.events_filt.WalkWS(7).end = 46.7600000000000;

%Walk
subjectdata.events_filt.WalkWS(9).task = 'Walk'; 
subjectdata.events_filt.WalkWS(9).start = 52.2230000000000;
subjectdata.events_filt.WalkWS(9).end = 54.6080000000000;

%Walk
subjectdata.events_filt.WalkWS(12).task = 'Walk'; 
subjectdata.events_filt.WalkWS(12).start = 72.8170000000000;
subjectdata.events_filt.WalkWS(12).end = 75.1240000000000;

%Selected stop 
subjectdata.events_filt.WalkWS(13).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(13).start = 78.5320000000000;
subjectdata.events_filt.WalkWS(13).end = 80.86;

%Walk
subjectdata.events_filt.WalkWS(14).task = 'Walk'; 
subjectdata.events_filt.WalkWS(14).start = 81.9230000000000;
subjectdata.events_filt.WalkWS(14).end = 84.2120000000000;

%Walk
subjectdata.events_filt.WalkWS(16).task = 'Walk'; 
subjectdata.events_filt.WalkWS(16).start = 108.488000000000;
subjectdata.events_filt.WalkWS(16).end = 110.763000000000;

%Selected stop
subjectdata.events_filt.WalkWS(17).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(17).start = 114.149000000000;
subjectdata.events_filt.WalkWS(17).end = 116.259;

%Walk
subjectdata.events_filt.WalkWS(20).task = 'Walk'; 
subjectdata.events_filt.WalkWS(20).start = 125.903000000000;
subjectdata.events_filt.WalkWS(20).end = 128.357000000000;

%Selected stop
subjectdata.events_filt.WalkWS(21).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(21).start = 131.806000000000;
subjectdata.events_filt.WalkWS(21).end = 133.853;

%Walk
subjectdata.events_filt.WalkWS(22).task = 'Walk'; 
subjectdata.events_filt.WalkWS(22).start = 134.939000000000;
subjectdata.events_filt.WalkWS(22).end = 137.298000000000;

%Walk
subjectdata.events_filt.WalkWS(24).task = 'Walk'; 
subjectdata.events_filt.WalkWS(24).start = 142.792000000000;
subjectdata.events_filt.WalkWS(24).end = 146.552000000000;

%Selected stop
subjectdata.events_filt.WalkWS(25).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(25).start = 149.547000000000;
subjectdata.events_filt.WalkWS(25).end = 151.628;

%Walk
subjectdata.events_filt.WalkWS(26).task = 'Walk'; 
subjectdata.events_filt.WalkWS(26).start = 152.870000000000;
subjectdata.events_filt.WalkWS(26).end = 155.278000000000;

%Selected stop
subjectdata.events_filt.WalkWS(30).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(30).start = 171.229000000000;
subjectdata.events_filt.WalkWS(30).end = 173.858;

%Walk
subjectdata.events_filt.WalkWS(33).task = 'Walk'; 
subjectdata.events_filt.WalkWS(33).start = 184.227000000000;
subjectdata.events_filt.WalkWS(33).end = 186.838000000000;

%Selected stop
subjectdata.events_filt.WalkWS(34).task = 'Selected stop'; 
subjectdata.events_filt.WalkWS(34).start = 189.872000000000;
subjectdata.events_filt.WalkWS(34).end = 193.532;

%Walk
subjectdata.events_filt.WalkWS(35).task = 'Walk'; 
subjectdata.events_filt.WalkWS(35).start = 194.765000000000;
subjectdata.events_filt.WalkWS(35).end = 197.147000000000;

%Selected stop
subjectdata.events_filt.WalkWS(38).task = 'Selected stop'; 
subjectdata.events_filt.WalkWS(38).start = 210.542000000000;
subjectdata.events_filt.WalkWS(38).end = 212.716;

%Walk
subjectdata.events_filt.WalkWS(42).task = 'Walk'; 
subjectdata.events_filt.WalkWS(42).start = 225.393000000000;
subjectdata.events_filt.WalkWS(42).end = 228.277000000000;

%Selected stop
subjectdata.events_filt.WalkWS(43).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(43).start = 231.457000000000;
subjectdata.events_filt.WalkWS(43).end = 234.555;

%Walk
subjectdata.events_filt.WalkWS(46).task = 'Walk'; 
subjectdata.events_filt.WalkWS(46).start = 244.108000000000;
subjectdata.events_filt.WalkWS(46).end = 247.832000000000;

%Selected stop
subjectdata.events_filt.WalkWS(47).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(47).start = 251.656000000000;
subjectdata.events_filt.WalkWS(47).end = 254.206;

%Walk
subjectdata.events_filt.WalkWS(48).task = 'Walk'; 
subjectdata.events_filt.WalkWS(48).start = 255.422000000000;
subjectdata.events_filt.WalkWS(48).end = 257.939000000000;


%=== FILTERED GAIT EVENTS FOR WALK WITH INTERFERENCE ONLY ===
%Manual Input for Filtered Gait Events based on the exact timings of heelstrike events (not shown here)
subjectdata.events_filt.WalkINT = struct;

%Walk 1
subjectdata.events_filt.WalkINT(1).task = 'Walk'; 
subjectdata.events_filt.WalkINT(1).start = 14.6810000000000;
subjectdata.events_filt.WalkINT(1).end = 22.6920000000000;

%Freezing while walking
subjectdata.events_filt.WalkINT(4).task = 'Freezing_walk'; 
subjectdata.events_filt.WalkINT(4).start = 32.5880000000000;
subjectdata.events_filt.WalkINT(4).end = 34.5460000000000;

%Walk
subjectdata.events_filt.WalkINT(6).task = 'Walk'; 
subjectdata.events_filt.WalkINT(6).start = 40.3150000000000;
subjectdata.events_filt.WalkINT(6).end = 45.8250000000000;

%Freezing while walking
subjectdata.events_filt.WalkINT(8).task = 'Freezing_walk'; 
subjectdata.events_filt.WalkINT(8).start = 46.9560000000000;
subjectdata.events_filt.WalkINT(8).end = 49.0630000000000;

%Walk
subjectdata.events_filt.WalkINT(10).task = 'Walk'; 
subjectdata.events_filt.WalkINT(10).start = 64.5750000000000;
subjectdata.events_filt.WalkINT(10).end = 68.7310000000000;

%Freezing while walking
subjectdata.events_filt.WalkINT(13).task = 'Freezing_walk'; 
subjectdata.events_filt.WalkINT(13).start = 59.4810000000000;
subjectdata.events_filt.WalkINT(13).end = 61.6260000000000;

%Walk
subjectdata.events_filt.WalkINT(14).task = 'Walk'; 
subjectdata.events_filt.WalkINT(14).start = 77.1760000000000;
subjectdata.events_filt.WalkINT(14).end = 85.7900000000000;

%WAlk
subjectdata.events_filt.WalkINT(16).task = 'Walk'; 
subjectdata.events_filt.WalkINT(16).start = 91.4570000000000;
subjectdata.events_filt.WalkINT(16).end = 96.7050000000000;

%Freezing while walking
subjectdata.events_filt.WalkINT(19).task = 'Freezing_walk'; 
subjectdata.events_filt.WalkINT(19).start = 107.046000000000;
subjectdata.events_filt.WalkINT(19).end = 110.676000000000;

%Walk
subjectdata.events_filt.WalkINT(20).task = 'Walk'; 
subjectdata.events_filt.WalkINT(20).start = 111.226000000000;
subjectdata.events_filt.WalkINT(20).end = 116.507000000000;

%Freezing while walking
subjectdata.events_filt.WalkINT(23).task = 'Freezing_walk'; 
subjectdata.events_filt.WalkINT(23).start = 124.853000000000;
subjectdata.events_filt.WalkINT(23).end = 128.182000000000;

%Walk
subjectdata.events_filt.WalkINT(24).task = 'Walk'; 
subjectdata.events_filt.WalkINT(24).start = 129.284000000000;
subjectdata.events_filt.WalkINT(24).end = 132.390000000000;

%Walk
subjectdata.events_filt.WalkINT(28).task = 'Walk'; 
subjectdata.events_filt.WalkINT(28).start = 150.608000000000;
subjectdata.events_filt.WalkINT(28).end = 154.130000000000;

%Freezing while walking
subjectdata.events_filt.WalkINT(30).task = 'Freezing_walk'; 
subjectdata.events_filt.WalkINT(30).start = 155.380000000000;
subjectdata.events_filt.WalkINT(30).end = 161.054000000000;

%WAlk
subjectdata.events_filt.WalkINT(31).task = 'Walk'; 
subjectdata.events_filt.WalkINT(31).start = 166.950000000000;
subjectdata.events_filt.WalkINT(31).end = 177.118000000000;

%Walk
subjectdata.events_filt.WalkINT(34).task = 'Walk'; 
subjectdata.events_filt.WalkINT(34).start = 187.385000000000;
subjectdata.events_filt.WalkINT(34).end = 194.421000000000;

%Walk
subjectdata.events_filt.WalkINT(36).task = 'Walk'; 
subjectdata.events_filt.WalkINT(36).start = 206.654000000000;
subjectdata.events_filt.WalkINT(36).end = 216.615000000000;

%Walk
subjectdata.events_filt.WalkINT(37).task = 'Walk'; 
subjectdata.events_filt.WalkINT(37).start = 227.204000000000;
subjectdata.events_filt.WalkINT(37).end = 234.616000000000;

%WAlk
subjectdata.events_filt.WalkINT(38).task = 'Walk'; 
subjectdata.events_filt.WalkINT(38).start = 240.359000000000;
subjectdata.events_filt.WalkINT(38).end = 243.052000000000;

%Walk
subjectdata.events_filt.WalkINT(40).task = 'Walk'; 
subjectdata.events_filt.WalkINT(40).start = 247.793000000000;
subjectdata.events_filt.WalkINT(40).end = 256.371000000000;

%Walk
subjectdata.events_filt.WalkINT(43).task = 'Walk'; 
subjectdata.events_filt.WalkINT(43).start = 265.421000000000;
subjectdata.events_filt.WalkINT(43).end = 277.610000000000;


% ===== Save DATA ====================================================================================================
save([path filesep subjectdata.subject_dir '_datafile.mat'], 'subjectdata', '-mat')

% *********************** END OF SCRIPT *******************************************************************************************************************
