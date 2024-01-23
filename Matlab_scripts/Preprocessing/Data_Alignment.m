%%=====  Data_Alignment.m ========================================%

%Date: November 2023
%Original author(s): Philipp Klocke, Moritz Löffler

%This script will help align both EEG and LFP and IMU data according to a mutual
%beginning. As such, the M1 sequence will be traced in the EEG signal which is the
%mutual timepoint where IMU and EEG data are synchronized. We will first cut 
%the overlapping EEG signal.In a second step we will manually identify the 
%stimulation artefact which is set at the beginning of each recording. The 
%exact time point of the stimulation artefact that will be used to align the data and 
%the information is stored in a sub-XX-datafile.m script. The files will be aligned
%according to the artefact and overlapping traces cut out. The data will be stored in a pre-specified
%filepath.
%===================================================================%

%Load EEG and LFP data and IMU data by specifying subject and SESSION of interest
clear; close all
subjectdata.generalpath         = uigetdir;                                                        % Example: SenseFOG-main/sub-XX/ses-standing
cd(subjectdata.generalpath)
filename                        = extractAfter(subjectdata.generalpath, "-main");                  % Create the specified filename
filename                        = extractBefore(filename(2:end), "ses-");                          % Create the specified taskname
filename                        = filename(1:end-1); 
taskname                        = extractAfter(subjectdata.generalpath,"ses-");                    % Create the specified taskname
taskname                        = append("ses-", taskname);                                        % Create the specified taskname
filepath                        = extractBefore(subjectdata.generalpath, "ses");                   % Create the specified filepath
filepath                        = filepath(1:end-1); 
fullname                        = append(subjectdata.generalpath, filesep, "ieeg", filesep,filename, "-", taskname, "_raw.mat"); 

if isfile(fullname); load(fullname); end                                                            % LOAD JSON [LFP] FILE
fullname                        = append(subjectdata.generalpath,filesep, "eeg", filesep,filename, "-", taskname, "_raw.mat"); 
if isfile(fullname); load(fullname); end                                                            % LOAD BVA [EEG] FILE
fullname                        = append(subjectdata.generalpath,filesep, "motion", filesep, filename, "-", taskname, "_raw.mat");
if isfile(fullname); load(fullname); end                                                            % LOAD HDF [IMU] FILE
fullname                        = append(filepath, filesep, filename, "_datafile.mat"); load(fullname);

subjectdata.filepath            = filepath;                                                         % Create the specified filepath
subjectdata.fs_eeg              = 1000;                                                             % EEG sampling rate is 1000 Hz per default


%=====LFP DATA =========================================================================
%Specify time range for display using min and max values
%Make sure the Stimulation artefact is present and that the artefact is aligned in both LFP traces 

minx     = 0; %arbitrary value
maxx     = 40000; %arbitrary value

clc
figure(1);
    ax3 = subplot(2,1,1);
    plot(1:length(LFP.interp_LFP_right),LFP.interp_LFP_right, 'LineWidth',1,'Color','r')
    xlim([minx maxx])
    xlabel('Samples')
    ylabel('Amplitude [a.u.]')
    legend('Right LFP')
    
    ax4 = subplot(2,1,2);
    plot(1:length(LFP.interp_LFP_left),LFP.interp_LFP_left, 'LineWidth',1,'Color','b')
    xlim([minx maxx])
    xlabel('Samples')
    ylabel('Amplitude [a.u.]')
    legend('Left LFP')
    set(gcf,'color','white')
    linkaxes([ax3,ax4],'xy');
    sgtitle({'LFP Datasets'; sprintf('Trial: %s ', EEG_File.eeg)})
    clc
    
%=== CLEAN-UP ====
clear ans ax1 ax2 ax3 ax4 minx maxx

%==== EEG DATA =========================================================================
%Finding the M1-Sequence of the IMU Dataset that appears in the EEG dataset
%The M1 Sequence represents the start of IMU recording in the EEG dataset
if      exist("IMU_data")
        M1                      = struct2table(EEG_File.vmrk);
        index_M1                = find(strcmp('M  1',(M1{:,2}))); %Finding the index of where M  1 appears
        sample_M1               = table2array(M1(index_M1,"sample"));
