%% sub-01-datafile.m ====================================================
% +------------------------------------------------------+
% |  Subject: SUB-01                                     |
% |                                                      |
% | Author: Philipp Klocke,Moritz Loeffler               | 
% +------------------------------------------------------+

% This script will serve as the main directory matlab file for sub-01

% Chose the pathway for the SenseFOG-main folder after downloading
subjectdata.generalpath     = uigetdir;                                                                                     % Target file should be the SenseFOG-main file after download
subjectdata.filedir         = 'sub-01';
subjectdata.subjectnr       = '01';
subjectdata.subject_dir     = 'sub-01';
path                        = append(subjectdata.generalpath, '/', subjectdata.filedir);
cd(path)

% SIT - Manual Input for EEG and LFP Datasets 
subjectdata.signalpoint.Sit                         = [];
subjectdata.signalpoint.Sit.EEG_signal              = 18684;                                                                % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Sit.LFP_signal              = 18738;                                                                % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Sit.LFP_signal > subjectdata.signalpoint.Sit.EEG_signal;                                         % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Sit.delay = subjectdata.signalpoint.Sit.LFP_signal - subjectdata.signalpoint.Sit.EEG_signal;     % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Sit.EEG_signal > subjectdata.signalpoint.Sit.LFP_signal;                                       % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Sit.delay = subjectdata.signalpoint.Sit.EEG_signal - subjectdata.signalpoint.Sit.LFP_signal;   % Find time-delay between both EEG and LFP
end 


% STAND - Manual Input for EEG and LFP Datasets 
subjectdata.signalpoint.Stand                        = [];
subjectdata.signalpoint.Stand.EEG_signal             = 17004;                                                                % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Stand.LFP_signal             = 22069;                                                                % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Stand.LFP_signal > subjectdata.signalpoint.Stand.EEG_signal;                                      % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Stand.delay = subjectdata.signalpoint.Stand.LFP_signal - subjectdata.signalpoint.Stand.EEG_signal;% Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Stand.EEG_signal > subjectdata.signalpoint.Stand.LFP_signal;                                    % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Stand.delay = subjectdata.signalpoint.Stand.EEG_signal - subjectdata.signalpoint.Stand.LFP_signal;%find time-delay between both EEG and LFP
end 


% WALK - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Walk                        = [];
subjectdata.signalpoint.Walk.EEG_signal             = 4758;                                                                    % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Walk.LFP_signal             = 31056;                                                                   % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Walk.LFP_signal > subjectdata.signalpoint.Walk.EEG_signal;                                          % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Walk.delay = subjectdata.signalpoint.Walk.LFP_signal - subjectdata.signalpoint.Walk.EEG_signal;     % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Walk.EEG_signal > subjectdata.signalpoint.Walk.LFP_signal;                                        % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Walk.delay = subjectdata.signalpoint.Walk.EEG_signal - subjectdata.signalpoint.Walk.LFP_signal;   % Find time-delay between both EEG and LFP
end


% WALK WITH STOPS - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.WalkWS                      = [];
subjectdata.signalpoint.WalkWS.EEG_signal           = 11919;                                                                    % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.WalkWS.LFP_signal           = 31813;                                                                    % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.WalkWS.LFP_signal > subjectdata.signalpoint.WalkWS.EEG_signal;                                       % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.WalkWS.delay = subjectdata.signalpoint.WalkWS.LFP_signal - subjectdata.signalpoint.WalkWS.EEG_signal;% Find time-delay between both EEG and LFP
else subjectdata.signalpoint.WalkWS.EEG_signal > subjectdata.signalpoint.WalkWS.LFP_signal;                                     % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.WalkWS.delay = subjectdata.signalpoint.WalkWS.EEG_signal - subjectdata.signalpoint.WalkWS.LFP_signal;% Find time-delay between both EEG and LFP
end 


%=== FILTERED GAIT EVENTS FOR WALK ONLY ===
% Manual input for filtered gait events based on exact timings of heelstrikes (not shown here)
subjectdata.events_filt.Walk = struct;

%Walk 1
subjectdata.events_filt.Walk(1).start = 8.5390; 
subjectdata.events_filt.Walk(1).task = 'Walk';
subjectdata.events_filt.Walk(1).end = 14.4190;

%Turn 1
subjectdata.events_filt.Walk(2).start =  14.9840;
subjectdata.events_filt.Walk(2).task = 'Turn';
subjectdata.events_filt.Walk(2).end = 19.5590;

