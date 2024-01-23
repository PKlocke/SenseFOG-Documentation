%% =====  Figure_4.m  ========================================%
%Date: December 2023
%Original author(s): Philipp Klocke, Moritz Loeffler

%This script will call the time-frequency coherence information for Stop and FoG,
%perform cluster-based permutation analysis and plot the figures as seen in
%the manuskript file. Make sure Fieldtrip is installed and added to the
%filepath.

subjectdata.generalpath                 = uigetdir;                                                                 % Specify filepath SenseFOG-main/Coherence-Data
cd(subjectdata.generalpath)
load("Stopping_Files_Coherence.mat")                                                                                % Load stopping coherence files
load("Freezing_Files_Coherence.mat")                                                                                % Load freezing coherence files

f           = Freezing_Files_Coherence.f;
Files.Stop  = Stopping_Files_Coherence.Stop;
Files.Fog   = Freezing_Files_Coherence.FOG;

filenames = {'Stop'; 'Fog'};

%Create Subject-Average and Grand Average of IMU Signals
for t = 1:length(filenames)
    names = unique([Files.(filenames{t}).name]);
    for i = 1:length(names)
        subjectfiles = cat(1,Files.(filenames{t})(ismember(cat(1,[Files.(filenames{t}).name]), names{i}))); 
        store.(filenames{t})(i).mean_IMU       = mean(cat(3,subjectfiles.Gyroscope),3);
    end
end

%Stop
Sensefog_ResultsTable(1).time                 = linspace(1,size(Files.Stop(1).STN_TA,2),size(Files.Stop(1).STN_TA,2));
Sensefog_ResultsTable(1).nfrq                 = 200;
Sensefog_ResultsTable(1).event_name           = "Stop";
Sensefog_ResultsTable(1).baseline_name        = "Standing";
Sensefog_ResultsTable(1).title                = "Stop vs. Standing";
Sensefog_ResultsTable(1).IMU_signal_mean      = mean(cat(3,store.Stop.mean_IMU),3);
Sensefog_ResultsTable(1).IMU_signal_std       = std(cat(1,store.Stop.mean_IMU));
Sensefog_ResultsTable(1).STN_TA               = mean(cat(3,Files.Stop.STN_TA),3);
Sensefog_ResultsTable(1).STN_GA               = mean(cat(3,Files.Stop.STN_GA),3);
Sensefog_ResultsTable(1).TA_GA                = mean(cat(3,Files.Stop.TA_GA),3);
Sensefog_ResultsTable(1).TA_raw               = mean(cat(1,Files.Stop.TA_rms_raw),1);
Sensefog_ResultsTable(1).GA_raw               = mean(cat(1,Files.Stop.GA_rms_raw),1);


%Compute Mean Baseline Coherence for STN-TA, STN-GA and TA-GA
for i = 1:length(Files.Stop)
    store_temp(i).STN_TA = Files.Stop(i).Baseline_COH.STN_TA;
    store_temp(i).STN_GA = Files.Stop(i).Baseline_COH.STN_GA;
    store_temp(i).TA_GA  = Files.Stop(i).Baseline_COH.TA_GA;
end
Sensefog_ResultsTable(1).mean_STN_TA_COH_Bsl = mean(cat(3,store_temp.STN_TA),3);
Sensefog_ResultsTable(1).mean_STN_GA_COH_Bsl = mean(cat(3,store_temp.STN_GA),3);
Sensefog_ResultsTable(1).mean_TA_GA_COH_Bsl  = mean(cat(3,store_temp.TA_GA),3);
clear store_temp



