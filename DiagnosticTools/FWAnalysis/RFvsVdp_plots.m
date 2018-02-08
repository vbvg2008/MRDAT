function RFvsVdp_plots(case_data, Vdp_byZone)
% Generate a scatter plot of recovery factor vs Dykstra-Parsons Coefficient
%
% Last Update Date: 12/11/2017
%
%SYNOPSIS:
%   RFvsVdp_plots(case_data, Vdp_byZone)
%
%DESCRIPTION:
% This function generates a scatter plot of recovery factor vs 
% Dykstra-Parsons coefficient of the upper zone  
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%   Vdp_byZone - DP coefficients by zone obtained with DykstraParsonsCoeff
%   function


num_cases = length(case_data);
final_time_idx = length(case_data{1,1}.Tvar.Time.cumt);
for i = 1:num_cases
    Vdp_upper(i,1) = Vdp_byZone(1, i);
    RF(i,1) = case_data{i,1}.Tvar.Field.OilRecoveryEfficiency.data(final_time_idx);
    Np(i,1) = case_data{i,1}.Tvar.Field.OilProductionCumulative.data(final_time_idx);
    HCPVI(i,1) = case_data{i,1}.DerivedData.Field.HCPVI.data(final_time_idx);    
end

MaxNumClusters = 6;
D1 = [Vdp_upper, RF];
D2 = [Vdp_upper, HCPVI];

% ClusterGroup_RF = kmeans(D1, MaxNumClusters);  
ClusterGroup_RF = clusterdata(D1,'linkage','ward','maxclust',MaxNumClusters);

% ClusterGroup_HCPVI = kmeans(D2, MaxNumClusters);  
ClusterGroup_HCPVI = clusterdata(D2,'linkage','ward','maxclust',MaxNumClusters);


figure;
gscatter(D1(:,1),D1(:,2), ClusterGroup_RF, [], '.', 15);
xlabel('Dykstra-Parsons Coefficient');
ylabel('Final Recovery Efficiency');

figure;
gscatter(D2(:,1),D2(:,2), ClusterGroup_HCPVI, [], '.', 15);
xlabel('Dykstra-Parsons Coefficient');
ylabel('Final Pore Volume Injected (HCPVI)');
 
% 
% figure;
% scatter(Vdp_upper, Np, '+');
% xlabel('Dykstra-Parsons Coefficient');
% ylabel('Final Cumulative Oil Production, STB');


end