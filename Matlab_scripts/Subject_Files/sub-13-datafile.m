%% sub-13-datafile.m ====================================================
% +------------------------------------------------------+
% |  Subject: SUB-13                                     |
% |                                                      |
% | Author: Philipp Klocke,Moritz Loeffler               | 
% +------------------------------------------------------+

% This script will serve as the main directory matlab file for sub-13

% Chose the pathway for the SenseFOG-main folder after downloading
subjectdata.generalpath     = uigetdir;                                                                                         % Target file should be the SenseFOG-main file after download
subjectdata.filedir         = 'sub-13';
subjectdata.subjectnr       = '13';
subjectdata.subject_dir     = 'sub-13';
path                        = append(subjectdata.generalpath, '/', subjectdata.filedir);
cd(path)


% SIT - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Sit = [];
subjectdata.signalpoint.Sit.EEG_signal          = 20671;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Sit.LFP_signal          = 18210;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Sit.LFP_signal > subjectdata.signalpoint.Sit.EEG_signal;                                             % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Sit.delay = subjectdata.signalpoint.Sit.LFP_signal - subjectdata.signalpoint.Sit.EEG_signal;         % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Sit.EEG_signal > subjectdata.signalpoint.Sit.LFP_signal;                                           % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Sit.delay = subjectdata.signalpoint.Sit.EEG_signal - subjectdata.signalpoint.Sit.LFP_signal;       % Find time-delay between both EEG and LFP
end 


% STAND - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Stand = [];
subjectdata.signalpoint.Stand.EEG_signal        = 24369;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Stand.LFP_signal        = 22231;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Stand.LFP_signal > subjectdata.signalpoint.Stand.EEG_signal;                                         % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Stand.delay = subjectdata.signalpoint.Stand.LFP_signal - subjectdata.signalpoint.Stand.EEG_signal;   % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Stand.EEG_signal > subjectdata.signalpoint.Stand.LFP_signal;                                       % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Stand.delay = subjectdata.signalpoint.Stand.EEG_signal - subjectdata.signalpoint.Stand.LFP_signal; % Find time-delay between both EEG and LFP
end 

% WALK - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.Walk = [];
subjectdata.signalpoint.Walk.EEG_signal         = 29536;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.Walk.LFP_signal         = 23932;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.Walk.LFP_signal > subjectdata.signalpoint.Walk.EEG_signal;                                           % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.Walk.delay = subjectdata.signalpoint.Walk.LFP_signal - subjectdata.signalpoint.Walk.EEG_signal;      % Find time-delay between both EEG and LFP
else subjectdata.signalpoint.Walk.EEG_signal > subjectdata.signalpoint.Walk.LFP_signal;                                         % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.Walk.delay = subjectdata.signalpoint.Walk.EEG_signal - subjectdata.signalpoint.Walk.LFP_signal;    % Find time-delay between both EEG and LFP
end

% WALK WITH STOPS - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.WalkWS = [];
subjectdata.signalpoint.WalkWS.EEG_signal       = 25889;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.WalkWS.LFP_signal       = 16194;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.WalkWS.LFP_signal > subjectdata.signalpoint.WalkWS.EEG_signal;                                       % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.WalkWS.delay = subjectdata.signalpoint.WalkWS.LFP_signal - subjectdata.signalpoint.WalkWS.EEG_signal;% Find time-delay between both EEG and LFP
else subjectdata.signalpoint.WalkWS.EEG_signal > subjectdata.signalpoint.WalkWS.LFP_signal;                                     % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.WalkWS.delay = subjectdata.signalpoint.WalkWS.EEG_signal - subjectdata.signalpoint.WalkWS.LFP_signal;% Find time-delay between both EEG and LFP
end 


% INTERFERENCE - Manual Input for EEG and LFP Datasets
subjectdata.signalpoint.WalkINT = [];
subjectdata.signalpoint.WalkINT.EEG_signal       = 19216;                                                                        % Sample where DBS Stimulation stops showing a clear downward spike, used for later alignsignals_new.m
subjectdata.signalpoint.WalkINT.LFP_signal       = 12709;                                                                        % Sample where DBS Stimulation stops showing a clear upward spike, used for later alignsignals_new.m
if subjectdata.signalpoint.WalkINT.LFP_signal > subjectdata.signalpoint.WalkINT.EEG_signal;                                      % If clause to see if LFP signal is longer than EEG signal 
   subjectdata.signalpoint.WalkINT.delay = subjectdata.signalpoint.WalkINT.LFP_signal - subjectdata.signalpoint.WalkINT.EEG_signal;% find time-delay between both EEG and LFP
