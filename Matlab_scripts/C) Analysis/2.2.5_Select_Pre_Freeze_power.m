%% =====  Select_Pre_Freeze_power.m  ========================================%

%Date: December 2023
%Original author(s): Philipp Klocke, Moritz Loeffler

%This script will first call all the timepoints for FOG events that
%were specified and stored in the Sub_GrandActivity_Log.m file. We will
%first compute the morlet wavelet spectra for the LFP time series and
%segment the time-frequency spectra according to gait cycles found before freeze onset.
%Then, we will use the standing baseline and normalize
%the power spectra yielding the mean %-change from standing.
%The current script will focus on data from the disease dominant STN.
%===========================================================================%

subjectdata.generalpath                 = uigetdir;                                                                 % Example: Call the SenseFOG-main file
cd(subjectdata.generalpath)
%Create a list of 20 place-holder names and find names that match with subjects in our SenseFOG main file   
names                                   = cellstr(strsplit(sprintf('sub-%02d ',1:20)));                             % Create a list of sub-names

for i = 1:20
    if ~isfolder(names{i}) == 1                                                                                     % Check if general folder exists for sub-XX
        fprintf(2," \n Missing Folder for %s ", names{i}); continue
    elseif isfolder(names{i}) == 1
        fprintf("\n Existing Folder for %s ", names{i})
        full_filename = append(subjectdata.generalpath, filesep, names{i},filesep, names{i}, "-dataevents.mat");            % Search for the dataevents.mat file in each subfile
        if isfile(full_filename); 
            Files(i).File = load(full_filename);             
            Files(i).name = sprintf('sub_%02d',i);
        elseif ~isfile(full_filename); fprintf(2," \n Missing Dataevents File for %s ", names{i}); continue
        end
    end
end
clear i full_filename

%Clear Files that have no content
idx     = find(cellfun(@isempty,{Files.File})); Files(idx) = []; clear idx
names   = {Files.name}';                                                                                             % Create a new names list

Subjects = struct; 
for i = 1:length(Files)
    Subjects.(names{i}) = Files(i).File.LFP_Events;
end


%Update September 2023 - Remove Subject 15 WalkINT as data are compromised by artefacts
Subjects.sub_15 = rmfield(Subjects.sub_15, "WalkINT");

%August 2023: Remove subjects known not to have FOG (walk)
Subjects = rmfield(Subjects, {'sub_01','sub_05','sub_09','sub_11','sub_13','sub_18','sub_19'});
names    = fieldnames(Subjects);


%High Pass LFP Data ===================================================================================================
%Highpass LFP Data (1 Hz cutoff, Butterworth filter, filter order6, passed
%forward and backward) before applying continuous Morlet wavelet transformation
[b,a] = butter(6,1/(1000/2),'high');

task = {'Walk','WalkWS','WalkINT','WalkINT_new'};
for k = 1:length(names)
    for m = 1:length(task)
          if isfield(Subjects.(names{k}), task(m)) == 0; continue; end
          Subjects.(names{k}).(task{m}).LFP_signal_R = filter(b,a, Subjects.(names{k}).(task{m}).LFP_signal_R);
          Subjects.(names{k}).(task{m}).LFP_signal_L = filter(b,a, Subjects.(names{k}).(task{m}).LFP_signal_L); 
    end
end

clear a b k m task Files


