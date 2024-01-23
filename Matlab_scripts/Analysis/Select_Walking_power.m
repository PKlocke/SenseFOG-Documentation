%% =====  Select_Walking_power.m  ========================================%

%Date: December 2023
%Original author(s): Philipp Klocke, Moritz Loeffler

%This script will first call all the timepoints for walking activity that
%were specified and stored in the Sub_GrandActivity_Log.m file. We will
%first compute the morlet wavelet spectra for the LFP time series and
%segment the time-frequency spectra according to the prespecified time
%points. In a second step, we will use the standing baseline and normalize
%the power spectra yielding the mean %-change from standing. Third, we will
%resample all epochs and bring them up to the same data length.
%The current script will focus on data from the disease dominant STN.
%===========================================================================%


subjectdata.generalpath                 = uigetdir;                                                                 % Example: Call the SenseFOG-main file
cd(subjectdata.generalpath)
names                                   = cellstr(strsplit(sprintf('sub-%02d ',1:20)));                             % Create a list of sub-names

for i = 1:20
    if ~isfolder(names{i}) == 1                                                                                     % Check if general folder exists for sub-XX
        fprintf(2," \n Missing Folder for %s ", names{i}); continue
    elseif isfolder(names{i}) == 1
        fprintf("\n Existing Folder for %s ", names{i})
        full_filename = append(subjectdata.generalpath, filesep, names{i}, filesep, names{i}, "-dataevents.mat");            % Search for the dataevents.mat file in each subfile
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


%High Pass LFP Data ===================================================================================================
%Highpass LFP Data (1 Hz cutoff, Butterworth filter, filter order6, passed
%forward and backward) before applying continuous Morlet wavelet transformation
[b,a] = butter(6,1/(1000/2),'high');

task = {'Walk'; 'WalkWS'; 'WalkINT'; 'WalkINT_new'};
for k = 1:length(names)
    for m = 1:length(task)
          if isfield(Subjects.(names{k}), task(m)) == 0; continue; end
          Subjects.(names{k}).(task{m}).LFP_signal_R = filter(b,a, Subjects.(names{k}).(task{m}).LFP_signal_R);
          Subjects.(names{k}).(task{m}).LFP_signal_L = filter(b,a, Subjects.(names{k}).(task{m}).LFP_signal_L); 
    end
end

clear a b k m task Files


%Apply Morlet Wavelet Transformation ===================================================================================
%BE AWARE THIS WILL CONSUME A LOT OF SPACE AND TIME (full dataset of 12 subjects may take up to 20 minutes)
task    = {'Walk'; 'WalkWS'; 'WalkINT'; 'WalkINT_new'};
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

%Remove GaitCycles that are close to FOG ===================================================================================
task    = {'Walk'; 'WalkWS'; 'WalkINT'; 'WalkINT_new'};
site    = {'Walking_Right_HS'; 'Walking_Left_HS'};

for k = 1:length(names)
    for m = 1:length(task)
        if isfield(Subjects.(names{k}), task(m)) == 0; continue; end
        if isfield(Subjects.(names{k}).(task{m}),'Walking_Right_HS') == 0; continue; end
         for t = 1:length(site)
             datafile = Subjects.(names{k}).(task{m});
             if isfield(datafile, "Walking_Freeze")
                 freeze_idx = [datafile.Walking_Freeze.start];
                 for i = 1:length(freeze_idx)
                     new_idx = find([datafile.(site{t}).start] >= (freeze_idx(i)-3) &  [datafile.(site{t}).start] <= freeze_idx(i)); %Find timepoints up to 3 seconds before FOG
                     if ~isempty(new_idx)
                         datafile.(site{t})(new_idx) = [];
                     end
                 end
             else %do nothing
             end
             Subjects.(names{k}).(task{m}) = datafile;
             clear datafile
         end
    end
end

%Remove GaitCycles that are close to Stop
task    = { 'WalkWS'};
site    = {'Walking_Right_HS'; 'Walking_Left_HS'};

for k = 1:length(names)
    for m = 1:length(task)
        if isfield(Subjects.(names{k}), task(m)) == 0; continue; end
        if isfield(Subjects.(names{k}).(task{m}),'Walking_Right_HS') == 0; continue; end
         for t = 1:length(site)
             datafile = Subjects.(names{k}).(task{m});
             if isfield(datafile, "Self_Selected_Stop")
                 stop_idx = [datafile.Self_Selected_Stop.start];
                 for i = 1:length(stop_idx)
                     new_idx = find([datafile.(site{t}).start] >= (stop_idx(i)-3) &  [datafile.(site{t}).start] <= stop_idx(i)); %Find timepoints up to 3 seconds before FOG
                     if ~isempty(new_idx)
                         datafile.(site{t})(new_idx) = [];
                     end
                 end
             else %do nothing
             end
             Subjects.(names{k}).(task{m}) = datafile;
             clear datafile
         end
    end
