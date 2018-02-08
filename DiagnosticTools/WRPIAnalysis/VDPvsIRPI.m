function [Vdp_byWR, IRPI, CorrCoeff] = VDPvsIRPI(case_data, plotChoice)
% Generate a Dykstra-Parsons coefficient vs. Initial RPI scatter plot
%
% Last Update Date: 01/15/2018
%
%SYNOPSIS:
%   VDPvsIRPI(case_data, plotChoice)
%   [Well_Vdp, IRPI] = VDPvsIRPI(case_data,Vdp_byLayer)
%
%DESCRIPTION:
% This function generates a Dykstra-Parsons coefficient vs. Initial RPI
% scatter plot
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%   Vdp_byLayer - Vector containing the DP coefficients by layer


Completions = [5 18; 10 18; 5 19; 1 14; 4 18; 5 18; 11 20; 1 13; 4 17]; % Completion layers by well: 9 producing wells

% plotChoice = 1; % For plotting Vdp by layer in the well region vs IRPI.
% plotChoice = 2; % For plotting Vdp by well region vs IRPI - All wells/cases in the same plot.
% plotChoice = 3; % For plotting Vdp by well region vs IRPI - One plot per well.

switch plotChoice
    
% -----------------------------------------------------------------------
% Vdp by layer vs IRPI...
    
    case 1        
        num_cases = length(case_data);
        k =0;
        %maxCompLayers = max(Completions(:,2) - Completions(:,1));        
        for case_idx = 1:num_cases
            well_list = fieldnames(case_data{case_idx}.Tvar.Well);
            prod_well_list = well_list(contains(well_list, 'PRO'));
            num_prod_wells = length(prod_well_list);
            for prod_well_idx=1:num_prod_wells
                prod_well_name = prod_well_list{prod_well_idx};
                First_layer = Completions(prod_well_idx, 1);
                Last_layer = Completions(prod_well_idx, 2);
                numCompLayers = Last_layer - First_layer + 1;
                % Well_Vdp(k+1:k+numCompLayers,1) = Vdp_byLayer(First_layer:Last_layer, case_idx);
                Well_Vdp(k+1:k+numCompLayers,1) = eval(['case_data{case_idx, 1}.Diagnostics.Well.', prod_well_name, '.Vdp;']);                
                IRPI(k+1:k+numCompLayers,1) = eval(['case_data{case_idx,1}.DerivedData.Well.', prod_well_name, '.RPI.data(2)']);                
                WellColor(k+1:k+numCompLayers,1) =  prod_well_idx;
                CaseColor(k+1:k+numCompLayers,1) =  case_idx;
                k = k + numCompLayers;
            end
        end        
        % % % Colors for each well (blue, red, green, yellow, cyan, magenta, purple, gray, orange)
        c = [0 0.2 0.8; 1 0 0; 0 0.6 0; 1 1 0; 0 1 1; 1 0 1; 0.4 0 0.8; 0.3 0.3 0.3; 1 0.4 0];
        figure;
        gscatter(Well_Vdp, log10(IRPI),WellColor, c,'.', 15);
        % gscatter(Well_Vdp, log10(IRPI),CaseColor, [],'.', 15);
        xlabel('Dykstra-Parsons Coefficient by Completion Layer');
        ylabel('Initial RPI, psi/BPD');
        