%Walk 2
subjectdata.events_filt.Walk(3).start =  20.6800;
subjectdata.events_filt.Walk(3).task = 'Walk';
subjectdata.events_filt.Walk(3).end = 24.1770;

%Turn 2
subjectdata.events_filt.Walk(4).start =  25.8530;
subjectdata.events_filt.Walk(4).task = 'Turn';
subjectdata.events_filt.Walk(4).end = 29.9460;

%Walk 3
subjectdata.events_filt.Walk(5).start = 30.5260; 
subjectdata.events_filt.Walk(5).task = 'Walk';
subjectdata.events_filt.Walk(5).end = 35.1360;

%Turn 3
subjectdata.events_filt.Walk(6).start = 36.8930; 
subjectdata.events_filt.Walk(6).task = 'Turn';
subjectdata.events_filt.Walk(6).end = 41.2080;

%Walk 4
subjectdata.events_filt.Walk(7).start = 41.7570; 
subjectdata.events_filt.Walk(7).task = 'Walk';
subjectdata.events_filt.Walk(7).end = 46.6300;

%Turn 4
subjectdata.events_filt.Walk(8).start = 48.4130; 
subjectdata.events_filt.Walk(8).task = 'Turn';
subjectdata.events_filt.Walk(8).end = 52.7670;

%Walk 5
subjectdata.events_filt.Walk(9).start = 53.3440; 
subjectdata.events_filt.Walk(9).task = 'Walk';
subjectdata.events_filt.Walk(9).end = 58.1260;

%Turn 5
subjectdata.events_filt.Walk(10).start = 59.9460; 
subjectdata.events_filt.Walk(10).task = 'Turn';
subjectdata.events_filt.Walk(10).end = 63.9900;

%Walk 6
subjectdata.events_filt.Walk(11).start = 64.5320; 
subjectdata.events_filt.Walk(11).task = 'Walk';
subjectdata.events_filt.Walk(11).end = 69.0900;

%Turn 6
subjectdata.events_filt.Walk(12).start = 70.7470; 
subjectdata.events_filt.Walk(12).task = 'Turn';
subjectdata.events_filt.Walk(12).end = 74.8640;

%Walk 7
subjectdata.events_filt.Walk(13).start = 75.4140; 
subjectdata.events_filt.Walk(13).task = 'Walk';
subjectdata.events_filt.Walk(13).end = 79.7790;

%Turn 7
subjectdata.events_filt.Walk(14).start = 81.4730; 
subjectdata.events_filt.Walk(14).task = 'Turn';
subjectdata.events_filt.Walk(14).end = 85.9270;

%Walk 8
subjectdata.events_filt.Walk(15).start = 86.4550; 
subjectdata.events_filt.Walk(15).task = 'Walk';
subjectdata.events_filt.Walk(15).end = 92.1060;

%Turn 8
subjectdata.events_filt.Walk(16).start = 92.6890; 
subjectdata.events_filt.Walk(16).task = 'Turn';
subjectdata.events_filt.Walk(16).end = 97.7120;

%Walk 9
subjectdata.events_filt.Walk(17).start = 98.2360; 
subjectdata.events_filt.Walk(17).task = 'Walk';
subjectdata.events_filt.Walk(17).end = 104.1610;

%Turn 9
subjectdata.events_filt.Walk(18).start = 105.2360; 
subjectdata.events_filt.Walk(18).task = 'Turn';
subjectdata.events_filt.Walk(18).end = 109.8070;

%Walk 10
subjectdata.events_filt.Walk(19).start = 111.1340; 
subjectdata.events_filt.Walk(19).task = 'Walk';
subjectdata.events_filt.Walk(19).end = 116.7670;

%Turn 10
subjectdata.events_filt.Walk(20).start = 118.5020; 
subjectdata.events_filt.Walk(20).task = 'Turn';
subjectdata.events_filt.Walk(20).end = 122.5120;

%Walk 11
subjectdata.events_filt.Walk(21).start = 123.2090; 
subjectdata.events_filt.Walk(21).task = 'Walk';
subjectdata.events_filt.Walk(21).end = 127.5790;

%Turn 11
subjectdata.events_filt.Walk(22).start = 129.7610; 
subjectdata.events_filt.Walk(22).task = 'Turn';
subjectdata.events_filt.Walk(22).end = 135.1390;

