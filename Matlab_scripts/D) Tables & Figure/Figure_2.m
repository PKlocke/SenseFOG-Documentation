%% =====  Figure_2.m  ========================================%
%Date: December 2023
%Original author(s): Philipp Klocke, Moritz Loeffler

%This script will call the time-frequency information of all Walking Files,
%perform cluster-based permutaiton analysis and plot the figure as seen in
%the manuskript file. Make sure Fieldtrip is installed and added to the
%filepath. The cluster-based permutation analysis is a very time-consuming
%step and may take up to 60 minutes given the amount of permutations.
%===========================================================================%

subjectdata.generalpath                 = uigetdir;                                                                 % Specify filepath SenseFOG-main/Time-Frequency-Data
cd(subjectdata.generalpath)
load("Walking_Files.mat")

f       = Walking_Files.f; 
Walking = [Walking_Files.Walking_Right_HS Walking_Files.Walking_Left_HS];

%Compute relative gait cycle timepoints
for i = 1:length(Walking)
        %Relative Midswing (relative to its gait cycle)
        if isempty(Walking(i).Midswing_Loc) == 0 && size(Walking(i).Midswing_Loc,1) == 1 
        temp_store                          = (Walking(i).end - Walking(i).Midswing_Loc);
        Walking(i).Midswing = (1-(temp_store / Walking(i).diff))*100;

        %Relative Toe-OFF (relative to its gait cycle)
        temp_store                          = (Walking(i).end - Walking(i).Toe_Off_Loc);
        Walking(i).Toe_Off  = (1-(temp_store / Walking(i).diff))*100;
        end
end

%Delete missing Files
idx             = find(cellfun(@isempty,{Walking.Midswing}));
Walking(idx)    = []; clear idx temp_store i

%Remove outliers greater than 
%By default, an outlier is a value that is more than three scaled median absolute deviations (MAD) away from the median.
[~, idx]        = rmoutliers([Walking.diff]);
Walking(idx)    = []; clear idx


%Create Subject-Average and Grand Average of IMU Signals
names = unique([Walking.name]);

for i = 1:length(unique([Walking.name]))
    [~, idx] = rmoutliers([Walking(ismember(cat(1,Walking.name), names{i})).diff]); sum(idx) %ubjectfiles(idx) = [];
    subjectfiles = cat(1,Walking(ismember(cat(1,Walking.name), names{i}))); subjectfiles(idx) = [];
    store(i).mean_IMU       = mean(cat(3,subjectfiles.IMU_gyr_rs),3);
    store(i).mean_Toe_Off   =  mean(cat(3,subjectfiles.Toe_Off),3);
    store(i).mean_Midswing  =  mean(cat(3,subjectfiles.Midswing),3);
end

Sensefog_ResultsTable.time                 = linspace(1,size(Walking(1).wt_rs,2),size(Walking(1).wt_rs,2));
Sensefog_ResultsTable.frex                 = f;
Sensefog_ResultsTable.tf_map               = mean(cat(3,Walking.wt_rs),3);
Sensefog_ResultsTable.nfrq                 = 200;
Sensefog_ResultsTable.tf_map_new           = [];
Sensefog_ResultsTable.event_name           = "Walking";
Sensefog_ResultsTable.baseline_name        = "Standing";
Sensefog_ResultsTable.title                = "Walking vs. Standing";
Sensefog_ResultsTable.IMU_signal           = cat(1, store.mean_IMU);
Sensefog_ResultsTable.IMU_signal_mean      = mean(cat(3,store.mean_IMU),3);
Sensefog_ResultsTable.IMU_signal_std       = std(cat(1,store.mean_IMU));
Sensefog_ResultsTable.ctrl_TO              = mean(cat(3,store.mean_Toe_Off),3);
Sensefog_ResultsTable.ctrl_MS              = mean(cat(3,store.mean_Midswing),3);


