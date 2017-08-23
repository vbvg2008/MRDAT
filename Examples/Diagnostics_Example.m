% **************************************************************
%                           Diagnostics Example
% **************************************************************
% 
% Last Update Date: 07/13/2017 
%
% DESCRIPTION:
%   Example for Data Extraction, Derived Functions and Diagnostic Tools 
%
% PARAMETERS:
%   case_data: data structure that is used in MRDAT
%   TvarDir: Directory path for the Time-dependent data files
%   CaseParamDir: Directory path for the case parameters file
%   CaseParamFileName: Name of the case parameters file 
% 
% Initialization
MRDATInit
%  

% ******************** Input Data ********************

% % % % Original Data
% % % TvarDir_1000 = 'C:\Users\Any Clariseth\Documents\MATLAB\MRDAT\Data\Original\Data Files 1000 Cases';
% % % TvarDir_512 = 'C:\Users\Any Clariseth\Documents\MATLAB\MRDAT\Data\Original\Data Files 500 Cases';
% % % CaseParaDir_1000 = 'C:\Users\Any Clariseth\Documents\MATLAB\MRDAT\Data\Original';
% % % CaseParaDir_512 = 'C:\Users\Any Clariseth\Documents\MATLAB\MRDAT\Data\Original';
% % % CasePara_FileName_1000 = '1000_Case_Param.xlsx';
% % % CasePara_FileName_512 = '512_Case_Param.xlsx';
% % % 
% % % [case_data_1000,case_list_1000] = ImportTvar(TvarDir_1000);
% % % case_data_1000 = ImportCasePara(CaseParaDir_1000,CasePara_FileName_1000,case_data_1000);
% % % 
% % % [case_data_512,case_list_512] = ImportTvar(TvarDir_512);
% % % case_data_512 = ImportCasePara(CaseParaDir_512,CasePara_FileName_512,case_data_512);
% % % 
% % % case_data = [case_data_1000;case_data_512];
% % % case_list = [case_list_1000;case_list_512];


% Case 80ac Data
TvarDir = 'C:\MRDAT\Data\Foam 300';
CaseParaDir = 'C:\MRDAT\Data';
CasePara_FileName_80ac = 'CaseParam_80ac.xlsx';
[case_data,case_list] = ImportTvar(TvarDir);
case_data = ImportCasePara(CaseParaDir,CasePara_FileName_80ac,case_data);


% % % Case 20ac Data
% % TvarDir_20ac = 'C:\Users\Any Clariseth\Documents\MATLAB\MRDAT\Data\Data20ac';
% % CaseParaDir = 'C:\Users\Any Clariseth\Documents\MATLAB\MRDAT\Data';
% % CasePara_FileName_20ac = 'CaseParam_20ac.xlsx';
% % 
% % [case_data,case_list] = ImportTvar(TvarDir_20ac);
% % case_data = ImportCasePara(CaseParaDir,CasePara_FileName_20ac,case_data);
% % 
% % % Case 320ac Data
% % TvarDir_320ac = 'C:\Users\Any Clariseth\Documents\MATLAB\MRDAT\Data\Data320ac';
% % CaseParaDir = 'C:\Users\Any Clariseth\Documents\MATLAB\MRDAT\Data';
% % CasePara_FileName_320ac = 'CaseParam_320ac.xlsx';
% % 
% % [case_data,case_list] = ImportTvar(TvarDir_320ac);
% % case_data = ImportCasePara(CaseParaDir,CasePara_FileName_320ac,case_data);