%Apply Morlet Wavelet Transformation ===================================================================================
task = {'Walk','WalkWS','WalkINT','WalkINT_new'};
fs      = 1000; %Sampling Frequency
for k = 1:length(names)
    for m = 1:length(task)
        if isfield(Subjects.(names{k}), task(m)) == 0; continue; end
       
        %Left FOOT ===
        MFF = 4*pi/(6+sqrt(2+6^2));                                                                                 % Morlet-Fourier-Factor
        R_cwtstruct          = cwtft({Subjects.(names{k}).(task{m}).LFP_signal_R,1/fs},'wavelet', 'morl','scales',1./([1:1:100]*MFF)); 
        Subjects.(names{k}).(task{m}).R_wt                 = abs(R_cwtstruct.cfs);
        Subjects.(names{k}).(task{m}).f                    = R_cwtstruct.frequencies;

        %Right FOOT ===
        MFF = 4*pi/(6+sqrt(2+6^2));                                                                                 % Morlet-Fourier-Factor
        L_cwtstruct          = cwtft({Subjects.(names{k}).(task{m}).LFP_signal_L,1/fs},'wavelet', 'morl','scales',1./([1:1:100]*MFF)); 
        Subjects.(names{k}).(task{m}).L_wt                 = abs(L_cwtstruct.cfs);
        Subjects.(names{k}).(task{m}).f                    = L_cwtstruct.frequencies;
    end
end
clear MFF R_cwtstruct L_cwtstruct k m task


%Find Right- and Left Foot Heelstrikes for each Freezing Activity
task    = {'Walk'; 'WalkWS'; 'WalkINT'; 'WalkINT_new'};
field   = {'Walking_Freeze'};
Pre_FOG = struct; 

