%% =====  STN_EMG_Coherence_Pre_Stop.m  ========================================%

%Date: December 2023
%Original author(s): Philipp Klocke, Moritz Loeffler

%This script will first call all the timepoints for self-selected stop that
%were specified and stored in the Sub_GrandActivity_Log.m file. Gait cycles occurring
%before the stop will be identified. We will then insert both EMG and LFP 
%timeseries into fieldtrip and compute the wavelet coherence between both signals. 
%Second, we will use the standing coherence as our baseline and normalize
%coherence spectra. Coherence spectra will be computed for the tibialis
%anterior (TA) and gastrocnemius muscles (GA) yielding the subthalamo-muscular
%coherence. Only the disease dominant STN will be focus of the current analysis.
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
names   = {Files.name}';                                                                                            % Create a new names list

Subjects = struct; 
for i = 1:length(Files)
    Subjects.(names{i}) = Files(i).File.LFP_Events;
end

%PRE-PROCESS LFP DATA
task    = {'WalkWS'};
site    = {'LFP_signal_L', 'Self_Selected_Stop_R' , 'STN'; 'LFP_signal_R', 'Self_Selected_Stop_L', 'STN'}; 
footsite= {'Accelerometer_RF', 'Gyroscope_RF'; 'Accelerometer_LF', 'Gyroscope_LF'};
fs      = 1000;                                                                                                     %Sampling Frequency

Pre_Stop_Coherence = struct; 