%Prepare Files for Statistical Analysis
input_file                  = Walking;
data_names.inputname        = Sensefog_ResultsTable.event_name; 
data_names.reference_name   = Sensefog_ResultsTable.baseline_name;
data_names.title            = Sensefog_ResultsTable.title;

eventfile       = []; baseline        = [];
for i = 1:length(input_file)
    eventfile(i).file(1,:,:) = input_file(i).wt_rs;
    baseline(i).file(1,:,:)  = [zeros(size(input_file(i).wt_org))];
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
Trialdata1_GAV.time       = Sensefog_ResultsTable.time; 
Trialdata1_GAV.label      = {'STN'};
Trialdata1_GAV.dimord     = 'subj_chan_freq_time';
Trialdata1_GAV.powspctrm  = trial_group_1;

% Create GrandAverage TrialData2 Array
Trialdata2_GAV            = [];
Trialdata2_GAV.freq       = f;
Trialdata2_GAV.time       = Sensefog_ResultsTable.time; 
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

Sensefog_ResultsTable.tf_map        = squeeze(diffmapG1G2.powspctrm);
Sensefog_ResultsTable.tf_map_new    = Sensefog_ResultsTable.tf_map .* squeeze(stat.mask);                         % Generates a map that only includes the significant bits
Sensefog_ResultsTable.frex          = diffmapG1G2.freq;
Sensefog_ResultsTable.stat          = stat; 


clear cfg diffmap G1G2 e freqs neg pos neg_clust neg_cluster_pvals pos_clust pos_cluster_pvals avgtrialG1 avgtrialG2 baseline eventfile cfg  trial_group_2 trial_group_1
clear num_freq num_time Trialdata1_GAV Trialdata2_GAV ans n_fc n_fic diffmapG1G2

%% PLOT FIGURE 2

c1 = -15; c2 = 15; %Color values

%Plot
filepath        = subjectdata.generalpath; cd(filepath)
filepath        = extractBefore(filepath,"Time-Frequency-Data");   
filepath        = char(filepath);
filepath        = string(filepath(1:end-1));
filepath        = append(filepath,filesep, "Table & Figures"); cd(filepath)


addpath("customcolormap")
imagefile       = imread("GaitCycleSchematic.png");                                                                 % Load gait cycle schematic
[a, b]          = size(imagefile);
imratio         = b/1000;
new_imagefile   = imresize(imagefile, [a b/imratio]);                                                               % Resize Image to make it fit and not squeeze

