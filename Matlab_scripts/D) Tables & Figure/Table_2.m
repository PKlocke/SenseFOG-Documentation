%% =====  Table_2.m  ========================================%

%Date: December 2023
%Original author(s): Philipp Klocke, Moritz Loeffler

%This script will call the gait kinematics of Walking, Pre-STOP and Pre-FOG
%and perform statistical analyis. 
%===========================================================================%

subjectdata.generalpath                 = uigetdir;                                                                 % Specify filepath SenseFOG-main/Kinematic_Data
cd(subjectdata.generalpath)
    load("Walking_Files.mat")                                                                                       % Walking Files
    load("Pre_Freezing_Files.mat")                                                                                  % Pre-FOG
    load("Pre_Stopping_Files.mat")                                                                                  % Pre-STOP


% WALKING FILES ============================================================
Dominant_Walking        = GaitData_Walk.dominant;
Nondominant_Walking     = GaitData_Walk.nondominant;

%Compute Cadence, relative stance time, relative swing time
%Disease Dominant Leg
for i = 1:length(Dominant_Walking)
    Dominant_Walking(i).cadence         = 60/(Dominant_Walking(i).diff/2);
    Dominant_Walking(i).rel_stancetime  = Dominant_Walking(i).Toe_Off;
    Dominant_Walking(i).rel_swingtime   = 100-Dominant_Walking(i).Toe_Off;
end

%Non-Disease Dominant Leg
for i = 1:length(Nondominant_Walking)
    Nondominant_Walking(i).cadence         = 60/(Nondominant_Walking(i).diff/2);
    Nondominant_Walking(i).rel_stancetime  = Nondominant_Walking(i).Toe_Off;
    Nondominant_Walking(i).rel_swingtime   = 100-Nondominant_Walking(i).Toe_Off;
end

%Find empty arrays and delete
idx     = find(cellfun(@isempty,{Dominant_Walking.rel_stancetime})); Dominant_Walking(idx) = []; clear idx
idx     = find(cellfun(@isempty,{Nondominant_Walking.rel_stancetime})); Nondominant_Walking(idx) = []; clear idx


%Compute Subject Averages
names                   = unique([Dominant_Walking.name]);
for i = 1:length(names)
    
    %Dominant
    subjectfiles = cat(1,Dominant_Walking(ismember(cat(1,Dominant_Walking.name), names{i}))); 
    [~, idx1] = rmoutliers([Dominant_Walking(ismember(cat(1,Dominant_Walking.name), names{i})).rel_stancetime]);
    [~, idx2] = rmoutliers([Dominant_Walking(ismember(cat(1,Dominant_Walking.name), names{i})).diff]);     
    idx = (idx1 + idx2) > 0; subjectfiles(idx) = [];
    
    Avg_dom(i).name                     = names{i};
    Avg_dom(i).Midswing_Peak            = mean(cell2mat({subjectfiles.Midswing_Peak}));
    Avg_dom(i).Cadence                  = mean(cell2mat({subjectfiles.cadence}));
    Avg_dom(i).Rel_stancetime           = mean(cell2mat({subjectfiles.rel_stancetime}));
    Avg_dom(i).Rel_swingtime            = mean(cell2mat({subjectfiles.rel_swingtime}));
    Avg_dom(i).stridetime               = mean(cell2mat({subjectfiles.diff}));
    
    %Dominant-Coefficient of variation)
    Avg_dom(i).Midswing_Peak_CV         = (std(cell2mat({subjectfiles.cadence})) / mean(cell2mat({subjectfiles.Midswing_Peak}))) * 100;
    Avg_dom(i).Cadence_CV               = (std(cell2mat({subjectfiles.cadence})) / mean(cell2mat({subjectfiles.cadence}))) * 100;
    Avg_dom(i).Rel_stancetime_CV        = (std(cell2mat({subjectfiles.rel_stancetime})) / mean(cell2mat({subjectfiles.rel_stancetime}))) * 100;
    Avg_dom(i).Rel_swingtime_CV         = (std(cell2mat({subjectfiles.rel_swingtime})) / mean(cell2mat({subjectfiles.rel_swingtime}))) * 100;
    Avg_dom(i).stridetime_CV            = (std(cell2mat({subjectfiles.diff})) / mean(cell2mat({subjectfiles.diff}))) * 100;
    
    %Non-Dominant
    subjectfiles = cat(1,Nondominant_Walking(ismember(cat(1,Nondominant_Walking.name), names{i}))); 
    [~, idx1] = rmoutliers([Nondominant_Walking(ismember(cat(1,Nondominant_Walking.name), names{i})).rel_stancetime]);
    [~, idx2] = rmoutliers([Nondominant_Walking(ismember(cat(1,Nondominant_Walking.name), names{i})).diff]); 
    idx = (idx1 + idx2) > 0; subjectfiles(idx) = [];

    Avg_nondom(i).name                  = names{i};
    Avg_nondom(i).Midswing_Peak         = mean(cell2mat({subjectfiles.Midswing_Peak}));
    Avg_nondom(i).Cadence               = mean(cell2mat({subjectfiles.cadence}));
    Avg_nondom(i).Rel_stancetime        = mean(cell2mat({subjectfiles.rel_stancetime}));
    Avg_nondom(i).Rel_swingtime         = mean(cell2mat({subjectfiles.rel_swingtime}));
    Avg_nondom(i).stridetime            = mean(cell2mat({subjectfiles.diff}));
    
    %Non-Dominant-Coefficient of variation)
    Avg_nondom(i).Midswing_Peak_CV      = (std(cell2mat({subjectfiles.cadence})) / mean(cell2mat({subjectfiles.Midswing_Peak}))) * 100;
    Avg_nondom(i).Cadence_CV            = (std(cell2mat({subjectfiles.cadence})) / mean(cell2mat({subjectfiles.cadence}))) * 100;
    Avg_nondom(i).Rel_stancetime_CV     = (std(cell2mat({subjectfiles.rel_stancetime})) / mean(cell2mat({subjectfiles.rel_stancetime}))) * 100;
    Avg_nondom(i).Rel_swingtime_CV      = (std(cell2mat({subjectfiles.rel_swingtime})) / mean(cell2mat({subjectfiles.rel_swingtime}))) * 100;
    Avg_nondom(i).stridetime_CV         = (std(cell2mat({subjectfiles.diff})) / mean(cell2mat({subjectfiles.diff}))) * 100;