%Walk 12
subjectdata.events_filt.Walk(23).start = 135.8030; 
subjectdata.events_filt.Walk(23).task = 'Walk';
subjectdata.events_filt.Walk(23).end = 140.1240;

%Turn 12
subjectdata.events_filt.Walk(24).start = 142.2330; 
subjectdata.events_filt.Walk(24).task = 'Turn';
subjectdata.events_filt.Walk(24).end = 146.4780;

%Walk 13
subjectdata.events_filt.Walk(25).start = 147.1960; 
subjectdata.events_filt.Walk(25).task = 'Walk';
subjectdata.events_filt.Walk(25).end = 151.4410;

%Turn 13
subjectdata.events_filt.Walk(26).start = 153.5150; 
subjectdata.events_filt.Walk(26).task = 'Turn';
subjectdata.events_filt.Walk(26).end = 158.3030;
  
%Walk 14
subjectdata.events_filt.Walk(27).start = 158.9670; 
subjectdata.events_filt.Walk(27).task = 'Walk';
subjectdata.events_filt.Walk(27).end = 163.9410;

%Turn 14
subjectdata.events_filt.Walk(28).start = 164.5730; 
subjectdata.events_filt.Walk(28).task = 'Turn';
subjectdata.events_filt.Walk(28).end = 169.6380;

%Freezing while turning, omit after discussion
%subjectdata.events_filt.Walk(29).start = 165.7170; 
%subjectdata.events_filt.Walk(29).task = 'Freezing_turn';
%subjectdata.events_filt.Walk(29).end = 168.3190;

%Walk 15
subjectdata.events_filt.Walk(30).start = 170.2000; 
subjectdata.events_filt.Walk(30).task = 'Walk';
subjectdata.events_filt.Walk(30).end = 175.0710;

%Turn 15
subjectdata.events_filt.Walk(31).start = 175.7240; 
subjectdata.events_filt.Walk(31).task = 'Turn';
subjectdata.events_filt.Walk(31).end = 180.6480;

%Walk 16
subjectdata.events_filt.Walk(32).start = 181.2380; 
subjectdata.events_filt.Walk(32).task = 'Walk';
subjectdata.events_filt.Walk(32).end = 186.0570;

%Turn 16
subjectdata.events_filt.Walk(33).start = 187.8500; 
subjectdata.events_filt.Walk(33).task = 'Turn';
subjectdata.events_filt.Walk(33).end = 191.7720;

%Walk 17
subjectdata.events_filt.Walk(34).start = 192.9890; 
subjectdata.events_filt.Walk(34).task = 'Walk';
subjectdata.events_filt.Walk(34).end = 197.8080;

%Turn 17
subjectdata.events_filt.Walk(35).start = 199.0430; 
subjectdata.events_filt.Walk(35).task = 'Turn';
subjectdata.events_filt.Walk(35).end = 203.2470;

%Walk 18
subjectdata.events_filt.Walk(36).start = 204.7880; 
subjectdata.events_filt.Walk(36).task = 'Walk';
subjectdata.events_filt.Walk(36).end = 207.9540;

%Turn 18
subjectdata.events_filt.Walk(37).start = 210.2460; 
subjectdata.events_filt.Walk(37).task = 'Turn';
subjectdata.events_filt.Walk(37).end = 214.3880;

%Walk 19
subjectdata.events_filt.Walk(38).start = 215.1670; 
subjectdata.events_filt.Walk(38).task = 'Walk';
subjectdata.events_filt.Walk(38).end = 219.3600;

%Turn 19
subjectdata.events_filt.Walk(39).start = 221.3200; 
subjectdata.events_filt.Walk(39).task = 'Turn';
subjectdata.events_filt.Walk(39).end = 225.4410;

%Walk 20
subjectdata.events_filt.Walk(40).start = 226.0360; 
subjectdata.events_filt.Walk(40).task = 'Walk';
subjectdata.events_filt.Walk(40).end = 230.6080;

%Turn 20
%subjectdata.events_filt.Walk(41).start = 232.4680; 
%subjectdata.events_filt.Walk(41).task = 'Turn';
%subjectdata.events_filt.Walk(41).end = 236.8450;


%=== FILTERED GAIT EVENTS FOR WALK WITH STOPS ONLY ===
%Manual Input for Filtered Gait Events based on the exact timings of heelstrike events (not shown here)
subjectdata.events_filt.WalkWS = struct;