else subjectdata.signalpoint.WalkINT.EEG_signal > subjectdata.signalpoint.WalkINT.LFP_signal;                                    % If clause to see if EEG signal is longer than LFP signal
     subjectdata.signalpoint.WalkINT.delay = subjectdata.signalpoint.WalkINT.EEG_signal - subjectdata.signalpoint.WalkINT.LFP_signal;% Find time-delay between both EEG and LFP
end 


%=== FILTERED GAIT EVENTS FOR WALK ONLY ===
% Manual input for filtered gait events based on exact timings of heelstrikes (not shown here)
subjectdata.events_filt.Walk = struct;

%Turn 1
subjectdata.events_filt.Walk(1).start = 69.265; 
subjectdata.events_filt.Walk(1).task = 'Turn';
subjectdata.events_filt.Walk(1).end = 76.1740000000000;

%Walk 1
subjectdata.events_filt.Walk(2).start = 77.5110000000000; 
subjectdata.events_filt.Walk(2).task = 'Walk';
subjectdata.events_filt.Walk(2).end = 81.6210000000000;

%Turn 2
subjectdata.events_filt.Walk(3).start = 83.0670000000000; 
subjectdata.events_filt.Walk(3).task = 'Turn';
subjectdata.events_filt.Walk(3).end = 88.111;

%Walk 2
subjectdata.events_filt.Walk(4).start = 90.2050000000000; 
subjectdata.events_filt.Walk(4).task = 'Walk';
subjectdata.events_filt.Walk(4).end = 94.8300000000000;

%Turn 3
subjectdata.events_filt.Walk(5).start = 95.652; 
subjectdata.events_filt.Walk(5).task = 'Turn';
subjectdata.events_filt.Walk(5).end = 103.056;

%Walk 3
subjectdata.events_filt.Walk(6).start = 105.138000000000; 
subjectdata.events_filt.Walk(6).task = 'Walk';
subjectdata.events_filt.Walk(6).end = 109.609000000000;

%Turn 4
subjectdata.events_filt.Walk(7).start = 110.373; 
subjectdata.events_filt.Walk(7).task = 'Turn';
subjectdata.events_filt.Walk(7).end = 116.986000000000;

%Walk 4
subjectdata.events_filt.Walk(8).start = 118.506000000000; 
subjectdata.events_filt.Walk(8).task = 'Walk';
subjectdata.events_filt.Walk(8).end = 121.474;

%Turn 5
subjectdata.events_filt.Walk(9).start = 122.272; 
subjectdata.events_filt.Walk(9).task = 'Turn';
subjectdata.events_filt.Walk(9).end = 127.832000000000;

%Walk
subjectdata.events_filt.Walk(10).start = 128.575000000000; 
subjectdata.events_filt.Walk(10).task = 'Walk';
subjectdata.events_filt.Walk(10).end = 132.031000000000;

%Turn
subjectdata.events_filt.Walk(11).start = 133.633000000000; 
subjectdata.events_filt.Walk(11).task = 'Turn';
subjectdata.events_filt.Walk(11).end = 139.989000000000;

%Walk
subjectdata.events_filt.Walk(12).start = 141.324000000000; 
subjectdata.events_filt.Walk(12).task = 'Walk';
subjectdata.events_filt.Walk(12).end = 144.109000000000;

%Turn
subjectdata.events_filt.Walk(13).start = 145.482000000000; 
subjectdata.events_filt.Walk(13).task = 'Turn';
subjectdata.events_filt.Walk(13).end = 150.200000000000;

%Walk
subjectdata.events_filt.Walk(14).start = 151.732000000000; 
subjectdata.events_filt.Walk(14).task = 'Walk';
subjectdata.events_filt.Walk(14).end = 154.792000000000;

%Turn
subjectdata.events_filt.Walk(15).start = 156.294000000000; 
subjectdata.events_filt.Walk(15).task = 'Turn';
subjectdata.events_filt.Walk(15).end = 160.810000000000;

