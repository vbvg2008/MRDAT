%Example for ImportTvar and ImportCasePara
Dir = 'C:\Users\reza6615\Desktop\MRDAT\data';
TVarFilename = 'ProdInjProfiles.xlsx';
TvarFilename2 = 'CumProductionProfiles.xlsx';
CaseFilename = 'CasePara.xlsx';

%------------------------------
%1 Importing one Tvar file
[case_data,case_list] = ImportTvar(Dir,TVarFilename);

%2 Importing one casePara file
[case_data,case_list] = ImportCasePara(Dir,CaseFilename);

%3 Importing Tvar then CasePara
case_data = ImportTvar(Dir,TVarFilename);
[case_data,case_list] = ImportCasePara(Dir,CaseFilename,case_data);

%4 Importing CasePara then Tvar
case_data = ImportCasePara(Dir,CaseFilename);
[case_data,case_list] = ImportTvar(Dir,TVarFilename,case_data);

%5 if you have multiple Tvar files to import
case_data = ImportTvar(Dir,TVarFilename);
case_data = ImportTvar(Dir,TvarFilename2,case_data);

%6 if you want to import all Tvar files in Dir:
case_data = ImportTvar(Dir);