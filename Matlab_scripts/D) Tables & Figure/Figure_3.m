%% =====  Figure_3.m  ========================================%
%Date: December 2023
%Original author(s): Philipp Klocke, Moritz Loeffler

%This script will call the time-frequency information for Stop, Pre-Stop, FoG and Pre-FoG,
%perform cluster-based permutation analysis and plot the figures as seen in
%the manuskript file. Make sure Fieldtrip is installed and added to the
%filepath.

subjectdata.generalpath                 = uigetdir;                                                                 % Specify filepath SenseFOG-main/Time-Frequency-Data
cd(subjectdata.generalpath)                                                                                         
load("Stopping_Files.mat")                                                                                          % Load stopping files
load("Freezing_Files.mat")                                                                                          % Load freezing files
load("Pre_Stopping_Files.mat")                                                                                      % Load pre-stop files
load("Pre_Freezing_Files.mat")                                                                                      % Load pre-fog files


f                     = Pre_Stopping_Files.frequencies;
Files.Pre_Fog         = Pre_Freezing_Files.Pre_Fogs;
Files.Pre_Stop        = Pre_Stopping_Files.Pre_Stops;
Files.Stop            = Stopping_Files;
Files.Fog             = Freezing_Files; 

filenames = {'Stop'; 'Fog';'Pre_Stop'; 'Pre_Fog'};

%Create Subject-Average and Grand Average of IMU Signals
for t = 1:length(filenames)
    names = unique({Files.(filenames{t}).name});
    for i = 1:length(names)
        subjectfiles = cat(1,Files.(filenames{t})(ismember(cat(1,{Files.(filenames{t}).name}), names{i}))); 
        if isfield(subjectfiles, 'IMU_signal')
        store.(filenames{t})(i).mean_IMU       = mean(cat(3,subjectfiles.IMU_signal),3);
        elseif isfield(subjectfiles,'IMU_signal_rs')
        store.(filenames{t})(i).mean_IMU  = mean(cat(3,subjectfiles.IMU_signal_rs),3); 
        elseif isfield(subjectfiles,'IMU')
        store.(filenames{t})(i).mean_IMU  = mean(cat(3,subjectfiles.IMU),3); end
        if isfield(subjectfiles, 'Toe_Off')
        store.(filenames{t})(i).mean_Toe_Off   = mean(cat(3,subjectfiles.Toe_Off),3);
        store.(filenames{t})(i).mean_Midswing  = mean(cat(3,subjectfiles.Midswing),3);end
    end
end

%Stop
Sensefog_ResultsTable(1).time                 = linspace(1,size(Files.Stop(1).wt,2),size(Files.Stop(1).wt,2));
Sensefog_ResultsTable(1).nfrq                 = 200;
Sensefog_ResultsTable(1).event_name           = "Stop";
Sensefog_ResultsTable(1).baseline_name        = "Standing";
Sensefog_ResultsTable(1).title                = "Stop vs. Standing";
Sensefog_ResultsTable(1).IMU_signal_mean      = mean(cat(3,store.Stop.mean_IMU),3);
Sensefog_ResultsTable(1).IMU_signal_std       = std(cat(1,store.Stop.mean_IMU));

%FoG
Sensefog_ResultsTable(2).time                 = linspace(1,size(Files.Fog(1).wt,2),size(Files.Fog(1).wt,2));
Sensefog_ResultsTable(2).nfrq                 = 200;
Sensefog_ResultsTable(2).event_name           = "FoG";
Sensefog_ResultsTable(2).baseline_name        = "Standing";
Sensefog_ResultsTable(2).title                = "FoG vs. Standing";
Sensefog_ResultsTable(2).IMU_signal_mean      = mean(cat(3,store.Fog.mean_IMU),3);
Sensefog_ResultsTable(2).IMU_signal_std       = std(cat(1,store.Fog.mean_IMU));

