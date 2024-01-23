%% =====  Figure_5.m  ========================================%
%Date: December 2023
%Original author(s): Philipp Klocke, Moritz Loeffler

%This script will create figure 5 as seen in the manuscript


%Load files
subjectdata.generalpath                 = uigetdir;                                                                 % Specify filepath SenseFOG-main/Coherence-Data
cd(subjectdata.generalpath)
load("Walking_Files_Coherence.mat")                                                                                 % Load walking coherence files
load("Pre_Stopping_Files_Coherence.mat")                                                                            % Load pre-stop coherence files
load("Pre_Freezing_Files_Coherence.mat")                                                                            % Load pre-fog coherence files

Files.Walk      = Walking_Files_Coherence.Walk;
Files.Pre_Stop  = Pre_Stopping_Files.Pre_Stops;
Files.Pre_FoG   = Pre_Freezing_Files.Pre_FoGs;
f               = Pre_Freezing_Files.f;

%Create Subject-Average and Grand Average of IMU Signal ============================================
filenames   = {"Walk"; "Pre_Stop"; "Pre_FoG"};
store       = [];
for t = 1:length(filenames)
    names = unique({Files.(filenames{t}).name});
    for i = 1:length(names)
        subjectfiles = cat(1,Files.(filenames{t})(ismember(cat(1,{Files.(filenames{t}).name}), names{i}))); 
        store.(filenames{t})(i).mean_IMU       = mean(cat(3,subjectfiles.Gyroscope_rs),3);
        if isfield(subjectfiles, 'Toe_Off')
           store.(filenames{t})(i).TO             = mean(cat(3,subjectfiles.Toe_Off),3);
           store.(filenames{t})(i).MS             = mean(cat(3,subjectfiles.Midswing),3);
        elseif isfield(subjectfiles, 'TO_rel')
           store.(filenames{t})(i).TO             = mean(cat(3,subjectfiles.TO_rel),3);
           store.(filenames{t})(i).MS             = mean(cat(3,subjectfiles.MS_rel),3);
       end
    end
end
clear subjectfiles

Sensefog_ResultsTable(1).mode                 = "Walk"; 
Sensefog_ResultsTable(1).IMU_signal_mean      = deg2rad(mean(cat(3,store.Walk.mean_IMU),3));                        % Walk
Sensefog_ResultsTable(1).IMU_signal_std       = deg2rad(std(cat(1,store.Walk.mean_IMU)));
Sensefog_ResultsTable(1).TO                   = mean(cat(3,store.Walk.TO),3);
Sensefog_ResultsTable(1).MS                   = mean(cat(3,store.Walk.MS),3);
Sensefog_ResultsTable(2).mode                 = "Pre-Stop"; 
Sensefog_ResultsTable(2).IMU_signal_mean      = deg2rad(mean(cat(3,store.Pre_Stop.mean_IMU),3));                    % Pre-Stop
Sensefog_ResultsTable(2).IMU_signal_std       = deg2rad(std(cat(1,store.Pre_Stop.mean_IMU)));
Sensefog_ResultsTable(2).TO                   = mean(cat(3,store.Pre_Stop.TO),3);
Sensefog_ResultsTable(2).MS                   = mean(cat(3,store.Pre_Stop.MS),3);
Sensefog_ResultsTable(3).mode                 = "Pre-FoG"; 
Sensefog_ResultsTable(3).IMU_signal_mean      = deg2rad(mean(cat(3,store.Pre_FoG.mean_IMU),3));                     % Pre-FoG
Sensefog_ResultsTable(3).IMU_signal_std       = deg2rad(std(cat(1,store.Pre_FoG.mean_IMU)));
Sensefog_ResultsTable(3).TO                   = mean(cat(3,store.Pre_FoG.TO),3);
Sensefog_ResultsTable(3).MS                   = mean(cat(3,store.Pre_FoG.MS),3);


%Create Co-Contraction Pattern ========================================================================
filenames = {"Walk"; "Pre_Stop"; "Pre_FoG"};
for t = 1:length(filenames)
    datafile = Files.(filenames{t});
    for i = 1:length(datafile)
         q(i) = max(datafile(i).TA_env_rs);
         p(i) = max(datafile(i).GA_env_rs);
    end
    max_TA = mean(cat(1,q),2);                                                                                      % Tibialis (TA) Envelope
    max_GA = mean(cat(1,p),2);                                                                                      % Gastrocnemius (GA) Envelope
    clear q p i
    
    %Calculate the MEAN TA and GA Envelope and normalize as a percentage of the mean max amplitude
    mean_TA.(filenames{t}) = (mean(cat(1,datafile.TA_env_rs),1) ./ max_TA) * 100;
    mean_GA.(filenames{t}) = (mean(cat(1,datafile.GA_env_rs),1) ./ max_GA) * 100;

    muscle_1               = mean_TA.(filenames{t});
    muscle_2               = mean_GA.(filenames{t});
    
    for i=1:length(muscle_1)
        if muscle_1(:,i)<muscle_2(:,i)
            comum_m1_m2(:,i)=muscle_1(:,i);
        else comum_m1_m2(:,i)=muscle_2(:,i);
        end
    end
    coconix.(filenames{t}) = comum_m1_m2;
    clear muscle_1 muscle_2 comum_m1_m2 max_TA max_GA i datafile
