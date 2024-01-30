%% =====  Sub_GrandActivity_Log.m  ========================================%

%Date: August 2022
%Original author(s): Philipp Klocke, Moritz Loeffler

%This script will use the predefined activity time points (walking, freezing, stopping, etc.)
%defined in the subject's datafile (sub-xx_datafile.mat; see sub-xx-datafile.m) and match them 
%to the corresponding heelstrike. These heelstrike events as well as corresponding toe-offs 
%were created and meticulously reviewed by the author team and stored under sub-XX-ses-xx_gaitfilt_cor.mat. 
%See the manuscript/Methods section for a detailed description of how gait events were collected from 
%the IMU data. For each session (walk, walkws,walkint, walkint_new), EEG, LFP and IMU data will be stored in a
%struct variable and saved. Standing or sitting files DO NOT need to be called here as we will call them 
%at a later stage. Call each session individually and load EEG, LFP and IMU data.Each subject in the dataset will yield one file. 
%===========================================================================%

%Load EEG and LFP data and IMU data by specifying subject and SESSION of interest
subjectdata.generalpath                 = uigetdir;                                                             % Example: SenseFOG-main/sub-XX/ses-standing
cd(subjectdata.generalpath)
filename                                = extractAfter(subjectdata.generalpath,"-main");                        % Create the specified filename
filename                                = extractBefore(filename(2:end),"ses-");                                % Create the specified taskname
filename                                = filename(1:end-1);
taskname                                = extractAfter(subjectdata.generalpath,"ses-");                         % Create the specified taskname
taskname                                = append("ses-", taskname);                                             % Create the specified taskname
filepath                                = extractBefore(subjectdata.generalpath, "ses");                        % Create the specified filepath
filepath                                = filepath(1:end-1); 
fullname = append(subjectdata.generalpath, filesep, "ieeg", filesep, filename, "-", taskname, "_lfpalg.mat"); load(fullname)     % LOAD JSON [LFP] FILE
fullname = append(subjectdata.generalpath, filesep, "eeg", filesep, filename, "-", taskname, "_eegalg.mat"); load(fullname)      % LOAD BVA [EEG] FILE
fullname = append(subjectdata.generalpath, filesep, "motion", filesep, filename, "-", taskname, "_gaitalg.mat"); load(fullname)  % LOAD HDF [IMU] FILE
fullname = append(subjectdata.generalpath, filesep, "motion", filesep, filename, "-", taskname, "_gaitfilt_cor.mat"); load(fullname) % LOAD GaitEvents
fullname = append(filepath, filesep, filename, "_datafile.mat"); load(fullname);

subjectdata.filepath                    = filepath;                                                             % Create the specified filepath
subjectdata.fs_eeg                      = 1000;                                                                 % EEG sampling rate is 1000 Hz per default

%Load LFP-Events from other subject-specific sessions, should they exist
cd(subjectdata.filepath)
if isfile(append(filename,"-", 'dataevents.mat')) == 1 
    load([subjectdata.filepath filesep filename '-' 'dataevents.mat'], 'LFP_Events', '-mat')
end
cd(subjectdata.generalpath)


% Specify Tasknames
if     taskname == 'ses-standing';  name = 'Stand';
elseif taskname == 'ses-sitting';   name = 'Sit'; 
elseif taskname == 'ses-walk';      name = 'Walk';
elseif taskname == 'ses-walkws';    name = 'WalkWS';
elseif taskname == 'ses-walkint';   name = 'WalkINT';
elseif taskname == 'ses-walkint2';  name = 'WalkINT_new';
end


LFP_Events.(name) = struct;                                                                                     % Assign a structure array to the current session

%Check for NaNs in the LFP dataset. Highpass filtrering will cause an error otherwise
%NaNs will only occur at the beginning of the dataset and not be relevant for spectral analysis
labels = {'LFP_signal_R';'LFP_signal_L'};
for i = 1:length(labels);idx = isnan(LFP.(labels{i})); LFP.(labels{i})(:,idx) = 0; end
clear labels i idx

%Convert GaitEvents from struct to table
GaitEvents.rf_events = struct2table(GaitEvents.rf_events);
GaitEvents.lf_events = struct2table(GaitEvents.lf_events);

