function HeterogeneityIndex_MW(case_data)
% Generate a heterogeneity index plot based on total HCPVI and final oil 
% recovery
%
% Last Update Date: 12/11/2017
%
%SYNOPSIS:
%   HeterogeneityIndex_MW(case_data)
%
%DESCRIPTION:
% This function generates a heterogeneity index plot based on total HCPVI and
% final oil recovery and, clustering cases by Initial RPI or Chan diagnostic
% identifier.  
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%

num_cases = length(case_data);
Time = case_data{1,1}.Tvar.Time.cumt;
TotalDaysIdx = length(Time);

for i=1:num_cases
    Qo(:, i) = case_data{i,1}.Tvar.Field.OilProductionRate.data;
    Qw(:, i) = case_data{i,1}.Tvar.Field.WaterProductionRate.data;
    WOR(:,i) = case_data{i,1}.DerivedData.Field.WOR.data;
    RF(:, i) = case_data{i,1}.Tvar.Field.OilRecoveryEfficiency.data;
    HCPVI(:, i) = case_data{i,1}.DerivedData.Field.HCPVI.data;
    PVI(:, i) = case_data{i,1}.DerivedData.Field.PVI.data;
%     ChanPlotFlag(i,1) = case_data{i,1}.Diagnostics.Field.ChanPlotFlag;
%     RPI_Cluster(i,1) = case_data{i,1}.Diagnostics.Clustering.InitialRPIvsCumOil;
end

% Group average
AvgQo = sum(Qo, 2, 'omitnan')./num_cases;
AvgQw = sum(Qw, 2, 'omitnan')./num_cases;
AvgWOR = sum(WOR, 2, 'omitnan')./num_cases;
AvgRF = sum(RF, 2, 'omitnan')./num_cases;
AvgHCPVI = sum(HCPVI, 2, 'omitnan')./num_cases;
AvgPVI = sum(PVI, 2, 'omitnan')./num_cases;

for i =1:num_cases
    % HI
    HI_oil(:, i) = (Qo(:, i)./AvgQo) - 1;
    HI_water(:, i) = (Qw(:, i)./AvgQw) - 1;
    HI_WOR(:, i) = (WOR(:, i)./AvgWOR) - 1;
    
    
    % Cumulative HI
    HI_oil_cum(:, i) = cumsum(HI_oil(:, i), 'omitnan');
    HI_water_cum(:, i) = cumsum(HI_water(:, i), 'omitnan');
    HI_WOR_cum(:, i) = cumsum(HI_WOR(:, i), 'omitnan');
    
    % HI of cumulative variables
    HI_RF(:, i) = (RF(:, i)./AvgRF) - 1;
    HI_HCPVI(:, i) = (HCPVI(:, i)./AvgHCPVI) - 1;
    HI_PVI(:, i) = (PVI(:, i)./AvgPVI) - 1;
    
end

% Plot last time-step
figure;
scatter(HI_oil_cum(TotalDaysIdx,:), HI_water_cum(TotalDaysIdx,:), 20, 'b', 'filled');
xlabel('HI.Oil');
ylabel('HI.Water');
grid on;

figure;
scatter(HI_oil_cum(TotalDaysIdx,:), HI_WOR_cum(TotalDaysIdx,:), 20, 'b', 'filled');
xlabel('HI.Oil');
ylabel('HI.WOR');
grid on;

figure;
scatter(HI_WOR_cum(TotalDaysIdx,:), HI_RF(TotalDaysIdx,:), 20, 'b', 'filled');
xlabel('HI.WOR');
ylabel('HI.RF');
grid on;

% c = ['r', 'g', 'm', 'c', 'b']; % For homogeneous case
% c = ['r', 'g', 'c', 'b']; % for heterogeneous case
figure;
scatter(HI_HCPVI(TotalDaysIdx,:), HI_RF(TotalDaysIdx,:), 20, 'b', 'filled');
% gscatter(HI_HCPVI(TotalDaysIdx,:), HI_RF(TotalDaysIdx,:), ChanPlotFlag, c, '.', 20);
% gscatter(HI_HCPVI(TotalDaysIdx,:), HI_RF(TotalDaysIdx,:), RPI_Cluster, c, '.', 20);
xlabel('HI.HCPVI');
ylabel('HI.RF');
% legend('Channeling', 'Coning', 'Normal', 'Not clear', 'No water production'); % For homogeneous case
% legend('Channeling', 'Coning', 'Not clear', 'No water production'); % for heterogeneous case
legend('show');
grid on;

% % % figure;
% % % scatter(HI_PVI(TotalDaysIdx,:), HI_RF(TotalDaysIdx,:), 20, 'b', 'filled');
% % % % gscatter(HI_HCPVI(TotalDaysIdx,:), HI_RF(TotalDaysIdx,:), ChanPlotFlag, c, '.', 20);
% % % xlabel('HI.PVI');
% % % ylabel('HI.RF');
% % % % legend('Channeling', 'Coning', 'Normal', 'Not clear', 'No water production'); % For homogeneous case
% % % % legend('Channeling', 'Coning', 'Not clear', 'No water production'); % for heterogeneous case
% % % grid on;

end

