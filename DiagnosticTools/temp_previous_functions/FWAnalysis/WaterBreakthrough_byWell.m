function case_data = WaterBreakthrough_byWell(case_data, save_flag)
% Calculates the point of water breakthrough
%
% Last Update Date: 10/31/2017
%
%SYNOPSIS:
%   case_data = WaterBreakthrough(case_data, save_flag)
%
%DESCRIPTION:
%  This function calculates the point at which the WOR has a sharp rise
%  with respect to time and cumulative production in a per well basis
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%   save_flag - 0 (no), 1 (yes)
%

if save_flag==1
    if ~exist('WD\WBT_Plots','dir')
        mkdir('WD\WBT_Plots');
    else
        delete('WD\WBT_Plots/*.png');
    end
    cd 'WD\WBT_Plots';
end

num_cases = length(case_data);
for case_idx=1:num_cases
    % List and number of wells
    well_list = fieldnames(case_data{case_idx}.Tvar.Well);
    num_wells = length(well_list);
    % WBT for each well
    for well_idx = 1: num_wells
        well_name = well_list{well_idx};
        if contains(well_name, 'PRO')
            WOR = eval(['case_data{case_idx,1}.DerivedData.Well.',well_name,'.WOR.data']);
            Time = case_data{case_idx,1}.Tvar.Time.cumt;
            TotalDaysIdx = length(Time);
            InitialWOR = WOR(2);
            FinalWOR = WOR(TotalDaysIdx);
            FinalWcut(well_idx) = eval(['case_data{case_idx,1}.DerivedData.Well.',well_name,'.WC.data(TotalDaysIdx)']);
            InitialWcut(well_idx) = eval(['case_data{case_idx,1}.DerivedData.Well.', well_name, '.WC.data(2)']);
            
            if FinalWOR > 0
                % Just calculate the WBT when a sharp increase in the WOR is seen in a
                % loglog plot of WOR vs time!!!!
                x = log10(Time);
                y = log10(WOR);
                
                x(isinf(x))= nan;
                y(isinf(y))= nan;
                
                [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);
                
                WBT_Idx = idydxmax;
                
                WOR_slope(well_idx) = (y(WBT_Idx+1) - y(WBT_Idx)) / (x(WBT_Idx+1) - x(WBT_Idx));
                WOR_angle(well_idx) = atand(WOR_slope(well_idx));
                
                if WOR_angle(well_idx)> 70
                    WBT_Days = case_data{case_idx,1}.Tvar.Time.cumt(WBT_Idx);
                    WBT_CumOilProd = eval(['case_data{case_idx,1}.Tvar.Well.', well_name, '.OilProductionCumulative.data(WBT_Idx)']);
                    WBT_ResVolProdCum = eval(['case_data{case_idx,1}.Tvar.Well.', well_name, '.ReservoirVolumeProductionCumulative.data(WBT_Idx)']);
                    WBT_HCPVI = eval(['case_data{case_idx,1}.DerivedData.Well.', well_name, '.data(WBT_Idx)']);
                    WBT_PVI = eval(['case_data{case_idx,1}.DerivedData.Well.', well_name, '.PVI.data(WBT_Idx)']);
                    str = ['Water Breakthrough occurs at ', num2str(WBT_Days), ' days'];
                    %             elseif InitialWcut(well_idx) > 0
                    %                 WBT_Days = 0;
                    %                 WBT_CumOilProd = 0;
                    %                 WBT_ResVolProdCum = 0;
                    %                 WBT_HCPVI = 0;
                    %                 str = ['Water Breakthrough occurs at 0 days with Initial Wcut of ', num2str(InitialWcut(case_idx)*100, 3), '%'];
                else
                    WBT_Days = nan;
                    WBT_CumOilProd = nan;
                    WBT_ResVolProdCum = nan;
                    WBT_HCPVI = nan;
                    WBT_PVI = nan;
                    str = ['Normal Displacement with Final Wcut of ', num2str(FinalWcut(well_idx)*100, 3), '%'];
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
                    saveas(gcf, [case_data{case_idx,1}.name,'_',well_name,  '.png']);
                end
                
            else
                WBT_Days = nan;
                WBT_CumOilProd = nan;
                WBT_ResVolProdCum = nan;
                WBT_HCPVI = nan;
                WBT_PVI = nan;
                
            end
            % Append results into the case_data structure
            eval(['case_data{case_idx,1}.Diagnostics.Well.', well_name, '.WaterBreakthrough.Time = WBT_Days;']);
            eval(['case_data{case_idx,1}.Diagnostics.Well.', well_name, '.WaterBreakthrough.CumOil = WBT_CumOilProd;']);
            eval(['case_data{case_idx,1}.Diagnostics.Well.', well_name, '.WaterBreakthrough.CumResVolProd = WBT_ResVolProdCum;']);
            eval(['case_data{case_idx,1}.Diagnostics.Well.', well_name, '.WaterBreakthrough.HCPVI = WBT_HCPVI;']);
            eval(['case_data{case_idx,1}.Diagnostics.Well.', well_name, '.WaterBreakthrough.PVI = WBT_PVI;']);
            
        end
    end
end

if save_flag==1
    cd '../';
    cd '../';
end

end