%Walk 1
subjectdata.events_filt.WalkWS(1).task = 'Walk'; 
subjectdata.events_filt.WalkWS(1).start = 10.7270;
subjectdata.events_filt.WalkWS(1).end = 12.9540;

%Selected stop 1
subjectdata.events_filt.WalkWS(2).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(2).start = 13.8050;
subjectdata.events_filt.WalkWS(2).end = 15.508;

%Selected stop 2
subjectdata.events_filt.WalkWS(3).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(3).start = 17.5120000000000;
subjectdata.events_filt.WalkWS(3).end = 18.775;

%Walk 2
subjectdata.events_filt.WalkWS(4).task = 'Walk'; 
subjectdata.events_filt.WalkWS(4).start = 19.9450;
subjectdata.events_filt.WalkWS(4).end = 21.2380;

%Selected stop 3 % After Review, Stop too short but good for Pre-Stop analyses
subjectdata.events_filt.WalkWS(5).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(5).start = 22.754;
subjectdata.events_filt.WalkWS(5).end = 23.720;

%Turn 1
subjectdata.events_filt.WalkWS(6).task = 'Turn'; 
subjectdata.events_filt.WalkWS(6).start = 27.6400;
subjectdata.events_filt.WalkWS(6).end = 33.4830;

%Freezing while turn
subjectdata.events_filt.WalkWS(7).task = 'Freezing_turn'; 
subjectdata.events_filt.WalkWS(7).start = 28.2810;
subjectdata.events_filt.WalkWS(7).end = 33.4830;


%Walk 3
subjectdata.events_filt.WalkWS(8).task = 'Walk'; 
subjectdata.events_filt.WalkWS(8).start = 37.1650;
subjectdata.events_filt.WalkWS(8).end = 39.7760;

%Walk 4
subjectdata.events_filt.WalkWS(9).task = 'Walk'; 
subjectdata.events_filt.WalkWS(9).start = 41.9189;
subjectdata.events_filt.WalkWS(9).end = 45.1160;

%Turn, omit turn after discussion
%subjectdata.events_filt.WalkWS(10).task = 'Turn'; 
%subjectdata.events_filt.WalkWS(10).start = 48.1380;
%subjectdata.events_filt.WalkWS(10).end = ;

%Freezing while turn
%subjectdata.events_filt.WalkWS(11).task = ''; 
%subjectdata.events_filt.WalkWS(11).start = ;
%subjectdata.events_filt.WalkWS(11).end = ;

% Walk 5
subjectdata.events_filt.WalkWS(12).task = 'Walk'; 
subjectdata.events_filt.WalkWS(12).start = 55.4780;
subjectdata.events_filt.WalkWS(12).end = 56.8610;

% Selected stop
subjectdata.events_filt.WalkWS(13).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(13).start = 58.5900;
subjectdata.events_filt.WalkWS(13).end = 60.141;

%Walk 6
subjectdata.events_filt.WalkWS(14).task = 'Walk'; 
subjectdata.events_filt.WalkWS(14).start = 61.3980;
subjectdata.events_filt.WalkWS(14).end = 63.9970;

% Turn
subjectdata.events_filt.WalkWS(15).task = 'Turn'; 
subjectdata.events_filt.WalkWS(15).start = 68.1780;
subjectdata.events_filt.WalkWS(15).end = 75.3030;

% Freezing while turning
subjectdata.events_filt.WalkWS(16).task = 'Freezing_turn'; 
subjectdata.events_filt.WalkWS(16).start = 69.8700;
subjectdata.events_filt.WalkWS(16).end = 75.3030;

%Selected stop After Review, Stop too short but good for Pre-Stop analyses
subjectdata.events_filt.WalkWS(17).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(17).start = 64.8870;
subjectdata.events_filt.WalkWS(17).end = 65.952;

%Walk 7
subjectdata.events_filt.WalkWS(18).task = 'Walk'; 
subjectdata.events_filt.WalkWS(18).start = 77.3140;
subjectdata.events_filt.WalkWS(18).end = 78.5370;

%Selected Stop 
subjectdata.events_filt.WalkWS(19).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(19).start = 79.5650;
subjectdata.events_filt.WalkWS(19).end = 80.876;