for k = 1:length(names)
    for m = 1:length(task)
        if  isfield(Subjects.(names{k}), task(m)) == 0; continue; end
            if isfield(Subjects.(names{k}).(task{m}), field) == 0; continue; end
            
            datafile = Subjects.(names{k}).(task{m}).(field{1});
                for i = 1:length(datafile)

                    freeze_start    = datafile(i).start;
                    %RF_events       = sort(Subjects.(names{k}).(task{m}).rf_events.Heelstrike_Loc);                 % Sort in ascending order
                    %RF_events       = RF_events(RF_events <= freeze_start);                                         % Only choose events that occur at or before stop
                    %LF_events       = sort(Subjects.(names{k}).(task{m}).lf_events.Heelstrike_Loc);                 % Sort in ascending order
                    %LF_events       = LF_events(LF_events <= freeze_start);                                         % Only choose events that occur at or before stop
                    RF_events       = sortrows(Subjects.(names{k}).(task{m}).rf_events, "Heelstrike_Loc");
                    RF_events       = RF_events(RF_events.Heelstrike_Loc <= freeze_start,:);                            
                    LF_events       = sortrows(Subjects.(names{k}).(task{m}).lf_events, "Heelstrike_Loc");
                    LF_events       = LF_events(LF_events.Heelstrike_Loc <= freeze_start,:);                            
                    DD_STN          = Subjects.(names{k}).Baseline_Power.STN_dominance;                             % Choose disease dominant STN
         
                    %Use the foot that corresponds to the disease dominant STN
                    if Subjects.(names{k}).Baseline_Power.STN_dominance == "Right"; foot = "Left";
                    
                        %Find Left Foot Heelstrikes occurring before freeze onset
                        %[minDis,idxGC3] = min(abs(LF_events-freeze_start));
                        [minDis,idxGC3] = min( abs(LF_events.Heelstrike_Loc-freeze_start));
                        if iscell(LF_events.Midswing_Loc);  LF_events.Midswing_Loc = cell2mat(cell2num({LF_events.Midswing_Loc}));end
                        if iscell(LF_events.Midswing_Peak);  LF_events.Midswing_Peak = cell2mat(cell2num({LF_events.Midswing_Peak}));end 
                        if iscell(LF_events.Toe_Off_Peak);  LF_events.Toe_Off_Peak = cell2mat(cell2num({LF_events.Toe_Off_Peak}));end
                        if iscell(LF_events.Heelstrike_Peak); LF_events.Heelstrike_Peak = cell2mat(cell2num({LF_events.Heelstrike_Peak}));end
                        if istable(LF_events); LF_events = table2array(LF_events); end
                        if istable(RF_events); RF_events = table2array(RF_events); end
                       
                        %GC1
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).start             = LF_events(idxGC3-1,5);          % Choose the HS Loc before FOG onset
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).end               = LF_events(idxGC3,5);            % Start with FOG Onset
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).duration          = LF_events(idxGC3,5) -LF_events(idxGC3-1,5); %Compute Difference
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).Midswing_Loc      = LF_events(idxGC3,1);
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).Midswing_Peak     = LF_events(idxGC3,2);
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).Toe_Off_Loc       = LF_events(idxGC3,3);
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).foot              = "Left";  
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).DD_STN            = DD_STN;
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).distance_FoG      = Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).duration + minDis;  
                        
                        %GC2
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).start             = LF_events(idxGC3-2,5);          % Choose the HS that occurs before the end
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).end               = LF_events(idxGC3-1,5);          % Choose one HS Loc before FOG onset
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).duration          = LF_events(idxGC3-1,5) -LF_events(idxGC3-2,5); %Compute Difference
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).Midswing_Loc      = LF_events(idxGC3-1,1);
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).Midswing_Peak     = LF_events(idxGC3-1,2);
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).Toe_Off_Loc       = LF_events(idxGC3-1,3);
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).foot              = "Left";  
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).DD_STN            = DD_STN;
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).distance_FoG      = Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).distance_FoG + Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).duration;
           
                        %GC3
                        if idxGC3 > 3
                            Pre_FOG.(names{k}).(task{m})(i).Pre_GC(3).start         = LF_events(idxGC3-3,5);          % Choose the HS that occurs before the end
                            Pre_FOG.(names{k}).(task{m})(i).Pre_GC(3).end           = LF_events(idxGC3-2,5);          % Choose two HS Loc before FOG onset
                            Pre_FOG.(names{k}).(task{m})(i).Pre_GC(3).duration      = LF_events(idxGC3-2,5) -LF_events(idxGC3-3,5); %Compute Difference
                            Pre_FOG.(names{k}).(task{m})(i).Pre_GC(3).Midswing_Loc  = LF_events(idxGC3-2,1);
                            Pre_FOG.(names{k}).(task{m})(i).Pre_GC(3).Midswing_Peak = LF_events(idxGC3-2,2);
                            Pre_FOG.(names{k}).(task{m})(i).Pre_GC(3).Toe_Off_Loc   = LF_events(idxGC3-2,3);
                            Pre_FOG.(names{k}).(task{m})(i).Pre_GC(3).foot          = "Left";
                            Pre_FOG.(names{k}).(task{m})(i).Pre_GC(3).DD_STN        = DD_STN;
                            Pre_FOG.(names{k}).(task{m})(i).Pre_GC(3).distance_FoG  = Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).distance_FoG + Pre_FOG.(names{k}).(task{m})(i).Pre_GC(3).duration;
                        end
                        clear foot 

                  
                    elseif Subjects.(names{k}).Baseline_Power.STN_dominance == "Left"; foot = "Right";
                        
                       %Find Right Foot Heelstrikes occurring before freezeonset
                        %[minDis,idxGC3] = min( abs( RF_events-freeze_start));
                        [minDis,idxGC3] = min( abs(RF_events.Heelstrike_Loc-freeze_start));
                        if iscell(RF_events.Midswing_Loc);  RF_events.Midswing_Loc = cell2mat(cell2num({RF_events.Midswing_Loc}));end
                        if iscell(RF_events.Midswing_Peak);  RF_events.Midswing_Peak = cell2mat(cell2num({RF_events.Midswing_Peak}));end
                        if iscell(RF_events.Toe_Off_Peak);  RF_events.Toe_Off_Peak = cell2mat(cell2num({RF_events.Toe_Off_Peak}));end
                        if iscell(RF_events.Heelstrike_Peak); RF_events.Heelstrike_Peak = cell2mat(cell2num({RF_events.Heelstrike_Peak})); end
                        if istable(LF_events); LF_events = table2array(LF_events); end
                        if istable(RF_events); RF_events = table2array(RF_events); end

                       
                        %GC3
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).start             = RF_events(idxGC3-1,5);          % Choose the HS Loc before FOG onset
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).end               = RF_events(idxGC3,5);            % Start with FOG Onset
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).duration          = RF_events(idxGC3,5) - RF_events(idxGC3-1,5); %Compute Difference
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).Midswing_Loc      = RF_events(idxGC3,1);
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).Midswing_Peak     = RF_events(idxGC3,2);
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).Toe_Off_Loc       = RF_events(idxGC3,3);
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).foot              = "Right";
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).DD_STN            = DD_STN;
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).distance_FoG      = Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).duration + minDis;  
                                              
                        %GC2
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).start             = RF_events(idxGC3-2,5);          % Choose the HS that occurs before the end
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).end               = RF_events(idxGC3-1,5);          % Choose one HS Loc before FOG onset
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).duration          = RF_events(idxGC3-1,5) - RF_events(idxGC3-2,5); %Compute Difference
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).Midswing_Loc      = RF_events(idxGC3-1,1);
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).Midswing_Peak     = RF_events(idxGC3-1,2);
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).Toe_Off_Loc       = RF_events(idxGC3-1,3);
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).foot              = "Right";  
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).DD_STN            = DD_STN;
                        Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).distance_FoG      = Pre_FOG.(names{k}).(task{m})(i).Pre_GC(1).distance_FoG + Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).duration;
                                             
                        %GC3
                        if idxGC3 > 3
                            Pre_FOG.(names{k}).(task{m})(i).Pre_GC(3).start         = RF_events(idxGC3-3,5);          % Choose the HS that occurs before the end
                            Pre_FOG.(names{k}).(task{m})(i).Pre_GC(3).end           = RF_events(idxGC3-2,5);          % Choose two HS Loc before FOG onset
                            Pre_FOG.(names{k}).(task{m})(i).Pre_GC(3).duration      = RF_events(idxGC3-2,5) - RF_events(idxGC3-3,5); %Compute Difference
                            Pre_FOG.(names{k}).(task{m})(i).Pre_GC(3).Midswing_Loc  = RF_events(idxGC3-2,1);
                            Pre_FOG.(names{k}).(task{m})(i).Pre_GC(3).Midswing_Peak = RF_events(idxGC3-2,2);
                            Pre_FOG.(names{k}).(task{m})(i).Pre_GC(3).Toe_Off_Loc   = RF_events(idxGC3-2,3);
                            Pre_FOG.(names{k}).(task{m})(i).Pre_GC(3).foot          = "Right";
                            Pre_FOG.(names{k}).(task{m})(i).Pre_GC(3).DD_STN        = DD_STN;
                            Pre_FOG.(names{k}).(task{m})(i).Pre_GC(3).distance_FoG  = Pre_FOG.(names{k}).(task{m})(i).Pre_GC(2).distance_FoG + Pre_FOG.(names{k}).(task{m})(i).Pre_GC(3).duration;
                        end
           
                        clear foot

                    else foot = "Error";
                    end   

                    clear LF_events RF_events freeze_start  idxGC3 DD_STN
                end
    end