for k = 1:length(names)
    for m = 1:length(task)
        if isfield(Subjects.(names{k}), task(m)) == 0; continue; end
        for t = 1:size(site,1)
            if isfield(Subjects.(names{k}).(task{m}), "Self_Selected_Stop") == 0; continue; end
            %LOAD LFP Data ============================================================
            cfg                 = [];
            datafile.trial{1}   = [Subjects.(names{k}).(task{m}).(site{t,1})];
            datafile.time{1}    = (1/fs):(1/fs):(length(datafile.trial{1})/ fs);
            datafile.label      = site(t,3); 
            datafile.fsample    = fs;  

            cfg.trl             = [];     % Keep empty so the entire dataset is used
            cfg.continuous      = 'yes';
            cfg.demean          = 'no';   % No baseline correction
            cfg.dftfilter       = 'no';   % De-activate 50 Hz (default) Notch-Filter
            cfg.channel         = 'all';
            cfg.hpfilter        = 'yes';  % Higphass filter at 1 Hz
            cfg.hpfreq          =  1;     % Higphass filter at 1 Hz
            cfg.rectify         = 'no';   % No rectifying of signal
            LFP                 = ft_preprocessing(cfg, datafile);
                   
            clear x1 x2 store datafile cfg  e

            %LOAD EMG Data ===============================================================
            datafile.trial{1}   = [Subjects.(names{k}).(task{m}).EEG.EEG_signal];                                   % Assign the EEG/EMG Data to the configuration structure
            datafile.time{1}    = [Subjects.(names{k}).(task{m}).EEG.EEG_time];                                     % Assign time to the configuration structure
            datafile.label      = table2cell(Subjects.(names{k}).(task{m}).EEG.EEG_channels);                       % Assign the EEG labels to the configuration structure
            datafile.fsample    = fs;                                                                               % Assign the correct sampling rate to the configuration structure

            channellist.Self_Selected_Stop_R    = {'TA_R1', 'TA_R2' 'TA';'GA_R1' 'GA_R2' 'GA'};
            channellist.Self_Selected_Stop_L    = {'TA_L1', 'TA_L2' 'TA';'GA_L1' 'GA_L2' 'GA'};

             for i = 1:height(channellist.Self_Selected_Stop_R)
                cfg                      = [];
                cfg.channel              = channellist.(site{t,2})(i,[1 2]);                                        % Use assigned channels
                cfg.reref                = 'yes';                                                                   % Re-Reference
                cfg.refmethod            = 'bipolar';                                                               % Choose Bipolar Channels
                cfg.refchannel           = channellist.(site{t,2})(i,:);
                cfg.continuous           = 'yes';
                cfg.demean               = 'no';                                                                    % No Baseline Correction of Signal - Update August 2023
                cfg.bpfilter             = 'yes';                                                                   % Activate Band-Pass Filter
                cfg.bpfreq               = [10 300];                                                                % Bandpass frequency range, specified as [lowFreq highFreq] in Hz
                cfg.dftfilter            = 'yes';                                                                   % Activate 50 Hz (default) Notch-Filter
                cfg.rectify              = 'yes';                                                                   % Rectify Channels 'no' or 'yes' (default = 'no')
                data_avg                 = ft_preprocessing(cfg, datafile);                                         % Re-Reference Channels    
                store(i).trial           = data_avg.trial{1};                                                       % Store Re-Referenced Channels
                store(i).location        = channellist.(site{t,2})(i,3);                                            % Assign Name to the Channels    
                store(i).time            = data_avg.time{1};
                store(i).sampleinfo      = data_avg.sampleinfo;
                store(i).cfg             = data_avg.cfg;
                store(i).fsample         = fs; 
             end

            %Concatenate arrays
            temp_store.trial            = {cat(1,store.trial)};
            temp_store.label            = [store.location]'; 
            temp_store.time             = {store(1).time};
            temp_store.sampleinfo       = store(1).sampleinfo; 
            temp_store.fsample          = store(1).fsample;
            temp_store.cfg              = store(1).cfg; 

            EMG  = temp_store; clear store

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
            Pre_Stop_Coherence.(names{k}).(task{m}).(site{t,2})                      = ft_appenddata([], LFP, EMG);
            Pre_Stop_Coherence.(names{k}).(task{m}).(site{t,2}).Gyroscope            = rad2deg(Subjects.(names{k}).(task{m}).(footsite{t,2})(:,2))';                                % Gyroscope Saggital Plane
                
            %Prepare individual Gait Cycle Events
            %***************************************************************************************************************
           datafile = Subjects.(names{k}).WalkWS.Self_Selected_Stop;
           idx = find([datafile.duration] < 1); datafile(idx) = [];                                                 % Find index of stops < 1s duraiton and delete    
             for p = 1:length(datafile)

                    stop_start      = datafile(p).start;
                    RF_events       = sortrows(Subjects.(names{k}).(task{m}).rf_events, "Heelstrike_Loc");              % Sort in ascending order
                    RF_events       = RF_events(RF_events.Heelstrike_Loc <= stop_start,:);                              % Only choose events that occur at or before stop       
                    LF_events       = sortrows(Subjects.(names{k}).(task{m}).lf_events, "Heelstrike_Loc");              % Sort in ascending order
                    LF_events       = LF_events(LF_events.Heelstrike_Loc <= stop_start,:);                              % Only choose events that occur at or before stop        
                    DD_STN          = Subjects.(names{k}).Baseline_Power.STN_dominance;                                 % Choose disease dominant STN

                    
                    %Use the foot that corresponds to the disease dominant STN
                    if Subjects.(names{k}).Baseline_Power.STN_dominance == "Left"; foot = "Right";

                        %find index where freeze start matches HS_Loc position                      
                        %[~,idxGC3] = min( abs(RF_events-stop_start));
                        [~,idxGC3] = min( abs(RF_events.Heelstrike_Loc-stop_start));
                        if istable(LF_events); LF_events = table2array(LF_events); end
                        if istable(RF_events); RF_events = table2array(RF_events); end

                                        
                        %GC3
                        store(p).Pre_GC(1).start             = RF_events(idxGC3-1,5);           %Choose the HS Loc before FOG onset
                        store(p).Pre_GC(1).end               = RF_events(idxGC3,5);             %Start with FOG Onset
                        store(p).Pre_GC(1).duration          = RF_events(idxGC3,5) -RF_events(idxGC3-1,5); %Compute Difference
                        store(p).Pre_GC(1).Midswing_Loc      = RF_events(idxGC3,1);
                        store(p).Pre_GC(1).Midswing_Peak     = RF_events(idxGC3,2);
                        store(p).Pre_GC(1).Toe_Off_Loc       = RF_events(idxGC3,3);
                        store(p).Pre_GC(1).predefined_foot   = datafile(i).Foot;                %Find the pre-defined foot for stopping (from previous analyses)
                        store(p).Pre_GC(1).foot              = "Right";  
                        store(p).Pre_GC(1).DD_STN            = DD_STN;
                        store(p).Pre_GC(1).dist_Stop         = store(p).Pre_GC(1).duration; 
                        
                        %GC2
                        store(p).Pre_GC(2).start             = RF_events(idxGC3-2,5);           %Choose the HS that occurs before the end
                        store(p).Pre_GC(2).end               = RF_events(idxGC3-1,5);           %Choose one HS Loc before FOG onset
                        store(p).Pre_GC(2).duration          = RF_events(idxGC3-1,5) -RF_events(idxGC3-2,5); %Compute Difference
                        store(p).Pre_GC(2).Midswing_Loc      = RF_events(idxGC3-1,1);
                        store(p).Pre_GC(2).Midswing_Peak     = RF_events(idxGC3-1,2);
                        store(p).Pre_GC(2).Toe_Off_Loc       = RF_events(idxGC3-1,3);
                        store(p).Pre_GC(2).predefined_foot   = datafile(i).Foot;                %Find the pre-defined foot for stopping (from previous analyses)
                        store(p).Pre_GC(2).foot              = "Right";  
                        store(p).Pre_GC(2).DD_STN            = DD_STN;
                        store(p).Pre_GC(2).dist_Stop         = store(p).Pre_GC(1).dist_Stop + store(p).Pre_GC(2).duration;
           
                        %GC3
                        if idxGC3 > 3
                            store(p).Pre_GC(3).start         = RF_events(idxGC3-3,5);           %Choose the HS that occurs before the end
                            store(p).Pre_GC(3).end           = RF_events(idxGC3-2,5);           %Choose two HS Loc before FOG onset
                            store(p).Pre_GC(3).duration      = RF_events(idxGC3-2,5) -RF_events(idxGC3-3,5); %Compute Difference
                            store(p).Pre_GC(3).Midswing_Loc  = RF_events(idxGC3-2,1);
                            store(p).Pre_GC(3).Midswing_Peak = RF_events(idxGC3-2,2);
                            store(p).Pre_GC(3).Toe_Off_Loc   = RF_events(idxGC3-2,3);
                            store(p).Pre_GC(3).predefined_foot= datafile(i).Foot;               %Find the pre-defined foot for stopping (from previous analyses)
                            store(p).Pre_GC(3).foot          = "Right";
                            store(p).Pre_GC(3).DD_STN        = DD_STN;
                            store(p).Pre_GC(3).dist_Stop     = store(p).Pre_GC(2).dist_Stop + store(p).Pre_GC(3).duration;
                        end

                        clear foot 

                     elseif Subjects.(names{k}).Baseline_Power.STN_dominance == "Right"; foot = "Left";
                        
                        %find index where stop start matches HS_Loc position
                        %[~,idxGC3] = min( abs( LF_events-stop_start));
                        [~,idxGC3] = min( abs(LF_events.Heelstrike_Loc-stop_start));
                        if istable(LF_events); LF_events = table2array(LF_events); end
                        if istable(RF_events); RF_events = table2array(RF_events); end


                        %GC3
                        store(p).Pre_GC(1).start             = LF_events(idxGC3-1,5);             %Choose the HS Loc before FOG onset
                        store(p).Pre_GC(1).end               = LF_events(idxGC3,5);               %Start with FOG Onset
                        store(p).Pre_GC(1).duration          = LF_events(idxGC3,5) -LF_events(idxGC3-1,5); %Compute Difference
                        store(p).Pre_GC(1).Midswing_Loc      = LF_events(idxGC3,1);
                        store(p).Pre_GC(1).Midswing_Peak     = LF_events(idxGC3,2);
                        store(p).Pre_GC(1).Toe_Off_Loc       = LF_events(idxGC3,3);
                        store(p).Pre_GC(1).predefined_foot   = datafile(i).Foot;                %Find the pre-defined foot for stopping (from previous analyses)
                        store(p).Pre_GC(1).foot              = "Left";
                        store(p).Pre_GC(1).DD_STN            = DD_STN;
                        store(p).Pre_GC(1).dist_Stop         = store(p).Pre_GC(1).duration; 
                                              
                        %GC2
                        store(p).Pre_GC(2).start             = LF_events(idxGC3-2,5);             %Choose the HS that occurs before the end
                        store(p).Pre_GC(2).end               = LF_events(idxGC3-1,5);             %Choose one HS Loc before FOG onset
                        store(p).Pre_GC(2).duration          = LF_events(idxGC3-1,5) -LF_events(idxGC3-2,5); %Compute Difference
                        store(p).Pre_GC(2).Midswing_Loc      = LF_events(idxGC3-1,1);
                        store(p).Pre_GC(2).Midswing_Peak     = LF_events(idxGC3-1,2);
                        store(p).Pre_GC(2).Toe_Off_Loc       = LF_events(idxGC3-1,3);
                        store(p).Pre_GC(2).predefined_foot   = datafile(i).Foot;                %Find the pre-defined foot for stopping (from previous analyses)
                        store(p).Pre_GC(2).foot              = "Left";  
                        store(p).Pre_GC(2).DD_STN            = DD_STN;
                        store(p).Pre_GC(2).dist_Stop         = store(p).Pre_GC(1).dist_Stop + store(p).Pre_GC(2).duration;
                                   
                        %GC3
                        if idxGC3 > 3
                            store(p).Pre_GC(3).start         = LF_events(idxGC3-3,5);             %Choose the HS that occurs before the end
                            store(p).Pre_GC(3).end           = LF_events(idxGC3-2,5);             %Choose two HS Loc before FOG onset
                            store(p).Pre_GC(3).duration      = LF_events(idxGC3-2,5) -LF_events(idxGC3-3,5); %Compute Difference
                            store(p).Pre_GC(3).Midswing_Loc  = LF_events(idxGC3-2,1);
                            store(p).Pre_GC(3).Midswing_Peak = LF_events(idxGC3-2,2);
                            store(p).Pre_GC(3).Toe_Off_Loc   = LF_events(idxGC3-2,3);
                            store(p).Pre_GC(3).predefined_foot   = datafile(i).Foot;            %Find the pre-defined foot for stopping (from previous analyses)
                            store(p).Pre_GC(3).foot          = "Left";
                            store(p).Pre_GC(3).DD_STN        = DD_STN;
                            store(p).Pre_GC(3).dist_Stop     = store(p).Pre_GC(2).dist_Stop + store(p).Pre_GC(3).duration;
                        end
                        clear foot

                    else foot = "Error";
                    end   
                    clear LF_events RF_events stop_start  idxGC3
            end
            
            
            %Asssing Gait Cycles back to the datafile - make sure assign correct site /STN
            if      Subjects.(names{k}).Baseline_Power.STN_dominance == "Left";
                Pre_Stop_Coherence.(names{k}).(task{m}).(site{1,2}).events               = store;
            elseif  Subjects.(names{k}).Baseline_Power.STN_dominance == "Right";
                Pre_Stop_Coherence.(names{k}).(task{m}).(site{2,2}).events               = store;
            end

           
            clear LFP EMG store temp_store datafile
        end
    end