%Walk
subjectdata.events_filt.Walk(16).start = 162.155000000000;
subjectdata.events_filt.Walk(16).task = 'Walk';
subjectdata.events_filt.Walk(16).end = 166.700000000000;

%Turn
subjectdata.events_filt.Walk(17).start = 168.178000000000; 
subjectdata.events_filt.Walk(17).task = 'Turn';
subjectdata.events_filt.Walk(17).end = 174.2440;

%Walk
subjectdata.events_filt.Walk(18).start = 175.721; 
subjectdata.events_filt.Walk(18).task = 'Walk';
subjectdata.events_filt.Walk(18).end = 178.959000000000;

%Turn
subjectdata.events_filt.Walk(19).start = 180.399000000000; 
subjectdata.events_filt.Walk(19).task = 'Turn';
subjectdata.events_filt.Walk(19).end = 186.901000000000;

%Walk
subjectdata.events_filt.Walk(20).start = 187.572000000000; 
subjectdata.events_filt.Walk(20).task = 'Walk';
subjectdata.events_filt.Walk(20).end = 192.176000000000;

%Turn
subjectdata.events_filt.Walk(21).start = 193.750000000000; 
subjectdata.events_filt.Walk(21).task = 'Turn';
subjectdata.events_filt.Walk(21).end = 199.489;

%Walk
subjectdata.events_filt.Walk(22).start = 200.370000000000; 
subjectdata.events_filt.Walk(22).task = 'Walk';
subjectdata.events_filt.Walk(22).end = 203.640000000000;

%Turn
subjectdata.events_filt.Walk(23).start = 205.100000000000; 
subjectdata.events_filt.Walk(23).task = 'Turn';
subjectdata.events_filt.Walk(23).end = 212.368;

%Walk
subjectdata.events_filt.Walk(24).start = 212.368000000000; 
subjectdata.events_filt.Walk(24).task = 'Walk';
subjectdata.events_filt.Walk(24).end = 215.165000000000;

%Turn
subjectdata.events_filt.Walk(25).start = 216.599000000000; 
subjectdata.events_filt.Walk(25).task = 'Turn';
subjectdata.events_filt.Walk(25).end = 223.319;

%Walk
subjectdata.events_filt.Walk(26).start = 224.898; 
subjectdata.events_filt.Walk(26).task = 'Walk';
subjectdata.events_filt.Walk(26).end = 228.308000000000;

%Turn
subjectdata.events_filt.Walk(27).start = 230.013000000000; 
subjectdata.events_filt.Walk(27).task = 'Turn';
subjectdata.events_filt.Walk(27).end = 237.228000000000;

%Freezing while turning
subjectdata.events_filt.Walk(28).start = 232.257000000000; 
subjectdata.events_filt.Walk(28).task = 'Freezing_turn';
subjectdata.events_filt.Walk(28).end = 236.589000000000;

%Walk
subjectdata.events_filt.Walk(29).start = 238.544000000000; 
subjectdata.events_filt.Walk(29).task = 'Walk';
subjectdata.events_filt.Walk(29).end = 240.034000000000;

%Turn
subjectdata.events_filt.Walk(30).start = 242.571; 
subjectdata.events_filt.Walk(30).task = 'Turn';
subjectdata.events_filt.Walk(30).end = 248.353000000000;

%Walk
subjectdata.events_filt.Walk(31).start = 249.954000000000; 
subjectdata.events_filt.Walk(31).task = 'Walk';
subjectdata.events_filt.Walk(31).end = 251.682000000000;

%Turn
subjectdata.events_filt.Walk(32).start = 254.765000000000; 
subjectdata.events_filt.Walk(32).task = 'Turn';
subjectdata.events_filt.Walk(32).end = 259.509000000000;

%Walk
subjectdata.events_filt.Walk(33).start = 260.913000000000; 
subjectdata.events_filt.Walk(33).task = 'Walk';
subjectdata.events_filt.Walk(33).end = 262.444000000000;

%Turn
subjectdata.events_filt.Walk(34).start = 263.946000000000; 
subjectdata.events_filt.Walk(34).task = 'Turn';
subjectdata.events_filt.Walk(34).end = 270.513000000000;

