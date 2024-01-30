%% =====  STN_EMG_Coherence_Freeze.m  ========================================%

%Date: December 2023
%Original author(s): Philipp Klocke, Moritz Loeffler

%This script will first call all the timepoints for freezing episodes that
%were specified and stored in the Sub_GrandActivity_Log.m file. We will
%first insert both EMG and LFP timeseries into fieldtrip and compute the
%wavelet coherence between both signals. Second, we will use the standing
%coherence as our baseline and normalize coherence spectra. Coherence
%spectra will be computed for the tibialis anterior (TA) and gastrocnemius
%muscles (GA) yielding the subthalamo-muscular coherence. Only the disease
%dominant STN will be focus of the current analysis.
%Make sure, Fieldtrip is added to the current path.
%===========================================================================%

subjectdata.generalpath                 = uigetdir;                                                                 % Example: Call the SenseFOG-main file
cd(subjectdata.generalpath)
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


% PRE-PROCESS LFP DATA
task    = {'Walk'; 'WalkWS'; 'WalkINT'; 'WalkINT_new'};
site    = {'LFP_signal_L', 'Freeze_RF' , 'STN'; 'LFP_signal_R', 'Freeze_LF', 'STN'}; 
IMU     = {'Accelerometer_RF','Gyroscope_RF'; 'Accelerometer_LF','Gyroscope_LF'};
fs      = 1000; %Sampling Frequency

FOG_Coherence = struct; 

for k = 1:length(names)
    for m = 1:length(task)
        if isfield(Subjects.(names{k}), task(m)) == 0; continue; end
        for t = 1:size(site,1)
            if isfield(Subjects.(names{k}).(task{m}), "Walking_Freeze") == 0; continue; end
            %LOAD LFP Data ============================================================
            cfg                 = [];
            datafile.trial{1}   = [Subjects.(names{k}).(task{m}).(site{t,1})];
            datafile.time{1}    = (1/fs):(1/fs):(length(datafile.trial{1})/ fs);
            datafile.label      = site(t,3); 
            datafile.fsample    = fs;  

            cfg.trl             = [];     % Keep empty so the entire dataset is used
            cfg.continuous      = 'yes';
            cfg.demean          = 'no';   % No prior baseline correction - Update August 2023
            cfg.dftfilter       = 'no';   % De-Activate 50 Hz (default) Notch-Filter
            cfg.channel         = 'all';
            cfg.hpfilter        = 'yes';  % Higphass Filter at 1 Hz
            cfg.hpfreq          =  1;     % Higphass Filter at 1 Hz
            cfg.rectify         = 'no';   % No Rectify of LFP Signal     
            LFP                 = ft_preprocessing(cfg, datafile);
                   
            clear x1 x2 store datafile cfg  e

            %LOAD EMG Data ===============================================================
            datafile.trial{1}   = [Subjects.(names{k}).(task{m}).EEG.EEG_signal];             % Assign the EEG/EMG Data to the configuration structure
            datafile.time{1}    = [Subjects.(names{k}).(task{m}).EEG.EEG_time];               % Assign time to the configuration structure
            datafile.label      = table2cell(Subjects.(names{k}).(task{m}).EEG.EEG_channels); % Assign the EEG labels to the configuration structure
            datafile.fsample    = fs;                                                         % Assign the correct sampling rate to the configuration structure

            channellist.Freeze_RF    = {'TA_R1', 'TA_R2' 'TA';'GA_R1' 'GA_R2' 'GA'};
            channellist.Freeze_LF     = {'TA_L1', 'TA_L2' 'TA';'GA_L1' 'GA_L2' 'GA'};

             for i = 1:height(channellist.Freeze_RF)
                cfg                      = [];
                cfg.channel              = channellist.(site{t,2})(i,[1 2]);                  % Use assigned channels
                cfg.reref                = 'yes';                                             % Re-Reference
                cfg.refmethod            = 'bipolar';                                         % Choose Bipolar Channels
                cfg.refchannel           = channellist.(site{t,2})(i,:);
                cfg.continuous           = 'yes';
                cfg.demean               = 'no';                                              % No Baselinen Correction - Update August 2023
                cfg.bpfilter             = 'yes';                                             % Activate Band-Pass Filter
                cfg.bpfreq               = [10 300];                                          % Bandpass frequency range, specified as [lowFreq highFreq] in Hz
                cfg.dftfilter            = 'yes';                                             % Activate 50 Hz (default) Notch-Filter
                cfg.rectify              = 'yes';                                             % Rectify Channels 'no' or 'yes' (default = 'no')
                data_avg                 = ft_preprocessing(cfg, datafile);                   % Re-Reference Channels    
                store(i).trial           = data_avg.trial{1};                                 % Store Re-Referenced Channels
                store(i).location        = channellist.(site{t,2})(i,3);                      % Assign Name to the Channels    
                store(i).time            = data_avg.time{1};
                store(i).sampleinfo      = data_avg.sampleinfo;
                store(i).cfg             = data_avg.cfg;
                store(i).fsample         = fs; 
             end

            %Concatenate arrays
            temp_store.trial            = {cat(1,store.trial)};
            temp_store.label            = [store.location]'; %{cat(1,store.location)};
            temp_store.time             = {store(1).time};
            temp_store.sampleinfo       = store(1).sampleinfo; 
            temp_store.fsample          = store(1).fsample;
            temp_store.cfg              = store(1).cfg; 

            EMG  = temp_store;

            %Make sure that EMG and LFP files are of the same length
            if length(EMG.trial{1}(1,:)) > length(LFP.trial{1}(1,:))
               EMG.trial{1}      = EMG.trial{1}(:,1:size(LFP.trial{1}(1,:),2));
               EMG.time(:,1)     = LFP.time;
               EMG.sampleinfo    = LFP.sampleinfo;

            elseif length(EMG.trial{1}(1,:)) < length(LFP.trial{1}(1,:))
               LFP.trial{1}      = LFP.trial{1}(:,1:size(EMG.trial{1}(1,:),2));
               LFP.time          = {EMG.time{1}(1,:)};
               LFP.sampleinfo    = EMG.sampleinfo;
            end
            FOG_Coherence.(names{k}).(task{m}).(site{t,2})                      = ft_appenddata([], LFP, EMG);
            FOG_Coherence.(names{k}).(task{m}).(site{t,2}).events               = [Subjects.(names{k}).(task{m}).Walking_Freeze];
            FOG_Coherence.(names{k}).(task{m}).(site{t,2}).Accelerometer        = Subjects.(names{k}).(task{m}).(IMU{t,1})(:,3);           %Anterior Posterior Plane Accelerometer
            FOG_Coherence.(names{k}).(task{m}).(site{t,2}).Gyroscope            = rad2deg(Subjects.(names{k}).(task{m}).(IMU{t,2})(:,2));  %Saggital PLane Gyroscope            
            clear LFP EMG
        end
    end