%FoG
Sensefog_ResultsTable(2).time                 = linspace(1,size(Files.Fog(1).STN_TA,2),size(Files.Fog(1).STN_TA,2));
Sensefog_ResultsTable(2).nfrq                 = 200;
Sensefog_ResultsTable(2).event_name           = "FoG";
Sensefog_ResultsTable(2).baseline_name        = "Standing";
Sensefog_ResultsTable(2).title                = "FoG vs. Standing";
Sensefog_ResultsTable(2).IMU_signal_mean      = mean(cat(3,store.Fog.mean_IMU),3);
Sensefog_ResultsTable(2).IMU_signal_std       = std(cat(1,store.Fog.mean_IMU));
Sensefog_ResultsTable(2).STN_TA               = mean(cat(3,Files.Fog.STN_TA),3);
Sensefog_ResultsTable(2).STN_GA               = mean(cat(3,Files.Fog.STN_GA),3);
Sensefog_ResultsTable(2).TA_GA                = mean(cat(3,Files.Fog.TA_GA),3);
Sensefog_ResultsTable(2).TA_raw               = mean(cat(1,Files.Fog.TA_rms_raw),1);
Sensefog_ResultsTable(2).GA_raw               = mean(cat(1,Files.Fog.GA_rms_raw),1);


%Compute Mean Baseline Coherence for STN-TA, STN-GA and TA-GA
for i = 1:length(Files.Fog)
    store_temp(i).STN_TA = Files.Fog(i).Baseline_COH.STN_TA;
    store_temp(i).STN_GA = Files.Fog(i).Baseline_COH.STN_GA;
    store_temp(i).TA_GA  = Files.Fog(i).Baseline_COH.TA_GA;
end
Sensefog_ResultsTable(2).mean_STN_TA_COH_Bsl = mean(cat(3,store_temp.STN_TA),3);
Sensefog_ResultsTable(2).mean_STN_GA_COH_Bsl = mean(cat(3,store_temp.STN_GA),3);
Sensefog_ResultsTable(2).mean_TA_GA_COH_Bsl  = mean(cat(3,store_temp.TA_GA),3);
clear store_temp store subjectfiles i t filenames


%Prepare Files for Non-parametric Cluster-based Permutation Analysis
filenames   = {'Stop'; 'Fog'};
modes       = {'STN_TA'; 'STN_GA'; 'TA_GA'}; 

for t = 1:length(filenames)
    for m = 1:length(modes)

        %Prepare Files for Statistical Analysis
        input_file                  = Files.(filenames{t});
            
        eventfile       = []; baseline        = [];
        for i = 1:length(input_file)
            if isfield(input_file, modes{m}) 
                eventfile(i).file(1,:,:) = input_file(i).(modes{m});
                baseline(i).file(1,:,:)  = [zeros(size(input_file(i).(modes{m})))];
            end
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
        cfg.frequency               = [1 100];         % [3 50]
        
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
        cfg.frequency        = [1 100];
        diffmapG1G2          = ft_selectdata(cfg, Trialdata2_GAV); %Use to average over the data (create group average)
        
        Sensefog_ResultsTable(t).(sprintf("tf_map_%s" , modes{m}))        = squeeze(diffmapG1G2.powspctrm);
        Sensefog_ResultsTable(t).(sprintf("tf_map_new_%s" , modes{m}))    = Sensefog_ResultsTable(t).(sprintf("tf_map_%s" , modes{m})) .* squeeze(stat.mask); % Generates a map that only includes the significant bits
        Sensefog_ResultsTable(t).frex                                     = diffmapG1G2.freq;
        Sensefog_ResultsTable(t).(sprintf("stat_%s" , modes{m}))          = stat; 
        
        clear cfg diffmap G1G2 e freqs neg pos neg_clust neg_cluster_pvals pos_clust pos_cluster_pvals avgtrialG1 avgtrialG2 baseline eventfile cfg  trial_group_2 trial_group_1
        clear num_freq num_time Trialdata1_GAV Trialdata2_GAV ans n_fc n_fic diffmapG1G2 input_file stat
    end
end

filepath        = subjectdata.generalpath; cd(filepath)
filepath        = extractBefore(filepath,"Time-Frequency-Data");   
filepath        = char(filepath);
filepath        = string(filepath(1:end-1));
filepath        = append(filepath,filesep, "Table & Figures"); cd(filepath)
save([sprintf('%s.mat',"Figure_4")],"Sensefog_ResultsTable");
clear i m modes names t 


%%
addpath("customcolormap")
IMU_time = Sensefog_ResultsTable(1).time; 
fs       = 1000;  
nfrq     = 200; 