%Walk
subjectdata.events_filt.Walk(35).start = 272.178000000000; 
subjectdata.events_filt.Walk(35).task = 'Walk';
subjectdata.events_filt.Walk(35).end = 273.965000000000;




%=== FILTERED GAIT EVENTS FOR WALK WITH STOPS ONLY ===
%Manual Input for Filtered Gait Events based on the exact timings of heelstrike events (not shown here)
subjectdata.events_filt.WalkWS = struct;

%Walk 1
subjectdata.events_filt.WalkWS(1).start = 36.1020; 
subjectdata.events_filt.WalkWS(1).task = 'Walk';
subjectdata.events_filt.WalkWS(1).end = 39.1860;

%Selected stop
subjectdata.events_filt.WalkWS(2).start =  42.7730;
subjectdata.events_filt.WalkWS(2).task = 'Selected_stop';
subjectdata.events_filt.WalkWS(2).end = 45.3;

%Turn
subjectdata.events_filt.WalkWS(3).start = 48.9830; 
subjectdata.events_filt.WalkWS(3).task = 'Turn';
subjectdata.events_filt.WalkWS(3).end = 54.8060;

%Walk 2
subjectdata.events_filt.WalkWS(4).start = 55.5610; 
subjectdata.events_filt.WalkWS(4).task = 'Walk';
subjectdata.events_filt.WalkWS(4).end = 57.1800;

%Selected stop
subjectdata.events_filt.WalkWS(5).start = 58.8760; 
subjectdata.events_filt.WalkWS(5).task = 'Selected_stop';
subjectdata.events_filt.WalkWS(5).end = 60.4;

%Walk 3
subjectdata.events_filt.WalkWS(6).start = 62.3480; 
subjectdata.events_filt.WalkWS(6).task = 'Walk';
subjectdata.events_filt.WalkWS(6).end = 65.6370;

%Turn
subjectdata.events_filt.WalkWS(7).start = 67.3380; 
subjectdata.events_filt.WalkWS(7).task = 'Turn';
subjectdata.events_filt.WalkWS(7).end = 73.4960;

%Selected stop
subjectdata.events_filt.WalkWS(8).start = 74.9620; 
subjectdata.events_filt.WalkWS(8).task = 'Selected_stop';
subjectdata.events_filt.WalkWS(8).end = 78.0;

%Walk 4
subjectdata.events_filt.WalkWS(9).start = 79.4780; 
subjectdata.events_filt.WalkWS(9).task = 'Walk';
subjectdata.events_filt.WalkWS(9).end = 84.1610;

%Turn
subjectdata.events_filt.WalkWS(10).start = 86.675; 
subjectdata.events_filt.WalkWS(10).task = 'Turn';
subjectdata.events_filt.WalkWS(10).end = 92.6820;

%Walk 5
subjectdata.events_filt.WalkWS(11).start = 94.2880; 
subjectdata.events_filt.WalkWS(11).task = 'Walk';
subjectdata.events_filt.WalkWS(11).end = 95.9850;

%Turn, omit turn after discussion, talking while turning
%subjectdata.events_filt.WalkWS(12).start = 104.4520; 
%subjectdata.events_filt.WalkWS(12).task = 'Turn';
%subjectdata.events_filt.WalkWS(12).end = 113.0470;

%Selected stop % After review 04/23 decided to omit this one
%subjectdata.events_filt.WalkWS(13).start = 100.1850; 
%subjectdata.events_filt.WalkWS(13).task = 'Selected_stop';
%subjectdata.events_filt.WalkWS(13).end = ;

%Walk 6
subjectdata.events_filt.WalkWS(14).start = 114.9740; 
subjectdata.events_filt.WalkWS(14).task = 'Walk';
subjectdata.events_filt.WalkWS(14).end = 119.8530;

%Selected stop
subjectdata.events_filt.WalkWS(15).start = 139.7620; 
subjectdata.events_filt.WalkWS(15).task = 'Selected_stop';
subjectdata.events_filt.WalkWS(15).end = 143.2;

%Walk 7
subjectdata.events_filt.WalkWS(16).start = 134.3820; 
subjectdata.events_filt.WalkWS(16).task = 'Walk';
subjectdata.events_filt.WalkWS(16).end = 135.8790;

%Turn
subjectdata.events_filt.WalkWS(17).start = 146.2830; 
subjectdata.events_filt.WalkWS(17).task = 'Turn';
subjectdata.events_filt.WalkWS(17).end = 152.0560;