end


%Clear-UP
clear cfg channellist data_avg datafile fs i k m site store t task  temp_store trl

task    = {'Walk'; 'WalkWS'; 'WalkINT'; 'WalkINT_new'};
site    = {'Freeze_RF' ; 'Freeze_LF'};
fs      = 1000;  
names   = fieldnames(FOG_Coherence); 

for k = 1:length(names)
    for m = 1:length(task)
        if isfield(FOG_Coherence.(names{k}), task(m)) == 0; continue; end
        for t = 1:size(site,1)
            if isfield(FOG_Coherence.(names{k}).(task{m}), site(t,1)) == 0; continue; end

            datafile = FOG_Coherence.(names{k}).(task{m}).(site{t});

            wavelet_coh          = struct;
            wavelet_coh(1).name  = "STN_TA"; [wavelet_coh(1).coh, ~, f] = wcoherence(datafile.trial{1}(1,:),datafile.trial{1}(2,:), fs, 'FrequencyLimits',[1 100]); %1 = STN
            wavelet_coh(2).name  = "STN_GA"; [wavelet_coh(2).coh, ~, f] = wcoherence(datafile.trial{1}(1,:),datafile.trial{1}(3,:), fs, 'FrequencyLimits',[1 100]); %2 = TA
            wavelet_coh(3).name  = "TA_GA" ; [wavelet_coh(3).coh, ~, f] = wcoherence(datafile.trial{1}(2,:),datafile.trial{1}(3,:), fs, 'FrequencyLimits',[1 100]); %3 = GA
                   
            %Perform Baseline Normalization using the baseline-stand coherence
            if t == 1;  Baseline_COH = Subjects.(names{k}).Baseline_Coherence.baseline_coh_L;
            else        Baseline_COH = Subjects.(names{k}).Baseline_Coherence.baseline_coh_R; end

            wavelet_coh(1).coh = ((wavelet_coh(1).coh - Baseline_COH.STN_TA) ./ Baseline_COH.STN_TA) *100;
            wavelet_coh(2).coh = ((wavelet_coh(2).coh - Baseline_COH.STN_GA) ./ Baseline_COH.STN_GA) *100;
            wavelet_coh(3).coh = ((wavelet_coh(3).coh - Baseline_COH.TA_GA) ./ Baseline_COH.TA_GA) *100;

            %Rawfiles
            TA_raw = datafile.trial{1}(2,:); %TA
            GA_raw = datafile.trial{1}(3,:); %TA
     
            %Create RMS TA/GA Files =====
            TA_rms_raw = sqrt(movmean(TA_raw .^2, 10));    
            GA_rms_raw = sqrt(movmean(GA_raw .^2, 10));    

           %Extract TF-information based on timepoints
           dataset = []; 
           for i = 1:length(datafile.events)
               dataset(i).start         = datafile.events(i).start;
               dataset(i).stop          = datafile.events(i).start + (999/fs);                                                            % Take 1000 ms for Stop if fs = 1000; 
               dataset(i).diff          = datafile.events(i).duration;
               dataset(i).name          = names(k); 
               dataset(i).STN_TA        = wavelet_coh(1).coh(:, [single(1000*dataset(i).start): single(1000*dataset(i).stop)]); 
               dataset(i).STN_GA        = wavelet_coh(2).coh(:, [single(1000*dataset(i).start): single(1000*dataset(i).stop)]); 
               dataset(i).TA_GA         = wavelet_coh(3).coh(:, [single(1000*dataset(i).start): single(1000*dataset(i).stop)]);
               dataset(i).TA_rms_raw    = TA_rms_raw(:, [single(1000*dataset(i).start): single(1000*dataset(i).stop)]);                   % TA Raw RMS Signal
               dataset(i).GA_rms_raw    = GA_rms_raw(:, [single(1000*dataset(i).start): single(1000*dataset(i).stop)]);                   % GA Raw RMS Signal
               dataset(i).Accelerometer = datafile.Accelerometer([single(1000*dataset(i).start): single(1000*dataset(i).stop)],:)';       % IMU signal  
               dataset(i).Gyroscope     = datafile.Gyroscope([single(1000*dataset(i).start): single(1000*dataset(i).stop)],:)';           % IMU signal  
               dataset(i).Baseline_COH  = Baseline_COH;  
           end
           FOG_Coherence.(names{k}).(task{m}).(site{t}).coh_files = dataset;
           clear datafile dataset
        end
    end