%Pre-Stop
Sensefog_ResultsTable(3).time                 = linspace(1,size(Files.Pre_Stop(1).wt_rs,2),size(Files.Pre_Stop(1).wt_rs,2));
Sensefog_ResultsTable(3).nfrq                 = 200;
Sensefog_ResultsTable(3).event_name           = "Pre-Stop";
Sensefog_ResultsTable(3).baseline_name        = "Standing";
Sensefog_ResultsTable(3).title                = "Pre-Stop vs. Standing";
Sensefog_ResultsTable(3).IMU_signal_mean      = mean(cat(3,store.Pre_Stop.mean_IMU),3);
Sensefog_ResultsTable(3).IMU_signal_std       = std(cat(1,store.Pre_Stop.mean_IMU));
Sensefog_ResultsTable(3).ctrl_TO              = mean(cat(3,store.Pre_Stop.mean_Toe_Off),3);
Sensefog_ResultsTable(3).ctrl_MS              = mean(cat(3,store.Pre_Stop.mean_Midswing),3);

%Pre-Fog
Sensefog_ResultsTable(4).time                 = linspace(1,size(Files.Pre_Fog(1).wt_rs,2),size(Files.Pre_Fog(1).wt_rs,2));
Sensefog_ResultsTable(4).nfrq                 = 200;
Sensefog_ResultsTable(4).event_name           = "Pre-FoG";
Sensefog_ResultsTable(4).baseline_name        = "Standing";
Sensefog_ResultsTable(4).title                = "Pre-FoG vs. Standing";
Sensefog_ResultsTable(4).IMU_signal_mean      = mean(cat(3,store.Pre_Fog.mean_IMU),3);
Sensefog_ResultsTable(4).IMU_signal_std       = std(cat(1,store.Pre_Fog.mean_IMU));
Sensefog_ResultsTable(4).ctrl_TO              = mean(cat(3,store.Pre_Fog.mean_Toe_Off),3);
Sensefog_ResultsTable(4).ctrl_MS              = mean(cat(3,store.Pre_Fog.mean_Midswing),3);

%Clean-UP
clear store idx

%Prepare Files for Non-parametric Cluster-based Permutation Analysis
filenames = {'Stop'; 'Fog';'Pre_Stop'; 'Pre_Fog'};

