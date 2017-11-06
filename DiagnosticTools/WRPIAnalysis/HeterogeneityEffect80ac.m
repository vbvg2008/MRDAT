function HeterogeneityEffect80ac(case_data)
% Analyze the effect of heterogeneity on the scatter plot 
% of Log(Initial RPI) vs Log(FinalCumOil)
%
% Last Update Date: 10/27/2017 
%
%SYNOPSIS:
%   HeterogeneityEffect80ac(case_data)
%
%DESCRIPTION:
%   This function generates a comparative plot to analyze the effect of 
% heterogeneity on the scatter plot of Log(Initial RPI) 
% vs Log(FinalCumOil)
%
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%
%
% Before using this function, import data from 80ac, 80ac_DD and 80ac_HT
% scenarios, and merge them into one case_data structure
%
%
%load 80ac_80acDD_80acHT.mat
%


num_cases = length(case_data);
TotalDaysIdx = length(case_data{1,1}.Tvar.Time.cumt);

for i=1:1012 %80ac
    InitialRPI(i,1) = case_data{i,1}.DerivedData.WPRO2.RPI.data(2);
    FinalCumOil(i,1) = case_data{i,1}.Tvar.Field.OilProductionCumulative.data(TotalDaysIdx);
end

% j=1;
% for i=1013:2024 % 80ac_DD
%     InitialRPI_DD(j,1) = case_data{i,1}.DerivedData.WPRO2.RPI.data(2);
%     FinalCumOil_DD(j,1) = case_data{i,1}.Tvar.Field.OilProductionCumulative.data(TotalDaysIdx);
%     j = j+1;
% end

k=1;
for i=2025:num_cases % 80ac_HT
    InitialRPI_HT(k,1) = case_data{i,1}.DerivedData.WPRO2.RPI.data(2);
    FinalCumOil_HT(k,1) = case_data{i,1}.Tvar.Field.OilProductionCumulative.data(TotalDaysIdx);
    k = k+1;
end

figure;
scatter(log10(InitialRPI),log10(FinalCumOil), [], 'b', 'o');
hold on;
% scatter(log10(InitialRPI_DD),log10(FinalCumOil_DD), [], 'g', '+');
% hold on;
scatter(log10(InitialRPI_HT),log10(FinalCumOil_HT), [], 'r', '^');
xlabel('Logarithm of Initial RPI');
ylabel('Logarithm of Final Cumulative Oil');
% title('80-acre well spacing');
grid on;
% legend('80ac', '80ac DD', '80ac HT');
% legend('Homogeneous - Drawdown limit', 'Homogeneous - No Drawdown limit', 'Heterogeneous - Drawdown limit');
legend('Homogeneous model', 'Heterogeneous model');

end