else    sample_M1               = 1; end


%Plot EEG Raw Data (single channels):
figure(2);
    plot(1:length(EEG_File.dat.dataset), EEG_File.dat.dataset(end,:),'-v','MarkerIndices',[sample_M1(1)],'MarkerFaceColor','red')
    text(sample_M1(1,1),1000,'M1')
    xlabel('Samples'); ylabel('arbitrary unit')
    xline(sample_M1(1), '--r', 'LineWidth',2)
    xlim([sample_M1(1)-2500 sample_M1(1)+2500])
    set(gcf,'color','white')
    title('Finding M1 Sequence')

%=== CLEAN-UP ====
clear numTrial index_M1 M1 


%==== ALIGNING EEG AND IMU DATA =============================================================================
%Next, we will align EEG and IMU data accoring to the M1-Sequence
EEG_pre_signal          = EEG_File.dat.dataset(:,(sample_M1(1,1):end));
EEG_File.eegtime_new    = (1/subjectdata.fs_eeg):(1/subjectdata.fs_eeg):(length(EEG_pre_signal)/subjectdata.fs_eeg);


% === Visualizing NOT-ALIGNED signals for demonstration purposes ===
figure(3)
    ax1 = subplot(3,1,1)
    plot(1:length(LFP.interp_LFP_right),LFP.interp_LFP_right, 'LineWidth',1,'Color','r')
    xlabel('Samples'); xlim([0 20000])
    title('Right LFP Signal')

    ax2 = subplot(3,1,2)
    plot(1:length(EEG_pre_signal), EEG_pre_signal(end,:))
    xlabel('Samples')
    xlim([0 20000]); ylim([-100 5000])
    title('EEG Data - IPG')
    
    ax3 = subplot(3,1,3)
    plot(1:length(EEG_pre_signal), EEG_pre_signal(14,:))
    xlim([0 20000])
    title('EEG Data - C4')
    linkaxes([ax2, ax3],'x')
    set(gcf,'color','white')
    sgtitle('Non-Aligned Datasets')
    clear ax1 ax2 ax3 


% Specify Tasknames
if     taskname == 'ses-standing';  task = 'Stand';
elseif taskname == 'ses-sitting';   task = 'Sit'; 
elseif taskname == 'ses-walk';      task = 'Walk';
elseif taskname == 'ses-walkws';    task = 'WalkWS';
elseif taskname == 'ses-walkint';   task = 'WalkINT';
elseif taskname == 'ses-walkint2';  task = 'WalkINT_new';
end

%Align files by cutting off non-overlapping traces
if subjectdata.signalpoint.(task).LFP_signal > subjectdata.signalpoint.(task).EEG_signal
   LFP_signal_R                         = LFP.interp_LFP_right(:,[subjectdata.signalpoint.(task).delay:end]);                                           % Cut LFP file according to time-delay (RIGHT)
   LFP_signal_L                         = LFP.interp_LFP_left(:,[subjectdata.signalpoint.(task).delay:end]);                                            % Cut LFP file according to time-delay (LEFT)
   EEG_File.dat.dataset_new             = EEG_pre_signal;
   EEG_signal                           = EEG_pre_signal; 

elseif subjectdata.signalpoint.(task).EEG_signal > subjectdata.signalpoint.(task).LFP_signal
   EEG_File.dat.dataset_new             = EEG_pre_signal(:,[subjectdata.signalpoint.(task).delay:end]);                                                 % Cut EEG file according to time-delay
   EEG_File.eegtime_new                 = (1/subjectdata.fs_eeg):(1/subjectdata.fs_eeg):(length(EEG_File.dat.dataset_new)/subjectdata.fs_eeg);
   %EEG_File.eegtime_new                = EEG_File.eegtime_new(:, [subjectdata.signalpoint.(task).delay:end]);                                          % Cut EEG time file according to time-delay 

   if exist("IMU_data")
   for i = 1:3 
        IMU_data.interp_accelerometer(i).Sensor = IMU_data.interp_accelerometer(i).Sensor([subjectdata.signalpoint.(task).delay:end],:);                % Prepare IMU files
        IMU_data.interp_gyroscope(i).Sensor     = IMU_data.interp_gyroscope(i).Sensor([subjectdata.signalpoint.(task).delay:end],:);                    % Prepare IMU files
        IMU_data.interp_magnetometer(i).Sensor  = IMU_data.interp_magnetometer(i).Sensor([subjectdata.signalpoint.(task).delay:end],:);                 % Prepare IMU files
    end

    IMU_data.imutime                     = (1/subjectdata.fs_eeg):(1/subjectdata.fs_eeg):(length(IMU_data.interp_accelerometer(1).Sensor)/subjectdata.fs_eeg); 
    IMU_data.eegtime                     = (1/subjectdata.fs_eeg):(1/subjectdata.fs_eeg):(length(IMU_data.interp_accelerometer(1).Sensor)/subjectdata.fs_eeg); 
    end
   
   EEG_signal                           = EEG_File.dat.dataset_new;
   LFP_signal_R                         = LFP.interp_LFP_right; 
   LFP_signal_L                         = LFP.interp_LFP_left;
