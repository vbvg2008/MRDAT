function HCPVIvsRF_AdditionalPlots(case_data)
% Generate additional scatter plots of HCPVI vs oil recovery clustered by 
% Chan diagnostic identifier and Initial RPI
%
% Last Update Date: 10/26/2017
%
%SYNOPSIS:
%   HCPVIvsRF_AdditionalPlots(case_data)
%
%DESCRIPTION:
% This function generates additional scatter plots of HCPVI vs oil recovery 
% clustered by Chan diagnostic identifier and Initial RPI
%
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%
% load 80acData.mat
% load 80acHT.mat

num_cases = length(case_data);
Time = case_data{1,1}.Tvar.Time.cumt;
TotalDaysIdx = length(Time);

for i=1:num_cases
    WBT_Days(i,1) = case_data{i,1}.Diagnostics.FWA.Field.WaterBreakthrough.Time;
    WBT_CumOilProd(i,1) = case_data{i,1}.Diagnostics.FWA.Field.WaterBreakthrough.CumOil;
    WBT_ResVolProdCum(i,1) = case_data{i,1}.Diagnostics.FWA.Field.WaterBreakthrough.CumResVolProd;
    WBT_HCPVI(i,1) = case_data{i,1}.Diagnostics.FWA.Field.WaterBreakthrough.HCPVI;
    FinalRF(i,1) = case_data{i,1}.Tvar.Field.OilRecoveryEfficiency.data(TotalDaysIdx);
    FinalCumOil(i,1) = case_data{i,1}.Tvar.Field.OilProductionCumulative.data(TotalDaysIdx);
    FinalResCumProd(i,1) = case_data{i,1}.Tvar.Field.ReservoirVolumeProductionCumulative.data(TotalDaysIdx);
    FinalHCPVI(i,1) = case_data{i,1}.DerivedData.Field.HCPVI.data(TotalDaysIdx);
    FinalPVI(i,1) = case_data{i,1}.DerivedData.Field.PVI.data(TotalDaysIdx);
    ChanPlotFlag(i,1) = case_data{i,1}.Diagnostics.FWA.Field.ChanPlotFlag;
    RPI_Cluster(i,1) = case_data{i,1}.Diagnostics.Clustering.InitialRPIvsCumOil;
    
end

% figure;
% scatter(WBT_HCPVI, FinalRF, 20, 'r', 'filled');
% xlabel('Pore Volume Injected at WB');
% ylabel('Final Oil Recovery');
% grid on;
% 
% figure;
% scatter(FinalHCPVI, FinalRF, 20, 'r', 'filled');
% xlabel('Final Pore Volume Injected');
% ylabel('Final Oil Recovery');
% grid on;

% figure;
% scatter(ChanPlotFlag, FinalRF, 20, 'b', 'filled');
% xlabel('Chan Plot Flag');
% ylabel('Final Oil Recovery');
% grid on;

figure;
c = ['r', 'g', 'm', 'c', 'b']; % for homogeneous
% c = ['r', 'g', 'c', 'b']; % for heterogeneous
gscatter(FinalHCPVI, FinalRF, ChanPlotFlag, c, '.', 20);
% gscatter(log10(FinalHCPVI), log10(FinalRF), ChanPlotFlag, c, '.', 20);
xlabel('Final Hydrocarbon Pore Volume Injected');
ylabel('Final Oil Recovery');
legend('Channeling', 'Coning', 'Normal', 'Not clear', 'No water production'); % for homogeneous
% legend('Channeling', 'Coning', 'Not clear', 'No water production'); % for heterogeneous
grid on;


figure;
c = ['r', 'g', 'm', 'c', 'b']; % for homogeneous
% c = ['r', 'g', 'c', 'b']; % for heterogeneous
gscatter(FinalHCPVI, FinalRF, RPI_Cluster, c, '.', 20);
xlabel('Final Hydrocarbon Pore Volume Injected');
ylabel('Final Oil Recovery');
legend('show'); 
grid on;


end