%% =====  Select_Sitting_power.m ========================================%
% Original author(s): Philipp Klocke, Moritz Loeffler

%This script will import the aligned LFP data from ses-sitting which will
%be used to compute the power for Sitting. The baseline will be
%stored in sub-XX-dataevents.mat which is created after using the
%Sub_GrandActivity_Log-m file. Note that the datafiles for sitting in
%subject 11 and subject 17 have been processed by the authors already. 
%A sitting file for subject 5 does not exist. The code will run through 20 iterations
%and find subjects matching with sub-XX in SenseFOG-main. 
%==============================================================================

subjectdata.generalpath                 = uigetdir;                                                                 % Example: Call the SenseFOG-main file
cd(subjectdata.generalpath)
names                                   = cellstr(strsplit(sprintf('sub-%02d ',1:20)));                             % Create a list of sub-names

%Hardcode STN Laterality for each Subject
STN_dominance = {'Left'; 'NaN'; 'NaN'; 'NaN'; 'Right'; 'NaN'; 'NaN'; 'NaN'; 'Right'; 'Left'; 'Left'; 'NaN'; 'Right'; 'Left'; 'Right'; 'NaN'; 'Right'; 'Left'; 'Right'; 'Right'};

for i = 1:20 %Run through 20 iterations and find each matching subject file in SenseFOG-main
    if ~isfolder(names{i}) == 1
        fprintf(2," \n Missing File for %s \n", names{i}); continue
    elseif isfolder(names{i}) == 1
        fprintf("\n Existing Folder for %s \n ", names{i})
        full_filename = append(subjectdata.generalpath, filesep, names{i}, filesep, "ses-sitting", filesep,"ieeg", filesep, names{i}, "-ses-sitting_lfpalg.mat");
        if isfile(full_filename); load(full_filename)                                                               % Load sitting LFP dataset
        elseif ~isfile(full_filename); fprintf(2," \n Missing Sitting LFP File for %s \n", names{i}); continue
        end

        full_filename = append(subjectdata.generalpath, filesep, names{i}, filesep, names{i}, "-dataevents.mat"); 
        load(full_filename)                                                                                         % Load the LFP activity log from the subject

        %HIGH PASS FILTERING 
        %Highpass LFP Data (1 Hz cutoff, Butterworth filter, filter order6, passed forward and backward) before applying continuous Morlet wavelet transforms
        [b,a]                           = butter(6,1/(1000/2),'high');

        LFP_signal_R                    = filter(b,a, LFP.LFP_signal_R);
        LFP_signal_L                    = filter(b,a, LFP.LFP_signal_L);
        clear a b

        %CONTINOUS MORLET WAVELET TRANSFORMATION
        fs                              = 1000; 
        MFF                             = 4*pi/(6+sqrt(2+6^2));                                                     % Morlet-Fourier-Factor 

        signal  = {'baseline_pwr_L'; 'baseline_pwr_R'};

        for k = 1:height(signal)
            if k == 1; 
                cwtstruct               = cwtft({LFP_signal_L,1/fs},'wavelet', 'morl','scales',1./([1:1:100]*MFF)); % Morlet Wavelet Transformation over signal
            elseif k == 2;
                cwtstruct               = cwtft({LFP_signal_R,1/fs},'wavelet', 'morl','scales',1./([1:1:100]*MFF)); % Morlet Wavelet Transformation over signal
            end
            
            wt                          = abs(cwtstruct.cfs);
            blocksize                   = 2000;                                                                     % Blocks of 2000 samples [2 seconds at 1000Hz]
            L                           = length(wt)-mod(length(wt),blocksize);                                     % Only full Blocks
            datablocks                  = reshape(wt(:,1:L),100,blocksize, []);                                     % Cut signal into blocks and turn into an array


            %Indicate potential artifacts by hand
            if i ==  1 && k == 1; datablocks(:,:,[1:13])                            = [];end %PD01
            if i ==  1 && k == 2; datablocks(:,:,[1:13])                            = [];end %PD01
            if i ==  9 && k == 1; datablocks(:,:,[1:12])                            = [];end %PD09 
            if i ==  9 && k == 2; datablocks(:,:,[1:12])                            = [];end %PD09 
            if i == 10 && k == 1; datablocks(:,:,[1:18])                            = [];end %PD10
            if i == 10 && k == 2; datablocks(:,:,[1:18])                            = [];end %PD10
            if i == 13 && k == 1; datablocks(:,:,[1:13])                            = [];end %PD13
            if i == 13 && k == 2; datablocks(:,:,[1:13])                            = [];end %PD13
            if i == 14 && k == 1; datablocks(:,:,[1:10])                            = [];end %PD14
            if i == 14 && k == 2; datablocks(:,:,[1:10])                            = [];end %PD14
            if i == 15 && k == 1; datablocks(:,:,[1:7])                             = [];end %PD15
            if i == 15 && k == 2; datablocks(:,:,[1:7])                             = [];end %PD15
            if i == 16 && k == 1; datablocks(:,:,[1:10])                            = [];end %PD16
            if i == 16 && k == 2; datablocks(:,:,[1:10])                            = [];end %PD16
            if i == 17 && k == 1; datablocks(:,:,[1:12])                            = [];end %PD17
            if i == 17 && k == 2; datablocks(:,:,[1:12])                            = [];end %PD17
            if i == 18 && k == 1; datablocks(:,:,[1:9])                             = [];end %PD18
            if i == 18 && k == 2; datablocks(:,:,[1:9])                             = [];end %PD18
            if i == 19 && k == 1; datablocks(:,:,[1:9])                             = [];end %PD19
            if i == 19 && k == 2; datablocks(:,:,[1:9])                             = [];end %PD19
            if i == 20 && k == 1; datablocks(:,:,[1:9])                             = [];end %PD20
            if i == 20 && k == 2; datablocks(:,:,[1:9])                             = [];end %PD20
        
            A                         = cat(3, datablocks);
            baseline                  = mean(mean(A,3),2);
            Methods                   = 'Morlet';

            LFP_Events.Sitting_Power.(signal{k,1}) = baseline;
            LFP_Events.Sitting_Power.Methods       = 'Morlet';
            LFP_Events.Sitting_Power.STN_dominance = STN_dominance{i};
            
        end
    end
    clear A ans baseline Methods L LFP_signal_L LFP_signal_R MFF wt 
    
    %SAVE DATA
    save([subjectdata.generalpath filesep names{i} filesep names{i} '-' 'dataevents.mat'], 'LFP_Events', '-mat')
end
% *********************** END OF SCRIPT ************************************************************************************************************************