end

%Make sure Gait Cycles don't exceed a duration of 2.5 seconds or are longer than 3s away from stopping onset
for k = 1:length(names)
    if isfield(Pre_Stop_Coherence, names(k)) == 0; continue; end
    for m = 1:length(task)
        if isfield(Pre_Stop_Coherence.(names{k}), task(m)) == 0; continue; end
        for t = 1:size(site,1)
            if isfield(Pre_Stop_Coherence.(names{k}).(task{m}), site(t,2)) == 0; continue; end
            if isfield(Pre_Stop_Coherence.(names{k}).(task{m}).(site{t,2}), 'events') == 0; continue; end

            for q = 1:length(Pre_Stop_Coherence.(names{k}).(task{m}).(site{t,2}).events)
                    index_del = [];
                    for p = 1:length(Pre_Stop_Coherence.(names{k}).(task{m}).(site{t,2}).events(q).Pre_GC)
                        if Pre_Stop_Coherence.(names{k}).(task{m}).(site{t,2}).events(q).Pre_GC(p).duration > 2.5   % If Gaitcycle lasts >2.5s, delete
                            index_del(length(index_del)+1,1) = p; 
                        end
                    end
                    Pre_Stop_Coherence.(names{k}).(task{m}).(site{t,2}).events(q).Pre_GC(index_del:end) = [];
                    
                    index_del = [];
                    for p = 1:length(Pre_Stop_Coherence.(names{k}).(task{m}).(site{t,2}).events(q).Pre_GC)
                        if Pre_Stop_Coherence.(names{k}).(task{m}).(site{t,2}).events(q).Pre_GC(p).dist_Stop > 3    % If GaitCycle is >3s away from STOP, delete
                            index_del(length(index_del)+1,1) = p;
                        end
                    end
                    Pre_Stop_Coherence.(names{k}).(task{m}).(site{t,2}).events(q).Pre_GC(index_del:end) = [];
            end
        end
    end
