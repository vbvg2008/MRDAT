%Call MHA routine 
Dir = 'C:\Users\Reza6165\Desktop\program';
Tfilename = 'Tvar.xlsx';
case_data = ImportTvar(Dir,Tfilename);
Pe = {'Tvar.Region.R23.DatumDepthCorrectedWaterPotential.data'};
cd(Dir);
case_data = MHA(Pe,case_data);

%------------------------------------
%call graphical interface only to review/edit existing plots:

Dir = 'C:\Users\Reza6165\Desktop\program';
Tfilename = 'Tvar.xlsx';
case_data = ImportTvar(Dir,Tfilename);
Pe = {'Tvar.Region.R23.DatumDepthCorrectedWaterPotential.data'};
cd(Dir);
case_data = MHA(Pe,case_data);  %during save, click no to exit program
MHA_gui(case_data);