t0=tiledlayout(2,1);      % A 'container' layout that holds two other layouts
t1=tiledlayout(t0,2,1);   % The layout holding the images, and the colorbar
t1.Layout.Tile=1;
t1.Layout.TileSpan=[1 1]; % A TileSpan prevents the two rows from being squished to match the lower layout's height

    nexttile(t1)
    image(new_imagefile)
    c = colorbar; c.Visible = 'off';
    xticks([ linspace(100,1000,11)]); xticklabels({'0','10','20', '30','40','50','60','70','80','90','100'});
    box off; set(gca,'ytick',[]);
    xlabel({"Gait Cycle [%]"},'FontSize', 12)

    nexttile(t1)
    p1 = plot(Sensefog_ResultsTable(1).time, -Sensefog_ResultsTable(1).IMU_signal_mean,'-b', 'LineWidth', 1.5, 'DisplayName', 'Mean Gyroscope [saggital plane]');
    hold on 
    patch([Sensefog_ResultsTable(1).time flip(Sensefog_ResultsTable(1).time)],[(-Sensefog_ResultsTable(1).IMU_signal_mean + Sensefog_ResultsTable(1).IMU_signal_std) flip(-Sensefog_ResultsTable(1).IMU_signal_mean - Sensefog_ResultsTable(1).IMU_signal_std)], 'b','FaceAlpha',0.1, 'EdgeColor', 'none');
    xline(Sensefog_ResultsTable(1).ctrl_TO*10,'k--',{"ctrl. TO"}, 'Color', 'b', 'LineWidth',1.5,'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'bottom','LabelOrientation', 'horizontal')
    xline(Sensefog_ResultsTable(1).ctrl_MS*10,'k--',{"ctrl. MS"}, 'Color', 'b','LineWidth',1.5,'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'bottom','LabelOrientation', 'horizontal')
    xline(509,'k--',{"ips. HS"}, 'Color', 'k','LineWidth',1.5,'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'bottom','LabelOrientation', 'horizontal')
    set(gca,'xtick',[]); box off; set(gca,'XColor','none');set(gca,'ytick',[]); xlim([-96 1001]);
    legend([p1 ],"Box","off", 'Location','southoutside', 'NumColumns',1)
    ylabel('Gyroscope [deg/s]','FontSize', 12);

t2=tiledlayout(t0,2,1);
t2.Layout.Tile = 2;
t2.Layout.TileSpan=[1 1]; 

    nexttile(t2)
    contourf(Sensefog_ResultsTable(1).time,Sensefog_ResultsTable(1).frex, Sensefog_ResultsTable(1).tf_map, Sensefog_ResultsTable(1).nfrq, 'linecolor', 'none')
    hold on 
    xline(Sensefog_ResultsTable(1).ctrl_TO*10,'k--','LineWidth',1.5)
    xline(Sensefog_ResultsTable(1).ctrl_MS*10,'k--','LineWidth',1.5)
    xline(509,'k--','LineWidth',1.5)
    
    mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
    colormap(mycolormap); caxis([c1 c2]); c.Limits = [c1 c2]; 
    xlim([-96 1001]); 
    set(gca,'YScale','log');set(gca, 'YTick', [5,10,20,30,50,100]); set(gca,'YLim', [3 100]); set(gca,'xtick',[]); box off; set(gca,'XColor','none');
    
    nexttile(t2)
    b = nan(size(Sensefog_ResultsTable(1).tf_map_new));
    b(logical(Sensefog_ResultsTable(1).tf_map_new)) = 1;
    contourf(Sensefog_ResultsTable(1).time,Sensefog_ResultsTable(1).frex,(b .* Sensefog_ResultsTable(1).tf_map), Sensefog_ResultsTable(1).nfrq, 'linecolor', 'none')
    hold on 
    xline(Sensefog_ResultsTable(1).ctrl_TO*10,'k--','LineWidth',1.5)
    xline(Sensefog_ResultsTable(1).ctrl_MS*10,'k--','LineWidth',1.5)
    xline(509,'k--','LineWidth',1.5)
       
    mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
    c = colorbar; c.Label.String = '%-Change from Standing'; caxis([c1 c2]); c.Limits = [c1 c2]; c.Layout.Tile='east';
    ylabel(t2,'Frequency [Hz]','FontSize', 12);set(gca,'YScale','log'); set(gca, 'YTick', [5,10,20,30,50,100]);set(gca,'YLim', [3 100]);  xlim([-96 1001]); set(gca,'xtick',[]); box off; set(gca,'XColor','none');
    hold off
    set(gcf,'color','w');

    a = annotation('textbox',[0.04 0.75 .2 .2],'String','A','EdgeColor','none'); a.FontSize = 18; a.FontWeight = "bold";
    b = annotation('textbox',[0.04 0.54 .2 .2],'String','B','EdgeColor','none'); b.FontSize = 18; b.FontWeight = "bold";
    c = annotation('textbox',[0.04 0.27 .2 .2],'String','C','EdgeColor','none'); c.FontSize = 18; c.FontWeight = "bold";
    d = annotation('textbox',[0.04 0.07 .2 .2],'String','D','EdgeColor','none'); d.FontSize = 18; d.FontWeight = "bold";

    cd(filepath)
    saveas(gcf,'Figure 2')
    save([sprintf('%s.mat',"Figure_2")],"Sensefog_ResultsTable");

    clear a b c C c1 c2 i idx imagefile imratio new_imagefile p1 store subjectfiles t0 t1 t2 d mycolormap stat 
 % *********************** END OF SCRIPT ************************************************************************************************************************