%Assign LFP signals to the current structure array
LFP_Events.(name).LFP_signal_R           = LFP.LFP_signal_R;
LFP_Events.(name).LFP_signal_L           = LFP.LFP_signal_L;
LFP_Events.(name).Accelerometer_RF       = IMU_data.interp_accelerometer(1).Sensor;                             % Save right foot accelerometer
LFP_Events.(name).Accelerometer_LF       = IMU_data.interp_accelerometer(2).Sensor;                             % Save left foot accelerometer
LFP_Events.(name).Gyroscope_RF           = rad2deg(IMU_data.interp_gyroscope(1).Sensor);                        % Save right foot gyroscope 
LFP_Events.(name).Gyroscope_LF           = rad2deg(IMU_data.interp_gyroscope(2).Sensor);                        % Save left foot gyroscope
LFP_Events.(name).rf_events              = GaitEvents.rf_events;                                                % Save right foot heelstrikes
LFP_Events.(name).lf_events              = GaitEvents.lf_events;                                                % Save left foot heelstrikes
LFP_Events.(name).EEG.EEG_signal         = EEG_File.EEG_signal;                                                 % Save EEG signal   
LFP_Events.(name).EEG.EEG_time           = EEG_File.EEG_time;                                                   % Save EEG time vector
LFP_Events.(name).EEG.EEG_channels       = EEG_File.channels;                                                   % Save EEG channel information


%Edit Novemeber 2022 - The signal delay (differnce between stimulation artefacts of EEG and LFP) need yet to be 
%subtracted from the pre-defined activity timepoints listed in the sub-XX-datafile.m, if LFP recording
%was started before EEG recording
if subjectdata.signalpoint.(name).EEG_signal > subjectdata.signalpoint.(name).LFP_signal == 1
    signaldelay                                 = subjectdata.signalpoint.(name).EEG_signal - subjectdata.signalpoint.(name).LFP_signal;
    for i = 1:length(subjectdata.events_filt.(name))
        subjectdata.events_filt.(name)(i).start = subjectdata.events_filt.(name)(i).start - (signaldelay/EEG_File.fs_eeg);
        subjectdata.events_filt.(name)(i).end   = subjectdata.events_filt.(name)(i).end - (signaldelay/EEG_File.fs_eeg);
    end       
end


%================ COLLECT WALKING ACTIVITY =============================================================================
idx = find(cellfun(@isempty,{subjectdata.events_filt.(name).task}));                                            % Delete any empty cells
subjectdata.events_filt.(name)(idx) = [];clear idx

%Search for all heelstrike events of one foot that occur during regular "Walking"
eventfile                                           = struct2table(subjectdata.events_filt.(name));             % Create an eventfile with all "WALK" Sequences
index_walk                                          = eventfile(ismember(eventfile.task,'Walk'),:);             % Find those with Walk only
index_walk                                          = [index_walk.start, index_walk.end];

%Find all Right foot heelstrikes
if isempty(index_walk) == 0 
    eventfile_gait_right                            = round(GaitEvents.rf_events.Heelstrike_Loc,4);             % All Right foot heelstrikes
    idx = eventfile_gait_right(eventfile_gait_right >= index_walk(1,1) & eventfile_gait_right <= index_walk(1,2)); %Find Heelstrikes that are listed as WALKING
    for i = 2:length(index_walk)
        idx_new = eventfile_gait_right(eventfile_gait_right >= index_walk(i,1) & eventfile_gait_right <= index_walk(i,2)); %find all HS events for each walking cycle
        store = cat(1, idx, idx_new); idx = store; 
    end
    LFP_Events.(name).Walking_Right_HS = store;
    
    kk = struct; 
    for i = 1:length(LFP_Events.(name).Walking_Right_HS)
        if i < length(LFP_Events.(name).Walking_Right_HS)
        kk(i).start = LFP_Events.(name).Walking_Right_HS(i); 
        kk(i).end = LFP_Events.(name).Walking_Right_HS(i+1); 
        kk(i).diff = kk(i).end - kk(i).start;
        end
    end
    store = vertcat(kk.diff); [~, idx] = rmoutliers(store); kk(idx) = []; %Removing outliers more than three scaled median absolute deviations (MAD) away from the median.
    LFP_Events.(name).Walking_Right_HS = kk; 

