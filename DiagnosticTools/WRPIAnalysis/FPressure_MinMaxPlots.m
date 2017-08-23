function case_data = FPressure_MinMaxPlots(case_data)
% Determines gradient of Field Pressure w.r.t. cumulative time (days)
%   Finds minimum and maximum values of the gradient and their locations
%   Plot and save Field Pressure and dP/dt vs. time plots for every case
%
% Last Update Date: 04/04/2017 
%
% SYNOPSIS:
%   case_data = FPressure_MinMaxPlots(case_data)
%
% DESCRIPTION:
%   This function calculates the minimum and maximum values of the gradient (dP/dt)
%   and its location in time
%
% PARAMETERS:
%   case_data: data structure that is used in MRDAT
%
%----------------------------------------------------------

num_cases = length(case_data);
TotalDays = length(case_data{1,1}.Tvar.Time.cumt);
for i = 1:num_cases
   
    x = case_data{i,1}.Tvar.Time.cumt;
    y = case_data{i,1}.Tvar.Field.Pressure.data;

    [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);
    InitialPressure = case_data{i,1}.Tvar.Field.Pressure.data(1);
    CurrentPressure = case_data{i,1}.Tvar.Field.Pressure.data(TotalDays);
    PressureDrop = InitialPressure - CurrentPressure;
    
    %Append into case_data
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dFPdCUMT = dydx;
    if dydxmin < 0
        case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dFPdCUMTmin = dydxmin;
        case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dFPdCUMTminID = idydxmin;
        case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dFPdCUMTminCUMT = xmin;
    else 
        case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dFPdCUMTmin = nan;
        case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dFPdCUMTminID = nan;
        case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dFPdCUMTminCUMT = nan;
    end
    if dydxmax > 0 
        case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dFPdCUMTmax = dydxmax;
        case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dFPdCUMTmaxID = idydxmax;
        case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dFPdCUMTmaxCUMT = xmax;
    else
        case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dFPdCUMTmax = nan;
        case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dFPdCUMTmaxID = nan;
        case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dFPdCUMTmaxCUMT = nan;
    end
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.InitialPressure = InitialPressure;      
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.CurrentPressure = CurrentPressure;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.PressureDrop = PressureDrop;
end

% Plots

choice = questdlg('Calculation Completed,Do you want to save Figures?','Calculation Completed','Yes','No','Yes');
if strcmp(choice,'Yes')==1
    
    if ~exist('FPvsTplot','dir')
        mkdir('FPvsTplot');
    else
        delete('FPvsTplot/*.png');
    end
    cd 'FPvsTplot';
    
    for i=1:num_cases        
        Case_name = case_data{i,1}.name;
        fig_name = [Case_name,'.png'];
        x = case_data{i,1}.Tvar.Time.cumt;
        y1 = case_data{i,1}.Tvar.Field.Pressure.data;
        y2 = case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dFPdCUMT;
        TotalPressureDrop = case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.PressureDrop;
        
        figure('visible','off');
        
        subplot(2,1,1);        
        plot(x,y1);
        title(['Total Field Pressure Drop/Rise: ', num2str(TotalPressureDrop,2), ' (psi)']);
        xlabel('Time (Days)');
        ylabel('Field Pressure (psi)'); 
        
        subplot(2,1,2);
        plot(x,y2);
        xlabel('Time (Days)');
        ylabel('dP/dt'); 
        
        saveas(gcf,fig_name);
        
        if mod(i,num_cases/4)==0 || i ==num_cases
            disp(['Saving Field Pressure vs Time Plots--------',num2str(i/num_cases*100),'% --------']);
        end
        
    end
    
    cd '../';
end

end