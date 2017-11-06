function case_data = ClusteringLogRPIvsCumOil_MW(case_data, save_flag)
% Clustering of Log(Initial RPI) vs Log(Final Cumulative Oil Production)
%
% Last Update Date: 11/04/2017
%
%SYNOPSIS:
%   case_data = ClusteringLogRPIvsCumOil_MW(case_data, save_flag)
%
%DESCRIPTION:
%   Clustering of Initial RPI vs Final Cumulative Oil Production (Log-Log).
%
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%   save_flag - 0 (no), 1 (yes)
%
num_cases = length(case_data);
TotalDaysIdx = length(case_data{1,1}.Tvar.Time.cumt);
for case_idx=1:num_cases
    well_list = fieldnames(case_data{case_idx}.Tvar.Well);
    prod_well_list = well_list(contains(well_list, 'PRO'));
    num_prod_wells = length(prod_well_list);
    
    FinalCumOil_byField(case_idx,1) = case_data{case_idx,1}.Tvar.Field.OilProductionCumulative.data(TotalDaysIdx);
    
    for prod_well_idx=1:num_prod_wells
        prod_well_name = prod_well_list{prod_well_idx};
        InitialRPI(prod_well_idx,case_idx) = eval(['case_data{case_idx,1}.DerivedData.Well.', prod_well_name, '.RPI.data(2)']);
        FinalCumOil_byWell(prod_well_idx,case_idx) = eval(['case_data{case_idx,1}.Tvar.Well.', prod_well_name,'.OilProductionCumulative.data(TotalDaysIdx)']);
        % Contribtion of each well to the field final production
        ProdContribution_byWell(prod_well_idx,case_idx) = FinalCumOil_byWell(prod_well_idx, case_idx)/FinalCumOil_byField(case_idx,1);
    end
end

% Clustering Analysis
IRPI = InitialRPI(:,1);
ProdCont_byWell = ProdContribution_byWell(:,1);
for case_idx =2:num_cases
    IRPI = [IRPI; InitialRPI(:, case_idx)];
    ProdCont_byWell = [ProdCont_byWell; ProdContribution_byWell(:,case_idx)];
end

D = [log10(IRPI), log10(ProdCont_byWell)];
% D = [log10(IRPI), ProdCont_byWell];

% number of maxclust
MaxNumClusters = 5;
% % % Colors for each cluster (blue, black, red, green, yellow, cyan, magenta, purple, gray, orange)
% % % c = [0 0.2 0.8; 0 0 0; 1 0 0; 0 0.6 0; 1 1 0; 0 1 1; 1 0 1; 0.4 0 0.8; 0.3 0.3 0.3; 1 0.4 0];
c = [1 0 0; 0.8 0.68 0.08; 0 0.95 0.2; 0 0.05 0.88; 0.8 0 1];

% Cluster Algorithm
% % ClusterGroup = kmeans(D, MaxNumClusters);
ClusterGroup = clusterdata(D,'linkage','ward','maxclust',MaxNumClusters);
% % ClusterGroup = kmedoids(D,MaxNumClusters);

% Append cluster group to case_data structure
k = 1;
kn = length(ClusterGroup);
for case_idx=1:num_cases
    well_list = fieldnames(case_data{case_idx}.Tvar.Well);
    prod_well_list = well_list(contains(well_list, 'PRO'));
    num_prod_wells = length(prod_well_list);
    for prod_well_idx=1:num_prod_wells
        eval(['case_data{case_idx,1}.Diagnostics.Well.', prod_well_list{prod_well_idx},'.IRPIvsCumOilCluster = ClusterGroup(k);']);
        k = k + 1;
    end
    if k<=kn
        continue;
    else
        break;
    end
end

if save_flag==1
    if ~exist('RPI_Clustering','dir')
        mkdir('RPI_Clustering');
    else
        delete('RPI_Clustering/*.png');
    end    
    cd 'RPI_Clustering';
    
    % Scatter plot by cluster group
    figure;
    gscatter(D(:,1),D(:,2),ClusterGroup, c, '.', 15);
    xlabel('Logarithm of Initial RPI');
    ylabel('Logarithm of Final Contribution in Cumulative Oil Production');
    grid on;
    
    saveas(gcf, 'RPIvsNp_Cluster.png');
    cd '../';
end

end