%Set color limits      %Set x-limits            %Set ylimits        %Set coh xlimits
a = -40; b = 40;       x1 = 0; x2 = 1000;       y1 = 4; y2 = 40;    xl1 = 0.2; xl2 = 0.48;

  t0 = tiledlayout(3,8);
    %=========PLOTTING STOPPING FILES
    t1 = tiledlayout(t0,2,1); %STOP GYROSCOPE IMU
    t1.Layout.Tile = 2;
    t1.Layout.TileSpan = [1, 3];
    nexttile(t1) %STOP GYROSCOPE IMU
    plot(Sensefog_ResultsTable(1).time, -Sensefog_ResultsTable(1).IMU_signal_mean, 'b')
    hold on 
    patch([Sensefog_ResultsTable(1).time flip(Sensefog_ResultsTable(1).time)],[(-Sensefog_ResultsTable(1).IMU_signal_mean + Sensefog_ResultsTable(1).IMU_signal_std) flip(-Sensefog_ResultsTable(1).IMU_signal_mean - Sensefog_ResultsTable(1).IMU_signal_std)], 'b','FaceAlpha',0.1, 'EdgeColor', 'none');
    set(gca,'xtick',[]); box off; set(gca,'XColor','none');
    ylabel({'Ang. Velocity', '[deg./s]'}); set(gca,'ytick',[]); ylim([-6000 6000]);
    title('Self-selected Stop','FontWeight','normal')

    nexttile(t1) %STOP EMG TA and GA
    pt1 = plot(Sensefog_ResultsTable(1).time, Sensefog_ResultsTable(1).TA_raw,'b-','DisplayName','Raw EMG TA');
    hold on 
    pt2 = plot(Sensefog_ResultsTable(1).time, Sensefog_ResultsTable(1).GA_raw,'r-','DisplayName','Raw EMG GA');
    ylim([0 160]); ylabel({'Amplitude'; '[RMS µV]'},'FontSize',10)
    legend([pt1 pt2], 'Location','northeast','Orientation','vertical','Box', 'off')
    set(gca,'xtick',[]); box off; set(gca,'XColor','none');
    title('RMS EMG Signal','FontWeight','normal')

    t2 = tiledlayout(t0,3,1);
    t2.Layout.Tile = 9;
    t2.Layout.TileSpan = [2, 1]; 
    nexttile(t2) %STN-TA COH Bsl STOP
    plot(Sensefog_ResultsTable(1).mean_STN_TA_COH_Bsl,f)
    ylim([y1 y2]);set(gca,'YScale','log'); xlim([xl1 xl2]); set(gca,'xtick',[]); set(gca,'ytick', [5 10 20 30 50]); box off
    title({'Standing Coherence', 'STN-TA'},'FontWeight','normal')

    nexttile(t2) %STN-GA COH Bsl STOP
    plot(Sensefog_ResultsTable(1).mean_STN_GA_COH_Bsl,f)
    ylim([y1 y2]);set(gca,'YScale','log'); xlim([xl1 xl2]); set(gca,'xtick',[]); set(gca,'ytick', [5 10 20 30 50]); box off
    title({'STN-GA'},'FontWeight','normal')

    nexttile(t2) %TA-GA  COH Bsl STOP
    plot(Sensefog_ResultsTable(1).mean_TA_GA_COH_Bsl,f)
    ylim([y1 y2]);set(gca,'YScale','log'); xlim([xl1 xl2]); set(gca,'ytick', [5 10 20 30 50]); box off
    ylabel(t2,'Frequency [Hz]'); xlabel({'Magnitude','Squared Coherence'})
    title({'TA-GA'},'FontWeight','normal')

    t3 = tiledlayout(t0,3,1);
    t3.Layout.Tile = 10;
    t3.Layout.TileSpan = [2, 3];
    nexttile(t3) %STN-TA COH STOP
    contourf(Sensefog_ResultsTable(1).time,f,Sensefog_ResultsTable(1).STN_TA,nfrq , 'linecolor', 'none')
    hold on 
    contour(Sensefog_ResultsTable(1).time,Sensefog_ResultsTable(1).frex,logical(Sensefog_ResultsTable(1).tf_map_new_STN_TA),1,'linecolor','k', 'linewidth',2); %This adds the boundaries of the significant bit
    caxis([a b]);
    mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
    colormap(mycolormap);  
    xlim([x1 x2]); ylim([y1 y2])
    set(gca,'xtick',[]); box off; set(gca,'XColor','none'); set(gca,'YColor','none');set(gca,'YScale','log');
    title('STN-TA Coherence','FontWeight','normal')

    nexttile(t3) %STN-GA COH STOP
    contourf(Sensefog_ResultsTable(1).time,f,Sensefog_ResultsTable(1).STN_GA, nfrq, 'linecolor', 'none')
    hold on 
    contour(Sensefog_ResultsTable(1).time,Sensefog_ResultsTable(1).frex,logical(Sensefog_ResultsTable(1).tf_map_new_STN_GA),1,'linecolor','k', 'linewidth',2); %This adds the boundaries of the significant bit
    caxis([a b]);
    mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
    colormap(mycolormap);  
    xlim([x1 x2]); ylim([y1 y2])
    set(gca,'xtick',[]); box off; set(gca,'XColor','none'); set(gca,'YColor','none');set(gca,'YScale','log');
    title('STN-GA Coherence','FontWeight','normal')

    nexttile(t3) %TA-GA COH STOP
    contourf(Sensefog_ResultsTable(1).time,f,Sensefog_ResultsTable(1).TA_GA,nfrq , 'linecolor', 'none')
    hold on 
    contour(Sensefog_ResultsTable(1).time,Sensefog_ResultsTable(1).frex,logical(Sensefog_ResultsTable(1).tf_map_new_TA_GA),1,'linecolor','k', 'linewidth',2); %This adds the boundaries of the significant bit
    caxis([a b]);
    mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
    colormap(mycolormap);  
    %C = jet(2000); colormap(C);
    xlim([x1 x2]); ylim([y1 y2]); xlabel('Time [ms]')
    box off; set(gca,'YColor','none');set(gca,'YScale','log');
    title('TA-GA Coherence','FontWeight','normal')

 
    %=========PLOTTING STOPPING FILES
    t4 = tiledlayout(t0,2,1); 
    t4.Layout.Tile = 6;
    t4.Layout.TileSpan = [1, 3];
    nexttile(t4) %FOG GYROSCOPE IMU
    plot(Sensefog_ResultsTable(2).time, -Sensefog_ResultsTable(2).IMU_signal_mean, 'r')
    hold on 
    patch([Sensefog_ResultsTable(2).time flip(Sensefog_ResultsTable(2).time)],[(-Sensefog_ResultsTable(2).IMU_signal_mean + Sensefog_ResultsTable(2).IMU_signal_std) flip(-Sensefog_ResultsTable(2).IMU_signal_mean - Sensefog_ResultsTable(2).IMU_signal_std)], 'r','FaceAlpha',0.1, 'EdgeColor', 'none');
    set(gca,'xtick',[]); box off; set(gca,'XColor','none'); set(gca,'ytick',[]); ylim([-6000 6000]);
    title('FoG','FontWeight','normal')

    nexttile(t4) %FOG EMG TA and GA
    pt1 = plot(Sensefog_ResultsTable(2).time, mean(cat(3,Sensefog_ResultsTable(2).TA_raw),3),'b-','DisplayName','Raw EMG TA');
    hold on 
    pt2 = plot(Sensefog_ResultsTable(2).time, mean(cat(3,Sensefog_ResultsTable(2).GA_raw),3),'r-','DisplayName','Raw EMG GA');
    ylim([0 160]); 
    set(gca,'xtick',[]); set(gca,'ytick',[]); box off; set(gca,'XColor','none');
    title('RMS EMG Signal','FontWeight','normal')

    t5 = tiledlayout(t0,3,1);
    t5.Layout.Tile = 13;
    t5.Layout.TileSpan = [2, 1];
    nexttile(t5) %STN-TA COH Bsl FOG
    plot(Sensefog_ResultsTable(2).mean_STN_TA_COH_Bsl,f)
    ylim([y1 y2]);set(gca,'YScale','log'); xlim([xl1 xl2]); set(gca,'xtick',[]); set(gca,'ytick', [5 10 20 30 50]); box off
    title({'Standing Coherence', 'STN-TA'},'FontWeight','normal')

    nexttile(t5) %STN-GA COH Bsl FOG
    plot(Sensefog_ResultsTable(2).mean_STN_GA_COH_Bsl,f)
    ylim([y1 y2]);set(gca,'YScale','log'); xlim([xl1 xl2]); set(gca,'xtick',[]); set(gca,'ytick', [5 10 20 30 50]); box off
    title({'STN-GA'},'FontWeight','normal')

    nexttile(t5) %TA-GA  COH Bsl FOG
    plot(Sensefog_ResultsTable(2).mean_TA_GA_COH_Bsl,f)
    ylim([y1 y2]);set(gca,'YScale','log'); xlim([xl1 xl2]); set(gca,'ytick', [5 10 20 30 50]); box off
    xlabel({'Magnitude','Squared Coherence'})
    title({'TA-GA'},'FontWeight','normal')
   
    t6 = tiledlayout(t0,3,1);
    t6.Layout.Tile = 14;
    t6.Layout.TileSpan = [2, 3];
    nexttile(t6) %STN-TA COH FOG
    contourf(Sensefog_ResultsTable(2).time,f,Sensefog_ResultsTable(2).STN_TA,nfrq , 'linecolor', 'none')
    hold on 
    contour(Sensefog_ResultsTable(2).time,Sensefog_ResultsTable(2).frex,logical(Sensefog_ResultsTable(2).tf_map_new_STN_TA),1,'linecolor','k', 'linewidth',2); %This adds the boundaries of the significant bit
    caxis([a b]);
    mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
    colormap(mycolormap);  
    xlim([x1 x2]); ylim([y1 y2])
    set(gca,'xtick',[]); box off; set(gca,'XColor','none'); set(gca,'YColor','none');set(gca,'YScale','log');
    title('STN-TA Coherence','FontWeight','normal')

    nexttile(t6) %STN-GA COH FOG
    contourf(Sensefog_ResultsTable(2).time,f,Sensefog_ResultsTable(2).STN_GA,nfrq , 'linecolor', 'none')
    hold on 
    contour(Sensefog_ResultsTable(2).time,Sensefog_ResultsTable(2).frex,logical(Sensefog_ResultsTable(2).tf_map_new_STN_GA),1,'linecolor','k', 'linewidth',2); %This adds the boundaries of the significant bit
    caxis([a b]);
    mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
    colormap(mycolormap);  
    xlim([x1 x2]); ylim([y1 y2])
    set(gca,'xtick',[]); box off; set(gca,'XColor','none'); set(gca,'YColor','none');set(gca,'YScale','log');
    title('STN-GA Coherence','FontWeight','normal')

    nexttile(t6) %TA-GA COH FOG
    contourf(Sensefog_ResultsTable(2).time,f,Sensefog_ResultsTable(2).TA_GA,nfrq , 'linecolor', 'none')
    hold on 
    contour(Sensefog_ResultsTable(2).time,Sensefog_ResultsTable(2).frex,logical(Sensefog_ResultsTable(2).tf_map_new_TA_GA),1,'linecolor','k', 'linewidth',2); %This adds the boundaries of the significant bit
    c = colorbar; c.Layout.Tile = 'east'; c.Label.String = '%-Change from Standing Coherence'; c.Label.FontSize = 10;  caxis([a b]); c.Limits = [a b];
    mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
    colormap(mycolormap);  
    xlim([x1 x2]); ylim([y1 y2]); xlabel('Time [ms]')
    box off; set(gca,'YColor','none');set(gca,'YScale','log');
    title('TA-GA Coherence','FontWeight','normal')
    set(gcf, 'Color', 'white')
    clear t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 x1 x2 xl1 xl2 y1 y2 p1 p2 ax1 ax2 c a b C pt1 pt2 

    %Save Figure
    cd(filepath)
    saveas(gcf,'Figure_4')
    
    % *********************** END OF SCRIPT ************************************************************************************************************************