end


%Check if any gait cycle durations are "off-limit"
for k = 1:length(names)
    for m = 1:length(task)
        if  isfield(Pre_FOG.(names{k}), task(m)) == 0; continue; end
            for i = 1:length(Pre_FOG.(names{k}).(task{m}))
                index_del = [];
                for t = 1:length(Pre_FOG.(names{k}).(task{m})(i).Pre_GC)
                    if Pre_FOG.(names{k}).(task{m})(i).Pre_GC(t).duration > 2.5                                     % If Gaitcycle lasts >2.5s, delete
                        index_del(length(index_del)+1,1) = t; 
                    end
                end
                Pre_FOG.(names{k}).(task{m})(i).Pre_GC(index_del:end) = [];
                index_del = [];
                for t = 1:length(Pre_FOG.(names{k}).(task{m})(i).Pre_GC)
                   if Pre_FOG.(names{k}).(task{m})(i).Pre_GC(t).distance_FoG > 3                                    % If GaitCycle is >3s away from FOG, delete
                        index_del(length(index_del)+1,1) = t;
                    end
                end
                Pre_FOG.(names{k}).(task{m})(i).Pre_GC(index_del:end) = [];
            end
            idx     = find(cellfun(@isempty,{Pre_FOG.(names{k}).(task{m}).Pre_GC}));
            Pre_FOG.(names{k}).(task{m})(idx) = []; clear idx
    end
