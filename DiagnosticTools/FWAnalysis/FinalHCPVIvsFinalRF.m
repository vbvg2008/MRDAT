function [WBT_HCPVI, WBT_HCPVI_HT, FinalHCPVI, FinalHCPVI_HT, FinalRF, FinalRF_HT, ChanPlotFlag, ChanPlotFlag_HT]=FinalHCPVIvsFinalRF(case_data)
% [WBT_HCPVI, WBT_HCPVI_HT, FinalHCPVI, FinalHCPVI_HT, FinalRF, FinalRF_HT, ChanPlotFlag, ChanPlotFlag_HT]=FinalHCPVIvsFinalRF(case_data)
% Generate water injected vs oil recovery performance plots
%
% Last Update Date: 10/26/2017
%
%SYNOPSIS:
%   FinalHCPVIvsFinalRF(case_data)
%
%DESCRIPTION:
% This function generates two water injected vs oil recovery performance 
% plots: 1) homogeneous model (80ac), and 2) heterogeneous model (80ac_HT)
%
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%
%
% load 80ac_80acHT.mat
% save_flag = 0;
% case_data = WaterBreakthrough(case_data, save_flag);
% case_data = ChanDiagnosticPlots_WOR(case_data, save_flag);

num_cases = length(case_data);
Time = case_data{1,1}.Tvar.Time.cumt;
TotalDaysIdx = length(Time);

figure;
for i=1:1012 % 80ac
    WBT_Days(i,1) = case_data{i,1}.Diagnostics.FWA.Field.WaterBreakthrough.Time;
    WBT_CumOilProd(i,1) = case_data{i,1}.Diagnostics.FWA.Field.WaterBreakthrough.CumOil;
    WBT_ResVolProdCum(i,1) = case_data{i,1}.Diagnostics.FWA.Field.WaterBreakthrough.CumResVolProd;
    WBT_HCPVI(i,1) = case_data{i,1}.Diagnostics.FWA.Field.WaterBreakthrough.HCPVI;
    WBT_PVI(i,1) = case_data{i,1}.Diagnostics.FWA.Field.WaterBreakthrough.PVI;
    FinalRF(i,1) = case_data{i,1}.Tvar.Field.OilRecoveryEfficiency.data(TotalDaysIdx);
    FinalCumOil(i,1) = case_data{i,1}.Tvar.Field.OilProductionCumulative.data(TotalDaysIdx);
    FinalResCumProd(i,1) = case_data{i,1}.Tvar.Field.ReservoirVolumeProductionCumulative.data(TotalDaysIdx);
    FinalHCPVI(i,1) = case_data{i,1}.DerivedData.Field.HCPVI.data(TotalDaysIdx);
    FinalPVI(i,1) = case_data{i,1}.DerivedData.Field.PVI.data(TotalDaysIdx);
    ChanPlotFlag(i,1) = case_data{i,1}.Diagnostics.FWA.Field.ChanPlotFlag;
    
    HCPVI(:,i) = case_data{i,1}.DerivedData.Field.HCPVI.data;
    PVI(:,i) = case_data{i,1}.DerivedData.Field.PVI.data;
    RF(:,i) = case_data{i,1}.Tvar.Field.OilRecoveryEfficiency.data;
    Qo(:, i) = case_data{i,1}.Tvar.Field.OilProductionRate.data;
    Np(:, i) = case_data{i,1}.Tvar.Field.OilProductionCumulative.data;
    PoreVolHC(:, i) = case_data{i,1}.Tvar.Field.PoreVolumeContainingHydrocarbon.data;
    plot(HCPVI(:,i), RF(:,i));
%     plot(PVI(:,i), RF(:,i));
    hold on;  
    
end
xlabel('Hydrocarbon Pore Volume Injected');
ylabel('Oil Recovery');
title('Homogeneous model');
grid on;


k=1;
figure;
for i=1013:num_cases % 80ac_HT
    WBT_Days_HT(k,1) = case_data{i,1}.Diagnostics.FWA.Field.WaterBreakthrough.Time;
    WBT_CumOilProd_HT(k,1) = case_data{i,1}.Diagnostics.FWA.Field.WaterBreakthrough.CumOil;
    WBT_ResVolProdCum_HT(k,1) = case_data{i,1}.Diagnostics.FWA.Field.WaterBreakthrough.CumResVolProd;
    WBT_HCPVI_HT(k,1) = case_data{i,1}.Diagnostics.FWA.Field.WaterBreakthrough.HCPVI;
    WBT_PVI_HT(k,1) = case_data{i,1}.Diagnostics.FWA.Field.WaterBreakthrough.PVI;
    FinalRF_HT(k,1) = case_data{i,1}.Tvar.Field.OilRecoveryEfficiency.data(TotalDaysIdx);
    FinalCumOil_HT(k,1) = case_data{i,1}.Tvar.Field.OilProductionCumulative.data(TotalDaysIdx);
    FinalResCumProd_HT(k,1) = case_data{i,1}.Tvar.Field.ReservoirVolumeProductionCumulative.data(TotalDaysIdx);
    FinalHCPVI_HT(k,1) = case_data{i,1}.DerivedData.Field.HCPVI.data(TotalDaysIdx);
    FinalPVI_HT(k,1) = case_data{i,1}.DerivedData.Field.PVI.data(TotalDaysIdx);
    ChanPlotFlag_HT(k,1) = case_data{i,1}.Diagnostics.FWA.Field.ChanPlotFlag;
    
    HCPVI_HT(:,k) = case_data{i,1}.DerivedData.Field.HCPVI.data;
    PVI_HT(:,k) = case_data{i,1}.DerivedData.Field.PVI.data;
    RF_HT(:,k) = case_data{i,1}.Tvar.Field.OilRecoveryEfficiency.data;
    Qo_HT(:, k) = case_data{i,1}.Tvar.Field.OilProductionRate.data;
    Np_HT(:, k) = case_data{i,1}.Tvar.Field.OilProductionCumulative.data;
    PoreVolHC_HT(:, k) = case_data{i,1}.Tvar.Field.PoreVolumeContainingHydrocarbon.data;
    plot(HCPVI_HT(:,k), RF_HT(:,k));
%     plot(PVI_HT(:,k), RF_HT(:,k));
    hold on;        
    k = k+1;
end
xlabel('Hydrocarbon Pore Volume Injected');
ylabel('Oil Recovery');
title('Heterogeneous model');
grid on;


figure;
scatter(WBT_HCPVI,FinalRF, [], 'b', 'o');
% scatter(WBT_PVI,FinalRF, [], 'b', 'o');
hold on;
scatter(WBT_HCPVI_HT,FinalRF_HT, [], 'r', '^');
% scatter(WBT_PVI_HT,FinalRF_HT, [], 'r', '^');
xlabel('Hydrocarbon Pore Volume Injected at WB');
ylabel('Final Oil Recovery');
grid on;
legend('Homogeneous model', 'Heterogeneous model');

figure;
scatter(FinalHCPVI,FinalRF, [], 'b', 'o');
% scatter(FinalPVI,FinalRF, [], 'b', 'o');
hold on;
scatter(FinalHCPVI_HT,FinalRF_HT, [], 'r', '^');
% scatter(FinalPVI_HT,FinalRF_HT, [], 'r', '^');
xlabel('Final Hydrocarbon Pore Volume Injected');
ylabel('Final Oil Recovery');
grid on;
legend('Homogeneous model', 'Heterogeneous model');


end