end

%Clear-UP
clear cfg channellist data_avg datafile fs i k m site store t task  temp_store trl p DD_STN index index_del q idx footsite



%Compute Wavelet Coherence
task    = {'WalkWS'};
site    = {'Self_Selected_Stop_R' ; 'Self_Selected_Stop_L'};
fs      = 1000;  
names   = fieldnames(Pre_Stop_Coherence); 

for k = 1:length(names)
    for m = 1:length(task)
        if isfield(Pre_Stop_Coherence.(names{k}), task(m)) == 0; continue; end
        for t = 1:size(site,1)
            if isfield(Pre_Stop_Coherence.(names{k}).(task{m}), site(t,1)) == 0; continue; end
            if isfield(Pre_Stop_Coherence.(names{k}).(task{m}).(site{t,1}), 'events') == 0; continue; end

            datafile = Pre_Stop_Coherence.(names{k}).(task{m}).(site{t});

            wavelet_coh = struct;
            wavelet_coh(1).name  = "STN_TA"; [wavelet_coh(1).coh, ~, f] = wcoherence(datafile.trial{1}(1,:),datafile.trial{1}(2,:), fs, 'FrequencyLimits',[1 40]); %1 = STN
            wavelet_coh(2).name  = "STN_GA"; [wavelet_coh(2).coh, ~, f] = wcoherence(datafile.trial{1}(1,:),datafile.trial{1}(3,:), fs, 'FrequencyLimits',[1 40]); %2 = TA
            wavelet_coh(3).name  = "TA_GA" ; [wavelet_coh(3).coh, ~, f] = wcoherence(datafile.trial{1}(2,:),datafile.trial{1}(3,:), fs, 'FrequencyLimits',[1 40]); %3 = GA
            
            %Rawfiles
            TA_raw = datafile.trial{1}(2,:); %TA
            GA_raw = datafile.trial{1}(3,:); %GA

            %Use a 4th order 6 Hz Lowpass Butterworth Filter to create an EMG envelope (This will be used to create cocontraction index)
            fc      = 6;
            fs      = 1000;
            [b,a]   = butter(4,fc/(fs/2));
            TA_env  = filter(b,a,TA_raw);
            GA_env  = filter(b,a,GA_raw); 

            %Create RMS TA/GA Files =====
            TA_rms_raw = sqrt(movmean(TA_raw .^2, 10));    
            GA_rms_raw = sqrt(movmean(GA_raw .^2, 10));    


            %Extract TF-information based on timepoints
            for i = 1:length(datafile.events)
               for p = 1:length(datafile.events(i).Pre_GC)
                   datafile.events(i).Pre_GC(p).STN_TA           = wavelet_coh(1).coh(:, [single(1000*datafile.events(i).Pre_GC(p).start): single(1000*datafile.events(i).Pre_GC(p).end)]); 
                   datafile.events(i).Pre_GC(p).STN_GA           = wavelet_coh(2).coh(:, [single(1000*datafile.events(i).Pre_GC(p).start): single(1000*datafile.events(i).Pre_GC(p).end)]); 
                   datafile.events(i).Pre_GC(p).TA_GA            = wavelet_coh(3).coh(:, [single(1000*datafile.events(i).Pre_GC(p).start): single(1000*datafile.events(i).Pre_GC(p).end)]); 
                   datafile.events(i).Pre_GC(p).TA_raw           = TA_raw(:, [single(1000*datafile.events(i).Pre_GC(p).start):     single(1000*datafile.events(i).Pre_GC(p).end)]);
                   datafile.events(i).Pre_GC(p).GA_raw           = GA_raw(:, [single(1000*datafile.events(i).Pre_GC(p).start):     single(1000*datafile.events(i).Pre_GC(p).end)]);
                   datafile.events(i).Pre_GC(p).TA_env           = TA_env(:, [single(1000*datafile.events(i).Pre_GC(p).start):     single(1000*datafile.events(i).Pre_GC(p).end)]);
                   datafile.events(i).Pre_GC(p).GA_env           = GA_env(:, [single(1000*datafile.events(i).Pre_GC(p).start):     single(1000*datafile.events(i).Pre_GC(p).end)]);
                   datafile.events(i).Pre_GC(p).TA_rms_raw       = TA_rms_raw(:, [single(1000*datafile.events(i).Pre_GC(p).start): single(1000*datafile.events(i).Pre_GC(p).end)]);
                   datafile.events(i).Pre_GC(p).GA_rms_raw       = GA_rms_raw(:, [single(1000*datafile.events(i).Pre_GC(p).start): single(1000*datafile.events(i).Pre_GC(p).end)]);
                   datafile.events(i).Pre_GC(p).Gyroscope        = datafile.Gyroscope(:,[single(1000*datafile.events(i).Pre_GC(p).start): single(1000*datafile.events(i).Pre_GC(p).end)]);

                   %Compute relative timepoints for gait cycle
                   store = datafile.events(i).Pre_GC(p).end - datafile.events(i).Pre_GC(p).Midswing_Loc;
                   datafile.events(i).Pre_GC(p).Midswing = (1-(store / datafile.events(i).Pre_GC(p).duration))*100;

                   store = datafile.events(i).Pre_GC(p).end - datafile.events(i).Pre_GC(p).Toe_Off_Loc;
                   datafile.events(i).Pre_GC(p).Toe_Off = (1-(store / datafile.events(i).Pre_GC(p).duration))*100;
               end

             
               %datafile.events(i).GaitParameter = rmfield(datafile.events(i).GaitParameter, {'HS_pks_1','HS_pks_2', 'MS_pks', 'TO_pks', 'DD_STN', 'name', 'foot'});
                
               field_ids = {'STN_TA', 'STN_GA', 'TA_GA', 'TA_raw', 'GA_raw','TA_env', 'GA_env', 'TA_rms_raw', 'GA_rms_raw', 'Gyroscope'};
                for p = 1:length(datafile.events(i).Pre_GC)
                   for y = 1:length(field_ids)
                        for z = 1:height(datafile.events(i).Pre_GC(p).(field_ids{y}))
                           pp = [flip(datafile.events(i).Pre_GC(p).(field_ids{y})(z,:)) datafile.events(i).Pre_GC(p).(field_ids{y})(z,:) flip(datafile.events(i).Pre_GC(p).(field_ids{y})(z,:))]; 
                           qq = resample(pp,3000,length(pp));
                           zz(z,:) = qq(:,1001:2000);
                        end
                        datafile.events(i).Pre_GC(p).(sprintf("%s_rs" , field_ids{y})) = zz; 
                        clear zz qq pp z 
                   end
                end
                
                %Delete excessive data
                datafile.events(i).GaitParameter = rmfield(datafile.events(i).Pre_GC, field_ids);
                datafile.events(i).GaitParameter = rmfield(datafile.events(i).GaitParameter, {'start', 'end', 'duration', 'Midswing_Loc', 'Midswing_Peak' 'Toe_Off_Loc', 'dist_Stop', 'predefined_foot', 'foot', 'DD_STN'});
            end

            clear a b fc GA_env GA_raw GA_rms_raw TA_raw TA_env TA_rms_raw wavelet_coh store
            

           %Average over all Sub-Pre_GaitCycles
           for i = 1:length(datafile.events)
               field_ids = fieldnames(datafile.events(i).GaitParameter);
               for p = 1:length(field_ids)
                   datafile.events(i).(field_ids{p}) = mean(cat(3,datafile.events(i).GaitParameter.(field_ids{p})),3);
               end
           end
           
           %Again, delete excessive data
           datafile.events = rmfield(datafile.events, {'GaitParameter', 'Pre_GC'});
           
           Pre_Stop_Coherence.(names{k}).(task{m}).(site{t}).events = datafile.events;
           clear datafile dataset wavelet_coh
        end
    end
