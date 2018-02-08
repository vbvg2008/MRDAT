function [case_data, IRPI, Np_byWell] = ClusteringLogRPIvsCumOil_MW(case_data, save_flag)
% Clustering of Log(Initial RPI) vs Log(Final Cumulative Oil Production)
%
% Last Update Date: 12/11/2017
%
%SYNOPSIS:
%   case_data = ClusteringLogRPIvsCumOil_MW(case_data, save_flag)
%
%DESCRIPTION:
%   Clustering of Initial RPI vs Final Cumulative Oil Production (Log-Log)
%
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%   save_flag - 0 (no), 1 (yes)
%
num_cases = length(case_data);
TotalDaysIdx = length(case_data{1,1}.Tvar.Time.cumt);
k =1;
for case_idx=1:num_cases
    well_list = fieldnames(case_data{case_idx}.Tvar.Well);
    prod_well_list = well_list(contains(well_list, 'PRO'));
    num_prod_wells = length(prod_well_list);
    
    Np_byField(case_idx,1) = case_data{case_idx,1}.Tvar.Field.OilProductionCumulative.data(TotalDaysIdx);
    
    for prod_well_idx=1:num_prod_wells
        prod_well_name = prod_well_list{prod_well_idx};
        IRPI(k,1) = eval(['case_data{case_idx,1}.DerivedData.Well.', prod_well_name, '.RPI.data(2)']);
        Np_byWell(k,1) = eval(['case_data{case_idx,1}.Tvar.Well.', prod_well_name,'.OilProductionCumulative.data(TotalDaysIdx)']);
        WellColor(k,1) =  prod_well_idx;
        % Contribtion of each well to the field final production
        ProdCont_byWell(k,1) = Np_byWell(k,1)/Np_byField(case_idx,1);
        k = k+1;
    end
end

D1 = [log10(IRPI), log10(Np_byWell)];
% D2 = [log10(IRPI), log10(ProdCont_byWell)];

% % % Colors for each well (blue, red, green, yellow, cyan, magenta, purple, gray, orange)
cw = [0 0.2 0.8; 1 0 0; 0 0.6 0; 1 1 0; 0 1 1; 1 0 1; 0.4 0 0.8; 0.3 0.3 0.3; 1 0.4 0];

MaxNumClusters = 5; 
% % % Colors for each cluster (blue, black, red, green, yellow, cyan, magenta, purple, gray, orange)
% % % c = [0 0.2 0.8; 0 0 0; 1 0 0; 0 0.6 0; 1 1 0; 0 1 1; 1 0 1; 0.4 0 0.8; 0.3 0.3 0.3; 1 0.4 0];
cc = [1 0 0; 0.8 0.68 0.08; 0 0.95 0.2; 0 0.05 0.88; 0.8 0 1];

% Cluster Analysis
% ClusterGroup = kmeans(D1, MaxNumClusters);  
ClusterGroup = clusterdata(D1,'linkage','ward','maxclust',MaxNumClusters);

% Append results to case_data
k = 1;
for case_idx=1:num_cases
    well_list = fieldnames(case_data{case_idx}.Tvar.Well);
    prod_well_list = well_list(contains(well_list, 'PRO'));
    num_prod_wells = length(prod_well_list);
    for prod_well_idx=1:num_prod_wells
        prod_well_name = prod_well_list{prod_well_idx};
        eval(['case_data{case_idx,1}.Diagnostics.Well.', prod_well_name, '.Clustering.InitialRPIvsCumOil = ClusterGroup(k);']);
        k = k+1;
    end
end

    h1 = figure;
    gscatter(D1(:,1),D1(:,2),WellColor, cw, '.', 15);
    xlabel('Logarithm of Initial RPI');
    ylabel('Logarithm of Final Cumulative Oil Production by Well');
    grid on;
    
%     h2 = figure;
%     gscatter(D2(:,1),D2(:,2),WellColor, cw, '.', 15);
%     xlabel('Logarithm of Initial RPI');
%     ylabel('Logarithm of Oil Production Contribution by Well');
%     grid on;
    
    h3 = figure;
    gscatter(D1(:,1),D1(:,2),ClusterGroup, cc, '.', 15);
    xlabel('Logarithm of Initial RPI');
    ylabel('Logarithm of Final Cumulative Oil Production by Well');
    grid on;
    
    
if save_flag==1
    if ~exist('WD\RPI_Clustering','dir')
        mkdir('WD\RPI_Clustering');
    end    
    cd 'WD\RPI_Clustering';
    
   saveas(h1, 'IRPIvsNp.png');
%    saveas(h2, 'IRPIvsRF.png');
   saveas(h3, 'IRPIvsNp_2.png');
   
    cd '../';
    cd '../';
end

end