end


%Segmenting Time-Frequency Matrix using pre-specified timepoints
%Next, extract all Heelstrike Events from the datasets and perform time- and frequency specific analyses ===============
%For each heelstrike, take out the data post Morlet wavelet transformation
task    = {'Walk'; 'WalkWS'; 'WalkINT'; 'WalkINT_new'};
site    = {'Walking_Right_HS'; 'Walking_Left_HS'};
IMU     = {'Accelerometer_RF', 'Gyroscope_RF'; 'Accelerometer_LF', 'Gyroscope_LF'};
LFP     = {'LFP_signal_L'; 'LFP_signal_R'};
input   = {'L_wt'  'LFP_signal_L'; 'R_wt' 'LFP_signal_R'};

for k = 1:length(names)
    for m = 1:length(task)
        if isfield(Subjects.(names{k}), task(m)) == 0; continue; end
        if isfield(Subjects.(names{k}).(task{m}),'Walking_Right_HS') == 0; continue; end
         for n = 1:length(site)
            for i = 1:length(Subjects.(names{k}).(task{m}).(site{n}))
                start                                                        = single(1000*Subjects.(names{k}).(task{m}).(site{n})(i).start);   % HS start
                stop                                                         = single(1000*Subjects.(names{k}).(task{m}).(site{n})(i).end);     % HS end
                
                %Assign exact gait parameters to this heelstrike
                if n == 1; 
                    [idx, loc] = ismembertol([Subjects.(names{k}).(task{m}).rf_events.Heelstrike_Loc],Subjects.(names{k}).(task{m}).(site{n})(i).end);
                    Subjects.(names{k}).(task{m}).(site{n})(i).Midswing_Loc     = Subjects.(names{k}).(task{m}).rf_events(idx,:).Midswing_Loc; 
                    Subjects.(names{k}).(task{m}).(site{n})(i).Midswing_Peak    = Subjects.(names{k}).(task{m}).rf_events(idx,:).Midswing_Peak; 
                    Subjects.(names{k}).(task{m}).(site{n})(i).Toe_Off_Loc      = Subjects.(names{k}).(task{m}).rf_events(idx,:).Toe_Off_Loc; 
                    if Subjects.(names{k}).(task{m}).(site{n})(i).Toe_Off_Loc > Subjects.(names{k}).(task{m}).(site{n})(i).Midswing_Loc;  Subjects.(names{k}).(task{m}).(site{n})(i).Midswing_Loc = []; Subjects.(names{k}).(task{m}).(site{n})(i).Toe_Off_Loc = []; end;  
                elseif n == 2; 
                    [idx, loc] = ismembertol([Subjects.(names{k}).(task{m}).lf_events.Heelstrike_Loc],Subjects.(names{k}).(task{m}).(site{n})(i).end);
                    Subjects.(names{k}).(task{m}).(site{n})(i).Midswing_Loc     = Subjects.(names{k}).(task{m}).lf_events(idx,:).Midswing_Loc; 
                    Subjects.(names{k}).(task{m}).(site{n})(i).Midswing_Peak    = Subjects.(names{k}).(task{m}).lf_events(idx,:).Midswing_Peak; 
                    Subjects.(names{k}).(task{m}).(site{n})(i).Toe_Off_Loc      = Subjects.(names{k}).(task{m}).lf_events(idx,:).Toe_Off_Loc; 
                    if Subjects.(names{k}).(task{m}).(site{n})(i).Toe_Off_Loc > Subjects.(names{k}).(task{m}).(site{n})(i).Midswing_Loc;  Subjects.(names{k}).(task{m}).(site{n})(i).Midswing_Loc = []; Subjects.(names{k}).(task{m}).(site{n})(i).Toe_Off_Loc = []; end;  
                end


                %Extract IMU Foot Information 
                Subjects.(names{k}).(task{m}).(site{n})(i).IMU_acc_rs        = Subjects.(names{k}).(task{m}).(IMU{n,1})([start:stop],3)'; 
                Subjects.(names{k}).(task{m}).(site{n})(i).IMU_gyr_rs        = rad2deg(Subjects.(names{k}).(task{m}).(IMU{n,2})([start:stop],2))'; 
                
                %%=== Extracting Frequency Domain + NORMALIZE =============================================== 
                %[MORLET WAVELET TRANSFORMATION]
                store       = (Subjects.(names{k}).(task{m}).(input{n,1})(:,[start:stop]));                         % Store the wt data in a matrix
                
                %*** EXCLUDE LOW FREQUENCY NOISE ***
                %Excluding low frequencies (up to 10 Hz) and other frequencies with possible technical artifact contamination related to the sensing equipment (33–37 Hz, 48–52 Hz, 90+ Hz)
                FD          = mean(store,2); 
                sum_FD      = sum(FD([10:33, 37:48, 52:90],:));                                                     % Normalize frequency domain to yield relative pwoer    
                Subjects.(names{k}).(task{m}).(site{n})(i).frequency_domain = (FD ./ sum_FD)';
                                  
               
                %TIME DOMAIN Data (Normalization will occur after resampling)
                Subjects.(names{k}).(task{m}).(site{n})(i).wt                 = Subjects.(names{k}).(task{m}).(input{n,1})(:, [start:stop]); %FOOT HS But contralateral STN
                              
                %Extract Sitting Power
                if isfield(Subjects.(names{k}),'Sitting_Power') == 1
                    if      n == 1; baseline = Subjects.(names{k}).Sitting_Power.baseline_pwr_L;
                    elseif  n == 2; baseline = Subjects.(names{k}).Sitting_Power.baseline_pwr_R; end
                    sum_FD  = sum(baseline([10:33, 37:48, 52:90],:));
                    Subjects.(names{k}).(task{m}).(site{n})(i).sitting = (baseline ./ sum_FD)';                        % Normalize baseline to yield relative power
                    clear baseline
                elseif ~isfield(Subjects.(names{k}),'Sitting_Power') == 1
                    Subjects.(names{k}).(task{m}).(site{n})(i).sitting = [];
                end

                   
                %Resample HS to same length (1000 datapoints)
                for t = 1:height(Subjects.(names{k}).(task{m}).(site{n})(i).wt)
                    pp = [flip(Subjects.(names{k}).(task{m}).(site{n})(i).wt(t,:)) Subjects.(names{k}).(task{m}).(site{n})(i).wt(t,:) flip(Subjects.(names{k}).(task{m}).(site{n})(i).wt(t,:))]; 
                    qq = resample(pp,3000,length(pp));
                    Subjects.(names{k}).(task{m}).(site{n})(i).wt_rs(t,:) = qq(:,1001:2000);
                end
                Subjects.(names{k}).(task{m}).(site{n}) = rmfield( Subjects.(names{k}).(task{m}).(site{n}),'wt');
                Subjects.(names{k}).(task{m}).(site{n})(i).wt_org =  Subjects.(names{k}).(task{m}).(site{n})(i).wt_rs;
            end
         end
    end