end

for i = 2:length(fieldnames(Avg_dom))
    parameter = fieldnames(Avg_dom);
    Table_2.Disease_vs_nondisease(i).parameter    = parameter{i};
    Table_2.Disease_vs_nondisease(i).Dominant     = sprintf('%.2f',mean(cat(2,Avg_dom.(parameter{i})),2));
    Table_2.Disease_vs_nondisease(i).Dom_SD       = sprintf('%.2f',std(cat(2,Avg_dom.(parameter{i})),1));
    Table_2.Disease_vs_nondisease(i).Non_Dominant = sprintf('%.2f',mean(cat(2,Avg_nondom.(parameter{i})),2));
    Table_2.Disease_vs_nondisease(i).Nondom_SD    = sprintf('%.2f',std(cat(2,Avg_nondom.(parameter{i})),1));
    Table_2.Disease_vs_nondisease(i).P            = signrank(cat(2,Avg_dom.(parameter{i})),cat(2,Avg_nondom.(parameter{i})));
end
Table_2.Disease_vs_nondisease(1) = []; clear i idx subjecfiles parameter 


% PRE-STOP FILES ========================================================================================================
%Compute Cadence, relative stance time, relative swing time
for i = 1:length(GaitData_Pre_Stop)
    GaitData_Pre_Stop(i).cadence         = 60/(GaitData_Pre_Stop(i).duration/2);
    GaitData_Pre_Stop(i).rel_stancetime  = GaitData_Pre_Stop(i).Toe_Off;
    GaitData_Pre_Stop(i).rel_swingtime   = 100-GaitData_Pre_Stop(i).Toe_Off;
end

names                   = unique({GaitData_Pre_Stop.name});
for i = 1:length(names)
     subjectfiles = cat(1,GaitData_Pre_Stop(ismember(cat(1,{GaitData_Pre_Stop.name}), names{i})));  
     [~, idx1] = rmoutliers([GaitData_Pre_Stop(ismember(cat(1,{GaitData_Pre_Stop.name}), names{i})).rel_stancetime]);
     [~, idx2] = rmoutliers([subjectfiles.duration]); 
     idx = (idx1 + idx2) > 0; subjectfiles(idx) = [];

      Pre_Stop(i).name                     = names{i};
      Pre_Stop(i).Midswing_Peak            = mean(cell2mat({subjectfiles.Midswing_Peak}));
      Pre_Stop(i).Cadence                  = mean(cell2mat({subjectfiles.cadence}));
      Pre_Stop(i).Rel_stancetime           = mean(cell2mat({subjectfiles.rel_stancetime}));
      Pre_Stop(i).Rel_swingtime            = mean(cell2mat({subjectfiles.rel_swingtime}));
      Pre_Stop(i).stridetime               = mean(cell2mat({subjectfiles.duration}));
    
      %Coefficient of variation)
      Pre_Stop(i).Midswing_Peak_CV         = (std(cell2mat({subjectfiles.cadence})) / mean(cell2mat({subjectfiles.Midswing_Peak}))) * 100;
      Pre_Stop(i).Cadence_CV               = (std(cell2mat({subjectfiles.cadence})) / mean(cell2mat({subjectfiles.cadence}))) * 100;
      Pre_Stop(i).Rel_stancetime_CV        = (std(cell2mat({subjectfiles.rel_stancetime})) / mean(cell2mat({subjectfiles.rel_stancetime}))) * 100;
      Pre_Stop(i).Rel_swingtime_CV         = (std(cell2mat({subjectfiles.rel_swingtime})) / mean(cell2mat({subjectfiles.rel_swingtime}))) * 100;
      Pre_Stop(i).stridetime_CV            = (std(cell2mat({subjectfiles.duration})) / mean(cell2mat({subjectfiles.duration}))) * 100;