end

Sensefog_ResultsTable(1).coconix      = coconix.Walk;                                                               % Walk
Sensefog_ResultsTable(2).coconix      = coconix.Pre_Stop;                                                           % Pre-Stop
Sensefog_ResultsTable(3).coconix      = coconix.Pre_FoG;                                                            % Pre-FoG
clear coconix mean_TA mean_GA

%Compute EMG ENVELOPES FOR TA and GA ====================================================================
filenames = {"Walk"; "Pre_Stop"; "Pre_FoG"};
for t = 1:length(filenames)
    datafile = Files.(filenames{t});
    TA_raw.(filenames{t}) = mean(cat(1,datafile.TA_rms_raw_rs),1);
    GA_raw.(filenames{t}) = mean(cat(1,datafile.GA_rms_raw_rs),1);
    clear datafile
end
Sensefog_ResultsTable(1).TA_raw = TA_raw.Walk;
Sensefog_ResultsTable(1).GA_raw = GA_raw.Walk;
Sensefog_ResultsTable(2).TA_raw = TA_raw.Pre_Stop;
Sensefog_ResultsTable(2).GA_raw = GA_raw.Pre_Stop;
Sensefog_ResultsTable(3).TA_raw = TA_raw.Pre_FoG;
Sensefog_ResultsTable(3).GA_raw = GA_raw.Pre_FoG;
clear TA_raw GA_raw 

%Compure Cohernece bands fore pre-specified band powers ==================================================
%Index for alpha band [8-12] and beta band [13-30]
index.alpha     =  f >= 8 & f < 13;
index.beta      =  f >= 13& f < 30;

%Create Coherence bands for pre-specified band powers
filenames       = {"Walk"; "Pre_Stop"; "Pre_FoG"};
frequency_bands = {'alpha'; 'beta'};
for t = 1:length(filenames)
    datafile = Files.(filenames{t});
    for i = 1:length(datafile)
        for k = 1:length(frequency_bands)
          store.STN_TA(i).(sprintf("%s" , frequency_bands{k}))  = ((mean(datafile(i).STN_TA_rs(index.(frequency_bands{k}),:)) - mean(mean(datafile(i).STN_TA_rs(index.(frequency_bands{k}),:)))) ./ mean(mean(datafile(i).STN_TA_rs(index.(frequency_bands{k}),:)))) * 100;
          store.STN_GA(i).(sprintf("%s" , frequency_bands{k}))  = ((mean(datafile(i).STN_GA_rs(index.(frequency_bands{k}),:)) - mean(mean(datafile(i).STN_GA_rs(index.(frequency_bands{k}),:)))) ./ mean(mean(datafile(i).STN_GA_rs(index.(frequency_bands{k}),:)))) * 100;
          store.TA_GA(i).(sprintf("%s" , frequency_bands{k}))   = ((mean(datafile(i).TA_GA_rs(index.(frequency_bands{k}),:))  - mean(mean(datafile(i).TA_GA_rs(index.(frequency_bands{k}),:)))) ./  mean(mean(datafile(i).TA_GA_rs(index.(frequency_bands{k}),:)))) * 100;
        end
    end
    Coherence_bands.(filenames{t}).STN_TA = store.STN_TA;
    Coherence_bands.(filenames{t}).STN_GA = store.STN_GA;
    Coherence_bands.(filenames{t}).TA_GA  = store.TA_GA;
    clear store datafile
end
clear t i k index

filenames       = {"Walk"; "Pre_Stop"; "Pre_FoG"};
frequency_bands = {'alpha'; 'beta'};
for t = 1:length(filenames)
    for k = 1:length(frequency_bands)
        Sensefog_ResultsTable(t).STN_TA_mean.(frequency_bands{k}) = mean(cat(1, Coherence_bands.(filenames{t}).STN_TA.(frequency_bands{k})),1);
        Sensefog_ResultsTable(t).STN_TA_std.(frequency_bands{k})  = std(cat(1,Coherence_bands.(filenames{t}).STN_TA.(frequency_bands{k})),1) ./ sqrt(length(Coherence_bands.(filenames{t}).STN_GA));
        Sensefog_ResultsTable(t).STN_GA_mean.(frequency_bands{k}) = mean(cat(1, Coherence_bands.(filenames{t}).STN_GA.(frequency_bands{k})),1);
        Sensefog_ResultsTable(t).STN_GA_std.(frequency_bands{k})  = std(cat(1,Coherence_bands.(filenames{t}).STN_GA.(frequency_bands{k})),1) ./ sqrt(length(Coherence_bands.(filenames{t}).STN_GA));
        Sensefog_ResultsTable(t).TA_GA_mean.(frequency_bands{k})  = mean(cat(1, Coherence_bands.(filenames{t}).TA_GA.(frequency_bands{k})),1);
        Sensefog_ResultsTable(t).TA_GA_std.(frequency_bands{k})   = std(cat(1,Coherence_bands.(filenames{t}).TA_GA.(frequency_bands{k})),1) ./ sqrt(length(Coherence_bands.(filenames{t}).TA_GA));
    end