end


% VISUALIZE ALIGNED DATASETS
xstart                                  = subjectdata.signalpoint.(task).LFP_signal - subjectdata.signalpoint.(task).delay;

figure(4)
ax1 = subplot(3,1,1)
    plot(1:length(LFP_signal_R),LFP_signal_R, 'LineWidth',1,'Color','r')
    xlabel('Samples')
    xlim([xstart-5000 xstart+5000])
    legend('Right STN LFP','Box', 'off')
    title('LFP Signal')
    
ax2 = subplot(3,1,2)
    plot(1:length(EEG_signal), EEG_signal(end-1,:))
    xlabel('Samples')
    xlim([xstart-5000 xstart+5000])
    ylim([-2000 2000])
    legend('Impulse Generator [IPG]','Box', 'off')
    title('EEG Data - IPG')

    if exist("IMU_data")
ax3 = subplot(3,1,3)
    plot(1:length(IMU_data.interp_accelerometer(1).Sensor),IMU_data.interp_accelerometer(1).Sensor(:,1))
    xlabel('Samples')
    xlim([xstart-5000 xstart+5000])
    legend('Accelerometer')
    title('IMU')
    else; ax3 = subplot(3,1,3); end
    set(gcf,'color','white')
    sgtitle({'Aligned LFP dataset and EEG dataset'; sprintf('Trial: %s ', EEG_File.eeg)})
    linkaxes([ax1, ax2 ax3],'x')
    clear ax1 ax2 ax3 xstart EEG_pre_signal 

   
%Assign alligned Files back to the original file
LFP.LFP_signal_R                = LFP_signal_R;
LFP.LFP_signal_L                = LFP_signal_L;
LFP.LFP_time                    = (1/subjectdata.fs_eeg):(1/subjectdata.fs_eeg):(length(LFP_signal_R)/subjectdata.fs_eeg);
EEG_File.EEG_signal             = EEG_signal;
EEG_File.EEG_time               = (1/subjectdata.fs_eeg):(1/subjectdata.fs_eeg):(length(EEG_File.eegtime_new)/subjectdata.fs_eeg);
EEG_File                        = rmfield(EEG_File, {'eegtime'; 'dat'; 'data'; 'eegtime_new'});
LFP                             = rmfield(LFP, {'raw_lfp_left'; 'raw_lfp_right'; 'fs_lfp'; 'interp_LFP_right'; 'interp_LFP_left' });
if exist("IMU_data"); IMU_data  = rmfield(IMU_data, {'info'});end


%========================SAVING DATA ================================
if exist("IMU_data"); save([subjectdata.filepath filesep char(taskname) filesep 'motion' filesep filename '-' char(taskname) '_gaitalg.mat'], 'IMU_data', '-mat'); end
if exist("LFP");      save([subjectdata.filepath filesep char(taskname) filesep 'ieeg' filesep filename '-' char(taskname) '_lfpalg.mat'], 'LFP', '-mat'); end     
if exist("EEG_File"); save([subjectdata.filepath filesep char(taskname) filesep 'eeg' filesep filename '-' char(taskname) '_eegalg.mat'], 'EEG_File', '-mat'); end
% *********************** END OF SCRIPT ************************************************************************************************************************
