function case_data = ChanDiagnosticPlots_WOR_byWell(case_data, save_flag)

% Determine the water production problem according to Chan diagnostic plots
%
% Last Update Date: 10/31/2017
%
%SYNOPSIS:
%   case_data = ChanDiagnosticPlots_WOR_byWell(case_data, save_flag)
%
%DESCRIPTION:
%  This function determines the water production problem accoing to Chan
%  diagnostic plots
%
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%   save_flag - 0 (no), 1 (yes)
%


if save_flag==1
    if ~exist('Chan_Plots','dir')
        mkdir('Chan_Plots');
    else
        delete('Chan_Plots/*.png');
    end
    cd 'Chan_Plots';
end

num_cases = length(case_data);

for case_idx=1:num_cases
    well_list = fieldnames(case_data{case_idx}.Tvar.Well);
    num_wells = length(well_list);
    
    for well_idx = 1: num_wells
        well_name = well_list(well_idx);
        if contains(well_name, 'PRO')
            WOR = eval(['case_data{case_idx,1}.DerivedData.Well.', well_name, '.WOR.data']);
            Time = case_data{case_idx,1}.Tvar.Time.cumt;
            TotalDaysIdx = length(Time);
            FinalWOR = WOR(TotalDaysIdx);
            if FinalWOR ==0
                ChanPlotFlag = 5; % No water production
            elseif FinalWOR > 0
                
                % WOR derivative
                DeltaT = diff(Time);
                WORder = diff(WOR)./DeltaT;
                % dx = mean(diff(Time));
                % dWORdTime = gradient(WOR,dx);
                
                % Take logarithm of Time, WOR and its derivative
                logTime = log10(Time);
                logWOR = log10(WOR);
                logWORder = log10(abs(WORder));
                
                % Remove Inf values
                logTime(isinf(logTime))= nan;
                logWOR(isinf(logWOR))= nan;
                logWORder(isinf(logWORder))= nan;
                
                % Select data with values different to nan
                WOR_StartIdx = find(~isnan(logWOR),1, 'first');
                WORder_StartIdx = find(~isnan(logWORder),1, 'first');
                
                x1 = logTime(WOR_StartIdx:TotalDaysIdx);
                y1 = logWOR(WOR_StartIdx:TotalDaysIdx);
                
                x2 = logTime(WORder_StartIdx:TotalDaysIdx-1);
                y2 = logWORder(WORder_StartIdx:TotalDaysIdx-1);
                
                % Smooth the data using the rloess with a span of 30%:
                %   For the loess and lowess methods, span is a percentage of the total number of data points, less than or equal to 1.
                %   For the moving average and Savitzky-Golay methods, span must be odd (an even span is automatically reduced by 1).
                yy1 = smooth(x1,y1,0.3,'rloess');
                yy2 = smooth(x2,y2,0.3,'rloess');
                
                % Find the best fit of the smoothed data
                [WOR_fit, WOR_stats] = fit(x1, yy1, 'poly1'); % linear fit of WOR
                [WORder_fit1, WORder_stats1] = fit(x2, yy2, 'poly1'); % linear fit of WOR der
                [WORder_fit2, WORder_stats2] = fit(x2, yy2, 'poly2'); % polinomial fit of WOR der
                
                % yyy1 = x1.*WOR_fit.p1 + WOR_fit.p2;
                % yyy2 = x2.*WORder_fit.p1 + WORder_fit.p2;
                
                % [WOR_fit, WOR_stats] = fit(x1, y1, 'poly1');
                % [WORder_fit, WORder_stats] = fit(x2, y2, 'poly1');
                
                % Chan Diagnostic Flag
                if WOR_fit.p1 >= 2
                    if WORder_fit1.p1 > 0.5 && WORder_stats1.rsquare > 0.8
                        ChanPlotFlag = 1; % Channeling
                    elseif WORder_fit1.p1 > 0.5 && WORder_fit2.p1 > 0
                        ChanPlotFlag = 1; % Channeling
                    elseif WORder_fit2.p1 > 0 && WORder_stats2.rsquare > 0.6 && WORder_fit1.p1 > 0
                        ChanPlotFlag = 1; % Channeling
                    elseif WORder_fit1.p1 > 0 && WORder_stats1.rsquare > 0.6 && WORder_fit2.p1 < -1
                        ChanPlotFlag = 1; % Channeling
                    elseif WORder_fit1.p1 < 0 && WORder_fit2.p1 < 0
                        ChanPlotFlag = 2; % Coning
                    elseif WORder_fit1.p1 < 0.5 && WORder_fit2.p1 < 0 && WORder_stats2.rsquare > 0.8
                        ChanPlotFlag = 2; % Coning
                    else
                        ChanPlotFlag = 4; % Not clear
                    end
                elseif WOR_fit.p1 < 2
                    if WORder_fit1.p1 <= -0.1 && WORder_stats1.rsquare > 0.8
                        ChanPlotFlag = 2; % Coning
                    elseif WORder_fit2.p1 < 0 && WORder_stats2.rsquare > 0.8
                        ChanPlotFlag = 2; % Coning
                    elseif WORder_fit1.p1 < 0 && WORder_fit2.p1 < 0
                        ChanPlotFlag = 2; % Coning
                    elseif WORder_fit1.p1 < -0.1 && (WORder_fit2.p1 > 0 && WORder_fit2.p1 < 1)
                        ChanPlotFlag = 2; % Coning
                    elseif (WORder_fit1.p1 > -0.1 && WORder_fit1.p1 < 0.5) && (WORder_fit2.p1 > 0 && WORder_fit2.p1 < 0.25)
                        ChanPlotFlag = 3; % Normal
                    elseif WORder_fit1.p1 > 0.5 && WORder_fit2.p1 > 0
                        ChanPlotFlag = 1; % Channeling
                    else
                        ChanPlotFlag = 4; % Not clear
                    end
                end
                %%%%
                % % %         if WOR_fit.p1 > 0.10 && WOR_fit.p1 < 3
                % % %             if WORder_fit1.p1 < -0.1 && WORder_stats1.rsquare > 0.9
                % % %                 ChanPlotFlag = 1; % coning
                % % %             elseif WORder_fit2.p1 < 0 && WORder_stats2.rsquare > 0.85
                % % %                 ChanPlotFlag = 1; % coning
                % % %             elseif WORder_fit1.p1 > 0.25 && WORder_stats1.rsquare > 0.9
                % % %                 ChanPlotFlag = 2; % channeling
                % % %             elseif WORder_fit2.p1 > 0 && WORder_stats2.rsquare > 0.85
                % % %                 ChanPlotFlag = 3; % Not clear
                % % %             else
                % % %                 ChanPlotFlag = 3;  % Not clear
                % % %             end
                % % %         elseif WOR_fit.p1 >= 3 && WORder_fit1.p1 > 1.5 && WORder_stats1.rsquare > 0.8
                % % %                 ChanPlotFlag = 2; % Channeling
                % % %         else
                % % %             ChanPlotFlag = 3; % Not clear
                % % %         end
                
                % Generation of plots
                if save_flag==1
                    figure('Visible', 'off');
                    loglog(10.^x1, 10.^y1,'b^', 'MarkerSize', 3);  % WOR
                    hold on;
                    loglog(10.^x1, 10.^yy1,'b-'); % Smoothed WOR
                    hold on;
                    loglog(10.^x2, 10.^y2,'rv', 'MarkerSize', 3); % WORder
                    hold on;
                    loglog(10.^x2, 10.^yy2,'r-'); % Smoothed WORder
                    % hold on;
                    % loglog(10.^x1, 10.^yyy1, 'k-'); % WOR fit (linear)
                    % hold on;
                    % loglog(10.^x2, 10.^yyy2, 'k-'); % WORder fit (linear)
                    grid on;
                    xlabel('Time (Days)');
                    ylabel('WOR and WOR^{\prime}');
                    legend('WOR','Smoothed WOR','WORder', 'Smoothed WORder', 'Location','NW');
                    axis([1 10000 -Inf Inf]);
                    if ChanPlotFlag==1
                        title('Water Channeling');
                        %title(['Channeling - WORfit slope: ', num2str(WOR_fit.p1,3), ' & WORderfit1 slope: ', num2str(WORder_fit1.p1,3), '& WORderfit2 a: ', num2str(WORder_fit2.p1,3)]);
                    elseif ChanPlotFlag==2
                        title('Water Coning');
                        %title(['Coning - WORfit slope: ', num2str(WOR_fit.p1, 3), ' & WORderfit1 slope: ', num2str(WORder_fit1.p1,3), '& WORderfit2 a: ', num2str(WORder_fit2.p1,3)]);
                    elseif ChanPlotFlag==3
                        title('Normal');
                        %title(['Normal (WORfit slope: ', num2str(WOR_fit.p1, 3), ' & WORderfit1 slope: ', num2str(WORder_fit1.p1,3), '& WORderfit2 a: ', num2str(WORder_fit2.p1,3)]);
                    else
                        title('Not clear');
                        %title(['Not clear (WORfit slope: ', num2str(WOR_fit.p1, 3), ' & WORderfit1 slope: ', num2str(WORder_fit1.p1,3), '& WORderfit2 a: ', num2str(WORder_fit2.p1,3)]);
                    end
                    saveas(gcf, [case_data{case_idx,1}.name,'_',well_name, '.png']);
                    close(gcf);
                end
            end
            
            % Append results to case_data structure
            eval(['case_data{case_idx,1}.Diagnostics.Well.', well_name, '.ChanPlotFlag = ChanPlotFlag;']);
            
        end
    end
end

if save_flag==1
    cd '../';
end


end