%Find all Left foot heelstrikes
    eventfile_gait_left = round(GaitEvents.lf_events.Heelstrike_Loc,4);                                         % ALL LEFT FOOT HEELSTRIKES
        idx = eventfile_gait_left(eventfile_gait_left >= index_walk(1,1) & eventfile_gait_left <= index_walk(1,2));
        for i = 2:length(index_walk)
            idx_new = eventfile_gait_left(eventfile_gait_left >= index_walk(i,1) & eventfile_gait_left <= index_walk(i,2)); %find all HS events for each walking cycle
            store = cat(1, idx, idx_new); idx = store; 
        end
        LFP_Events.(name).Walking_Left_HS = store; 
        
        kk = struct; 
        for i = 1:length(LFP_Events.(name).Walking_Left_HS)
            if i < length(LFP_Events.(name).Walking_Left_HS)
            kk(i).start = LFP_Events.(name).Walking_Left_HS(i); 
            kk(i).end = LFP_Events.(name).Walking_Left_HS(i+1); 
            kk(i).diff = kk(i).end - kk(i).start;
            end
        end
        store = vertcat(kk.diff); [~, idx] = rmoutliers(store); kk(idx) = [];  % Removing outliers more than three scaled median absolute deviations (MAD) away from the median.
        LFP_Events.(name).Walking_Left_HS = kk;
end

%Clean-UP
clear ans i idx idx_new store index_walk kk datafield i idx idx_imu idx_lfp k eventfile_gait_left eventfile_gait_right fields data_field

%================ COLLECT FREEZING ACTIVITY ============================================================================
index_freeze_walk = eventfile(ismember(eventfile.task,'Freezing_walk'),:);                                       % Find those with Freeze Turn only
index_freeze_walk = [index_freeze_walk.start, index_freeze_walk.end];
if isempty(index_freeze_walk) == 1; fprintf(2," \n List of Freezing Walks is empty "); end

kk = struct; 
for i = 1:size(index_freeze_walk,1)
    if isempty(i) == 1; continue
    else
            kk(i).start = index_freeze_walk(i,1); 
            kk(i).end = index_freeze_walk(i,2); 
            kk(i).duration = kk(i).end - kk(i).start;
    end
end

if isempty(fieldnames(kk)) == 1; clear kk; else LFP_Events.(name).Walking_Freeze = kk; end                       % Store the files into a struct
if isfield(LFP_Events.(name), 'Walking_Freeze') == 1; num = length(LFP_Events.(name).Walking_Freeze); fprintf('\n Number of Walking Freezes is %d', num); end
clear i index_freeze_walk kk num



%================ COLLECT SELF-SELECTED STOPS ==========================================================================
index_stop                  = [eventfile(ismember(eventfile.task,'Selected_stop'),["start"])];                  % Find those with Selected Stop only
index_stop_stop             = eventfile(ismember(eventfile.task,'Selected_stop'),["end"]);                      % Find those with Selected Stop only
index_stop                  = [index_stop.start];
index_stop_stop             = [index_stop_stop.end];
if isempty(index_stop) == 1; fprintf(2,"\n List of SELF-SELECTED STOPS is empty "); end
window                      = 1499;                                                                             % Choose 1500 samples (1.5s) after stop

kk = struct; 
for i = 1:size(index_stop,1)
    if isempty(i) == 1; continue
    else
        kk(i).start = index_stop(i,1); kk(i).stop = index_stop_stop(i,1);
        start = single(1000*kk(i).start); 
        stop = single((start + window));
        kk(i).duration = kk(i).stop - kk(i).start;
    end
end
if isempty(fieldnames(kk)) == 1; clear kk; else LFP_Events.(name).Self_Selected_Stop = kk; end                  % Store the files into a struct
clear kk start stop window 

%Plot Self-Selected Stops and search for the right heelstrikes should they be inconsistent
%Re-evaluate Stop times with the respective HS initiating the stop.
%If need to adjust the HS event, change the HS in %GaitEvents.(name).Heelstrike_Loc and in the sub-XX-ses-XX-gaitfilt.file
%Then Re-run subjectdata.events_filt and this section of script for all HS events to be updated.

