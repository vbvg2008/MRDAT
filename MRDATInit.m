function  MRDATInit()



 current_path = fileparts(mfilename('fullpath'));
 
 addpath([current_path '/DataExtraction']);
 addpath([current_path '/DerivedFunctions']);
 addpath([current_path '/DiagnosticTools']);
 addpath([current_path '/DiagnosticTools/MHA']);
 addpath([current_path '/DiagnosticTools/FPAnalysis']);
 addpath([current_path '/DiagnosticTools/WRPIAnalysis']);
 addpath([current_path '/DiagnosticTools/FPAnalysis']);
 addpath([current_path '/DiagnosticTools/FWAnalysis']);
 
 disp('MRDAT Path Added...');
  
end
