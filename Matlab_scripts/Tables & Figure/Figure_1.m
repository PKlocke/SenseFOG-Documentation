%% =====  Figure_1.m  ========================================%
%Date: December 2023
%Original author(s): Philipp Klocke, Moritz Loeffler

%This script will call the frequency-domain information for Stop, Pre-Stop,
%FoG,Pre-FoG, as well as Walking and perform cluster-based permutation analysis 
% followed by plotting the figures as seen in the manuskript file. 
% Make sure Fieldtrip is installed and added to the %filepath.

subjectdata.generalpath                 = uigetdir;                                                                 % Specify filepath SenseFOG-main/Time-Frequency-Data
cd(subjectdata.generalpath)                                                                                         
load("Stopping_Files.mat")                                                                                          % Load stopping files
load("Freezing_Files.mat")                                                                                          % Load freezing files
load("Pre_Stopping_Files.mat")                                                                                      % Load pre-stop files
load("Pre_Freezing_Files.mat")                                                                                      % Load pre-fog files
load("Walking_Files.mat")                                                                                           % Load walking files


f                     = Pre_Stopping_Files.frequencies;
Files.Pre_Fog         = Pre_Freezing_Files.Pre_Fogs;
Files.Pre_Stop        = Pre_Stopping_Files.Pre_Stops;
Files.Stop            = Stopping_Files;
Files.Fog             = Freezing_Files; 
Files.Walking         = [Walking_Files.Walking_Right_HS, Walking_Files.Walking_Left_HS];

%Find empty arrays and delete
idx                   = find(cellfun(@isempty,{Files.Walking.Toe_Off_Loc})); Files.Walking(idx) = []; clear idx

%Find index if files where no sitting file exists
idx                   = find(cellfun(@isempty,{Files.Walking.sitting})); Files.Walking(idx) = []; clear idx


%Stop
Sensefog_ResultsTable(1).x_name               = "Self-selected Stop";
Sensefog_ResultsTable(1).y_name               = "Standing";
Sensefog_ResultsTable(1).title                = "Self-selected Stop vs. Standing";

%FoG
Sensefog_ResultsTable(2).x_name               = "FoG";
Sensefog_ResultsTable(2).y_name               = "Standing";
Sensefog_ResultsTable(2).title                = "FoG vs. Standing";

%Pre-Stop
Sensefog_ResultsTable(3).x_name               = "Pre-Stop";
Sensefog_ResultsTable(3).y_name               = "Standing";
Sensefog_ResultsTable(3).title                = "Pre-Stop vs. Standing";

%Pre-Fog
Sensefog_ResultsTable(4).x_name               = "Pre-FoG";
Sensefog_ResultsTable(4).y_name               = "Standing";
Sensefog_ResultsTable(4).title                = "Pre-FoG vs. Standing";

%Walking
Sensefog_ResultsTable(5).x_name               = "Walking";
Sensefog_ResultsTable(5).y_name               = "Standing";
Sensefog_ResultsTable(5).title                = "Walking vs. Standing";

%Sitting
Sensefog_ResultsTable(6).x_name               = "Sitting";
Sensefog_ResultsTable(6).y_name               = "Standing";
Sensefog_ResultsTable(6).title                = "Sitting vs. Standing";

%Prepare Files for Non-parametric Cluster-based Permutation Analysis
filenames = {'Stop'; 'Fog';'Pre_Stop'; 'Pre_Fog'; 'Walking'; 'Sitting'};