%Selected stop
subjectdata.events_filt.WalkWS(18).start = 156.5220; 
subjectdata.events_filt.WalkWS(18).task = 'Selected_stop';
subjectdata.events_filt.WalkWS(18).end = 159.45;

%Walk 8 
subjectdata.events_filt.WalkWS(19).start = 161.0580; 
subjectdata.events_filt.WalkWS(19).task = 'Walk';
subjectdata.events_filt.WalkWS(19).end = 164.4710;

%Turn
subjectdata.events_filt.WalkWS(21).start = 165.3990; 
subjectdata.events_filt.WalkWS(21).task = 'Turn';
subjectdata.events_filt.WalkWS(21).end = 171.7070;

%Selected stop
subjectdata.events_filt.WalkWS(22).start = 179.7520; 
subjectdata.events_filt.WalkWS(22).task = 'Selected_stop';
subjectdata.events_filt.WalkWS(22).end = 182.6;

%Turn
subjectdata.events_filt.WalkWS(23).start = 186.5910; 
subjectdata.events_filt.WalkWS(23).task = 'Turn';
subjectdata.events_filt.WalkWS(23).end = 192.5000;

%Walk 10
subjectdata.events_filt.WalkWS(24).start = 193.9888; 
subjectdata.events_filt.WalkWS(24).task = 'Walk';
subjectdata.events_filt.WalkWS(24).end = 198.4260;

%Turn
subjectdata.events_filt.WalkWS(25).start = 200.6560; 
subjectdata.events_filt.WalkWS(25).task = 'Turn';
subjectdata.events_filt.WalkWS(25).end = 205.3760;

%Walk 11
subjectdata.events_filt.WalkWS(26).start = 206.1370; 
subjectdata.events_filt.WalkWS(26).task = 'Walk';
subjectdata.events_filt.WalkWS(26).end = 212.2250;

%Turn
subjectdata.events_filt.WalkWS(27).start = 213.9140; 
subjectdata.events_filt.WalkWS(27).task = 'Turn';
subjectdata.events_filt.WalkWS(27).end = 218.6040;

%Selected stop
subjectdata.events_filt.WalkWS(28).start = 219.1960; 
subjectdata.events_filt.WalkWS(28).task = 'Selected_stop';
subjectdata.events_filt.WalkWS(28).end = 221.995;

%Walk 12
subjectdata.events_filt.WalkWS(29).start = 222.7540; 
subjectdata.events_filt.WalkWS(29).task = 'Walk';
subjectdata.events_filt.WalkWS(29).end = 227.3150;

%Turn
subjectdata.events_filt.WalkWS(30).start = 229.7810; 
subjectdata.events_filt.WalkWS(30).task = 'Turn';
subjectdata.events_filt.WalkWS(30).end = 235.2100;

%Walk 13
subjectdata.events_filt.WalkWS(31).start = 236.8060; 
subjectdata.events_filt.WalkWS(31).task = 'Walk';
subjectdata.events_filt.WalkWS(31).end = 238.5320;

%Selected stop
subjectdata.events_filt.WalkWS(32).start = 242.4260; 
subjectdata.events_filt.WalkWS(32).task = 'Selected_stop';
subjectdata.events_filt.WalkWS(32).end = 244.2;

%Turn
subjectdata.events_filt.WalkWS(33).start = 248.5840; 
subjectdata.events_filt.WalkWS(33).task = 'Turn';
subjectdata.events_filt.WalkWS(33).end = 254.1520;

%Walk 14
subjectdata.events_filt.WalkWS(34).start = 255.7150; 
subjectdata.events_filt.WalkWS(34).task = 'Walk';
subjectdata.events_filt.WalkWS(34).end = 160.1510;

%Turn
subjectdata.events_filt.WalkWS(35).start = 262.6080; 
subjectdata.events_filt.WalkWS(35).task = 'Turn';
subjectdata.events_filt.WalkWS(35).end = 268.0290;

%Walk 15
subjectdata.events_filt.WalkWS(36).start = 268.7500; 
subjectdata.events_filt.WalkWS(36).task = 'Walk';
subjectdata.events_filt.WalkWS(36).end = 274.8060;