end

clear i index_del k m t index minDis datafile


%Extract Time Frequency Data
pre_names   = fieldnames(Pre_FOG);

for k = 1:length(pre_names)
    for m = 1:length(task)
        if isfield(Pre_FOG.(pre_names{k}),task(m)) == 0; continue; end

        for i = 1:length(Pre_FOG.(pre_names{k}).(task{m}))
            for t = 1:length(Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC)

                if Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(1).foot == "Right"
                    IMU_file            = rad2deg(Subjects.(pre_names{k}).(task{m}).Gyroscope_RF(:,2))';
                    LFP_file            = Subjects.(pre_names{k}).(task{m}).L_wt;       
                    baseline_standing   = Subjects.(pre_names{k}).Baseline_Power.baseline_pwr_L;                    % Find corresponding Standing Baseline
                elseif Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(1).foot == "Left"
                    IMU_file            = rad2deg(Subjects.(pre_names{k}).(task{m}).Gyroscope_LF(:,2))';
                    LFP_file = Subjects.(pre_names{k}).(task{m}).R_wt;                  
                    baseline_standing   = Subjects.(pre_names{k}).Baseline_Power.baseline_pwr_R;                    % Find corresponding Standing Baseline
                end


            xstart  = single(Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).start * fs);
            xend    = single(Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).end * fs);
             
            %Basline Standing [unfiltered, filtered]
            Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).baseline_stand_org = baseline_standing';
            sumFD       = sum(Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).baseline_stand_org(:,[10:33, 37:48, 52:90])); 
            Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).baseline_pwr_stand = baseline_standing ./ sumFD;

            %Frequency Domain [unfiltered]
            Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).frequency_org = mean(LFP_file(:, [xstart:xend]),2)';

            %Frequency Domain [filtered] - %excluding low frequencies (up to 10 Hz) and other frequencies with possible technical artifact contamination related to the sensing equipment (33–37 Hz, 48–52 Hz, 90+ Hz)
            sum_FD      = sum(Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).frequency_org(:,[10:33, 37:48, 52:90])); 
            Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).frequency_domain = (Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).frequency_org ./ sum_FD);
         
            %Time-Frequency Domain [original]
            Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).wt_org = LFP_file(:, [xstart:xend]);

            %IMU-SIGNAL [original]
            Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).IMU_signal = IMU_file(:, [xstart:xend]);

            %Resample IMU_data to same length (e.g. 1000 datapoints)
            pp = [flip(Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).IMU_signal) Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).IMU_signal flip(Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).IMU_signal)]; 
            qq = resample(pp,3000,length(pp));
            Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).IMU_signal = qq(:,1001:2000);
      

            %Resample TF-Data to same length (e.g. 1000 datapoints)
            for h = 1:height(Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).wt_org)
                   pp = [flip(Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).wt_org(h,:)) Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).wt_org(h,:) flip(Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).wt_org(h,:))]; 
                   qq = resample(pp,3000,length(pp));
                   Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).wt_rs(h,:) = qq(:,1001:2000);
            end

            %Time-Frequency Domain [Standing Baseline subtracted]
            Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).wt_standing = ((Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).wt_rs - baseline_standing) ./ baseline_standing) * 100;

            %Compute relative timepoints for gait cycle
            store = Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).end - Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).Midswing_Loc;
            Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).Midswing = (1-(store / Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).duration))*100;

            store = Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).end - Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).Toe_Off_Loc;
            Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).Toe_Off = (1-(store / Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC(t).duration))*100;
            end

            clear h i input LFP_file  p pp qq t xend xstart sum_FD sumFD baseline_standing  
        end
    end