end


idx = matches({Avg_dom.name},{Pre_Stop.name}); %Chose only subjects that provided pre_stops 
for i = 2:length(fieldnames(Pre_Stop))
    parameter = fieldnames(Pre_Stop);
    Table_2.Walking_vs_Pre_Stop(i).parameter    = parameter{i};
    Table_2.Walking_vs_Pre_Stop(i).Dominant     = sprintf('%.2f',mean(cat(2,Avg_dom(idx).(parameter{i})),2));
    Table_2.Walking_vs_Pre_Stop(i).Dom_SD       = sprintf('%.2f',std(cat(2,Avg_dom(idx).(parameter{i})),1));
    Table_2.Walking_vs_Pre_Stop(i).Pre_Stop     = sprintf('%.2f',mean(cat(2,Pre_Stop.(parameter{i})),2));
    Table_2.Walking_vs_Pre_Stop(i).pre_Stop_SD  = sprintf('%.2f',std(cat(2,Pre_Stop.(parameter{i})),1));
    Table_2.Walking_vs_Pre_Stop(i).P            = signrank(cat(2,Avg_dom(idx).(parameter{i})),cat(2,Pre_Stop.(parameter{i})));
end
Table_2.Walking_vs_Pre_Stop(1) = []; clear subjectfiles i 

% Pre_FOG Files ========================================================================================================
%Compute Cadence, relative stance time, relative swing time
for i = 1:length(GaitData_Pre_Fog)
    GaitData_Pre_Fog(i).cadence         = 60/(GaitData_Pre_Fog(i).duration/2);
    GaitData_Pre_Fog(i).rel_stancetime  = GaitData_Pre_Fog(i).Toe_Off;
    GaitData_Pre_Fog(i).rel_swingtime   = 100-GaitData_Pre_Fog(i).Toe_Off;
end

names                   = unique({GaitData_Pre_Fog.name});
for i = 1:length(names)
     subjectfiles = cat(1,GaitData_Pre_Fog(ismember(cat(1,{GaitData_Pre_Fog.name}), names{i})));  
     [~, idx] = rmoutliers([GaitData_Pre_Stop(ismember(cat(1,{GaitData_Pre_Fog.name}), names{i})).rel_stancetime]);
     [~, idx] = rmoutliers([subjectfiles.duration]); 
     idx = (idx1 + idx2) > 0; subjectfiles(idx) = [];

      Pre_Fog(i).name                     = names{i};
      Pre_Fog(i).Midswing_Peak            = mean(cell2mat({subjectfiles.Midswing_Peak}));
      Pre_Fog(i).Cadence                  = mean(cell2mat({subjectfiles.cadence}));
      Pre_Fog(i).Rel_stancetime           = mean(cell2mat({subjectfiles.rel_stancetime}));
      Pre_Fog(i).Rel_swingtime            = mean(cell2mat({subjectfiles.rel_swingtime}));
      Pre_Fog(i).stridetime               = mean(cell2mat({subjectfiles.duration}));
    
      %Coefficient of variation)
      Pre_Fog(i).Midswing_Peak_CV         = (std(cell2mat({subjectfiles.cadence})) / mean(cell2mat({subjectfiles.Midswing_Peak}))) * 100;
      Pre_Fog(i).Cadence_CV               = (std(cell2mat({subjectfiles.cadence})) / mean(cell2mat({subjectfiles.cadence}))) * 100;
      Pre_Fog(i).Rel_stancetime_CV        = (std(cell2mat({subjectfiles.rel_stancetime})) / mean(cell2mat({subjectfiles.rel_stancetime}))) * 100;
      Pre_Fog(i).Rel_swingtime_CV         = (std(cell2mat({subjectfiles.rel_swingtime})) / mean(cell2mat({subjectfiles.rel_swingtime}))) * 100;
      Pre_Fog(i).stridetime_CV            = (std(cell2mat({subjectfiles.duration})) / mean(cell2mat({subjectfiles.duration}))) * 100;