for t = 1:length(filenames)
    if  t == 6; input_file = Files.Walking;
    else input_file = Files.(filenames{t}); end
    eventfile = []; baseline = [];
    for i = 1:length(input_file)    
        if   t == 6; eventfile{i}.avg        = 10*log10(input_file(i).sitting);
        else eventfile{i}.avg        = 10*log10(input_file(i).frequency_domain); end
        if isfield(input_file, 'baseline_stand')
        baseline{i}.avg         = 10*log10(input_file(i).baseline_stand); 
        elseif isfield(input_file, 'baseline')
        baseline{i}.avg         = 10*log10(input_file(i).baseline)';
        end
        if size(eventfile{i}.avg,2) == 1; eventfile{i}.avg  =  eventfile{i}.avg'; end
        if size(baseline{i}.avg,2) == 1 ; baseline{i}.avg   = baseline{i}.avg'; end
        eventfile{i}.label      = {'STN'};     baseline{i}.label        = {'STN'};
        eventfile{i}.fsample    = [];          baseline{i}.fsample      = [];      
        eventfile{i}.time       = f;           baseline{i}.time         = f;
        eventfile{i}.cfg        = [];          baseline{i}.cfg          = [];      
        eventfile{i}.dimord     = 'chan_time'; baseline{i}.dimord   = 'chan_time'; 
    end

        %Calculate Grandaverage Data for each condition [Eventfile, Baseline]
        % "{:}" means to use data from all elements of the variable
        cfg                     = [];
        cfg.channel             = 'all';
        cfg.latency             = 'all';
        cfg.parameter           = 'avg';
        GAVeventfile            = ft_timelockgrandaverage(cfg, eventfile{:});
        GAVbaseline             = ft_timelockgrandaverage(cfg, baseline{:});
        
        %Calculate Standard Error of the MEAN
        store_temp = [];
        for i = 1:length(eventfile)
            store_temp(i).eventfile    = eventfile{i}.avg;
        end
        sem_eventfile = std(cat(1,store_temp.eventfile) ./ sqrt(length(store_temp)));
        
        store_temp = [];
        for i = 1:length(baseline)
            store_temp(i).baseline     = baseline{i}.avg;
        end
        sem_baseline  = std(cat(1,store_temp.baseline) ./ sqrt(length(store_temp)));
        
        
        Nevt = length(eventfile);                   % Number of subjects
        Nbsl = length(baseline);
        
        cfg                     = [];               
        cfg.channel             = 'all';            % Nx1 cell-array with selection of channels (default = 'all');
        cfg.latency             = [3 35];           % [begin end] in seconds or 'all' (default = 'all');
        cfg.avgovertime         = 'no';             % Indicate no if you want to find clusters in time without prior knowledge where to look at, default = 'no';
        cfg.parameter           = 'avg';            % string (default = 'tria' or 'avg'), 'avg' needs to be a parameter in the eventfiles/baselinefiles
        cfg.method              = 'montecarlo';     %
        cfg.statistic           = 'ft_statfun_depsamplesT'; % Dependent Samples T-Test
        cfg.alpha               = 0.025;            % number, critical value for rejecting the null-hypothesis per tail (default = 0.05)
        cfg.clusteralpha        = 0.05;
        cfg.tail                = 0;                %Two-sided t-test    
        cfg.clustertail         = 0; 
        cfg.correctm            = 'cluster';        % string, apply multiple-comparison correction, 'no', 'max', cluster', 'tfce', 'bonferroni', 'holm', 'hochberg', 'fdr' (default = 'no')
        cfg.correcttail         = 'prob';           % string, correct p-values or alpha-values when doing a two-sided test, 'alpha','prob' or 'no' (default = 'no')
        cfg.numrandomization    =  1000;            % Possible Permutaitons = 2^number of subjects
        cfg.design(1,1:2*Nevt)  = [ones(1,Nevt) 2*ones(1,Nbsl)];
        cfg.design(2,1:2*Nevt)  = [1:Nevt 1:Nbsl];  %
        
        cfg.ivar                = 1;                % the 1st row in cfg.design contains the independent variable
        cfg.uvar                = 2;                % the 2nd row in cfg.design contains the subject number
        
        stat                    = ft_timelockstatistics(cfg, baseline{:}, eventfile{:});


        %PLOT DATA - OPTION 3 (Significance bars indicated as horizontal bars and shading
        startpoint = []; stoppoint = [];
        for i = 2:length(stat.mask)-1
            if   stat.mask(1) == 1; startpoint(1) = 1; end
            if   stat.mask(i) == 1 && stat.mask(i-1) == 0; startpoint(i) = i; end
            if   stat.mask(i) == 1 && stat.mask(i+1) == 0; stoppoint(i) = i;  end
            if   stat.mask(end) == 1; stoppoint(length(stat.mask)) = length(stat.mask); end
        end
        
        startpoint  = stat.time(find(startpoint > 0)); %Find the timepoint in the time matrix where the significance begins
        stoppoint   = stat.time(find(stoppoint  > 0)); %Find the timepoint int eh time matrix where the significance stops

        Sensefog_ResultsTable(t).z          = GAVeventfile.time;
        Sensefog_ResultsTable(t).x          = GAVeventfile.avg;
        Sensefog_ResultsTable(t).y          = GAVbaseline.avg;
        Sensefog_ResultsTable(t).x_sem      = sem_eventfile;
        Sensefog_ResultsTable(t).y_sem      = sem_baseline;
        Sensefog_ResultsTable(t).startpoint = startpoint;
        Sensefog_ResultsTable(t).stoppoint  = stoppoint;
        Sensefog_ResultsTable(t).stat       = stat; 

        %Clean-UP
        clear baseline cfg data_names eventfile file GAVbaseline GAVeventfile input_file Nbsl Nevt sem_baseline sem_eventfile stoppoint stat
        clear store_temp i startpoint 
end

filepath        = subjectdata.generalpath; cd(filepath)
filepath        = extractBefore(filepath,"Time-Frequency-Data");   
filepath        = char(filepath);
filepath        = string(filepath(1:end-1));
filepath        = append(filepath,filesep, "Table & Figures"); cd(filepath)
save([sprintf('%s.mat',"Figure_1")],"Sensefog_ResultsTable");


%% PLOT Figure 1
c1 = [0 0.4470 0.7410];         %Sitting color
c2 = [0 0 0];                   %Standing color
c3 = [0.6350 0.0780 0.1840];    %Activity color

figure
    tiledlayout(1,3)
    %Walking, Standing, Sitting
    nexttile
    ax1 = plot(Sensefog_ResultsTable(6).z,Sensefog_ResultsTable(6).x,'Color', c2, 'LineWidth', 1); %Sitting
    hold on 
    patch([Sensefog_ResultsTable(6).z flip(Sensefog_ResultsTable(6).z)],[(Sensefog_ResultsTable(6).x + Sensefog_ResultsTable(6).x_sem) flip(Sensefog_ResultsTable(6).x - Sensefog_ResultsTable(6).x_sem)], c2,'FaceAlpha',0.25, 'EdgeColor', 'none');

    ax2 =  plot(Sensefog_ResultsTable(5).z, Sensefog_ResultsTable(5).y, 'Color', c1, 'LineWidth', 1); %Standing
    hold on
    patch([Sensefog_ResultsTable(5).z flip(Sensefog_ResultsTable(5).z)],[(Sensefog_ResultsTable(5).y + Sensefog_ResultsTable(5).y_sem) flip(Sensefog_ResultsTable(5).y - Sensefog_ResultsTable(5).y_sem)], c1 ,'FaceAlpha',0.25, 'EdgeColor', 'none');
 
    ax3 =  plot(Sensefog_ResultsTable(5).z, Sensefog_ResultsTable(5).x, 'Color', c3, 'LineWidth', 1); %Walking
    patch([Sensefog_ResultsTable(5).z flip(Sensefog_ResultsTable(5).z)],[(Sensefog_ResultsTable(5).x + Sensefog_ResultsTable(5).x_sem) flip(Sensefog_ResultsTable(5).x - Sensefog_ResultsTable(5).x_sem)], c3,'FaceAlpha',0.25, 'EdgeColor', 'none');
    
    xlim([3 35]); ylim([-19 -12]);ylimits = ylim; 
    for i = 1:length(Sensefog_ResultsTable(6).startpoint)
        rectangle('Position',[Sensefog_ResultsTable(6).startpoint(i), ylimits(1)*0.99 , (Sensefog_ResultsTable(6).stoppoint(i) - Sensefog_ResultsTable(6).startpoint(i)),  0.1], 'FaceColor','black', 'EdgeColor', 'none') 
    end
    
    for i = 1:length(Sensefog_ResultsTable(5).startpoint)
        rectangle('Position',[Sensefog_ResultsTable(5).startpoint(i), ylimits(1)*0.98 , (Sensefog_ResultsTable(5).stoppoint(i) - Sensefog_ResultsTable(5).startpoint(i)),  0.1], 'FaceColor',[.7 .7 .7], 'EdgeColor', 'none') 
    end
    legend([ax2 ax1 ax3], Sensefog_ResultsTable(6).y_name, Sensefog_ResultsTable(6).x_name,Sensefog_ResultsTable(5).x_name,'Box','off','FontSize', 10)
    ylabel('Relative Power [dB]'); xlabel('Frequency [Hz]')
    box off
   
nexttile
    %Self-selected Stop, Pre-Stop, Standing
    ax1 = plot(Sensefog_ResultsTable(1).z,Sensefog_ResultsTable(1).y,'Color', c2, 'LineWidth', 1);
    hold on 
    patch([Sensefog_ResultsTable(1).z flip(Sensefog_ResultsTable(1).z)],[(Sensefog_ResultsTable(1).y + Sensefog_ResultsTable(1).y_sem) flip(Sensefog_ResultsTable(1).y - Sensefog_ResultsTable(1).y_sem)], c2,'FaceAlpha',0.25, 'EdgeColor', 'none');
    
    ax2 = plot(Sensefog_ResultsTable(3).z,Sensefog_ResultsTable(3).x,'Color', c1, 'LineWidth', 1);
    patch([Sensefog_ResultsTable(3).z flip(Sensefog_ResultsTable(3).z)],[(Sensefog_ResultsTable(3).x + Sensefog_ResultsTable(3).x_sem) flip(Sensefog_ResultsTable(3).x - Sensefog_ResultsTable(3).x_sem)], c1,'FaceAlpha',0.25, 'EdgeColor', 'none');

    ax3 = plot(Sensefog_ResultsTable(1).z,Sensefog_ResultsTable(1).x,'Color', c3, 'LineWidth', 1);
    patch([Sensefog_ResultsTable(1).z flip(Sensefog_ResultsTable(1).z)],[(Sensefog_ResultsTable(1).x + Sensefog_ResultsTable(1).x_sem) flip(Sensefog_ResultsTable(1).x - Sensefog_ResultsTable(1).x_sem)], c3,'FaceAlpha',0.25, 'EdgeColor', 'none');
    
    xlim([3 35]); ylim([-19 -12]); ylimits = ylim; 
    for i = 1:length(Sensefog_ResultsTable(1).startpoint)
        rectangle('Position',[Sensefog_ResultsTable(1).startpoint(i), ylimits(1)*0.99 , (Sensefog_ResultsTable(1).stoppoint(i) - Sensefog_ResultsTable(1).startpoint(i)),  0.1], 'FaceColor','black', 'EdgeColor', 'none') 
    end
    for i = 1:length(Sensefog_ResultsTable(3).startpoint)
        rectangle('Position',[Sensefog_ResultsTable(3).startpoint(i), ylimits(1)*0.98 , (Sensefog_ResultsTable(3).stoppoint(i) - Sensefog_ResultsTable(3).startpoint(i)),  0.1], 'FaceColor',[.7 .7 .7], 'EdgeColor', 'none') 
    end
    legend([ax1 ax2 ax3], Sensefog_ResultsTable(1).y_name, Sensefog_ResultsTable(1).x_name,Sensefog_ResultsTable(3).x_name,'Box','off','FontSize', 10)
    ylabel('Relative Power [dB]'); xlabel('Frequency [Hz]')
    box off

nexttile  
    %FoG, Pre-FoG, Standing
    ax1 = plot(Sensefog_ResultsTable(2).z,Sensefog_ResultsTable(2).y,'Color', c2, 'LineWidth', 1);
    hold on 
    patch([Sensefog_ResultsTable(2).z flip(Sensefog_ResultsTable(2).z)],[(Sensefog_ResultsTable(2).y + Sensefog_ResultsTable(2).y_sem) flip(Sensefog_ResultsTable(2).y - Sensefog_ResultsTable(2).y_sem)], c2,'FaceAlpha',0.25, 'EdgeColor', 'none');
      
    ax2 = plot(Sensefog_ResultsTable(4).z,Sensefog_ResultsTable(4).x,'Color', c1, 'LineWidth', 1);
    patch([Sensefog_ResultsTable(4).z flip(Sensefog_ResultsTable(4).z)],[(Sensefog_ResultsTable(4).x + Sensefog_ResultsTable(4).x_sem) flip(Sensefog_ResultsTable(4).x - Sensefog_ResultsTable(4).x_sem)], c1,'FaceAlpha',0.25, 'EdgeColor', 'none');

    ax3 = plot(Sensefog_ResultsTable(2).z,Sensefog_ResultsTable(2).x,'Color', c3, 'LineWidth', 1);
    hold on
    patch([Sensefog_ResultsTable(2).z flip(Sensefog_ResultsTable(2).z)],[(Sensefog_ResultsTable(2).x + Sensefog_ResultsTable(2).x_sem) flip(Sensefog_ResultsTable(2).x - Sensefog_ResultsTable(2).x_sem)], c3,'FaceAlpha',0.25, 'EdgeColor', 'none');
 

    xlim([3 35]); ylim([-19 -12]); ylimits = ylim; 
    for i = 1:length(Sensefog_ResultsTable(2).startpoint)
        rectangle('Position',[Sensefog_ResultsTable(2).startpoint(i), ylimits(1)*0.99 , (Sensefog_ResultsTable(2).stoppoint(i) - Sensefog_ResultsTable(2).startpoint(i)),  0.1], 'FaceColor','black', 'EdgeColor', 'none') 
    end
    for i = 1:length(Sensefog_ResultsTable(4).startpoint)
        rectangle('Position',[Sensefog_ResultsTable(4).startpoint(i), ylimits(1)*0.98 , (Sensefog_ResultsTable(4).stoppoint(i) - Sensefog_ResultsTable(4).startpoint(i)),  0.1], 'FaceColor',[.7 .7 .7], 'EdgeColor', 'none') 
    end
    legend([ax1 ax2 ax3], Sensefog_ResultsTable(2).y_name, Sensefog_ResultsTable(3).x_name,Sensefog_ResultsTable(2).x_name,'Box', 'off','FontSize', 10)
    ylabel('Relative Power [dB]'); xlabel('Frequency [Hz]')
    set(gcf,'color','w'); box off


    a = annotation('textbox',[0.07 0.745 .2 .2],'String','a','EdgeColor','none'); a.FontSize = 18; a.FontWeight = "bold";
    b = annotation('textbox',[0.350 0.745 .2 .2],'String','b','EdgeColor','none'); b.FontSize = 18; b.FontWeight = "bold";
    c = annotation('textbox',[0.63 0.745 .2 .2],'String','c','EdgeColor','none'); c.FontSize = 18; c.FontWeight = "bold";

   saveas(gcf,'Figure_1','m')

   %Clean Up 
   clear ans ax1 ax2 ax3 c C cfg data_names eventfile test a b c c1 c2 c3 i t ylimits

% *********************** END OF SCRIPT ************************************************************************************************************************