end
clear index k t i frequency_bands filenames Coherence_bands


%% PLOT EMG ACTIVATION TOGETHER WITH Co-CONTRACTION INDICES

filepath        = subjectdata.generalpath; cd(filepath)
filepath        = extractBefore(filepath,"Time-Frequency-Data");   
filepath        = char(filepath);
filepath        = string(filepath(1:end-1));
filepath        = append(filepath,filesep, "Table & Figures"); cd(filepath)
addpath("customcolormap")

%Create a 5 x 3 matrix with Gyroscope, TA EMG Activation, GA EMG Activation, TA/GA Raw EMG traces and Co-Contraction Indices 
IMU_time        = 0.1:0.1:100; 
fs              = 1000;  
nfrq            = 200; 


%Color Ratio            %Y-Limits               %X-Limits               %Alpha-Level
a = -0.5; b = 0.5;      y1 = 5; y2 = 40;        x1 = 0; x2 = 100;       alpha = 0.2; %Determine facealpha 

figure(2332143)
t0 = tiledlayout(4,3,'TileSpacing','compact','Padding','compact');
t1 = tiledlayout(t0,3,1);
t1.Layout.Tile = 1;
t1.Layout.TileSpan = [1, 1];

%REGULAR GAIT ===========================================================================
nexttile(t1,[1,1]) %IMU ACCELEROMETER and GYROSCOPE
    plot(IMU_time, -Sensefog_ResultsTable(1).IMU_signal_mean, 'k')    
    hold on 
    patch([IMU_time flip(IMU_time)],[(-Sensefog_ResultsTable(1).IMU_signal_mean + -Sensefog_ResultsTable(1).IMU_signal_std) flip(-Sensefog_ResultsTable(1).IMU_signal_mean - -Sensefog_ResultsTable(1).IMU_signal_std)], 'k','FaceAlpha',0.1, 'EdgeColor', 'none');
    xline(Sensefog_ResultsTable(1).TO,'k--',{"ips. TO"}, 'LineWidth',1,'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'top','FontSize', 8)
    xline(Sensefog_ResultsTable(1).MS,'k--',{"ips. MS"},  'LineWidth',1,'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'bottom','FontSize', 8)
    xline(50,'k--',{"ctrl. HS"},  'LineWidth',1,'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'top','FontSize', 8)
    set(gca,'xtick',[]); box off; set(gca,'XColor','none');
    ylabel({'Angular Velocity';'[deg./s]'},'FontSize',10); ylim([-200 250])
     title('Walking Gait Cycle','FontWeight','normal')

nexttile(t1,[2,1]) % RAW RMS EMG Tibialis and Gastrocnemius muscle
    pt1 = plot(IMU_time, Sensefog_ResultsTable(1).TA_raw,'b-','DisplayName','Raw EMG TA');
    hold on 
    pt2 = plot(IMU_time, Sensefog_ResultsTable(1).GA_raw,'r-','DisplayName','Raw EMG GA');
    xline(Sensefog_ResultsTable(1).TO,'k--','LineWidth',0.5)
    xline(Sensefog_ResultsTable(1).MS,'k--','LineWidth',0.5)
    xline(50,'k--','LineWidth',0.5)
    ylim([0 150]); ylabel({'Amplitude'; '[RMS µV]'},'FontSize',10)
    legend([pt1 pt2], 'Location','northwest','Orientation','vertical','Box', 'off')
    set(gca,'xtick',[]); box off; set(gca,'XColor','none');
    title('RMS EMG Signal','FontWeight','normal')
 
t2 = tiledlayout(t0,4,1);
t2.Layout.Tile = 4;
t2.Layout.TileSpan = [1, 1]; 
nexttile(t2,[2,1]) %Regular Gait RAW EMG FILES
     p1 = plot(IMU_time,Sensefog_ResultsTable(1).STN_TA_mean.alpha,'Color', [0 0.4470 0.7410],'LineWidth', 1.5,'DisplayName', 'STN-TA');
     hold on
     p2 = plot(IMU_time, Sensefog_ResultsTable(1).STN_GA_mean.alpha,'Color', [0.7 0 0],'LineWidth', 1.5,'DisplayName', 'STN-GA');
     patch([IMU_time flip(IMU_time)],[(Sensefog_ResultsTable(1).STN_TA_mean.alpha + Sensefog_ResultsTable(1).STN_TA_std.alpha) flip(Sensefog_ResultsTable(1).STN_TA_mean.alpha - Sensefog_ResultsTable(1).STN_TA_std.alpha)], [0 0.4470 0.7410],'FaceAlpha',0.2, 'EdgeColor', 'none');
     patch([IMU_time flip(IMU_time)],[(Sensefog_ResultsTable(1).STN_GA_mean.alpha + Sensefog_ResultsTable(1).STN_GA_std.alpha) flip(Sensefog_ResultsTable(1).STN_GA_mean.alpha - Sensefog_ResultsTable(1).STN_GA_std.alpha)], [0.7 0 0],'FaceAlpha',0.2, 'EdgeColor', 'none');
     xline(Sensefog_ResultsTable(1).TO,'k--','LineWidth',0.5)
     xline(Sensefog_ResultsTable(1).MS,'k--','LineWidth',0.5)
     xline(50,'k--','LineWidth',0.5)
     ylabel(t2,{'%-Change from Mean'; 'Magnitude Squared Coherence'},'FontSize',10)
     set(gca,'XColor','none'); set(gca,'xtick',[]); box off
     ylim([-30 45])
     yline(0,'k-','Linewidth',1);
     title('Subthalamo-muscular and intermuscular coherence','[Alpha 8-12 Hz]','FontWeight','normal');
     
nexttile(t2,[2,1])
    p3 = plot(IMU_time, Sensefog_ResultsTable(1).TA_GA_mean.alpha,'Color', '#7E2F8E','LineWidth', 1.5,'DisplayName', 'TA-GA');
    hold on 
    patch([IMU_time flip(IMU_time)],[(Sensefog_ResultsTable(1).TA_GA_mean.alpha + Sensefog_ResultsTable(1).TA_GA_std.alpha) flip(Sensefog_ResultsTable(1).TA_GA_mean.alpha - Sensefog_ResultsTable(1).TA_GA_std.alpha)], [0.4940 0.1840 0.5560],'FaceAlpha',0.2, 'EdgeColor', 'none');
    xline(Sensefog_ResultsTable(1).TO,'k--','LineWidth',0.5)
    xline(Sensefog_ResultsTable(1).MS,'k--','LineWidth',0.5)
    xline(50,'k--','LineWidth',0.5)
    yline(0,'k-','Linewidth',1);
    legend([p1 p2 p3], "Location", "northwest",'NumColumns', 3, 'Box', 'off')
    ylim([-30 45]);
    set(gca,'xtick',[]); box off; set(gca,'XColor','none');
   
t3 = tiledlayout(t0,4,1);
t3.Layout.Tile = 7;
t3.Layout.TileSpan = [1, 1];
nexttile(t3,[2,1]) %Regular Gait RAW EMG FILES
     p1 = plot(IMU_time, Sensefog_ResultsTable(1).STN_TA_mean.beta,'Color', [0 0.4470 0.7410],'LineWidth', 1.5,'DisplayName', 'STN-TA');
     hold on
     p2 = plot(IMU_time, Sensefog_ResultsTable(1).STN_GA_mean.beta,'Color', [0.7 0 0],'LineWidth', 1.5,'DisplayName', 'STN-GA');
     patch([IMU_time flip(IMU_time)],[(Sensefog_ResultsTable(1).STN_TA_mean.beta + Sensefog_ResultsTable(1).STN_TA_std.beta) flip(Sensefog_ResultsTable(1).STN_TA_mean.beta - Sensefog_ResultsTable(1).STN_TA_std.beta)], [0 0.4470 0.7410],'FaceAlpha',0.2, 'EdgeColor', 'none');
     patch([IMU_time flip(IMU_time)],[(Sensefog_ResultsTable(1).STN_GA_mean.beta + Sensefog_ResultsTable(1).STN_GA_std.beta) flip(Sensefog_ResultsTable(1).STN_GA_mean.beta - Sensefog_ResultsTable(1).STN_GA_std.beta)], [0.7 0 0],'FaceAlpha',0.2, 'EdgeColor', 'none');
     xline(Sensefog_ResultsTable(1).TO,'k--','LineWidth',0.5)
     xline(Sensefog_ResultsTable(1).MS,'k--','LineWidth',0.5)
     xline(50,'k--','LineWidth',0.5)
     yline(0,'k-','Linewidth',1);
     ylabel(t3,{'%-Change from Mean'; 'Magnitude Squared Coherence'},'FontSize', 10)
     set(gca,'XColor','none'); set(gca,'xtick',[]); box off
     ylim([-30.5 33]);
     title({'[Beta 13-30 Hz]'}, 'FontWeight', 'normal');
     

nexttile(t3,[2,1])
    p3 = plot(IMU_time, Sensefog_ResultsTable(1).TA_GA_mean.beta,'Color', '#7E2F8E','LineWidth', 1.5,'DisplayName', 'TA-GA');
    hold on 
    patch([IMU_time flip(IMU_time)],[(Sensefog_ResultsTable(1).TA_GA_mean.beta + Sensefog_ResultsTable(1).TA_GA_std.beta) flip(Sensefog_ResultsTable(1).TA_GA_mean.beta - Sensefog_ResultsTable(1).TA_GA_std.beta)], [0.4940 0.1840 0.5560],'FaceAlpha',0.2, 'EdgeColor', 'none');
    xline(Sensefog_ResultsTable(1).TO,'k--','LineWidth',0.5)
    xline(Sensefog_ResultsTable(1).MS,'k--','LineWidth',0.5)
    xline(50,'k--','LineWidth',0.5)
    yline(0,'k-','Linewidth',1);
    legend([p1 p2 p3], "Location", "northwest",'NumColumns', 3, 'Box', 'off')
    ylim([-30.5 33]);
    set(gca,'xtick',[]); box off; set(gca,'XColor','none');
    
t4 = tiledlayout(t0,1,1);
t4.Layout.Tile = 10;
t4.Layout.TileSpan = [1, 1];
nexttile(t4) %Regular Gait Cocontraction Index
    area(IMU_time, Sensefog_ResultsTable(1).coconix,'EdgeColor','black' ,'FaceColor',[0.7 0.7 0.7], 'FaceAlpha', alpha,'DisplayName', 'Walking'); %REGULAR GAIT
    xline(Sensefog_ResultsTable(1).TO,'k--','LineWidth',0.5)
    xline(Sensefog_ResultsTable(1).MS,'k--','LineWidth',0.5)
    xline(50,'k--','LineWidth',0.5)
    title('Co-Contraction','FontWeight','normal')
    xlabel('Walking Gait Cycle [%]','FontSize',10);  ylabel('% Mean Max. Ampl.','FontSize',10);box off
    ylim([0 53])



% PRE STOP PLOTS ============================================================================================================================================================================================================================================================
t5 = tiledlayout(t0,3,1);
t5.Layout.Tile = 2;
t5.Layout.TileSpan = [1, 1];
nexttile(t5,[1,1]) %IMU ACCELEROMETER and GYROSCOPE
    plot(IMU_time, -Sensefog_ResultsTable(2).IMU_signal_mean, 'k')
    hold on 
    patch([IMU_time flip(IMU_time)],[(-Sensefog_ResultsTable(2).IMU_signal_mean + -Sensefog_ResultsTable(2).IMU_signal_std) flip(-Sensefog_ResultsTable(2).IMU_signal_mean - -Sensefog_ResultsTable(2).IMU_signal_std)], 'k','FaceAlpha',0.1, 'EdgeColor', 'none');
    xline(Sensefog_ResultsTable(2).TO,'k--',{"ips. TO"}, 'LineWidth',1,'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'top','FontSize', 8)
    xline(Sensefog_ResultsTable(2).MS,'k--',{"ips. MS"},  'LineWidth',1,'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'bottom','FontSize', 8)
    xline(50,'k--',{"ctrl. HS"},  'LineWidth',1,'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'top','FontSize', 8)
    set(gca,'xtick',[]); box off; set(gca,'XColor','none'); ylim([-200 250])
    title('Pre-Stop Gait Cycle','FontWeight','normal')

nexttile(t5,[2,1]) %RAW RMS EMG TRACE Tibialis and Gastrocnemius PRE-STOP
    plot(IMU_time, Sensefog_ResultsTable(2).TA_raw,'b-','DisplayName','Raw EMG TA')
    hold on 
    plot(IMU_time,Sensefog_ResultsTable(2).GA_raw ,'r-','DisplayName','Raw EMG GA')
    xline(Sensefog_ResultsTable(2).TO,'k--','LineWidth',0.5)
    xline(Sensefog_ResultsTable(2).MS,'k--','LineWidth',0.5)
    xline(50,'k--','LineWidth',0.5)
    ylim([0 150]); %ylabel('Amplitude [RMS µV]')
    set(gca,'xtick',[]); box off; set(gca,'XColor','none');
    title('RMS EMG Signal','FontWeight','normal')

     
t6 = tiledlayout(t0,4,1); 
t6.Layout.Tile = 5;
t6.Layout.TileSpan = [1, 1];
nexttile(t6,[2,1]) %COHERENCE PRE-STOP ALPHA [8-12 HZ]
    p1 = plot(IMU_time, Sensefog_ResultsTable(2).STN_TA_mean.alpha,'Color', [0 0.4470 0.7410],'LineWidth', 1.5,'DisplayName', 'STN-TA');
    hold on
    p2 = plot(IMU_time, Sensefog_ResultsTable(2).STN_GA_mean.alpha,'Color',[0.7 0 0],'LineWidth', 1.5,'DisplayName', 'STN-GA');
    patch([IMU_time flip(IMU_time)],[(Sensefog_ResultsTable(2).STN_TA_mean.alpha + Sensefog_ResultsTable(2).STN_TA_std.alpha) flip(Sensefog_ResultsTable(2).STN_TA_mean.alpha - Sensefog_ResultsTable(2).STN_TA_std.alpha)], [0 0.4470 0.7410],'FaceAlpha',0.2, 'EdgeColor', 'none');
    patch([IMU_time flip(IMU_time)],[(Sensefog_ResultsTable(2).STN_GA_mean.alpha + Sensefog_ResultsTable(2).STN_GA_std.alpha) flip(Sensefog_ResultsTable(2).STN_GA_mean.alpha - Sensefog_ResultsTable(2).STN_GA_std.alpha)], [0.7 0 0],'FaceAlpha',0.2, 'EdgeColor', 'none');
    ylim([-30 45])
    xline(Sensefog_ResultsTable(2).TO,'k--','LineWidth',0.5)
    xline(Sensefog_ResultsTable(2).MS,'k--','LineWidth',0.5)
    xline(50,'k--','LineWidth',0.5)
    title({'Subthalamo-muscular and intermuscular coherence'; '[Alpha 8-12 Hz]'}, 'FontWeight', 'normal');
    set(gca,'xtick',[]); box off; set(gca,'XColor','none');

nexttile(t6,[2,1])
    p3 = plot(IMU_time, Sensefog_ResultsTable(2).TA_GA_mean.alpha,'Color', 	'#7E2F8E','LineWidth', 1.5,'DisplayName', 'TA-GA');
    patch([IMU_time flip(IMU_time)],[(Sensefog_ResultsTable(2).TA_GA_mean.alpha + Sensefog_ResultsTable(2).TA_GA_std.alpha) flip(Sensefog_ResultsTable(2).TA_GA_mean.alpha - Sensefog_ResultsTable(2).TA_GA_std.alpha)], [0.4940 0.1840 0.5560],'FaceAlpha',0.2, 'EdgeColor', 'none');
    ylim([-30 45])
    yline(0,'k-','LineWidth',1);
    xline(Sensefog_ResultsTable(2).TO,'k--','LineWidth',0.5)
    xline(Sensefog_ResultsTable(2).MS,'k--','LineWidth',0.5)
    xline(50,'k--','LineWidth',0.5)
    set(gca,'xtick',[]); box off; set(gca,'XColor','none');
       
t7 = tiledlayout(t0,4,1);
t7.Layout.Tile = 8;
t7.Layout.TileSpan = [1, 1];
nexttile(t7,[2,1]) %COHERENCE PRE-STOP BETA [13-30 HZ]
    p1 = plot(IMU_time, Sensefog_ResultsTable(2).STN_TA_mean.beta,'Color', 	[0 0.4470 0.7410],'LineWidth', 1.5,'DisplayName', 'STN-TA');
    hold on
    p2 = plot(IMU_time, Sensefog_ResultsTable(2).STN_GA_mean.beta,'Color',[0.7 0 0],'LineWidth', 1.5,'DisplayName', 'STN-GA');
    patch([IMU_time flip(IMU_time)],[(Sensefog_ResultsTable(2).STN_TA_mean.beta + Sensefog_ResultsTable(2).STN_TA_std.beta) flip(Sensefog_ResultsTable(2).STN_TA_mean.beta - Sensefog_ResultsTable(2).STN_TA_std.beta)], [0 0.4470 0.7410],'FaceAlpha',0.2, 'EdgeColor', 'none');
    patch([IMU_time flip(IMU_time)],[(Sensefog_ResultsTable(2).STN_GA_mean.beta + Sensefog_ResultsTable(2).STN_GA_std.beta) flip(Sensefog_ResultsTable(2).STN_GA_mean.beta - Sensefog_ResultsTable(2).STN_GA_std.beta)], [0.7 0 0],'FaceAlpha',0.2, 'EdgeColor', 'none');
    ylim([-30.5 33]);
    yline(0,'k-','LineWidth',1);
    xline(Sensefog_ResultsTable(2).TO,'k--','LineWidth',0.5)
    xline(Sensefog_ResultsTable(2).MS,'k--','LineWidth',0.5)
    xline(50,'k--','LineWidth',0.5)
    title({'[Beta 13-30 Hz]'}, 'FontWeight', 'normal');
    set(gca,'xtick',[]); box off; set(gca,'XColor','none');

nexttile(t7,[2,1])
    p3 = plot(IMU_time, Sensefog_ResultsTable(2).TA_GA_mean.beta,'Color', 	'#7E2F8E','LineWidth', 1.5,'DisplayName', 'TA-GA');
    patch([IMU_time flip(IMU_time)],[(Sensefog_ResultsTable(2).TA_GA_mean.beta + Sensefog_ResultsTable(2).TA_GA_std.beta) flip(Sensefog_ResultsTable(2).TA_GA_mean.beta - Sensefog_ResultsTable(2).TA_GA_std.beta)], [0.4940 0.1840 0.5560],'FaceAlpha',0.2, 'EdgeColor', 'none');
    ylim([-30.5 33]);
    yline(0,'k-','LineWidth',1);
    xline(Sensefog_ResultsTable(2).TO,'k--','LineWidth',0.5)
    xline(Sensefog_ResultsTable(2).MS,'k--','LineWidth',0.5)
    xline(50,'k--','LineWidth',0.5)
    set(gca,'xtick',[]); box off; set(gca,'XColor','none');


t8 = tiledlayout(t0,1,1);
t8.Layout.Tile = 11;
t8.Layout.TileSpan = [1, 1];
nexttile(t8) %Pre-STOP Cocontraction Index
    area(IMU_time, Sensefog_ResultsTable(2).coconix, 'EdgeColor','black','FaceColor',[0.7 0.7 0.7], 'FaceAlpha', alpha,'DisplayName', 'Pre-STOP'); %Pre-STOP
    xline(Sensefog_ResultsTable(2).TO,'k--','LineWidth',0.5)
    xline(Sensefog_ResultsTable(2).MS,'k--','LineWidth',0.5)
    xline(50,'k--','LineWidth',0.5)
    xlabel('Pre-Stop Gait Cycle [%]','FontSize',10); box off
    title('Co-Contraction','FontWeight','normal')
    ylim([0 53])


% PRE FOG PLOTS ==================================== ==================================== ==================================== ====================================
t9 = tiledlayout(t0,3,1);
t9.Layout.Tile = 3;
t9.Layout.TileSpan = [1, 1];
nexttile(t9,[1,1]) %IMU ACCELEROMETER and GYROSCOPE
    plot(IMU_time, -Sensefog_ResultsTable(3).IMU_signal_mean, 'k')
    hold on 
    patch([IMU_time flip(IMU_time)],[(-Sensefog_ResultsTable(3).IMU_signal_mean + -Sensefog_ResultsTable(3).IMU_signal_std) flip(-Sensefog_ResultsTable(3).IMU_signal_mean - -Sensefog_ResultsTable(3).IMU_signal_std)], 'k','FaceAlpha',0.1, 'EdgeColor', 'none');
    xline(Sensefog_ResultsTable(2).TO,'k--',{"ips. TO"}, 'LineWidth',1,'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'top','FontSize', 8)
    xline(Sensefog_ResultsTable(2).MS,'k--',{"ips. MS"},  'LineWidth',1,'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'bottom','FontSize', 8)
    xline(50,'k--',{"ctrl. HS"}, 'LineWidth', 1,'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'bottom','FontSize', 8)
    set(gca,'xtick',[]); box off; set(gca,'XColor','none');ylim([-200 250])
    title('Pre-FoG Gait Cycle','FontWeight','normal')

nexttile(t9,[2,1]) %Pre-STOP RAW EMG FILES
    plot(IMU_time, Sensefog_ResultsTable(3).TA_raw,'b-','DisplayName','Raw EMG TA')
    hold on 
    plot(IMU_time, Sensefog_ResultsTable(3).GA_raw,'r-','DisplayName','Raw EMG GA')
    xline(Sensefog_ResultsTable(3).TO,'k--','LineWidth',0.5)
    xline(Sensefog_ResultsTable(3).MS,'k--','LineWidth',0.5)
    xline(50,'k--','LineWidth', 0.5)
    ylim([0 150]); %ylabel('Amplitude [RMS µV]')
    set(gca,'xtick',[]); box off; set(gca,'XColor','none');
    title('RMS EMG Signal','FontWeight','normal')

    
t10 = tiledlayout(t0,4,1);
t10.Layout.Tile = 6;
t10.Layout.TileSpan = [1, 1];
nexttile(t10,[2,1]) %COHERENCE PRE-FOG [ALPHA 8-13 Hz]
    p1 = plot(IMU_time, Sensefog_ResultsTable(3).STN_TA_mean.alpha,'Color', 	[0 0.4470 0.7410],'LineWidth', 1.5,'DisplayName', 'STN-TA');
    hold on 
    p2 = plot(IMU_time, Sensefog_ResultsTable(3).STN_GA_mean.alpha,'Color', 	[0.7 0 0],'LineWidth', 1.5,'DisplayName', 'STN-GA');
    patch([IMU_time flip(IMU_time)],[(Sensefog_ResultsTable(3).STN_TA_mean.alpha + Sensefog_ResultsTable(3).STN_TA_std.alpha) flip(Sensefog_ResultsTable(3).STN_TA_mean.alpha - Sensefog_ResultsTable(3).STN_TA_std.alpha)], [0 0.4470 0.7410],'FaceAlpha',0.2, 'EdgeColor', 'none');
    patch([IMU_time flip(IMU_time)],[(Sensefog_ResultsTable(3).STN_GA_mean.alpha + Sensefog_ResultsTable(3).STN_GA_std.alpha) flip(Sensefog_ResultsTable(3).STN_GA_mean.alpha - Sensefog_ResultsTable(3).STN_GA_std.alpha)], [0.7 0 0],'FaceAlpha',0.2, 'EdgeColor', 'none');
    ylim([-30 45])
    yline(0,'k-','LineWidth',1);
    xline(Sensefog_ResultsTable(3).TO,'k--','LineWidth',0.5)
    xline(Sensefog_ResultsTable(3).MS,'k--','LineWidth',0.5)
    xline(50,'k--','LineWidth', 0.5)
    title({'Subthalamo-muscular and intermuscular coherence'; '[Alpha 8-12 Hz]'}, 'FontWeight', 'normal');
    set(gca,'xtick',[]); box off; set(gca,'XColor','none');

nexttile(t10,[2,1])
    p3 = plot(IMU_time, Sensefog_ResultsTable(3).TA_GA_mean.alpha,'Color', 	'#7E2F8E','LineWidth', 1.5,'DisplayName', 'TA-GA');
    hold on 
    patch([IMU_time flip(IMU_time)],[(Sensefog_ResultsTable(3).TA_GA_mean.alpha + Sensefog_ResultsTable(3).TA_GA_std.alpha) flip(Sensefog_ResultsTable(3).TA_GA_mean.alpha - Sensefog_ResultsTable(3).TA_GA_std.alpha)], [0.4940 0.1840 0.5560],'FaceAlpha',0.2, 'EdgeColor', 'none');
    ylim([-30 45])
    yline(0,'k-','LineWidth',1);
    xline(Sensefog_ResultsTable(3).TO,'k--','LineWidth',0.5)
    xline(Sensefog_ResultsTable(3).MS,'k--','LineWidth',0.5)
    xline(50,'k--','LineWidth', 0.5)
    set(gca,'xtick',[]); box off; set(gca,'XColor','none');


t11 = tiledlayout(t0,4,1);
t11.Layout.Tile = 9;
t11.Layout.TileSpan = [1, 1];
nexttile(t11,[2,1]) %COHERENCE Pre-FOG [BETA 13-30 Hz]
    p1 = plot(IMU_time, Sensefog_ResultsTable(3).STN_TA_mean.beta,'Color', 	[0 0.4470 0.7410],'LineWidth', 1.5,'DisplayName', 'STN-TA');
    hold on 
    p2 = plot(IMU_time, Sensefog_ResultsTable(3).STN_GA_mean.beta,'Color', 	[0.7 0 0],'LineWidth', 1.5,'DisplayName', 'STN-GA');
    patch([IMU_time flip(IMU_time)],[(Sensefog_ResultsTable(3).STN_TA_mean.beta + Sensefog_ResultsTable(3).STN_TA_std.beta) flip(Sensefog_ResultsTable(3).STN_TA_mean.beta - Sensefog_ResultsTable(3).STN_TA_std.beta)], [0 0.4470 0.7410],'FaceAlpha',0.2, 'EdgeColor', 'none');
    patch([IMU_time flip(IMU_time)],[(Sensefog_ResultsTable(3).STN_GA_mean.beta + Sensefog_ResultsTable(3).STN_GA_std.beta) flip(Sensefog_ResultsTable(3).STN_GA_mean.beta - Sensefog_ResultsTable(3).STN_GA_std.beta)], [0.7 0 0],'FaceAlpha',0.2, 'EdgeColor', 'none');
    ylim([-30.5 33]);
    yline(0,'k-','LineWidth',1);
    xline(Sensefog_ResultsTable(3).TO,'k--','LineWidth',0.5)
    xline(Sensefog_ResultsTable(3).MS,'k--','LineWidth',0.5)
    xline(50,'k--','LineWidth', 0.5)
    title({'[Beta 13-30 Hz]'}, 'FontWeight', 'normal');
    set(gca,'xtick',[]); box off; set(gca,'XColor','none');

nexttile(t11,[2,1])
    p3 = plot(IMU_time, Sensefog_ResultsTable(3).TA_GA_mean.beta,'Color', 	'#7E2F8E','LineWidth', 1.5,'DisplayName', 'TA-GA');
    hold on 
    patch([IMU_time flip(IMU_time)],[(Sensefog_ResultsTable(3).TA_GA_mean.beta + Sensefog_ResultsTable(3).TA_GA_std.beta) flip(Sensefog_ResultsTable(3).TA_GA_mean.beta - Sensefog_ResultsTable(3).TA_GA_std.beta)], [0.4940 0.1840 0.5560],'FaceAlpha',0.2, 'EdgeColor', 'none');
    ylim([-30.5 33]);
    yline(0,'k-','LineWidth',1);
    xline(Sensefog_ResultsTable(3).TO,'k--','LineWidth',0.5)
    xline(Sensefog_ResultsTable(3).MS,'k--','LineWidth',0.5)
    xline(50,'k--','LineWidth', 0.5)
    set(gca,'xtick',[]); box off; set(gca,'XColor','none');
     
     
t14 = tiledlayout(t0,1,1);
t14.Layout.Tile = 12;
t14.Layout.TileSpan = [1, 1];
nexttile(t14) %Pre-FOG Cocontraction Index
    area(IMU_time, Sensefog_ResultsTable(3).coconix,'EdgeColor','black', 'FaceColor',[0.7 0.7 0.7], 'FaceAlpha', alpha,'DisplayName', 'Pre-FOG'); %Pre-FOG
    xline(Sensefog_ResultsTable(3).TO,'k--','LineWidth',0.5)
    xline(Sensefog_ResultsTable(3).MS,'k--','LineWidth',0.5)
    xline(50,'k--','LineWidth', 0.5)
    xlabel('Pre-FoG Gait Cycle [%]','FontSize',10); box off
    title('Co-Contraction','FontWeight','normal')
    ylim([0 53])
    set(gcf,'Color','White')


a = annotation('textbox',[0.02 0.80 .2 .2],'String','a','EdgeColor','none'); a.FontSize = 18; a.FontWeight = "bold";
b = annotation('textbox',[0.02 0.71 .2 .2],'String','b','EdgeColor','none'); b.FontSize = 18; b.FontWeight = "bold";
c = annotation('textbox',[0.02 0.55 .2 .2],'String','c','EdgeColor','none'); c.FontSize = 18; c.FontWeight = "bold";
d = annotation('textbox',[0.02 0.31 .2 .2],'String','d','EdgeColor','none'); d.FontSize = 18; d.FontWeight = "bold";
e = annotation('textbox',[0.02 0.07 .2 .2],'String','e','EdgeColor','none'); e.FontSize = 18; e.FontWeight = "bold";

clear a b ans c C i k m t x1 x2 y1 y2 fs t0 t1 t2 t3 t4 nfrq pt1 pt2 c d e f g h i j k l m alpha
clear a b c d e f g h fs i k index p1 p2 p3 nfrq t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 x1 x2 y1 y2 C

%Save Figure
cd(filepath)
saveas(gcf,'Figure_4')
%************************************END OF SCRIPT***********************************************************************