end

idx = matches({Avg_dom.name},{Pre_Fog.name}); %Chose only subjects that provided pre_stops 
for i = 2:length(fieldnames(Pre_Fog))
    if i == 1 || i == 2; f = 0; elseif i > 2; f = 2; end; 
    parameter = fieldnames(Pre_Fog);
    Table_2.Walking_vs_Pre_Fog(i).parameter    = parameter{i};
    Table_2.Walking_vs_Pre_Fog(i).Dominant     = sprintf('%.2f',round(mean(cat(2,Avg_dom(idx).(parameter{i})),2),f));
    Table_2.Walking_vs_Pre_Fog(i).dom_SD       = sprintf('%.2f',round(std(cat(2,Avg_dom(idx).(parameter{i})),1),f));
    Table_2.Walking_vs_Pre_Fog(i).Pre_Fog      = sprintf('%.2f',round(mean(cat(2,Pre_Fog.(parameter{i})),2),f));
    Table_2.Walking_vs_Pre_Fog(i).pre_Fog_SD   = sprintf('%.2f',round(std(cat(2,Pre_Fog.(parameter{i})),1),f));
    Table_2.Walking_vs_Pre_Fog(i).P            = signrank(cat(2,Avg_dom(idx).(parameter{i})),cat(2,Pre_Fog.(parameter{i})));
end
Table_2.Walking_vs_Pre_Fog(1) = []; clear subjectfiles i 



%Final Table (as in manuscript file) 
B                                     = {' ± ', ' ± ', ' ± ',' ± ',' ± ',' ± ',' ± ',' ± ',' ± ',' ± '};
FINAL_TABLE2                          = table('Size', [10, 10], 'VariableTypes',{'string', 'double','double','double','double','double','double','double','double','double'});
FINAL_TABLE2.Properties.VariableNames = {'Parameter'; 'Walking (D)';'Walking (ND)';'P ';'Pre_Stop (D)';'Walking (D )';' P';'Pre-FoG (D)';'Walking ( D)';'P'};
FINAL_TABLE2.Parameter(1:10)          = {Table_2.Walking_vs_Pre_Fog.parameter};
FINAL_TABLE2.("P ")(1:10)             = [Table_2.Disease_vs_nondisease.P];
FINAL_TABLE2.(" P")(1:10)             = [Table_2.Walking_vs_Pre_Stop.P];
FINAL_TABLE2.P(1:10)                  = [Table_2.Walking_vs_Pre_Fog.P];
FINAL_TABLE2.("Walking (D)")          = strcat({Table_2.Disease_vs_nondisease.Dominant},B,{Table_2.Disease_vs_nondisease.Dom_SD})';
FINAL_TABLE2.("Walking (ND)")         = strcat({Table_2.Disease_vs_nondisease.Non_Dominant},B,{Table_2.Disease_vs_nondisease.Nondom_SD})';
FINAL_TABLE2.("Pre_Stop (D)")         = strcat({Table_2.Walking_vs_Pre_Stop.Pre_Stop},B,{Table_2.Walking_vs_Pre_Stop.pre_Stop_SD})';
FINAL_TABLE2.("Walking (D )")         = strcat({Table_2.Walking_vs_Pre_Stop.Dominant},B,{Table_2.Walking_vs_Pre_Stop.Dom_SD})';
FINAL_TABLE2.("Pre-FoG (D)")          = strcat({Table_2.Walking_vs_Pre_Fog.Pre_Fog},B,{Table_2.Walking_vs_Pre_Fog.pre_Fog_SD})';
FINAL_TABLE2.("Walking ( D)")         = strcat({Table_2.Walking_vs_Pre_Fog.Dominant},B,{Table_2.Walking_vs_Pre_Fog.dom_SD})';

%Save Table
filepath        = subjectdata.generalpath; cd(filepath)
filepath        = extractBefore(filepath,"Kinematic-Data");   
filepath        = char(filepath);
filepath        = string(filepath(1:end-1));
filepath        = append(filepath,filesep, "Table & Figures"); cd(filepath)
writetable(FINAL_TABLE2,"Table_2.xlsx",'Sheet',1,'Range','A1:J11')

%Find table under Sensefog-main/Table & Figures

% *********************** END OF SCRIPT ************************************************************************************************************************