%Turn
subjectdata.events_filt.WalkWS(37).start = 276.4670; 
subjectdata.events_filt.WalkWS(37).task = 'Turn';
subjectdata.events_filt.WalkWS(37).end = 283.0200;

%Walk 16
subjectdata.events_filt.WalkWS(38).start = 283.7510; 
subjectdata.events_filt.WalkWS(38).task = 'Walk';
subjectdata.events_filt.WalkWS(38).end = 286.6890;

%Turn
subjectdata.events_filt.WalkWS(39).start = 294.7110; 
subjectdata.events_filt.WalkWS(39).task = 'Turn';
subjectdata.events_filt.WalkWS(39).end = 301.0320;

%Selected stop
subjectdata.events_filt.WalkWS(40).start = 290.6310; 
subjectdata.events_filt.WalkWS(40).task = 'Selected_stop';
subjectdata.events_filt.WalkWS(40).end = 293.2;

%Walk 17
subjectdata.events_filt.WalkWS(41).start = 302.7060; 
subjectdata.events_filt.WalkWS(41).task = 'Walk';
subjectdata.events_filt.WalkWS(41).end = 307.3760;

%Turn
subjectdata.events_filt.WalkWS(42).start = 309.6440; 
subjectdata.events_filt.WalkWS(42).task = 'Turn';
subjectdata.events_filt.WalkWS(42).end = 315.6420;

%Walk 18
subjectdata.events_filt.WalkWS(43).start = 317.1820; 
subjectdata.events_filt.WalkWS(43).task = 'Walk';
subjectdata.events_filt.WalkWS(43).end = 318.6650;

%Selected stop
subjectdata.events_filt.WalkWS(44).start = 322.5450; 
subjectdata.events_filt.WalkWS(44).task = 'Selected_stop';
subjectdata.events_filt.WalkWS(44).end = 325.0;

%Turn
subjectdata.events_filt.WalkWS(45).start = 329.3000; 
subjectdata.events_filt.WalkWS(45).task = 'Turn';
subjectdata.events_filt.WalkWS(45).end = 334.6330;

%Walk 19
subjectdata.events_filt.WalkWS(46).start = 336.1760; 
subjectdata.events_filt.WalkWS(46).task = 'Walk';
subjectdata.events_filt.WalkWS(46).end = 343.7780;

%Turn
subjectdata.events_filt.WalkWS(47).start = 345.2740; 
subjectdata.events_filt.WalkWS(47).task = 'Turn';
subjectdata.events_filt.WalkWS(47).end = 351.2980;



%=== FILTERED GAIT EVENTS FOR WALK WITH INTERFERENCE ONLY ===
%Manual Input for Filtered Gait Events based on the exact timings of heelstrike events (not shown here)
subjectdata.events_filt.WalkINT = struct;

%Walk 1
subjectdata.events_filt.WalkINT(1).task = 'Walk'; 
subjectdata.events_filt.WalkINT(1).start = 22.0530000000000;
subjectdata.events_filt.WalkINT(1).end = 31.1890000000000;

%Turn 1
subjectdata.events_filt.WalkINT(2).task = 'Turn'; 
subjectdata.events_filt.WalkINT(2).start = 32.4120000000000;
subjectdata.events_filt.WalkINT(2).end = 38.3390000000000;

%Walk 2
subjectdata.events_filt.WalkINT(3).task = 'Walk'; 
subjectdata.events_filt.WalkINT(3).start = 39.6750000000000;
subjectdata.events_filt.WalkINT(3).end = 46.8700000000000;

%Turn 2
subjectdata.events_filt.WalkINT(4).task = 'Turn'; 
subjectdata.events_filt.WalkINT(4).start = 48.2430000000000;
subjectdata.events_filt.WalkINT(4).end = 53.8720000000000;

%Freezing while turning
subjectdata.events_filt.WalkINT(5).task = 'Freezing_turn'; 
subjectdata.events_filt.WalkINT(5).start = 49.5640000000000;
subjectdata.events_filt.WalkINT(5).end = 53.2380000000000;

%Walk 3
subjectdata.events_filt.WalkINT(6).task = 'Walk'; 
subjectdata.events_filt.WalkINT(6).start = 55.4920000000000;
subjectdata.events_filt.WalkINT(6).end = 62.7050000000000;

