function [HI_Np, HI_Wp, ChanPlotFlagCode]=HeterogeneityIndex_MW(case_data, plotChoice)
%[HI_HCPVI, HI_RF, ChanPlotFlag]=HeterogeneityIndex_MW(case_data, plotChoice)
% Generate a heterogeneity index plot based on oil and water production
%
% Last Update Date: 01/15/2018
%
%SYNOPSIS:
%   HeterogeneityIndex_MW(case_data, plotChoice)
%
%DESCRIPTION:
% This function generates a heterogeneity index plot based on oil and water
% production, clustering by well, Initial RPI or Chan diagnostic identifier.
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%

switch plotChoice
    case 1 % HI_Np vs HI_Wp
        num_cases = length(case_data);
        Time = case_data{1,1}.Tvar.Time.cumt;
        TotalDaysIdx = length(Time);
        k=1;
        for case_idx=1:num_cases
            well_list = fieldnames(case_data{case_idx}.Tvar.Well);
            prod_well_list = well_list(contains(well_list, 'PRO'));
            num_prod_wells = length(prod_well_list);
            for prod_well_idx=1:num_prod_wells
                prod_well_name = prod_well_list{prod_well_idx};
                Qo(:, k) = eval(['case_data{case_idx,1}.Tvar.Well.', prod_well_name, '.OilProductionRate.data']);
                Qw(:, k) = eval(['case_data{case_idx,1}.Tvar.Well.', prod_well_name, '.WaterProductionRate.data']);
                WOR(:, k) = eval(['case_data{case_idx,1}.DerivedData.Well.', prod_well_name, '.WOR.data']);
                Np(:, k) = eval(['case_data{case_idx,1}.Tvar.Well.', prod_well_name, '.OilProductionCumulative.data']);
                Wp(:, k) = eval(['case_data{case_idx,1}.Tvar.Well.', prod_well_name, '.WaterProductionCumulative.data']);
                ChanPlotFlagCode(k,1) = eval(['case_data{case_idx,1}.Diagnostics.Well.', prod_well_name, '.ChanPlotFlag']);
                if ChanPlotFlagCode(k,1)==1
                    ChanPlotFlag{k,1}='Channeling';
                elseif ChanPlotFlagCode(k,1)==2
                    ChanPlotFlag{k,1}='Coning';
                elseif ChanPlotFlagCode(k,1)==3
                    ChanPlotFlag{k,1}='Normal';
                elseif ChanPlotFlagCode(k,1)==4
                    ChanPlotFlag{k,1}='Not clear';
                else
                    ChanPlotFlag{k,1}='No water production';
                end
                
                RPI_Cluster(k,1) = eval(['case_data{case_idx,1}.Diagnostics.Well.', prod_well_name, '.Clustering.InitialRPIvsCumOil']);
                WellColor(k,1) =  prod_well_idx;
                
                WBT_days(k,1) = eval(['case_data{case_idx,1}.Diagnostics.Well.', prod_well_name, '.WaterBreakthrough.Time']);
                if isnan(WBT_days(k,1))
                    WBT{k,1}='NaN';
                elseif WBT_days(k,1)>=0 && WBT_days(k,1)<1500
                    WBT{k,1}='< 1500 days';
                else
                    WBT{k,1}='>= 1500 days';
                end
                k = k+1;
            end
        end
        
        % Group average
        AvgQo = sum(Qo, 2, 'omitnan')./(num_cases*num_prod_wells);
        AvgQw = sum(Qw, 2, 'omitnan')./(num_cases*num_prod_wells);
        AvgWOR = sum(WOR, 2, 'omitnan')./(num_cases*num_prod_wells);
        AvgNp = sum(Np, 2, 'omitnan')./(num_cases*num_prod_wells);
        AvgWp = sum(Wp, 2, 'omitnan')./(num_cases*num_prod_wells);
        
        for k =1:(num_cases*num_prod_wells)
            % HI
            HI_oil(:, k) = (Qo(:, k)./AvgQo) - 1;
            HI_water(:, k) = (Qw(:, k)./AvgQw) - 1;
            HI_WOR(:, k) = (WOR(:, k)./AvgWOR) - 1;
            HI_Np(:, k) = (Np(:, k)./AvgNp) - 1;
            HI_Wp(:, k) = (Wp(:, k)./AvgWp) - 1;
            
            % Cumulative HI for non-cumulative variables
            HI_oil_cum(:, k) = cumsum(HI_oil(:, k), 'omitnan');
            HI_water_cum(:, k) = cumsum(HI_water(:, k), 'omitnan');
            HI_WOR_cum(:, k) = cumsum(HI_WOR(:, k), 'omitnan');
            
        end
        
        % Plot last time-step
        
        % % % Colors for each well (blue, red, green, yellow, cyan, magenta, purple, gray, orange)
        cw = [0 0.2 0.8; 1 0 0; 0 0.6 0; 1 1 0; 0 1 1; 1 0 1; 0.4 0 0.8; 0.3 0.3 0.3; 1 0.4 0];
        % % % Colors by cluster or Chan plot flag
        cc = [1 0 0; 0.8 0.68 0.08; 0 0.95 0.2; 0 0.05 0.88; 0.8 0 1];
        
        figure;
        % gscatter(HI_oil_cum(TotalDaysIdx,:), HI_water_cum(TotalDaysIdx,:), WellColor, cw, '+');
        % gscatter(HI_oil_cum(TotalDaysIdx,:), HI_WOR_cum(TotalDaysIdx,:), WellColor, cw, '+');
        % gscatter(HI_Np(TotalDaysIdx,:), HI_Wp(TotalDaysIdx,:), WellColor, cw, '+');
        % gscatter(HI_Np(TotalDaysIdx,:), HI_Wp(TotalDaysIdx,:), RPI_Cluster, cc, '+');
        gscatter(HI_Np(TotalDaysIdx,:), HI_Wp(TotalDaysIdx,:), ChanPlotFlag, cc, '+');
        % gscatter(HI_Np(TotalDaysIdx,:), HI_Wp(TotalDaysIdx,:), WBT, [], '+');
        xlabel('HI.Oil');
        ylabel('HI.Water');
        grid on;
        
        
        % Plot time evolution of HI (every 6 months)
        
        HI_Np_TE = HI_Np(2,:)';
        HI_Wp_TE = HI_Wp(2,:)';
        num_data_points = length(HI_Np(2,:)); % num_cases*num_prod_wells
        TimeColor(1:num_data_points,1)=2;
        k=num_data_points+1;
        for idx=7:6:TotalDaysIdx
            HI_Np_TE = [HI_Np_TE; HI_Np(idx,:)'];
            HI_Wp_TE = [HI_Wp_TE; HI_Wp(idx,:)'];
            TimeColor(k:k+num_data_points-1, 1) = idx;
            k = k + num_data_points;
        end
        
        %colormap('jet');
        figure;
        gscatter(HI_Np_TE, HI_Wp_TE, TimeColor, colormap(jet(31)), '+');
        %gscatter(HI_Np_TE, HI_Wp_TE, TimeColor, colormap(hsv(31)), '+'); % default option
        xlabel('HI.Oil');
        ylabel('HI.Water');
        %colormap('jet');
        
        
        % Dsitribution of wells/cases per quadrant
        %
        % well = 1;
        % casenum = 1;
        % for k=1: (num_cases*num_prod_wells)
        %     Np_idx = HI_Np(TotalDaysIdx,k);
        %     Wp_idx = HI_Wp(TotalDaysIdx,k);
        %
        %     if Np_idx >=0 && Wp_idx <=0
        %         WIDQ(well, casenum) = 1;
        %     elseif Np_idx >0 && Wp_idx >0
        %         WIDQ(well, casenum) = 2;
        %     elseif Np_idx <0 && Wp_idx <0
        %         WIDQ(well, casenum) = 3;
        %     elseif Np_idx <0 && Wp_idx >0
        %         WIDQ(well, casenum) = 4;
        %     end
        %     if well <num_prod_wells
        %         well = well + 1;
        %     else
        %         well = 1;
        %         casenum = casenum +1;
        %     end
        % end
        %
        % figure;
        % histogram(WIDQ,'BinMethod','integers');
        % xlabel('Quadrant');
        % ylabel('Frecuency');
        
    case 2 % HI_HCPVI vs HI_RF
        
        num_cases = length(case_data);
        Time = case_data{1,1}.Tvar.Time.cumt;
        TotalDaysIdx = length(Time);        
        for case_idx=1:num_cases
            RF(:, case_idx) = case_data{case_idx,1}.Tvar.Field.OilRecoveryEfficiency.data;
            HCPVI(:, case_idx) = case_data{case_idx,1}.DerivedData.Field.HCPVI.data;
            PVI(:, case_idx) = case_data{case_idx,1}.DerivedData.Field.PVI.data;
            well_list = fieldnames(case_data{case_idx}.Tvar.Well);
            prod_well_list = well_list(contains(well_list, 'PRO'));
            num_prod_wells = length(prod_well_list);
            for prod_well_idx=1:num_prod_wells
                prod_well_name = prod_well_list{prod_well_idx};
                ChanPlotFlag(prod_well_idx,case_idx) = eval(['case_data{case_idx,1}.Diagnostics.Well.', prod_well_name, '.ChanPlotFlag']);
            end
        end
        
        % Group average
        AvgRF = sum(RF, 2, 'omitnan')./num_cases;
        AvgHCPVI = sum(HCPVI, 2, 'omitnan')./num_cases;
        AvgPVI = sum(PVI, 2, 'omitnan')./num_cases;
        
        for case_idx =1:num_cases
            % HI of cumulative variables
            HI_RF(:, case_idx) = (RF(:, case_idx)./AvgRF) - 1;
            HI_HCPVI(:, case_idx) = (HCPVI(:, case_idx)./AvgHCPVI) - 1;
            HI_PVI(:, case_idx) = (PVI(:, case_idx)./AvgPVI) - 1;
        end
        
        ChanFlagMode = mode(ChanPlotFlag, 1);
        
        c = ['r', 'g', 'm', 'c', 'b'];
        figure;
        %scatter(HI_HCPVI(TotalDaysIdx,:), HI_RF(TotalDaysIdx,:), 20, 'b', 'filled');
        gscatter(HI_HCPVI(TotalDaysIdx,:), HI_RF(TotalDaysIdx,:), ChanFlagMode, c, '.', 20);
        xlabel('HI.HCPVI');
        ylabel('HI.RF');
        grid on;
       
end

end

