%% =====  Select_Stop_power.m  ========================================%

%Date: December 2023
%Original author(s): Philipp Klocke, Moritz Loeffler

%This script will first call all the timepoints for self-selected stops that
%were specified and stored in the Sub_GrandActivity_Log.m file. We will
%first compute the morlet wavelet spectra for the LFP time series and
%segment the time-frequency spectra according to the prespecified time
%points. In a second step, we will use the standing baseline and normalize
%the power spectra yielding the mean %-change from standing.
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


%High Pass LFP Data ===================================================================================================
%Highpass LFP Data (1 Hz cutoff, Butterworth filter, filter order6, passed
%forward and backward) before applying continuous Morlet wavelet transformation
[b,a] = butter(6,1/(1000/2),'high');

task = {'WalkWS'};
for k = 1:length(names)
    for m = 1:length(task)
          if isfield(Subjects.(names{k}), task(m)) == 0; continue; end
          Subjects.(names{k}).(task{m}).LFP_signal_R = filter(b,a, Subjects.(names{k}).(task{m}).LFP_signal_R);
          Subjects.(names{k}).(task{m}).LFP_signal_L = filter(b,a, Subjects.(names{k}).(task{m}).LFP_signal_L); 
    end
end

clear a b k m task Files


%Apply Morlet Wavelet Transformation ===================================================================================
task = {'WalkWS'};
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

%Choose Self-Selected Stop Time Points and Segment Data=================================================================
task        = {'WalkWS'};
field       = {'Self_Selected_Stop'};
imu         = {'Gyroscope_RF'; 'Gyroscope_LF'};
input       = {'L_wt' 'R_wt'; 'L_frequency_domain' 'R_frequency_domain'; 'baseline_pwr_L' 'baseline_pwr_R'; 'L_wt_org' 'R_wt_org'; 'baseline_L_org' 'baseline_R_org'};
SSS     = struct; 

for k = 1:length(names)
    for m = 1:length(task)
        if  isfield(Subjects.(names{k}), task(m)) == 0; continue; end
            if isfield(Subjects.(names{k}).(task{m}), field) == 0; continue; end
            datafile = Subjects.(names{k}).(task{m}).(field{1});
            for i = 1:length(datafile)
                if datafile(i).duration < 1.0; continue; end                                                        % Exclude Stop Durations that last shorter than 1 s
                pretrialtime    = 0;                                                                                % Baseline before onset of stopping
                epochduration   = 1000;                                                                             % Use an Epoch of 1000 ms
                start           = single(1000*Subjects.(names{k}).(task{m}).(field{1})(i).start) - pretrialtime;    % Transition time of ca. 1 seconds
                full_stop       = single(1000*Subjects.(names{k}).(task{m}).(field{1})(i).stop);                    % Entire Duration of Stopping Episode
                stop            = start + pretrialtime + epochduration;                                             % 1 seconds into the stop
                time_vector     = -pretrialtime:1:epochduration;
                
                 for t = 1:width(input)
                    
                    %=== Store IMU Signals ======================================================================
                    IMU =   rad2deg(Subjects.(names{k}).(task{m}).(imu{t})([start:stop],2)); %saggital plane
                    Subjects.(names{k}).(task{m}).(field{1})(i).(imu{t}) = IMU';
  

                    %%=== Extracting Frequency Domain + NORMALIZE =============================================== 
                    %*** EXCLUDE LOW FREQUENCY NOISE ***
                    %Excluding low frequencies (up to 10 Hz) and other frequencies with possible technical artifact contamination related to the sensing equipment (33–37 Hz, 48–52 Hz, 90+ Hz)
                    store       = Subjects.(names{k}).(task{m}).(input{1,t})(:,[(start+pretrialtime):full_stop]);   % Make sure the baseline is not included to compute PSD
                    
                    FD          = mean(store,2);
                    sum_FD      = sum(FD([10:33, 37:48, 52:90],:));
                    Subjects.(names{k}).(task{m}).(field{1})(i).(input{2,t}) = (FD ./ sum_FD)';
                    
                                    
                    %%=== Extracting Time Domain + NORMALIZE ====================================================
                    %TAKE MWT and NORMALIZE BY MEAN OF BASELINE (power - average baseline power)/average baseline power x 100
                    store       = Subjects.(names{k}).(task{m}).(input{1,t})(:,[start:stop]);
                    Subjects.(names{k}).(task{m}).(field{1})(i).(input{4,t}) = store;                               % Save non-normalized dataset as _org
                    

                    %NORMALIZING TIME DOMAIN
                    %Percental Normalization by Baseline [pref. Standing] - [(activity - baseline) / baseline] * 100
                    Option = "Percental_Normalization";

                    %Standing Baseline
                    if t == 1; baseline = Subjects.(names{k}).Baseline_Power.baseline_pwr_L;
                    elseif t == 2; baseline = Subjects.(names{k}).Baseline_Power.baseline_pwr_R; end
                    Subjects.(names{k}).(task{m}).(field{1})(i).(input{1,t}) = ((store - baseline) ./ baseline) *100;  
                end
                               
                if isfield(SSS, (names{k})) == 0; SSS.(names{k}).Left_STN = []; SSS.(names{k}).Right_STN = [];end
                if isempty(SSS.(names{k}).Right_STN) == 1; l = 0; end  
               
                SSS.(names{k}).Right_STN(i+l).name                    = names{k};
                SSS.(names{k}).Left_STN(i+l).name                     = names{k};
                SSS.(names{k}).Right_STN(i+l).duration                = datafile(i).duration;
                SSS.(names{k}).Left_STN(i+l).duration                 = datafile(i).duration;
                SSS.(names{k}).Left_STN(i+l).frequency_domain         = Subjects.(names{k}).(task{m}).(field{1})(i).L_frequency_domain;
                SSS.(names{k}).Right_STN(i+l).frequency_domain        = Subjects.(names{k}).(task{m}).(field{1})(i).R_frequency_domain;
                SSS.(names{k}).Left_STN(i+l).wt                       = Subjects.(names{k}).(task{m}).(field{1})(i).L_wt;
                SSS.(names{k}).Right_STN(i+l).wt                      = Subjects.(names{k}).(task{m}).(field{1})(i).R_wt;
                SSS.(names{k}).Left_STN(i+l).wt_org                   = Subjects.(names{k}).(task{m}).(field{1})(i).L_wt_org;
                SSS.(names{k}).Right_STN(i+l).wt_org                  = Subjects.(names{k}).(task{m}).(field{1})(i).R_wt_org;
                
                SSS.(names{k}).Right_STN(i+l).foot                    = datafile(i).Foot;
                SSS.(names{k}).Left_STN(i+l).foot                     = datafile(i).Foot;
                SSS.(names{k}).Left_STN(i+l).IMU                      = Subjects.(names{k}).(task{m}).(field{1})(i).Gyroscope_RF;
                SSS.(names{k}).Right_STN(i+l).IMU                     = Subjects.(names{k}).(task{m}).(field{1})(i).Gyroscope_LF;

                %BASELINE STAND
                SSS.(names{k}).Left_STN(i+l).baseline                 = Subjects.(names{k}).Baseline_Power.baseline_pwr_L ./  sum(Subjects.(names{k}).Baseline_Power.baseline_pwr_L([10:33, 37:48, 52:90],:))'; %Normalize here
                SSS.(names{k}).Right_STN(i+l).baseline                = Subjects.(names{k}).Baseline_Power.baseline_pwr_R ./  sum(Subjects.(names{k}).Baseline_Power.baseline_pwr_R([10:33, 37:48, 52:90],:))'; %Normalize here                                
                SSS.(names{k}).Right_STN(i+l).baseline_org            = Subjects.(names{k}).Baseline_Power.baseline_pwr_R;
                SSS.(names{k}).Left_STN(i+l).baseline_org             = Subjects.(names{k}).Baseline_Power.baseline_pwr_L;
                l                                                     = length(SSS.(names{k}).Right_STN);
            end
    end