end

%Clean-UP
clear ans FD i k m n pp qq start stop store sum_FD t 

for k = 1:length(names)
    for m = 1:length(task)
        if isfield(Subjects.(names{k}), task(m)) == 0; continue; end
        if isfield(Subjects.(names{k}).(task{m}),'Walking_Right_HS') == 0; continue; end 
         for n = 1:length(site)
              for i = 1:length(Subjects.(names{k}).(task{m}).(site{n}))
                           
                %NORMALIZING TIME DOMAIN using the standing frequency domain
                Option = "Percental_Normalization";
                
                %Standing Baseline
                if n == 1; baseline = Subjects.(names{k}).Baseline_Power.baseline_pwr_L;
                elseif n == 2; baseline = Subjects.(names{k}).Baseline_Power.baseline_pwr_R; end
                Subjects.(names{k}).(task{m}).(site{n})(i).wt_rs = ((Subjects.(names{k}).(task{m}).(site{n})(i).wt_org - baseline) ./ baseline) *100;
                
                sum_FD      = sum(baseline([10:33, 37:48, 52:90],:));
                Subjects.(names{k}).(task{m}).(site{n})(i).baseline = (baseline ./ sum_FD)';                        % Normalize baseline to yield relative power
                clear baseline

                Subjects.(names{k}).(task{m}).(site{n})(i).name = names(k);
                Subjects.(names{k}).(task{m}).(site{n})(i).task = task(m);

                bands = {'IMU_acc_rs', 'IMU_gyr_rs'};
                for t = 1:length(bands)
                    pp = [flip(Subjects.(names{k}).(task{m}).(site{n})(i).(bands{t})) Subjects.(names{k}).(task{m}).(site{n})(i).(bands{t}) flip(Subjects.(names{k}).(task{m}).(site{n})(i).(bands{t}))]; 
                    qq = resample(pp,3000,length(pp));
                    Subjects.(names{k}).(task{m}).(site{n})(i).(bands{t}) = qq(:,1001:2000);
                end
              end
         end
    end
end

%Clean-UP
clear ans bands i input k LFP m n pp qq site t IMU sum_FD

%Store all data according to disease laterality (based on MDS-UPDRS III scores)
Walking_Files           = struct;
Walking_Files.f         = Subjects.(names{1}).(task{1}).f;
Walking_Files.Option    = Option;
Walking_Files.names     = names; 

task            = {'Walk', 'WalkWS', 'WalkINT', 'WalkINT_new'};
fieldnames      = {'Walking_Right_HS', 'Walking_Left_HS'};