%Turn 3
subjectdata.events_filt.WalkINT(7).task = 'Turn'; 
subjectdata.events_filt.WalkINT(7).start = 64.2690000000000;
subjectdata.events_filt.WalkINT(7).end = 70.8660000000000;

%Walk 4
subjectdata.events_filt.WalkINT(8).task = 'Walk'; 
subjectdata.events_filt.WalkINT(8).start = 72.5990000000000;
subjectdata.events_filt.WalkINT(8).end = 80.2030000000000;

%Turn 4
subjectdata.events_filt.WalkINT(9).task = 'Turn'; 
subjectdata.events_filt.WalkINT(9).start = 81.8110000000000;
subjectdata.events_filt.WalkINT(9).end = 88.3000000000000;

%Walk 5
subjectdata.events_filt.WalkINT(10).task = 'Walk'; 
subjectdata.events_filt.WalkINT(10).start = 89.8740000000000;
subjectdata.events_filt.WalkINT(10).end = 95.7260000000000;

%Turn 5
subjectdata.events_filt.WalkINT(11).task = 'Turn'; 
subjectdata.events_filt.WalkINT(11).start = 97.3580000000000;
subjectdata.events_filt.WalkINT(11).end = 105.591;

%Walk 6
subjectdata.events_filt.WalkINT(12).task = 'Walk'; 
subjectdata.events_filt.WalkINT(12).start = 107.086;
subjectdata.events_filt.WalkINT(12).end = 114.682000000000;

%Turn 6
subjectdata.events_filt.WalkINT(13).task = 'Turn'; 
subjectdata.events_filt.WalkINT(13).start = 116.174000000000;
subjectdata.events_filt.WalkINT(13).end = 123.269;

%Walk 7
subjectdata.events_filt.WalkINT(14).task = 'Walk'; 
subjectdata.events_filt.WalkINT(14).start = 124.609;
subjectdata.events_filt.WalkINT(14).end = 130.299000000000;

%Turn 7
subjectdata.events_filt.WalkINT(15).task = 'Turn'; 
subjectdata.events_filt.WalkINT(15).start = 131.882000000000;
subjectdata.events_filt.WalkINT(15).end = 140.456000000000;

%Freezing while turning 2
subjectdata.events_filt.WalkINT(16).task = 'Freezing_turn'; 
subjectdata.events_filt.WalkINT(16).start = 134.515000000000;
subjectdata.events_filt.WalkINT(16).end = 138.591000000000;

%Walk 9
subjectdata.events_filt.WalkINT(17).task = 'Walk'; 
subjectdata.events_filt.WalkINT(17).start = 141.864000000000;
subjectdata.events_filt.WalkINT(17).end = 149.185000000000;

%Turn 9
subjectdata.events_filt.WalkINT(18).task = 'Turn'; 
subjectdata.events_filt.WalkINT(18).start = 150.747000000000;
subjectdata.events_filt.WalkINT(18).end = 157.429000000000;

%Walk 10
subjectdata.events_filt.WalkINT(19).task = 'Walk'; 
subjectdata.events_filt.WalkINT(19).start = 159.013000000000;
subjectdata.events_filt.WalkINT(19).end = 165.910000000000;

%Turn 10
subjectdata.events_filt.WalkINT(20).task = 'Turn'; 
subjectdata.events_filt.WalkINT(20).start = 167.390000000000;
subjectdata.events_filt.WalkINT(20).end = 177.173;

%Freezing while turning
subjectdata.events_filt.WalkINT(21).task = 'Freezing_turn'; 
subjectdata.events_filt.WalkINT(21).start = 170.053000000000;
subjectdata.events_filt.WalkINT(21).end = 175.789000000000;

%Walk 11
subjectdata.events_filt.WalkINT(22).task = 'Walk'; 
subjectdata.events_filt.WalkINT(22).start = 178.349;
subjectdata.events_filt.WalkINT(22).end = 185.560000000000;

%Turn 11
subjectdata.events_filt.WalkINT(23).task = 'Turn'; 
subjectdata.events_filt.WalkINT(23).start = 186.955000000000;
subjectdata.events_filt.WalkINT(23).end = 197.454000000000;

%Freezing while turning
subjectdata.events_filt.WalkINT(24).task = 'Freezing_turn'; 
subjectdata.events_filt.WalkINT(24).start = 189.136000000000;
subjectdata.events_filt.WalkINT(24).end = 195.816000000000;