end

clear y wavelet_coh q modes index_del index TA_raw GA_raw field_ids ans dataset i k m p t a b fc 


task    = {'WalkWS'};
site    = {'Self_Selected_Stop_R' ; 'Self_Selected_Stop_L'};
modes   = {'GC_duration', 'TO_rel', 'MS_rel', 'STN_TA_rs', 'STN_GA_rs', 'TA_GA_rs', 'TA_raw_rs', 'GA_raw_rs','TA_rms_raw', 'GA_rms_raw', 'Gyroscope_rs', 'Accelerometer_rs'};
fs      = 1000;  
names   = fieldnames(Pre_Stop_Coherence); 

COHERENCE.DOMINANT_STN = []; 

for k = 1:length(names)
    for m = 1:length(task)
        if isfield(Pre_Stop_Coherence.(names{k}), task(m)) == 0; continue; end
        for t = 1:size(site,1)
            if isfield(Pre_Stop_Coherence.(names{k}).(task{m}), site(t,1)) == 0; continue; end
            if isfield(Pre_Stop_Coherence.(names{k}).(task{m}).(site{t,1}),"events") == 0; continue; end
            [Pre_Stop_Coherence.(names{k}).(task{m}).(site{t,1}).events.name] = deal(names{k});
            COHERENCE.DOMINANT_STN = cat(2,COHERENCE.DOMINANT_STN, [Pre_Stop_Coherence.(names{k}).(task{m}).(site{t,1}).events]);      
        end
    end
end

Pre_Stopping_Files.Pre_Stops        = COHERENCE.DOMINANT_STN;
Pre_Stopping_Files.f                = f; 

%Clean-UP
clear bsl_names filepath fs i idx k l modes pp qq site sites stn_dominance t task wavelet_coh z f m COHERENCE

%SAVE DATA
save([subjectdata.generalpath filesep 'Coherence-Data' filesep 'Pre_Stopping_Files_Coherence.mat'], 'Pre_Stopping_Files', '-mat')

% *********************** END OF SCRIPT ************************************************************************************************************************
