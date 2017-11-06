function case_data = WaterBreakthrough_byField(case_data, save_flag)
% Calculates the point of water breakthrough
%
% Last Update Date: 10/31/2017
%
%SYNOPSIS:
%   case_data = WaterBreakthrough_byField(case_data, save_flag)
%
%DESCRIPTION:
%  This function calculates the point at which the WOR has a sharp rise
%  with respect to time and cumulative production
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%   save_flag - 0 (no), 1 (yes)
%

if save_flag==1
    if ~exist('WBT_Plots','dir')
        mkdir('WBT_Plots');
    else
        delete('WBT_Plots/*.png');
    end
    cd 'WBT_Plots';
end

num_cases = length(case_data);
for case_idx=1:num_cases
    WOR = case_data{case_idx,1}.DerivedData.Field.WOR.data;
    InitialWOR = case_data{case_idx,1}.DerivedData.Field.WOR.data();
    Time = case_data{case_idx,1}.Tvar.Time.cumt;
    TotalDaysIdx = length(Time);
    FinalWOR = WOR(TotalDaysIdx);
    FinalWcut(case_idx) = case_data{case_idx,1}.DerivedData.Field.WC.data(TotalDaysIdx);
    InitialWcut(case_idx) = case_data{case_idx,1}.DerivedData.Field.WC.data(2);
    
    if FinalWOR > 0
        
        % Just calculate the WBT when a sharp increase in the WOR is seen in a
        % loglog plot of WOR vs time!!!!
        x = log10(Time);
        y = log10(WOR);
        
        x(isinf(x))= nan;
        y(isinf(y))= nan;
        
        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);
        
        WBT_Idx = idydxmax;
        
        WOR_slope(case_idx) = (y(WBT_Idx+1) - y(WBT_Idx)) / (x(WBT_Idx+1) - x(WBT_Idx));
        WOR_angle(case_idx) = atand(WOR_slope(case_idx));
        
        if WOR_angle(case_idx)> 70
            WBT_Days = case_data{case_idx,1}.Tvar.Time.cumt(WBT_Idx);
            WBT_CumOilProd = case_data{case_idx,1}.Tvar.Field.OilProductionCumulative.data(WBT_Idx);
            WBT_ResVolProdCum = case_data{case_idx,1}.Tvar.Field.ReservoirVolumeProductionCumulative.data(WBT_Idx);
            WBT_HCPVI = case_data{case_idx,1}.DerivedData.Field.HCPVI.data(WBT_Idx);
            WBT_PVI = case_data{case_idx,1}.DerivedData.Field.PVI.data(WBT_Idx);
            str = ['Water Breakthrough occurs at ', num2str(WBT_Days), ' days'];
%         elseif InitialWcut(case_idx) > 0
%             WBT_Days = 0;
%             WBT_CumOilProd = 0;
%             WBT_ResVolProdCum = 0;
%             WBT_HCPVI = 0;
%             str = ['Water Breakthrough occurs at 0 days with Initial Wcut of ', num2str(InitialWcut(case_idx)*100, 3), '%'];
        else
            WBT_Days = nan;
            WBT_CumOilProd = nan;
            WBT_ResVolProdCum = nan;
            WBT_HCPVI = nan;
            WBT_PVI = nan;
            str = ['Normal Displacement with Final Wcut of ', num2str(FinalWcut(case_idx)*100, 3), '%'];
        end
        
        if save_flag==1
            figure('Visible', 'off');
            subplot(2,1,1);
            loglog(Time,WOR);
            xlabel('Time (Days)');
            ylabel('Water-Oil Ratio (stb/stb)');
            title(str);
            
            subplot(2,1,2);
            semilogx(Time,dydx);
            xlabel('Time (Days)');
            ylabel('dWOR/dTime');
            saveas(gcf, [case_data{case_idx,1}.name,'.png']);
        end
        
    else
        WBT_Days = nan;
        WBT_CumOilProd = nan;
        WBT_ResVolProdCum = nan;
        WBT_HCPVI = nan; 
        WBT_PVI = nan;
        
    end
    % Append results into the case_data structure
    case_data{case_idx,1}.Diagnostics.Field.WaterBreakthrough.Time = WBT_Days;
    case_data{case_idx,1}.Diagnostics.Field.WaterBreakthrough.CumOil = WBT_CumOilProd;
    case_data{case_idx,1}.Diagnostics.Field.WaterBreakthrough.CumResVolProd = WBT_ResVolProdCum;
    case_data{case_idx,1}.Diagnostics.Field.WaterBreakthrough.HCPVI = WBT_HCPVI;
    case_data{case_idx,1}.Diagnostics.Field.WaterBreakthrough.PVI = WBT_PVI;
    
end

if save_flag==1
    cd '../';
end

end