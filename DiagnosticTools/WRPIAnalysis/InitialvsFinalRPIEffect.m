function InitialvsFinalRPIEffect(case_data)
% Analyze the effect of RPI at different dates and its
% relationship with final cumulative oil production
%
% Last Update Date: 10/27/2017 
%
%SYNOPSIS:
%   InitialvsFinalRPIEffect(case_data)
%
%DESCRIPTION:
%   This function generates comparative plots to analyze the effect of 
% using Initial vs Final RPI on the scatter plot of Log(RPI) 
% vs Log(FinalCumOil)
%
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%
%
% Before using this function, import data from 80ac scenario
%
% load 80acData.mat
%


num_cases = length(case_data);
TotalDaysIdx = length(case_data{1,1}.Tvar.Time.cumt);
for i=1:num_cases
    InitialRPI(i,1) = case_data{i,1}.DerivedData.WPRO2.RPI.data(2);
    FinalRPI(i,1) = case_data{i,1}.DerivedData.WPRO2.RPI.data(TotalDaysIdx);
    FinalCumOil(i,1) = case_data{i,1}.Tvar.Field.OilProductionCumulative.data(TotalDaysIdx);
    FinalRF(i,1) = case_data{i,1}.Tvar.Field.OilRecoveryEfficiency.data(TotalDaysIdx);
    InitialWcut(i,1) = case_data{i,1}.DerivedData.Field.WC.data(2);
    FinalWcut(i,1) = case_data{i,1}.DerivedData.Field.WC.data(2);
end

MaxNumClusters = 5;
c = [1 0 0; 0.8 0.68 0.08; 0 0.95 0.2; 0 0.05 0.88; 0.8 0 1];

D1 = [log10(FinalRPI), log10(FinalCumOil)];
ClusterGroup1 = clusterdata(D1,'linkage','ward','maxclust',MaxNumClusters);

D2 = [log10(InitialRPI), log10(FinalCumOil)];
ClusterGroup2 = clusterdata(D2,'linkage','ward','maxclust',MaxNumClusters);

figure;
gscatter(D1(:,1),D1(:,2),ClusterGroup1, c, 'o', 5);
hold on;
gscatter(D2(:,1),D2(:,2),ClusterGroup1, c, 'x', 7);
text(0.2, 0.7, 'o  FinalRPI');
text(0.2, 0.4, 'x  InitialRPI');
xlabel('Logarithm of RPI');
ylabel('Logarithm of Final Cumulative Oil Production');
grid on;

figure;
scatter(log10(InitialRPI),log10(FinalCumOil), [], 'b', 'o');
hold on;
scatter(log10(FinalRPI),log10(FinalCumOil), [], 'r', '+');
xlabel('Logarithm of RPI');
ylabel('Logarithm of Final Cumulative Oil Production');
legend('Initial RPI', 'Final RPI');
grid on;

figure;
scatter(log10(FinalRPI),log10(InitialRPI), [], 'b', 'o');
xlabel('Logarithm of Final RPI');
ylabel('Logarithm of Initial RPI');
grid on;


end