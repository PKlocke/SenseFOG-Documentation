%% =====  Baseline_Coherence.m ========================================%
% Original author(s): Philipp Klocke, Moritz Loeffler

%This script will import the aligned LFP and EMG data from ses-standing which will
%be used to compute the baseline coherence [Standing]. The baseline will be
%stored in sub-XX-dataevents.mat which is created after using the
%Sub_GrandActivity_Log-m file.
%==============================================================================

subjectdata.generalpath                 = uigetdir;                                                                 % Example: Call the SenseFOG-main file
cd(subjectdata.generalpath)
names                                   = cellstr(strsplit(sprintf('sub-%02d ',1:20)));                             % Create a list of sub-names

%Hardcode STN Laterality for each Subject
STN_dominance = {'Left'; 'NaN'; 'Left'; 'NaN'; 'Right'; 'Right'; 'Right'; 'Right'; 'Right'; 'Left'; 'Left'; 'Left'; 'Right'; 'Left'; 'Right'; 'Left'; 'Right'; 'Left'; 'Right'; 'Right'};


for i = 1:20
    if ~isfolder(names{i}) == 1
        fprintf(2," \n Missing File for %s \n", names{i}); continue
    elseif isfolder(names{i}) == 1
        fprintf("\n Existing Folder for %s \n ", names{i})
        full_filename       = append(subjectdata.generalpath, filesep, names{i}, filesep, "ses-standing", filesep, "ieeg",filesep, names{i}, "-ses-standing_lfpalg.mat");
        full_filename_eeg   = append(subjectdata.generalpath, filesep, names{i}, filesep, "ses-standing", filesep, "eeg", filesep, names{i}, "-ses-standing_eegalg.mat");
        if isfile(full_filename) && isfile(full_filename_eeg)
            load(full_filename)                                                                                      % Load standing LFP dataset
            load(full_filename_eeg)                                                                                  % Load standing EEG dataset
        elseif ~isfile(full_filename);      fprintf(2," \n Missing Standing LFP File for %s \n", names{i});
        elseif ~isfile(full_filename_eeg);  fprintf(2," \n Missing Standing EEG File for %s \n", names{i}); continue;
        end

        full_filename = append(subjectdata.generalpath, filesep, names{i}, filesep, names{i}, "-dataevents.mat"); 
        if ~isfile(full_filename);      fprintf(2," \n Missing LFP activity log for %s \n", names{i}); continue; end
        load(full_filename)                                                                                         % Load the LFP activity log from the subject


        %Pre-Process both LFP and EMG Data
        site    = {'LFP_signal_L', 'Right_Foot', 'STN'; 'LFP_signal_R','Left_Foot', 'STN'}; 
        fs      = 1000;                                                                                             % Sampling Frequency
        Coherence = struct; 

        for t = 1:size(site,1)
            %LOAD LFP Data =============================================================================================
            cfg                 = [];
            datafile.trial{1}   = [LFP.(site{t,1})];
            datafile.time{1}    = (1/fs):(1/fs):(length(datafile.trial{1})/ fs);
            datafile.label      = site(t,3); 
            datafile.fsample    = fs;  
                    
            cfg.trl             = [];                                                                               % Keep empty so the entire dataset is used
            cfg.continuous      = 'yes';
            cfg.demean          = 'no';                                                                             % Update August 2023 - no baseline correction
            cfg.dftfilter       = 'no';                                                                             % De-Activate 50 Hz (default) Notch-Filter
            cfg.channel         = 'all';
            cfg.hpfilter        = 'yes';                                                                            % Higphass Filter at 1 Hz
            cfg.hpfreq          =  1;                                                                               % Higphass Filter at 1 Hz
            cfg.rectify         = 'no';                                                                             % No Rectify Signal - Update August 2023
            LFP_new             = ft_preprocessing(cfg, datafile);
                    
            clear x1 x2 store datafile cfg  e
        
            %LOAD EMG Data =============================================================================================
            datafile.trial{1}   = [EEG_File.EEG_signal];                                                            % Assign the EEG/EMG Data to the configuration structure
            datafile.time{1}    = [EEG_File.EEG_time];                                                              % Assign time to the configuration structure
            datafile.label      = table2cell(EEG_File.channels);                                                    % Assign the EEG labels to the configuration structure
            datafile.fsample    = fs;                                                                               % Assign the correct sampling rate to the configuration structure
                    
            channellist.Right_Foot    = {'TA_R1', 'TA_R2' 'TA';'GA_R1' 'GA_R2' 'GA'};
            channellist.Left_Foot     = {'TA_L1', 'TA_L2' 'TA';'GA_L1' 'GA_L2' 'GA'};
        
            for p = 1:height(channellist.Right_Foot)
                cfg                      = [];
                cfg.channel              = channellist.(site{t,2})(p,[1 2]);                                        % Use assigned channels
                cfg.reref                = 'yes';                                                                   % Re-Reference
                cfg.refmethod            = 'bipolar';                                                               % Choose Bipolar Channels
                cfg.refchannel           = channellist.(site{t,2})(p,:);
                cfg.continuous           = 'yes';
                cfg.demean               = 'no';
                cfg.bpfilter             = 'yes';                                                                   % Activate Band-Pass Filter
                cfg.bpfreq               = [10 300];                                                                % Bandpass frequency range, specified as [lowFreq highFreq] in Hz
                cfg.dftfilter            = 'yes';                                                                   % Activate 50 Hz (default) Notch-Filter
                cfg.rectify              = 'yes';                                                                   % Rectify Channels 'no' or 'yes' (default = 'no')
                data_avg                 = ft_preprocessing(cfg, datafile);                                         % Re-Reference Channels    
                store(p).trial           = data_avg.trial{1};                                                       % Store Re-Referenced Channels
                store(p).location        = channellist.(site{t,2})(p,3);                                            % Assign Name to the Channels    
                store(p).time            = data_avg.time{1};
                store(p).sampleinfo      = data_avg.sampleinfo;
                store(p).cfg             = data_avg.cfg;
                store(p).fsample         = fs; 
            end
        
            %Concatenate arrays
            temp_store.trial            = {cat(1,store.trial)};
            temp_store.label            = [store.location]'; 
            temp_store.time             = {store(1).time};
            temp_store.sampleinfo       = store(1).sampleinfo; 
            temp_store.fsample          = store(1).fsample;
            temp_store.cfg              = store(1).cfg; 
                    
            EMG  = temp_store;
        
            %Make sure that EMG and LFP files are of the same length
            if length(EMG.trial{1}(1,:)) > length(LFP_new.trial{1}(1,:))
                EMG.trial{1}      = EMG.trial{1}(:,1:size(LFP_new.trial{1}(1,:),2));
                EMG.time(:,1)     = LFP_new.time;
                EMG.sampleinfo    = LFP_new.sampleinfo;
        
            elseif length(EMG.trial{1}(1,:)) < length(LFP_new.trial{1}(1,:))
                LFP_new.trial{1}      = LFP_new.trial{1}(:,1:size(EMG.trial{1}(1,:),2));
                LFP_new.time          = {EMG.time{1}(1,:)};
                LFP_new.sampleinfo    = EMG.sampleinfo;
            end
            Coherence.(site{t,2})                      = ft_appenddata([], LFP_new, EMG);
            clear LFP_new EMG
        end

        %COMPUTE COHERENCE =============================================================================================
        site    = {'Right_Foot'; 'Left_Foot'}; 
        fs      = 1000;                                                                                             % Sampling Frequency

           for t = 1:size(site,1)
                datafile = Coherence.(site{t});
                wavelet_coh = struct;
                wavelet_coh(1).name  = "STN_TA"; [wavelet_coh(1).coh, ~, f] = wcoherence(datafile.trial{1}(1,:),datafile.trial{1}(2,:), fs, 'FrequencyLimits',[1 100]); % 1 = STN
                wavelet_coh(2).name  = "STN_GA"; [wavelet_coh(2).coh, ~, f] = wcoherence(datafile.trial{1}(1,:),datafile.trial{1}(3,:), fs, 'FrequencyLimits',[1 100]); % 2 = TA
                wavelet_coh(3).name  = "TA_GA" ; [wavelet_coh(3).coh, ~, f] = wcoherence(datafile.trial{1}(2,:),datafile.trial{1}(3,:), fs, 'FrequencyLimits',[1 100]); % 3 = GA
                Coherence.(site{t}).coh_files                               = wavelet_coh;
           end
    
        clear t datafile wavelet_co fs

     
         for k = 1:size(site,1)
             for t = 1:size(Coherence.(site{k}).coh_files,2)
                    
                    datainput = Coherence.(site{k}).time{1};
                    blocksize   = 2000;                                                                             % Blocks of 2000 samples [2 seconds at 1000Hz]
                    L           = length(datainput)-mod(length(datainput),blocksize);                               % Only full Blocks
                    datablocks  = reshape(Coherence.(site{k}).coh_files(t).coh(:,1:L),length(f),blocksize, []); % Cut signal into blocks and turn into an array
                
                   % for p = 1:size(datablocks,3)
                   %     Morlets     = f; 
                   %     idx         = Morlets >= 1 & Morlets <= 50;
                   %     frex        = Morlets(idx); nfrq = 200;
                   %     fs          = 1000; 
                   %     time        = 1:1:2000;
                   % 
                   %     %Currently inactivated, deactivate to plot each epoch
                   %     figure(p)
                   %     contourf(time,frex, datablocks(idx,:,p), nfrq, 'linecolor', 'none')
                   %     title(p) 
                   % end
        
                    %Indicate potential artifacts by hand
                    if i == 1 && k == 1;  datablocks(:,:,[1:10,53])                         = [];end % sub-01
                    if i == 1 && k == 2;  datablocks(:,:,[1:10])                            = [];end % sub-01
                    if i == 5 && k == 1;  datablocks(:,:,[1:10])                            = [];end % sub-05
                    if i == 5 && k == 2;  datablocks(:,:,[1:10,65])                         = [];end % sub-05
                    if i == 9 && k == 1;  datablocks(:,:,[1:10,22])                         = [];end % sub-09
                    if i == 9 && k == 2;  datablocks(:,:,[1:10])                            = [];end % sub-09
                    if i == 10 && k == 1;  datablocks(:,:,[1:15,31])                        = [];end % sub-10
                    if i == 10 && k == 2;  datablocks(:,:,[1:15])                           = [];end % sub-10
                    if i == 11 && k == 1;  datablocks(:,:,[1:10,28,43])                     = [];end % sub-11
                    if i == 11 && k == 2;  datablocks(:,:,[1:10,40])                        = [];end % sub-11
                    if i == 13 && k == 1;  datablocks(:,:,[1:13])                           = [];end % sub-13
                    if i == 13 && k == 2;  datablocks(:,:,[1:13])                           = [];end % sub-13
                    if i == 14 && k == 1;  datablocks(:,:,[1:10])                           = [];end % sub-14
                    if i == 14 && k == 2;  datablocks(:,:,[1:10])                           = [];end % sub-14
                    if i == 15 && k == 1;  datablocks(:,:,[1:10])                           = [];end % sub-15
                    if i == 15 && k == 2;  datablocks(:,:,[1:10])                           = [];end % sub-15
                    if i == 16 && k == 1;  datablocks(:,:,[1:10])                           = [];end % sub-16
                    if i == 16 && k == 2;  datablocks(:,:,[1:15])                           = [];end % sub-16
                    if i == 17 && k == 1; datablocks(:,:,[1:10,34,47,53,60])                = [];end % sub-17
                    if i == 17 && k == 2; datablocks(:,:,[1:10])                            = [];end % sub-17
                    if i == 18 && k == 1; datablocks(:,:,[1:10])                            = [];end % sub-18
                    if i == 18 && k == 2; datablocks(:,:,[1:10])                            = [];end % sub-18
                    if i == 19 && k == 1; datablocks(:,:,[1:10])                            = [];end % sub-19
                    if i == 19 && k == 2; datablocks(:,:,[1:10])                            = [];end % sub-19
                    if i == 20 && k == 1; datablocks(:,:,[1:10])                            = [];end % sub-20
                    if i == 20 && k == 2; datablocks(:,:,[1:11])                            = [];end % sub-20
        
                    A                         = cat(3, datablocks);
                    baseline                  = mean(mean(A,3),2);
                    Methods                   = 'Morlet';
                    signal                    = {'baseline_coh_L'; 'baseline_coh_R'};
                    mode                      = {'STN_TA'; 'STN_GA'; 'TA_GA'};  

                    LFP_Events.Baseline_Coherence.(signal{k,1}).(mode{t})         = baseline;
                    LFP_Events.Baseline_Coherence.Methods                         = 'Morlet';
                    LFP_Events.Baseline_Coherence.STN_dominance                   = STN_dominance{i};
                    clear datablocks  datainput blocksize L Methods signal A baseline
             end
         end
    end
    
    %SAVE DATA
    save([full_filename], 'LFP_Events', '-mat')

    %Clean-UP
    clear A baseline blocksize cfg channellist data_avg datablocks datainput k L p signal site store t temp_store wavelet_coh
end

% *********************** END OF SCRIPT ************************************************************************************************************************
