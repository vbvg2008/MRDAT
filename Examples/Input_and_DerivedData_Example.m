% **************************************************************
%                Input and Derived Data Example
% **************************************************************
% 
%% Initialization
MRDATInit
%  

%% ******************** Input Data ********************

%% Scenario 80ac (Dataset: 80acData.mat) 
TvarDir = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data\Data80ac';
CaseParaDir = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data';
CasePara_FileName = 'CaseParam_80ac.xlsx';

[case_data,case_list] = ImportTvar(TvarDir);
case_data = ImportCasePara(CaseParaDir,CasePara_FileName,case_data);

%% Scenario 80acHT (Dataset: 80acHT.mat)
CaseParaDir = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data';
TvarDir = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data\Data80acHT';
CasePara_FileName = 'CaseParam_80acHT.xlsx';
[case_data,case_list] = ImportTvar(TvarDir);
case_data = ImportCasePara(CaseParaDir,CasePara_FileName,case_data);

%% Scenario 20ac (Dataset: 20acData.mat)
TvarDir_20ac = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data\Data20ac';
CaseParaDir = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data';
CasePara_FileName_20ac = 'CaseParam_20ac.xlsx';

[case_data,case_list] = ImportTvar(TvarDir_20ac);
case_data = ImportCasePara(CaseParaDir,CasePara_FileName_20ac,case_data);

%% Scenario 320ac (Dataset: 320acData.mat)
TvarDir_320ac = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data\Data320ac';
CaseParaDir = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data';
CasePara_FileName_320ac = 'CaseParam_320ac.xlsx';

[case_data,case_list] = ImportTvar(TvarDir_320ac);
case_data = ImportCasePara(CaseParaDir,CasePara_FileName_320ac,case_data);

%% Scenario 80ac, 20ac and 320ac (Dataset: 20ac_80ac_320ac.mat)
CaseParaDir = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data';
TvarDir_80ac = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data\Data80ac';
CasePara_FileName_80ac = 'CaseParam_80ac.xlsx';
TvarDir_20ac = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data\Data20ac';
CasePara_FileName_20ac = 'CaseParam_20ac.xlsx';
TvarDir_320ac = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data\Data320ac';
CasePara_FileName_320ac = 'CaseParam_320ac.xlsx';

[case_data_80ac,case_list_80ac] = ImportTvar(TvarDir_80ac);
case_data_80ac = ImportCasePara(CaseParaDir,CasePara_FileName_80ac,case_data_80ac);
[case_data_20ac,case_list_20ac] = ImportTvar(TvarDir_20ac);
case_data_20ac = ImportCasePara(CaseParaDir,CasePara_FileName_20ac,case_data_20ac);
[case_data_320ac,case_list_320ac] = ImportTvar(TvarDir_320ac);
case_data_320ac = ImportCasePara(CaseParaDir,CasePara_FileName_320ac,case_data_320ac);

case_data = [case_data_80ac; case_data_20ac; case_data_320ac];
case_list = [case_list_80ac; case_list_20ac; case_list_320ac];


%% Scenario 80ac, 20acNG and 320acNG (Dataset: 20acNG_80ac_320acNG.mat)
CaseParaDir = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data';
TvarDir_80ac = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data\Data80ac';
CasePara_FileName_80ac = 'CaseParam_80ac.xlsx';
[case_data_80ac,case_list_80ac] = ImportTvar(TvarDir_80ac);
case_data_80ac = ImportCasePara(CaseParaDir,CasePara_FileName_80ac,case_data_80ac);

TvarDir_20ac = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data\Data20acNG';
CasePara_FileName_20ac = 'CaseParam_20acNG.xlsx';
[case_data_20ac,case_list_20ac] = ImportTvar(TvarDir_20ac);
case_data_20ac = ImportCasePara(CaseParaDir,CasePara_FileName_20ac,case_data_20ac);

TvarDir_320ac = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data\Data320acNG';
CasePara_FileName_320ac = 'CaseParam_320acNG.xlsx';
[case_data_320ac,case_list_320ac] = ImportTvar(TvarDir_320ac);
case_data_320ac = ImportCasePara(CaseParaDir,CasePara_FileName_320ac,case_data_320ac);

case_data = [case_data_80ac; case_data_20ac; case_data_320ac];
case_list = [case_list_80ac; case_list_20ac; case_list_320ac];


%% Scenario 80ac, 80acDD and 80acHT (Datasets: 80ac_80acDD_80acHT.mat and 80ac_80acHT.mat)
CaseParaDir = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data';

