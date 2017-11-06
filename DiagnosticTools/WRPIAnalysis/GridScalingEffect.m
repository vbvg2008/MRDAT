function GridScalingEffect(case_data)
% Analyze the effect of grid scaling on the scatter plot 
% of Log(Initial RPI) vs Log(FinalCumOil)
%
% Last Update Date: 10/27/2017 
%
%SYNOPSIS:
%   GridScalingEffect(case_data)
%
%DESCRIPTION:
%   This function generates a comparative plot to analyze the effect of 
% grid scaling on the scatter plot of Log(Initial RPI) 
% vs Log(FinalCumOil)
%
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%
%
% Before using this function, import data from 20ac and 20ac_NG
% scenarios, and merge them into one case_data structure
%
% load 20ac_20acNG.mat;
% load 320ac_320acNG.mat;

num_cases = length(case_data);
TotalDaysIdx = length(case_data{1,1}.Tvar.Time.cumt);

for i=1:1012 % 20ac or 320ac
    InitialRPI(i,1) = case_data{i,1}.DerivedData.WPRO2.RPI.data(2);
    FinalCumOil(i,1) = case_data{i,1}.Tvar.Field.OilProductionCumulative.data(TotalDaysIdx);
end

k=1;
for i=1013:num_cases % 20acNG or 320acNG
    InitialRPI_NG(k,1) = case_data{i,1}.DerivedData.WPRO2.RPI.data(2);
    FinalCumOil_NG(k,1) = case_data{i,1}.Tvar.Field.OilProductionCumulative.data(TotalDaysIdx);
    k = k+1;
end

figure;
scatter(log10(InitialRPI),log10(FinalCumOil), [], 'b', 'o');
hold on;
% scatter(log10(InitialRPI_NG),log10(FinalCumOil_NG), [], 'r', 'x'); % 20ac
scatter(log10(InitialRPI_NG),log10(FinalCumOil_NG), [], 'g', 'x'); % 320ac
xlabel('Logarithm of Initial RPI');
ylabel('Logarithm of Final Cumulative Oil');
grid on;
% legend('50x50x42 cells', '25x25x42 cells'); % 20ac
legend('50x50x42 cells', '100x100x42 cells'); % 320ac

end