if isfield(LFP_Events.(name), "Self_Selected_Stop") == 1
    figure
    idx = [(LFP_Events.(name).Self_Selected_Stop.start)];
    ax1 = subplot(2,1,1)
        plot(IMU_data.imutime, rad2deg(IMU_data.interp_gyroscope(1).Sensor(:,2)),'b-')    
        hold on
        plot(GaitEvents.rf_events.Heelstrike_Loc, GaitEvents.rf_events.Heelstrike_Peak, 'o', 'Color', 'r','MarkerFaceColor','r','MarkerEdgeColor','r')
        xline([LFP_Events.(name).Self_Selected_Stop.start], 'g', 'LineStyle','-', 'LineWidth', 1.5)
        xline([GaitEvents.rf_events.Heelstrike_Loc], 'k', 'LineStyle','--')
        title('RIGHT FOOT'); ylabel('Gyroscope'); xlabel('Time [s]')
        legend('Right Foot Gyroscope', 'Heelstrike', 'Stop')
    
    ax2 = subplot(2,1,2)
        plot(IMU_data.imutime, rad2deg(IMU_data.interp_gyroscope(2).Sensor(:,2)),'r-')    
        hold on
        plot(GaitEvents.lf_events.Heelstrike_Loc, GaitEvents.lf_events.Heelstrike_Peak, 'o', 'Color', 'b','MarkerFaceColor','b','MarkerEdgeColor','b')
        xline([GaitEvents.lf_events.Heelstrike_Loc], 'k', 'LineStyle','--')
        xline([LFP_Events.(name).Self_Selected_Stop.start], 'g', 'LineStyle','-', 'LineWidth', 1.5)
        legend('Left Foot Gyroscope', 'Heelstrike')
        title('LEFT FOOT'); ylabel('Gyroscope'); xlabel('Time [s]')
        linkaxes([ax1, ax2],'x')
        xlim([idx(1)-2.5 idx(1)+2.5]);
        clear ax1 ax2 dim g1 g2 idx str i 
end

%Determine the foot used to stop walking activity
if isfield(LFP_Events.(name), "Self_Selected_Stop") == 1
    for i = 1:length(index_stop)
        dist = abs(GaitEvents.rf_events.Heelstrike_Loc - index_stop(i));
        minIdx = (dist == min(dist));
        minVal_R = GaitEvents.rf_events.Heelstrike_Loc(minIdx);

        dist = abs(GaitEvents.lf_events.Heelstrike_Loc - index_stop(i));
        minIdx = (dist == min(dist));
        minVal_L = GaitEvents.lf_events.Heelstrike_Loc(minIdx);

        if ((index_stop(i) - minVal_R)^2) < ((index_stop(i) - minVal_L)^2); LFP_Events.(name).Self_Selected_Stop(i).Foot = {'Right'};
        elseif ((index_stop(i) - minVal_R)^2) > ((index_stop(i) - minVal_L)^2); LFP_Events.(name).Self_Selected_Stop(i).Foot = {'Left'}; end
    end
end
if isfield(LFP_Events.(name), 'Self_Selected_Stop') == 1; num = length(LFP_Events.(name).Self_Selected_Stop); fprintf('Number of Self-Selected-Stops is %d', num); end

%Clean Up
clear dist i index_stop index_stop_stop minDist minIdx minVal_L minVal_R num

% CLEAR ANY PRE-FOG HEELSTRIKES FROM THE WALKING DATASET ===============================================================

if isfield(LFP_Events.(name), 'Walking_Right_HS')
    site    = {'Walking_Right_HS'; 'Walking_Left_HS'};
    
    if isfield(LFP_Events.(name), 'Walking_Freeze')
        freeze_list = [LFP_Events.(name).Walking_Freeze.start];
        for n = 1:length(site)
            for p = 1:length(freeze_list)
                [minValue,closestIndex] = min(abs([LFP_Events.(name).(site{n}).start]-freeze_list(p))); %Determine if Freeze HS occurrs in walking dataset
                if minValue <= 1 && LFP_Events.(name).(site{n})(closestIndex).start - LFP_Events.(name).(site{n})(closestIndex-1).start < 2;  LFP_Events.(name).(site{n})(closestIndex-2:closestIndex) = [];
                elseif minValue >1 && minValue < 2; LFP_Events.(name).(site{n})(closestIndex-1:closestIndex) = []; 
                end           
            end
        end
    end
    
    if isfield(LFP_Events.(name), 'Self-Selected_Stop')
        stop_list = [LFP_Events.(name).Self_Selected_Stop.start];
        for n = 1:length(site)
            for p = 1:length(stop_list)
                [minValue,closestIndex] = min(abs([LFP_Events.(name).(site{n}).start]-stop_list(p))); %Determine if Stop HS occurrs in walking dataset
                if minValue <= 1 && LFP_Events.(name).(site{n})(closestIndex).start - LFP_Events.(name).(site{n})(closestIndex-1).start < 2;  LFP_Events.(name).(site{n})(closestIndex-2:closestIndex) = [];
                elseif minValue >= 1 && minValue < 2; LFP_Events.(name).(site{n})(closestIndex-1:closestIndex) = []; 
                end           
            end
        end
    end
end


%SAVE DATA
save([subjectdata.filepath filesep filename '-' 'dataevents.mat'], 'LFP_Events', '-mat')
% *********************** END OF SCRIPT ************************************************************************************************************************