%Walk 8
subjectdata.events_filt.WalkWS(20).task = 'Walk'; 
subjectdata.events_filt.WalkWS(20).start = 81.1680;
subjectdata.events_filt.WalkWS(20).end = 86.4970;

%Turn
subjectdata.events_filt.WalkWS(21).task = 'Turn'; 
subjectdata.events_filt.WalkWS(21).start = 88.488;
subjectdata.events_filt.WalkWS(21).end = 93.7060;

%Selected stop % After Review, Stop is meant to be exluded due to FI
%subjectdata.events_filt.WalkWS(22).task = 'Selected_stop'; 
%subjectdata.events_filt.WalkWS(22).start = 87.5320;
%subjectdata.events_filt.WalkWS(22).end = ;

%Walk 9 
subjectdata.events_filt.WalkWS(23).task = 'Walk'; 
subjectdata.events_filt.WalkWS(23).start = 98.1650;
subjectdata.events_filt.WalkWS(23).end = 103.6970;

%Turn 
subjectdata.events_filt.WalkWS(24).task = 'Turn'; 
subjectdata.events_filt.WalkWS(24).start = 104.9140;
subjectdata.events_filt.WalkWS(24).end = 111.4890;

%Freezing while turning 
subjectdata.events_filt.WalkWS(25).task = 'Freezing_turn'; 
subjectdata.events_filt.WalkWS(25).start = 105.9410;
subjectdata.events_filt.WalkWS(25).end = 110.8020;

%Selected stop 
subjectdata.events_filt.WalkWS(26).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(26).start = 114.3520;
subjectdata.events_filt.WalkWS(26).end =  116.023;

%Turn 
subjectdata.events_filt.WalkWS(27).task = 'Turn'; 
subjectdata.events_filt.WalkWS(27).start = 125.2400;
subjectdata.events_filt.WalkWS(27).end = 133.0740;

%Freezing while turning
subjectdata.events_filt.WalkWS(28).task = 'Freezing_turn'; 
subjectdata.events_filt.WalkWS(28).start = 126.7690;
subjectdata.events_filt.WalkWS(28).end = 133.0740;

%Selected stop % After Review, Stop too short but good for Pre-Stop analyses
subjectdata.events_filt.WalkWS(29).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(29).start = 96.6470;
subjectdata.events_filt.WalkWS(29).end = 97.806;

%Selected stop
subjectdata.events_filt.WalkWS(30).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(30).start = 121.9110;
subjectdata.events_filt.WalkWS(30).end = 123.438;

%Walk 10
subjectdata.events_filt.WalkWS(31).task = 'Walk'; 
subjectdata.events_filt.WalkWS(31).start = 116.3410;
subjectdata.events_filt.WalkWS(31).end = 120.3840;

%Walk 11
subjectdata.events_filt.WalkWS(32).task = 'Walk'; 
subjectdata.events_filt.WalkWS(32).start = 137.5660;
subjectdata.events_filt.WalkWS(32).end = 141.6230;

%Turn
subjectdata.events_filt.WalkWS(33).task = 'Turn'; 
subjectdata.events_filt.WalkWS(33).start = 143.4670;
subjectdata.events_filt.WalkWS(33).end = 150.1490;

%Freezing while turning
subjectdata.events_filt.WalkWS(34).task = 'Freezing_turn'; 
subjectdata.events_filt.WalkWS(34).start = 143.9800;
subjectdata.events_filt.WalkWS(34).end = 150.1490;

%Walk 12
subjectdata.events_filt.WalkWS(35).task = 'Walk'; 
subjectdata.events_filt.WalkWS(35).start = 152.3950;
subjectdata.events_filt.WalkWS(35).end = 153.7040;

%Selected stop, relatively short but included 
subjectdata.events_filt.WalkWS(36).task = 'Selected_stop'; 
subjectdata.events_filt.WalkWS(36).start = 154.705;
subjectdata.events_filt.WalkWS(36).end = 155.855;

%Walk 13
subjectdata.events_filt.WalkWS(37).task = 'Walk'; 
subjectdata.events_filt.WalkWS(37).start = 157.0670;
subjectdata.events_filt.WalkWS(37).end = 159.6180;



% ===== Save DATA ====================================================================================================
save([path filesep subjectdata.subject_dir '_datafile.mat'], 'subjectdata', '-mat')

% *********************** END OF SCRIPT *******************************************************************************************************************
