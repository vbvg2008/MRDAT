% **************************************************************
%      Initial RPI Analysis and Heterogeneity Index Example
% **************************************************************
% 
% Initialization: MRDATInit
%  
%% ************ Field Water Production Analysis ************

% load 80acData.mat;
% Load 80acData.mat dataset
save_flag = 1; % or save_flag = 0;
scenario_type = 'single-well'; % or scenario_type = 'multi-well';
% case_data = WaterBreakthrough_byWell(case_data, save_flag);
% case_data = WaterBreakthrough_byField(case_data, save_flag);
case_data = WaterBreakthrough(case_data, save_flag, scenario_type);
case_data = ChanDiagnosticPlots_WOR(case_data, save_flag);
ErsaghiIndexPlots(case_data);
Yfunction(case_data);

%% ************ Reciprocal Productivity Index Analysis ************

% load 80acData.mat;
% case_data = WRPI_IniMinMaxPlots(case_data); % generate plots of RPI and its derivative with respect to time
case_data = ClusteringLogRPIvsCumOil(case_data); 
case_data = ClusteringLogRPIvsRF(case_data); 
ClusteringLogRPIvsWBT(case_data); 
InitialvsFinalRPIEffect(case_data);

% load 80ac_80acDD.mat;
DrawdownEffect80ac(case_data); 

% load 20ac_80ac_320ac.mat;
%load 20acNG_80ac_320acNG.mat;
WellSpacingEffect(case_data); 

% load 20ac_20acNG.mat;
%load 320ac_320acNG.mat;
GridScalingEffect(case_data); 

% load 80ac_80acDD_80acHT.mat;
HeterogeneityEffect80ac(case_data); 


%% ******************* Heterogeneity Index *******************

% load 80ac_80acHT.mat dataset ;
% save_flag = 0;
% case_data = WaterBreakthrough(case_data, save_flag);
% case_data = ChanDiagnosticPlots_WOR(case_data, save_flag);
% case_data = ClusteringLogRPIvsCumOil(case_data); 
FinalHCPVIvsFinalRF(case_data);

% load 80acData.mat;
%load 80acHT.mat;
% save_flag = 0;
% case_data = WaterBreakthrough(case_data, save_flag);
% case_data = ChanDiagnosticPlots_WOR(case_data, save_flag);
% case_data = ClusteringLogRPIvsCumOil(case_data); 
HCPVIvsRF_AdditionalPlots(case_data);
HeterogeneityIndex(case_data);