end

clear filepath fs GA_raw IMU k m modes site t TA_raw task wavelet_coh i TA_rms_raw GA_rms_raw Baseline_COH Files
clear cfg channellist data_avg store temp_store


task    = {'Walk'; 'WalkWS'; 'WalkINT'; 'WalkINT_new'};
site    = {'Freeze_RF' ; 'Freeze_LF'};
fs      = 1000;  
names   = fieldnames(FOG_Coherence); 

COHERENCE.Freeze_RF = []; COHERENCE.Freeze_LF = [];

for k = 1:length(names)
    for m = 1:length(task)
        if isfield(FOG_Coherence.(names{k}), task(m)) == 0; continue; end
        for t = 1:size(site,1)
            if isfield(FOG_Coherence.(names{k}).(task{m}), site(t,1)) == 0; continue; end
            if isfield(FOG_Coherence.(names{k}).(task{m}).(site{t}), 'coh_files') == 0; continue; end
              COHERENCE.(site{t}) = [ COHERENCE.(site{t}), FOG_Coherence.(names{k}).(task{m}).(site{t}).coh_files];
        end
    end
end


%Choose Files belonging to the disease dominant STN
Freezing_Files_Coherence.FOG = []; 

for i = 1:length(COHERENCE.Freeze_RF)
    name_idx        = COHERENCE.Freeze_RF(i).name;
    stn_dominance   = Subjects.(name_idx{1}).Baseline_Coherence.STN_dominance;  

    if stn_dominance == "Left"
        Freezing_Files_Coherence.FOG = cat(2, Freezing_Files_Coherence.FOG, COHERENCE.Freeze_RF(i));
    elseif stn_dominance == "Right"
        Freezing_Files_Coherence.FOG = cat(2, Freezing_Files_Coherence.FOG, COHERENCE.Freeze_LF(i));
    end
end
Freezing_Files_Coherence.f             = f; 


%Clean-UP
clear bsl_names filepath fs i idx k l modes pp qq site sites stn_dominance t task wavelet_coh z f m name_idx 


%SAVE DATA
save([subjectdata.generalpath filesep 'Coherence-Data' filesep 'Freezing_Files_Coherence.mat'], 'Freezing_Files_Coherence', '-mat')

% *********************** END OF SCRIPT ************************************************************************************************************************