end


fieldnum = fieldnames(SSS);
for k = 1:length(fieldnum)
    idx = find(cellfun(@isempty,{SSS.(fieldnum{k}).Left_STN.wt}));                                              %Clear Files that have no content
    SSS.(fieldnum{k}).Left_STN(idx) = []; SSS.(fieldnum{k}).Right_STN(idx) = [];  clear idx l       
end

%CLEAN-UP
clear ans baseline datafile epochduration FD field fieldnum full_stop fs i imu IMU input k l m pretrialtime start stop sum_FD t task 


FILES.f         = Subjects.(names{1}).WalkWS.f;
FILES.Option    = Option;
FILES.time      = time_vector;
FILES.names     = names; 

FILES.SSS = []; %Create empty struct for all Self-Selected Stop
for k = 1:length(names)
    if isfield(SSS, (names{k})) == 0; continue; end
    if isfield(FILES.SSS, 'wt_r') == 0; FILES.SSS.wt_r = []; FILES.SSS.wt_l = []; end
        datafile_r          = SSS.(names{k}).Right_STN;
        datafile_l          = SSS.(names{k}).Left_STN;
        FILES.SSS.wt_r  = cat(2,datafile_r, FILES.SSS.wt_r); %Concatenate all Stop Events 
        FILES.SSS.wt_l  = cat(2,datafile_l, FILES.SSS.wt_l); %Concatenate all Stop Events 
end

idx = find(cellfun(@isempty,{FILES.SSS.wt_r.wt}));
FILES.SSS.wt_r(idx)     = []; FILES.SSS.wt_l(idx) = [];
FILES.SSS.Option        = FILES.Option; 

Stopping_Files = [];
for k = 1:length(names)
    if isfield(SSS, (names{k})) == 0; continue; end
    %Check for STN Dominance
        if      Subjects.(names{k}).Baseline_Power.STN_dominance == "Left"; 
            Stopping_Files = cat(2,Stopping_Files,SSS.(names{k}).Left_STN);

        elseif  Subjects.(names{k}).Baseline_Power.STN_dominance == "Right";
            Stopping_Files = cat(2,Stopping_Files,SSS.(names{k}).Right_STN);
        end
end

clear datafile_l datafile_r  i idx k store time_vector

%SAVE DATA
save([subjectdata.generalpath filesep 'Time-Frequency-Data' filesep 'Stopping_Files.mat'], 'Stopping_Files', '-mat')
% *********************** END OF SCRIPT ************************************************************************************************************************