% -----------------------------------------------------------------------
% Vdp by near wellbore region vs IRPI... (all wells in the same plot)
        
    case 2        
        num_cases = length(case_data);
        k=1;
        for case_idx = 1:num_cases
            well_list = fieldnames(case_data{case_idx}.Tvar.Well);
            prod_well_list = well_list(contains(well_list, 'PRO'));
            num_prod_wells = length(prod_well_list);
            for prod_well_idx=1:num_prod_wells
                prod_well_name = prod_well_list{prod_well_idx};
                Vdp_byWR(k,1) = eval(['case_data{case_idx, 1}.Diagnostics.Well.', prod_well_name, '.Vdp_WR;']);
                IRPI(k,1) = eval(['case_data{case_idx,1}.DerivedData.Well.', prod_well_name, '.RPI.data(2)']);
                RPI_Cluster(k,1) = eval(['case_data{case_idx,1}.Diagnostics.Well.', prod_well_name, '.Clustering.InitialRPIvsCumOil']);
                ChanPlotFlag(k,1) = eval(['case_data{case_idx,1}.Diagnostics.Well.', prod_well_name, '.ChanPlotFlag']);
                WellColor(k,1) =  prod_well_idx;
                CaseColor(k,1) = case_idx;
                k = k + 1;
            end
        end
        
        D = [Vdp_byWR, log10(IRPI)];
        MaxNumClusters = 5;
        VdpCluster = clusterdata(D,'linkage','ward','maxclust',MaxNumClusters);
        
        % % % Colors for each well (blue, red, green, yellow, cyan, magenta, purple, gray, orange)
        %c = [0 0.2 0.8; 1 0 0; 0 0.6 0; 1 1 0; 0 1 1; 1 0 1; 0.4 0 0.8; 0.3 0.3 0.3; 1 0.4 0];
        cc = [1 0 0; 0.8 0.68 0.08; 0 0.95 0.2; 0 0.05 0.88; 0.8 0 1];
        figure;
        %gscatter(Vdp_byWR, log10(IRPI),VdpCluster, [],'.', 15);
        gscatter(Vdp_byWR, log10(IRPI),RPI_Cluster, cc,'.', 15);
        %gscatter(Vdp_byWR, log10(IRPI),WellColor, [],'.', 15);
        %gscatter(Vdp_byWR, log10(IRPI),WellColor, [], '*');
        %gscatter(Vdp_byWR, log10(IRPI),CaseColor, [],'.', 15);
        xlabel('Dykstra-Parsons Coefficient - Near Wellbore Region');
        ylabel('Initial RPI, psi/BPD');
        
% -----------------------------------------------------------------------
% Vdp by near wellbore region vs IRPI... (one plot per well)

    case 3
        TotalDaysIdx = length(case_data{1,1}.Tvar.Time.cumt);
        num_cases = length(case_data);
        for case_idx = 1:num_cases
            well_list = fieldnames(case_data{case_idx}.Tvar.Well);
            prod_well_list = well_list(contains(well_list, 'PRO'));
            num_prod_wells = length(prod_well_list);
            for prod_well_idx=1:num_prod_wells
                prod_well_name = prod_well_list{prod_well_idx};
                Vdp_byWR(case_idx,prod_well_idx) = eval(['case_data{case_idx, 1}.Diagnostics.Well.', prod_well_name, '.Vdp_WR;']);
                IRPI(case_idx,prod_well_idx) = eval(['case_data{case_idx,1}.DerivedData.Well.', prod_well_name, '.RPI.data(2)']);
                Np_Well(case_idx,prod_well_idx) = eval(['case_data{case_idx,1}.Tvar.Well.', prod_well_name, '.OilProductionCumulative.data(TotalDaysIdx)']);
                RPI_Cluster(case_idx,prod_well_idx) = eval(['case_data{case_idx,1}.Diagnostics.Well.', prod_well_name, '.Clustering.InitialRPIvsCumOil']);
            end            
        end
        CaseColor = [1:num_cases]';
        cc = [1 0 0; 0.8 0.68 0.08; 0 0.95 0.2; 0 0.05 0.88; 0.8 0 1];
        figure; 
        for i=1:num_prod_wells
            subplot(3,3,i);
            %figure;
            scatter(Vdp_byWR(:, i), log10(IRPI(:, i)), 15, 'o', 'filled');
            %scatter(Vdp_byWR(:, i), log10(Np_Well(:, i)), 15, 'o', 'filled');
            %gscatter(Vdp_byWR(:, i), log10(IRPI(:, i)),RPI_Cluster(:,i), cc, '.', 15);
            xlabel('Vdp - Wellbore Region');
            ylabel('Initial RPI, psi/BPD');
            title(['WPRO', num2str(i)]);
            X = Vdp_byWR(:, i);
            Y = log10(IRPI(:, i));
            CorrCoeff(i,1) = corr2(X,Y);
        end
end

end