%Walk 12
subjectdata.events_filt.WalkINT(25).task = 'Walk'; 
subjectdata.events_filt.WalkINT(25).start = 197.454000000000;
subjectdata.events_filt.WalkINT(25).end = 205.505000000000;

%Turn 12
subjectdata.events_filt.WalkINT(26).task = 'Turn'; 
subjectdata.events_filt.WalkINT(26).start = 207.143000000000;
subjectdata.events_filt.WalkINT(26).end = 216.058000000000;

%Walk 13
subjectdata.events_filt.WalkINT(27).task = 'Walk'; 
subjectdata.events_filt.WalkINT(27).start = 217.607000000000;
subjectdata.events_filt.WalkINT(27).end = 224.777000000000;

%Turn 13
subjectdata.events_filt.WalkINT(28).task = 'Turn'; 
subjectdata.events_filt.WalkINT(28).start = 226.343000000000;
subjectdata.events_filt.WalkINT(28).end = 237.023000000000;

%Freezing while turning
subjectdata.events_filt.WalkINT(29).task = 'Freezing_turn'; 
subjectdata.events_filt.WalkINT(29).start = 228.380000000000;
subjectdata.events_filt.WalkINT(29).end = 236.463000000000;

%Walk 14
subjectdata.events_filt.WalkINT(30).task = 'Walk'; 
subjectdata.events_filt.WalkINT(30).start = 238.751000000000;
subjectdata.events_filt.WalkINT(30).end = 246.275000000000;

%Turn 14
subjectdata.events_filt.WalkINT(31).task = 'Turn'; 
subjectdata.events_filt.WalkINT(31).start = 249.571;
subjectdata.events_filt.WalkINT(31).end = 258.551000000000;

%Freezing while turning
subjectdata.events_filt.WalkINT(32).task = 'Freezing_turn'; 
subjectdata.events_filt.WalkINT(32).start = 251.195000000000;
subjectdata.events_filt.WalkINT(32).end = 256.945000000000;

%Walk 15
subjectdata.events_filt.WalkINT(33).task = 'Walk'; 
subjectdata.events_filt.WalkINT(33).start = 260.097000000000;
subjectdata.events_filt.WalkINT(33).end = 267.627000000000;

%Turn 15
subjectdata.events_filt.WalkINT(34).task = 'Turn'; 
subjectdata.events_filt.WalkINT(34).start = 269.057000000000;
subjectdata.events_filt.WalkINT(34).end = 277.549000000000;

%Freezing while turing
subjectdata.events_filt.WalkINT(35).task = 'Freezing_turn'; 
subjectdata.events_filt.WalkINT(35).start = 271.094000000000;
subjectdata.events_filt.WalkINT(35).end = 276.830000000000;

%Walk 16
subjectdata.events_filt.WalkINT(36).task = 'Walk'; 
subjectdata.events_filt.WalkINT(36).start = 279.107000000000;
subjectdata.events_filt.WalkINT(36).end = 286.186000000000;

%Turn 16
subjectdata.events_filt.WalkINT(37).task = 'Turn'; 
subjectdata.events_filt.WalkINT(37).start = 287.773000000000;
subjectdata.events_filt.WalkINT(37).end = 302.794000000000;

%Freezing while turning
subjectdata.events_filt.WalkINT(38).task = 'Freezing_turn'; 
subjectdata.events_filt.WalkINT(38).start = 289.290000000000;
subjectdata.events_filt.WalkINT(38).end = 302.794000000000;

%Turn 17
subjectdata.events_filt.WalkINT(39).task = 'Turn'; 
subjectdata.events_filt.WalkINT(39).start = 313.390000000000;
subjectdata.events_filt.WalkINT(39).end = 322.851000000000;

%Freezing while turning
subjectdata.events_filt.WalkINT(40).task = 'Freezing_turn'; 
subjectdata.events_filt.WalkINT(40).start = 315.2440;
subjectdata.events_filt.WalkINT(40).end = 322.851000000000;


% ===== Save DATA ====================================================================================================
save([path filesep subjectdata.subject_dir '_datafile.mat'], 'subjectdata', '-mat')

% *********************** END OF SCRIPT *******************************************************************************************************************