end

clear k m q A ans index minDis task IMU_file


% Average over all gaitcycles within a given pre-freeze event
task        = {'Walk'; 'WalkWS'; 'WalkINT'; 'WalkINT_new'};
field       = {'Walking_Freeze'};
labels      = {'wt_rs'; 'wt_standing'; 'IMU_signal'; 'duration'};
imu_label   = {'Midswing'; 'Toe_Off';'Midswing_Peak'}; 
All_FOGs    = [];

pre_names = fieldnames(Pre_FOG);

for k = 1:length(pre_names)
    for m = 1:length(task)
         if isfield(Pre_FOG.(pre_names{k}),task(m)) == 0; continue; end
    
        %Average for each Freezing Episode
        for i = 1:length(Pre_FOG.(pre_names{k}).(task{m}))
            for q = 1:length(labels)
                A = cat(3, Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC.(labels{q}));
                Pre_FOG.(pre_names{k}).(task{m})(i).(labels{q}) = mean(A,3);
            end

            for q = 1:length(imu_label)
                if isfield(Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC, imu_label(q)) == 0; continue; end
                A = cat(2,Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC.(imu_label{q}));
                Pre_FOG.(pre_names{k}).(task{m})(i).(imu_label{q}) = mean(A,2);
            end

            Pre_FOG.(pre_names{k}).(task{m})(i).frequency_domain    = mean(cell2mat({Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC.frequency_domain}'),1,"omitnan");
            Pre_FOG.(pre_names{k}).(task{m})(i).baseline_stand_org  = mean(cell2mat({Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC.baseline_stand_org}'),1,"omitnan");            
            Pre_FOG.(pre_names{k}).(task{m})(i).baseline_stand      = mean(cell2mat({Pre_FOG.(pre_names{k}).(task{m})(i).Pre_GC.baseline_pwr_stand}),2,"omitnan")';
            Pre_FOG.(pre_names{k}).(task{m})(i).name                = (pre_names{k});
        end 
    end
     
    for t = 1:length(task)
        if isfield(Pre_FOG.(pre_names{k}), task(t))
            All_FOGs =   cat(2,All_FOGs, Pre_FOG.(pre_names{k}).(task{t})); 
        end
    end
end

clear A 

Pre_Freezing_Files.frequencies         = Subjects.(names{1}).(task{1}).f;
Pre_Freezing_Files.Pre_Fogs            = All_FOGs;
Pre_Freezing_Files.Pre_Fogs            = rmfield(Pre_Freezing_Files.Pre_Fogs,'Pre_GC'); 
Pre_Freezing_Files.Pre_fog_count       = size(cell2mat({All_FOGs.Pre_GC}),2);

GaitData_Pre_Fog                       = Pre_Freezing_Files.Pre_Fogs; 
GaitData_Pre_Fog                       = rmfield(GaitData_Pre_Fog, {'wt_rs'; 'wt_standing'; 'IMU_signal'; 'frequency_domain'; 'baseline_stand_org'; 'baseline_stand'});

clear lables idx idx_del imu_label store t  index_del k m nfrq q time field A i  c  C baseline_standing condition_labels datafile labels task num_freq num_time store_file store_temp pre_names 

%SAVE DATA
save([subjectdata.generalpath filesep 'Time-Frequency-Data' filesep 'Pre_Freezing_Files.mat'], 'Pre_Freezing_Files', '-mat')
save([subjectdata.generalpath filesep 'Kinematic-Data' filesep 'Pre_Freezing_Files.mat'], 'GaitData_Pre_Fog', '-mat')

% *********************** END OF SCRIPT ************************************************************************************************************************