for t = 1:length(filenames)

    %Prepare Files for Statistical Analysis
    input_file                  = Files.(filenames{t});
        
    eventfile       = []; baseline        = [];
    for i = 1:length(input_file)
        if isfield(input_file, 'wt') 
            eventfile(i).file(1,:,:) = input_file(i).wt;
            baseline(i).file(1,:,:)  = [zeros(size(input_file(i).wt))];
        elseif isfield(input_file, 'wt_standing')
            eventfile(i).file(1,:,:) = input_file(i).wt_standing;
            baseline(i).file(1,:,:)  = [zeros(size(input_file(i).wt_standing))];end
    end
    
    %******************************************************************************************
    % NON-PARAMETRIC DEPENDENT SAMPLING CLUSTER-BASED PERMUTAITON TESTING
    %******************************************************************************************
    % Description: Files need to be of the size [frequency x time] or Frequency-Domain Plots
    trial_group_2           = cat(4,eventfile.file);
    trial_group_2           = permute(trial_group_2, [4 1 2 3]);                                                        %Make sure the data is in the right format. VERY IMPORTANT 
    trial_group_1           = cat(4,baseline.file);
    trial_group_1           = permute(trial_group_1, [4 1 2 3]);                                                        %Make sure the data is in the right format. VERY IMPORTANT
    
    % CREATE FIELDTRIP-LIKE STRUCTURE ARRAYS
    % Create GrandAverage TrialData2 Array
    Trialdata1_GAV            = [];
    Trialdata1_GAV.freq       = f;
    Trialdata1_GAV.time       = Sensefog_ResultsTable(t).time; 
    Trialdata1_GAV.label      = {'STN'};
    Trialdata1_GAV.dimord     = 'subj_chan_freq_time';
    Trialdata1_GAV.powspctrm  = trial_group_1;
    
    % Create GrandAverage TrialData2 Array
    Trialdata2_GAV            = [];
    Trialdata2_GAV.freq       = f;
    Trialdata2_GAV.time       = Sensefog_ResultsTable(t).time; 
    Trialdata2_GAV.label      = {'STN'};
    Trialdata2_GAV.dimord     = 'subj_chan_freq_time';
    Trialdata2_GAV.powspctrm  = trial_group_2;
    
    % Create the information for Statistical testing in fieldtrip structure format
    cfg                         = [];
    cfg.method                  = 'montecarlo';    % use the Monte Carlo Method to calculate the significance probability
    cfg.clusterthreshold        = 'nonparametric_individual';
    cfg.statistic               = 'depsamplesT';   % use the dependent samples T-statistic as a measure to evaluate the effect at the sample level
    cfg.correctm                = 'cluster';
    cfg.clusteralpha            = 0.05;            % default is 0.05; alpha level of the sample-specific test statistic that will be used for thresholding
    cfg.clusterstatistic        = 'maxsum';        % 'maxsum'; test statistic that will be evaluated under the permutation distribution.
    cfg.neighbours              = [];              % see below
    cfg.clustertail             = 0;               %
    cfg.alpha                   = 0.025;           % (default should be 0.025) alpha level of the permutation test
    cfg.numrandomization        = 1000;            % number of draws from the permutation distribution; Num = num of subj.^2
    cfg.frequency               = [3 100];         % [3 50]
    
    n_fc  = size(Trialdata2_GAV.powspctrm, 1);
    n_fic = size(Trialdata1_GAV.powspctrm, 1);
    
    % Specify Experimental Design
    % cfg.ivar  = independent variable, row number of the design that contains the labels of the conditions to be compared (default=1)
    % cfg.uvar  = unit variable, row number of design that contains the labels of the units-of-observation, i.e. subjects or trials (default=2)
    
    cfg.design                  = [ones(1,n_fic), ones(1,n_fc)*2; linspace(1,n_fic,n_fic),linspace(1,n_fc,n_fc)]  ; % design matrix
    cfg.ivar                    = 1;                % number or list with indices indicating the indep (i = independent variable = 1st row)
    cfg.uvar                    = 2;                % number or list with indices indicating the indep (u = participants = 2nd row)
    
    [stat] = ft_freqstatistics(cfg, Trialdata2_GAV, Trialdata1_GAV); %Make sure to put the condition first to see the positive effects in the condition, not the baseline condition
    
    % Make a vector of all p-values associated with the clusters from ft_freqstatistics.
    % Then, find which clusters are deemed interesting to visualize, here we use a cutoff criterion based on the
    % cluster-associated p-value, and take a 5% two-sided cutoff (i.e. 0.025 for the positive and negative clusters,
    % respectively
    pos_cluster_pvals   = [stat.posclusters(:).prob];
    pos_clust           = find(pos_cluster_pvals < 0.025);
    pos                 = ismember(stat.posclusterslabelmat, pos_clust);
    
    % and now for the negative clusters...
    neg_cluster_pvals   = [stat.negclusters(:).prob];
    neg_clust           = find(neg_cluster_pvals < 0.025);
    neg                 = ismember(stat.negclusterslabelmat, neg_clust);
    
    
    % Create Grand Averages
    cfg                  = [];
    cfg.channel          = 'all';
    cfg.avgoverrpt       = 'yes'; %rep = subjects
    cfg.frequency        = [3 100];
    diffmapG1G2          = ft_selectdata(cfg, Trialdata2_GAV); %Use to average over the data (create group average)
    
    Sensefog_ResultsTable(t).tf_map        = squeeze(diffmapG1G2.powspctrm);
    Sensefog_ResultsTable(t).tf_map_new    = Sensefog_ResultsTable(t).tf_map .* squeeze(stat.mask);                         % Generates a map that only includes the significant bits
    Sensefog_ResultsTable(t).frex          = diffmapG1G2.freq;
    Sensefog_ResultsTable(t).stat          = stat; 
    
    clear cfg diffmap G1G2 e freqs neg pos neg_clust neg_cluster_pvals pos_clust pos_cluster_pvals avgtrialG1 avgtrialG2 baseline eventfile cfg  trial_group_2 trial_group_1
    clear num_freq num_time Trialdata1_GAV Trialdata2_GAV ans n_fc n_fic diffmapG1G2 input_file stat
end

filepath        = subjectdata.generalpath; cd(filepath)
filepath        = extractBefore(filepath,"Time-Frequency-Data");   
filepath        = char(filepath);
filepath        = string(filepath(1:end-1));
filepath        = append(filepath,filesep, "Table & Figures"); cd(filepath)
save([sprintf('%s.mat',"Figure_3")],"Sensefog_ResultsTable");


%% Plot Figure 3
addpath("customcolormap")

t0 = tiledlayout(6,2);
t1 = tiledlayout(t0,1,1);
t1.Layout.Tile = 1;
t1.Layout.TileSpan = [1, 1];
    nexttile(t1) % %FIRST BLOCK [SELF SELECTED STOP] ====================================================================================
    p1 = plot(Sensefog_ResultsTable(1).time, -Sensefog_ResultsTable(1).IMU_signal_mean,'-b', 'LineWidth', 1.5, 'DisplayName', 'Mean Gyroscope [saggital plane]');
    hold on 
    patch([Sensefog_ResultsTable(1).time flip(Sensefog_ResultsTable(1).time)],[(-Sensefog_ResultsTable(1).IMU_signal_mean + Sensefog_ResultsTable(1).IMU_signal_std) flip(-Sensefog_ResultsTable(1).IMU_signal_mean - Sensefog_ResultsTable(1).IMU_signal_std)], 'b','FaceAlpha',0.1, 'EdgeColor', 'none');
    set(gca,'xtick',[]); box off; set(gca,'XColor','none');xlim([0 1000]); set(gca,'ytick',[]); %ylim([-100 80]);
    legend([p1],"Box","off", 'Location','southoutside', 'NumColumns',1)
    ylabel('Gyroscope [deg/s]','FontSize', 12);
    title('Self-selected Stop', 'FontSize', 12, 'FontWeight','normal')
    

t2 = tiledlayout(t0,3,1);
t2.Layout.Tile = 3;
t2.Layout.TileSpan = [2, 1];
    
    nexttile(t2,[2,1])
    c1 = -30; c2 = 30; %Color values
    contourf(Sensefog_ResultsTable(1).time,Sensefog_ResultsTable(1).frex, Sensefog_ResultsTable(1).tf_map, Sensefog_ResultsTable(1).nfrq, 'linecolor', 'none')
    mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
    colormap(mycolormap); caxis([c1 c2]);
    ylabel(t2,'Frequency [Hz]','FontSize', 12); set(gca, 'YTick', [0:20:100]); xlim([0 1000]);
    set(gca, 'YTick', [5, 10, 20, 30, 50, 100]);set(gca,'YScale','log');  set(gca,'YLim', [3 100]); set(gca,'xtick',[]); box off; set(gca,'XColor','none');
      
    
    nexttile(t2)
    b = nan(size(Sensefog_ResultsTable(1).tf_map_new));
    b(logical(Sensefog_ResultsTable(1).tf_map_new)) = 1;
    contourf(Sensefog_ResultsTable(1).time,Sensefog_ResultsTable(1).frex,(b .* Sensefog_ResultsTable(1).tf_map), Sensefog_ResultsTable(1).nfrq, 'linecolor', 'none')
    mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
    colormap(mycolormap); caxis([c1 c2]); 
    set(gca, 'YTick', [ 10,  30, 50]);ylim([3 50]); set(gca,'YScale','log');  xlim([0 1000]); xlabel('Time [ms]'); box off
    

t3 = tiledlayout(t0,1,1);
t3.Layout.Tile = 7;
t3.Layout.TileSpan = [1, 1];
    nexttile(t3) % %SECOND BLOCK [PRE-STOP] ===================================================================================================
    p1 = plot(Sensefog_ResultsTable(3).time, -Sensefog_ResultsTable(3).IMU_signal_mean,'-b',  'LineWidth', 1.5, 'DisplayName', 'Mean Gyroscope [saggital plane]');
    hold on 
    patch([Sensefog_ResultsTable(3).time flip(Sensefog_ResultsTable(3).time)],[(-Sensefog_ResultsTable(3).IMU_signal_mean + Sensefog_ResultsTable(3).IMU_signal_std) flip(-Sensefog_ResultsTable(3).IMU_signal_mean - Sensefog_ResultsTable(3).IMU_signal_std)], 'b','FaceAlpha',0.1, 'EdgeColor', 'none');
    xline(Sensefog_ResultsTable(3).ctrl_TO*10,'k--',{"ctrl. TO"}, 'LineWidth',1,'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'top','FontSize', 8,'LabelOrientation', 'horizontal')
    xline(Sensefog_ResultsTable(3).ctrl_MS*10,'k--',{"ctrl. MS"},  'LineWidth',1,'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'bottom','FontSize', 8,'LabelOrientation', 'horizontal')
    xline(500,'k--', {"ips. HS"}, 'LineWidth', 1, 'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'top','FontSize', 8,'LabelOrientation', 'horizontal')
    set(gca,'xtick',[]); box off; set(gca,'XColor','none');set(gca,'ytick',[]); xlim([0 1000])
    legend([p1],"Box","off", 'Location','southoutside', 'NumColumns',1)
    ylabel('Gyroscope [deg/s]','FontSize', 12);
    title('Pre-Stop', 'FontSize', 12, 'FontWeight','normal')


t4 = tiledlayout(t0,3,1);
t4.Layout.Tile = 9;
t4.Layout.TileSpan = [2, 1];
    
    nexttile(t4,[2,1])
    contourf(Sensefog_ResultsTable(3).time,Sensefog_ResultsTable(3).frex, Sensefog_ResultsTable(3).tf_map, Sensefog_ResultsTable(3).nfrq, 'linecolor', 'none')
    hold on 
    xline(Sensefog_ResultsTable(3).ctrl_TO*10,'k--', 'LineWidth',1)
    xline(Sensefog_ResultsTable(3).ctrl_MS*10,'k--', 'LineWidth',1)
    xline(500,'k--', 'LineWidth',1)
    mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
    colormap(mycolormap); caxis([c1 c2]); 
    ylabel(t4,'Frequency [Hz]','FontSize', 12); set(gca, 'YTick', [0:20:100]); xlim([0 1000]);
    set(gca, 'YTick', [5, 10, 20, 30, 50, 100]);set(gca,'YScale','log');  set(gca,'YLim', [3 100]); set(gca,'xtick',[]); box off; set(gca,'XColor','none');

    nexttile(t4)
    b = nan(size(Sensefog_ResultsTable(3).tf_map_new));
    b(logical(Sensefog_ResultsTable(3).tf_map_new)) = 1;
    contourf(linspace(0,100, length(Sensefog_ResultsTable(3).IMU_signal_mean)),Sensefog_ResultsTable(3).frex,(b .* Sensefog_ResultsTable(3).tf_map), Sensefog_ResultsTable(3).nfrq, 'linecolor', 'none')
    hold on 
    xline(Sensefog_ResultsTable(3).ctrl_TO,'k--', 'LineWidth',1)
    xline(Sensefog_ResultsTable(3).ctrl_MS,'k--', 'LineWidth',1)
    xline(50,'k--', 'LineWidth',1)
    mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
    colormap(mycolormap); caxis([c1 c2]); 
    set(gca, 'YTick', [ 10,  30, 50]);ylim([3 50]); set(gca,'YScale','log');  set(gca,'YScale','log'); xlabel('Pre-Stop Gait Cycle [%]'); box off


t5 = tiledlayout(t0,1,1);
t5.Layout.Tile = 2;
t5.Layout.TileSpan = [1, 1];
    nexttile(t5) % %THIRD BLOCK [FREEZE WALK] ==========================================================================================
    p1 = plot(Sensefog_ResultsTable(2).time, -Sensefog_ResultsTable(2).IMU_signal_mean,'-r', 'LineWidth', 1.5,  'DisplayName', 'Mean Gyroscope [saggital plane]');
    hold on 
    patch([Sensefog_ResultsTable(2).time flip(Sensefog_ResultsTable(2).time)],[(-Sensefog_ResultsTable(2).IMU_signal_mean + Sensefog_ResultsTable(2).IMU_signal_std) flip(-Sensefog_ResultsTable(2).IMU_signal_mean - Sensefog_ResultsTable(2).IMU_signal_std)], 'r','FaceAlpha',0.1, 'EdgeColor', 'none');
    set(gca,'xtick',[]); box off; set(gca,'XColor','none'); xlim([0 1000]); set(gca,'ytick',[]); %ylim([-100 80]);
    legend([p1],"Box","off", 'Location','southoutside', 'NumColumns',1)
    title('FoG', 'FontSize', 12, 'FontWeight','normal')

t6 = tiledlayout(t0,3,1);
t6.Layout.Tile = 4;
t6.Layout.TileSpan = [2, 1];
    
    nexttile(t6, [2,1])
    contourf(Sensefog_ResultsTable(2).time,Sensefog_ResultsTable(2).frex, Sensefog_ResultsTable(2).tf_map, Sensefog_ResultsTable(2).nfrq, 'linecolor', 'none')
    mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
    colormap(mycolormap); caxis([c1 c2]); 
    set(gca, 'YTick', [0:20:100]); xlim([0 1000]);
    set(gca, 'YTick', [5, 10, 20, 30, 50, 100]);set(gca,'YScale','log');  set(gca,'YLim', [3 100]); set(gca,'xtick',[]); box off; set(gca,'XColor','none');

    nexttile(t6)
    b = nan(size(Sensefog_ResultsTable(2).tf_map_new));
    b(logical(Sensefog_ResultsTable(2).tf_map_new)) = 1;
    contourf(Sensefog_ResultsTable(2).time,Sensefog_ResultsTable(2).frex,(b .* Sensefog_ResultsTable(2).tf_map), Sensefog_ResultsTable(2).nfrq, 'linecolor', 'none')
    mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
    colormap(mycolormap); caxis([c1 c2]); 
    c = colorbar('Ticks',[linspace(c1,c2,5)]); c.Label.String = '%-Change from Standing'; caxis([c1 c2]); c.Limits = [c1 c2]; c.Layout.Tile='east';
    set(gca, 'YTick', [10,  30,  50]); ylim([3 50]); set(gca,'YScale','log');  xlim([0 1000]); xlabel('Time [ms]'); box off

t7 = tiledlayout(t0,1,1);
t7.Layout.Tile = 8;
t7.Layout.TileSpan = [1, 1];
    nexttile(t7) % %FOURTH BLOCK [PRE-FOG] ==========================================================================================
    p1 = plot(Sensefog_ResultsTable(4).time, -Sensefog_ResultsTable(4).IMU_signal_mean,'-r', 'LineWidth', 1.5,  'DisplayName', 'Mean Gyroscope [saggital plane]');
    hold on 
    patch([Sensefog_ResultsTable(4).time flip(Sensefog_ResultsTable(4).time)],[(-Sensefog_ResultsTable(4).IMU_signal_mean + Sensefog_ResultsTable(4).IMU_signal_std) flip(-Sensefog_ResultsTable(4).IMU_signal_mean - Sensefog_ResultsTable(4).IMU_signal_std)], 'r','FaceAlpha',0.1, 'EdgeColor', 'none');
    xline(Sensefog_ResultsTable(4).ctrl_TO*10,'k--',{"ctrl. TO"}, 'LineWidth',1,'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'top','FontSize', 8,'LabelOrientation', 'horizontal')
    xline(Sensefog_ResultsTable(3).ctrl_MS*10,'k--',{"ctrl. MS"},  'LineWidth',1,'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'bottom','FontSize', 8,'LabelOrientation', 'horizontal')
    xline(500,'k--',{"ips. HS"}, 'LineWidth', 1,'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'top','FontSize', 8,'LabelOrientation', 'horizontal')
    set(gca,'xtick',[]); box off; set(gca,'XColor','none');set(gca,'ytick',[]); xlim([0 1000])
    legend([p1],"Box","off", 'Location','southoutside', 'NumColumns',1)
    title('Pre-FoG', 'FontSize', 12, 'FontWeight','normal')

t8 = tiledlayout(t0,3,1);
t8.Layout.Tile = 10;
t8.Layout.TileSpan = [2, 1];
    
    nexttile(t8, [2,1])
    contourf(Sensefog_ResultsTable(4).time,Sensefog_ResultsTable(4).frex, Sensefog_ResultsTable(4).tf_map, Sensefog_ResultsTable(4).nfrq, 'linecolor', 'none')
    hold on 
    xline(Sensefog_ResultsTable(4).ctrl_TO*10,'k--','LineWidth',1)
    xline(Sensefog_ResultsTable(4).ctrl_MS*10,'k--', 'LineWidth',1)
    xline(500,'k--','LineWidth', 1)
    C = jet(200); colormap(C); caxis([c1 c2]);
    set(gca, 'YTick', [5, 10, 20, 30, 50, 100]);set(gca,'YScale','log'); set(gca,'YLim', [3 100]); set(gca,'xtick',[]); box off; set(gca,'XColor','none');
 
    nexttile(t8)
    b = nan(size(Sensefog_ResultsTable(4).tf_map_new));
    b(logical(Sensefog_ResultsTable(4).tf_map_new)) = 1;
    contourf(linspace(0,100, length(Sensefog_ResultsTable(4).IMU_signal_mean)),Sensefog_ResultsTable(4).frex,(b .* Sensefog_ResultsTable(4).tf_map), Sensefog_ResultsTable(4).nfrq, 'linecolor', 'none')
    hold on 
    xline(Sensefog_ResultsTable(4).ctrl_TO,'k--','LineWidth',1)
    xline(Sensefog_ResultsTable(4).ctrl_MS,'k--', 'LineWidth',1)
    xline(50,'k--','LineWidth', 1)
    mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
    colormap(mycolormap); caxis([c1 c2]); 
    c = colorbar('Ticks',[linspace(c1,c2,5)]); c.Label.String = '%-Change from Standing'; caxis([c1 c2]); c.Limits = [c1 c2]; c.Layout.Tile='east'; 
    set(gca, 'YTick', [10, 30, 50]);ylim([3 50]);set(gca,'YScale','log');  xlabel('Pre-FoG Gait Cycle [%]'); box off

    set(gcf,'Color', 'white')

    a = annotation('textbox',[0.05 0.75 .2 .2],'String','A','EdgeColor','none'); a.FontSize = 18; a.FontWeight = "bold";
    b = annotation('textbox',[0.50 0.75 .2 .2],'String','B','EdgeColor','none'); b.FontSize = 18; b.FontWeight = "bold";
    c = annotation('textbox',[0.05 0.30 .2 .2],'String','C','EdgeColor','none'); c.FontSize = 18; c.FontWeight = "bold";
    d = annotation('textbox',[0.50 0.30 .2 .2],'String','D','EdgeColor','none'); d.FontSize = 18; d.FontWeight = "bold";

    cd(filepath)
    saveas(gcf,'Figure_3')

    clear t3 t4 t5 t6 t7 t8 t0 t1 t2 a b c C c1 c2 d i mycolormap p1 t 
    % *********************** END OF SCRIPT ************************************************************************************************************************