for i = 1:length(fieldnames); Walking_Files.(fieldnames{i}) = struct; end                                           %Final struct array where all DOMINANT STN files will be stored

for i = 1:length(names)
    if isfield(Subjects,names(i)) == 0; continue; end                                                               %Check if fields exist, otherwise skip i for 1 itr.
    datafile    = Subjects.(names{i});
    for k = 1:length(task)
        if isfield(datafile, task{k}) == 0; continue; end                                                           %Check if fields exist, otherwise skip k for 1 itr.
        datafield = getfield(datafile, task{k});
        if isfield(datafield, fieldnames(1)) == 0; continue; end

        %Check for STN Dominance
        if      datafile.Baseline_Power.STN_dominance == "Left"; m = 1; z = 2; 
        elseif  datafile.Baseline_Power.STN_dominance == "Right"; m = 2; z = 1; 
        end

        store = getfield(datafield, fieldnames{m});

        if size(Walking_Files.(fieldnames{m}),2) == 1 && exist('store') == 1
               Walking_Files.(fieldnames{m}) = store; clear store
        elseif size(Walking_Files.(fieldnames{m}),2) > 1 && exist('store') == 1 
               Walking_Files.(fieldnames{m}) = [Walking_Files.(fieldnames{m}), store]; clear store
        end
    end
end
clear i k z m fs ans datafield datafile Option

%Store Gait Data for non-disease dominant leg
fieldnames      = {'Walking_Right_HS', 'Walking_Left_HS'};
GaitData_Walk = struct; GaitData_Walk.dominant = []; GaitData_Walk.nondominant = [];

for i = 1:length(names)
    if isfield(Subjects,names(i)) == 0; continue; end                                                               %Check if fields exist, otherwise skip i for 1 itr.
    datafile    = Subjects.(names{i});
    for k = 1:length(task)
        if isfield(datafile, task{k}) == 0; continue; end                                                           %Check if fields exist, otherwise skip k for 1 itr.
        datafield = getfield(datafile, task{k});
        if isfield(datafield, fieldnames(1)) == 0; continue; end

        %Check for STN Dominance
        if      datafile.Baseline_Power.STN_dominance == "Left"; m = 1; z = 2; 
        elseif  datafile.Baseline_Power.STN_dominance == "Right"; m = 2; z = 1; 
        end
        store = getfield(datafield, fieldnames{m});
        store = rmfield(store,{ 'IMU_acc_rs'; 'IMU_gyr_rs'; 'frequency_domain'; 'sitting'; 'wt_rs'; 'wt_org'; 'baseline'});
        GaitData_Walk.dominant = cat(2,store, GaitData_Walk.dominant);

        store = getfield(datafield, fieldnames{z});
        store = rmfield(store,{ 'IMU_acc_rs'; 'IMU_gyr_rs'; 'frequency_domain'; 'sitting'; 'wt_rs'; 'wt_org'; 'baseline'});
        GaitData_Walk.nondominant = cat(2,store, GaitData_Walk.nondominant);
        clear datafield
    end
    clear datafile
end
clear fieldnames i idx k loc m store z site

%Compute relative gait cycle timepoints
site = {'dominant'; 'nondominant'};
for t = 1:length(site)
    for i = 1:length(GaitData_Walk.(site{t}))
        %Relative Midswing (relative to its gait cycle)
        if isempty(GaitData_Walk.(site{t})(i).Midswing_Loc) == 0 && size(GaitData_Walk.(site{t})(i).Midswing_Loc,1) == 1 
        temp_store                          = (GaitData_Walk.(site{t})(i).end - GaitData_Walk.(site{t})(i).Midswing_Loc);
        GaitData_Walk.(site{t})(i).Midswing = (1-(temp_store / GaitData_Walk.(site{t})(i).diff))*100;

        %Relative Toe-OFF (relative to its gait cycle)
        temp_store                          = (GaitData_Walk.(site{t})(i).end - GaitData_Walk.(site{t})(i).Toe_Off_Loc);
        GaitData_Walk.(site{t})(i).Toe_Off  = (1-(temp_store / GaitData_Walk.(site{t})(i).diff))*100;
        end
    end
    idx = find(cellfun(@isempty,{GaitData_Walk.(site{t}).Midswing}));
    GaitData_Walk.(site{t})(idx) = []; clear idx 
end
clear t site i temp_store task


%SAVE DATA
save([subjectdata.generalpath filesep 'Time-Frequency-Data' filesep 'Walking_Files.mat'], 'Walking_Files', '-mat')
save([subjectdata.generalpath filesep 'Kinematic-Data' filesep 'Walking_Files.mat'], 'GaitData_Walk', '-mat')
% *********************** END OF SCRIPT ************************************************************************************************************************
