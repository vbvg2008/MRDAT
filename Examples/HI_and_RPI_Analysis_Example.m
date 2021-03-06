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
case_data = ChanDiagnosticPlots_WOR(case_data, save_flag, scenario_type);
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

%% ******************* Multi-well scenario *******************

% load MW_100Cases_01122018.mat (case data (input + derived data) + grid data (PERMX, Region))
% % % zones = [20 2 30];
% Completions = [5 18; 10 18; 5 19; 1 14; 4 18; 5 18; 11 20; 1 13; 4 17];
% save_flag = 0;
% scenario_type = 'multi-well';
% % % plotChoice = 1; % For plotting Vdp by layer in the well region vs IRPI - All wells/cases in the same plot.
% % % plotChoice = 2; % For plotting Vdp by well region vs IRPI - All wells/cases in the same plot.
% plotChoice = 3; % For plotting Vdp by well region vs IRPI - One plot per well.

case_data = WaterBreakthrough(case_data, save_flag, scenario_type);
case_data = ChanDiagnosticPlots_WOR(case_data, save_flag, scenario_type);
case_data = ClusteringLogRPIvsCumOil_MW(case_data, save_flag);
case_data = DykstraParsonsCoeff(grid_data, case_data, Completions);
VDPvsIRPI(case_data, plotChoice);
% % % [Vdp_byLayer, Vdp_byZone] = DykstraParsonsCoeff_byLayerZone(grid_data, zones);
% % % [Well_Vdp, IRPI] = VDPvsIRPI(case_data,Vdp_byLayer); % IRPI vs DP coefficient by completion layer
% % % RFvsVdp_plots(case_data, Vdp_byZone); % RF vs DP coefficient in the upper zone
HeterogeneityIndex(case_data); % HCPVI vs RF by field
HeterogeneityIndex_MW(case_data); % Np vs Wp by well
MostProductiveWells(case_data); % Histogram of most productive wells