% % % Case 80ac, 20ac and 320ac Data (all together)
% % CaseParaDir = 'C:\Users\Any Clariseth\Documents\MATLAB\MRDAT\Data';
% % TvarDir_80ac = 'C:\Users\Any Clariseth\Documents\MATLAB\MRDAT\Data\Data80ac';
% % CasePara_FileName_80ac = 'CaseParam_80ac.xlsx';
% % TvarDir_20ac = 'C:\Users\Any Clariseth\Documents\MATLAB\MRDAT\Data\Data20ac';
% % CasePara_FileName_20ac = 'CaseParam_20ac.xlsx';
% % TvarDir_320ac = 'C:\Users\Any Clariseth\Documents\MATLAB\MRDAT\Data\Data320ac';
% % CasePara_FileName_320ac = 'CaseParam_320ac.xlsx';
% % 
% % [case_data_80ac,case_list_80ac] = ImportTvar(TvarDir_80ac);
% % case_data_80ac = ImportCasePara(CaseParaDir,CasePara_FileName_80ac,case_data_80ac);
% % [case_data_20ac,case_list_20ac] = ImportTvar(TvarDir_20ac);
% % case_data_20ac = ImportCasePara(CaseParaDir,CasePara_FileName_20ac,case_data_20ac);
% % [case_data_320ac,case_list_320ac] = ImportTvar(TvarDir_320ac);
% % case_data_320ac = ImportCasePara(CaseParaDir,CasePara_FileName_320ac,case_data_320ac);
% % 
% % case_data = [case_data_80ac; case_data_20ac; case_data_320ac];
% % case_list = [case_list_80ac; case_list_20ac; case_list_320ac];

% 
% ******************** Derived Data ********************
% Get the derived data (ex.: GOR, WC, WOR, OC, RPI, etc...)

case_data = WOR(case_data);
case_data = WC(case_data);
case_data = GOR(case_data);
case_data = OC(case_data);
case_data = RPI(case_data);
case_data = ErsaghiIndex(case_data);
case_data = MBT(case_data);

% ******************** Field Production Analysis ********************

% Gradient of GOR, WOR, WC and OC w.r.t. reservoir volume prod cumulative
% Finds minima and maxima of the gradient and their locations

save_flag = 0; % Flag to save plot files - (1 - yes; 0 - no)
plot_type = 5; % Flag for plot types (1 - log-log (default); 2 - cartesian-cartesian; 3 - cartesian-log; 4 - log-cartesian; 5 - all above)

case_data = FGORResVolMinMax(case_data,save_flag);
case_data = FWORResVolMinMax(case_data,save_flag);
case_data = FWCResVolMinMax(case_data);
case_data = FOCResVolMinMax(case_data);

% Gradient of GOR, WOR, WC and OC w.r.t. time
% Finds minima and maxima of the gradient and their locations

case_data = FGORTimeMinMax(case_data,plot_type,save_flag);
case_data = FWORTimeMinMax(case_data,plot_type,save_flag);
case_data = FWCTimeMinMax(case_data,plot_type,save_flag);
case_data = FOCTimeMinMax(case_data,plot_type,save_flag);

% Diagnostic plots

case_data = FWORGORWC_RVPlots(case_data);
case_data = FWORGORWCOC_RVPlots(case_data);
case_data = FWORGORWCOC_TimePlots(case_data);

case_data = DP_GORWC(case_data);
case_data = DP_GORWCOC(case_data);
case_data = DP_3D_GORWCOC(case_data);


% ************ Field Water Production Analysis ************

case_data = WaterBreakthrough(case_data);
ErsaghiIndexPlots(case_data);


% ************ Well Reciprocal Productivity Index Analysis ************

case_data = WRPI_IniMinMaxPlots(case_data);
% case_data = FPressure_MinMaxPlots(case_data);
% case_data = FGOR_MinMaxPlots(case_data);
% RPI_Analysis(case_data);
% case_data = ClusteringRPIvsCumOil(case_data);
case_data = ClusteringLogRPIvsCumOil(case_data);
case_data = ClusteringLogRPIvsRF(case_data);
case_data = ClusteringLogRPIvsWBT(case_data);


% case_data = AvgDPvsTNpRVPC(case_data);
% case_data = ClusteringAvgDPvsNp(case_data);
% case_data = ClusteringAvgDPvsRF(case_data);

% ******************** Modified Hall Analysis ********************