TvarDir_80ac = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data\Data80ac';
CasePara_FileName_80ac = 'CaseParam_80ac.xlsx';
[case_data_80ac,case_list_80ac] = ImportTvar(TvarDir_80ac);
case_data_80ac = ImportCasePara(CaseParaDir,CasePara_FileName_80ac,case_data_80ac);

TvarDir_80acDD = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data\Data80acDD';
CasePara_FileName_80acDD = 'CaseParam_80acDD.xlsx';
[case_data_80acDD,case_list_80acDD] = ImportTvar(TvarDir_80acDD);
case_data_80acDD = ImportCasePara(CaseParaDir,CasePara_FileName_80acDD,case_data_80acDD);

TvarDir_80acHT = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data\Data80acHT';
CasePara_FileName_80acHT = 'CaseParam_80acHT.xlsx';
[case_data_80acHT,case_list_80acHT] = ImportTvar(TvarDir_80acHT);
case_data_80acHT = ImportCasePara(CaseParaDir,CasePara_FileName_80acHT,case_data_80acHT);

case_data = [case_data_80ac; case_data_80acDD; case_data_80acHT];
case_list = [case_list_80ac; case_list_80acDD; case_list_80acHT];

case_data = [case_data_80ac; case_data_80acHT];
case_list = [case_list_80ac; case_list_80acHT];


%% Scenario 20ac and 20acNG (Dataset: 20ac_20acNG.mat)
CaseParaDir = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data';

TvarDir_20ac = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data\Data20ac';
CasePara_FileName_20ac = 'CaseParam_20ac.xlsx';
[case_data_20ac,case_list_20ac] = ImportTvar(TvarDir_20ac);
case_data_20ac = ImportCasePara(CaseParaDir,CasePara_FileName_20ac,case_data_20ac);

TvarDir_20acNG = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data\Data20acNG';
CasePara_FileName_20acNG = 'CaseParam_20acNG.xlsx';
[case_data_20acNG,case_list_20acNG] = ImportTvar(TvarDir_20acNG);
case_data_20acNG = ImportCasePara(CaseParaDir,CasePara_FileName_20acNG,case_data_20acNG);

case_data = [case_data_20ac; case_data_20acNG];
case_list = [case_list_20ac; case_list_20acNG];


%% Scenario 320ac and 320acNG (Dataset: 320ac_320acNG.mat) 
CaseParaDir = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data';

TvarDir_320ac = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data\Data320ac';
CasePara_FileName_320ac = 'CaseParam_320ac.xlsx';
[case_data_320ac,case_list_320ac] = ImportTvar(TvarDir_320ac);
case_data_320ac = ImportCasePara(CaseParaDir,CasePara_FileName_320ac,case_data_320ac);

TvarDir_320acNG = 'C:\Users\Any Clariseth\Documents\MATLAB\WD\Data\Data320acNG';
CasePara_FileName_320acNG = 'CaseParam_320acNG.xlsx';
[case_data_320acNG,case_list_320acNG] = ImportTvar(TvarDir_320acNG);
case_data_320acNG = ImportCasePara(CaseParaDir,CasePara_FileName_320acNG,case_data_320acNG);

case_data = [case_data_320ac; case_data_320acNG];
case_list = [case_list_320ac; case_list_320acNG];


%% Scenario Multi-well (Dataset: MW_100Cases_01122018.mat) 
TvarDir = 'C:\Users\Any Clariseth\Documents\MATLAB\Data\Data_MW_300Cases\Data';
CaseParaDir = 'C:\Users\Any Clariseth\Documents\MATLAB\Data\Data_MW_300Cases';
CasePara_FileName = 'CasePara_MW_300Cases.xlsx';

[case_data,case_list] = ImportTvar(TvarDir);
case_data = ImportCasePara(CaseParaDir,CasePara_FileName,case_data);

dir = 'C:\Users\Any Clariseth\Documents\MATLAB\Data\Data_MW_300Cases\GRDECL';
fileName_perm = 'PERMX.GRDECL';
fileName_region = 'Region.GRDECL';
nk = 52;
num_cases = 100;
keywordName = 'FIP_ADD';

grid_data = ImportGRDECL_perm(dir, fileName_perm, nK, num_cases);
grid_data = ImportGRDECL_Region(dir, fileName_region, nK, keywordName, grid_data);


%% ******************** Derived Data ********************

case_data = WOR(case_data); % water-oil ratio
case_data = WC(case_data); % water cut
case_data = GOR(case_data); % gas-oil ratio
case_data = OC(case_data); % oil cut
case_data = RPI(case_data); % reciprocal productivity index 
case_data = ErsaghiIndex(case_data); % Ersaghi index 
case_data = MBT(case_data); % material balance time
case_data = HCPVI(case_data); % hydrocarbon pore volume injected
case_data = RF(case_data); % oil recovery efficiency







