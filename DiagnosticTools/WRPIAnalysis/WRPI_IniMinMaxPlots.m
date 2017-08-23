function case_data = WRPI_IniMinMaxPlots(case_data)
% Determines gradient of RPI w.r.t. cumulative time (days)
%   Finds minimum and maximum values of the gradient and their locations
%   Finds the initial value of RPI and total change with time
%   Plot and save RPI and dRPI/dt vs. time plots for every case
%
% Last Update Date: 04/05/2017 
%
% SYNOPSIS:
%   case_data = WRPI_IniMinMaxPlots(case_data)
%
% DESCRIPTION:
%   This function calculates the minimum and maximum values of the gradient (dRPI/dt)
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
    y1 = case_data{i,1}.DerivedData.WPRO2.RPI.data; % Producer
    y2 = case_data{i,1}.DerivedData.WINJ1.RPI.data; % Injector

    [dydx1, dydxmin1, idydxmin1, xmin1, dydxmax1, idydxmax1, xmax1] = SlopeFuncMinMax(x,y1);
    [dydx2, dydxmin2, idydxmin2, xmin2, dydxmax2, idydxmax2, xmax2] = SlopeFuncMinMax(x,y2);
    
    ProInitialRPI = case_data{i,1}.DerivedData.WPRO2.RPI.data(2);
    ProLastRPI = case_data{i,1}.DerivedData.WPRO2.RPI.data(TotalDays);
    ProRPIChange = ProLastRPI - ProInitialRPI;
    
    InjInitialRPI = case_data{i,1}.DerivedData.WINJ1.RPI.data(2);
    InjLastRPI = case_data{i,1}.DerivedData.WINJ1.RPI.data(TotalDays);
    InjRPIChange = InjLastRPI - InjInitialRPI;
    
    %Append into case_data - Producer
    case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.dRPIdCUMT = dydx1;
    if dydxmin1 < 0 % just negative slopes
        case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.dRPIdCUMTmin = dydxmin1;
        case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.dRPIdCUMTminID = idydxmin1;
        case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.dRPIdCUMTminCUMT = xmin1;        
    else 
        case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.dRPIdCUMTmin = nan;
        case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.dRPIdCUMTminID = nan;
        case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.dRPIdCUMTminCUMT = nan;
    end
    if dydxmax1 > 0 % just positive slopes
        case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.dRPIdCUMTmax = dydxmax1;
        case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.dRPIdCUMTmaxID = idydxmax1;
        case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.dRPIdCUMTmaxCUMT = xmax1;  
    else
        case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.dRPIdCUMTmax = nan;
        case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.dRPIdCUMTmaxID = nan;
        case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.dRPIdCUMTmaxCUMT = nan;
    end
    case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.InitialRPI = ProInitialRPI;
    case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.LastRPI = ProLastRPI;
    case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.RPIChange = ProRPIChange;
    
    %Append into case_data - Injector
    case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.dRPIdCUMT = dydx2;
    if dydxmin2 < 0 % just negative slopes
        case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.dRPIdCUMTmin = dydxmin2; 
        case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.dRPIdCUMTminID = idydxmin2;
        case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.dRPIdCUMTminCUMT = xmin2;
    else
        case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.dRPIdCUMTmin = nan; 
        case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.dRPIdCUMTminID = nan;
        case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.dRPIdCUMTminCUMT = nan;
    end
    if dydxmax2 > 0 % just positive slopes
        case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.dRPIdCUMTmax = dydxmax2;
        case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.dRPIdCUMTmaxID = idydxmax2;
        case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.dRPIdCUMTmaxCUMT = xmax2;
    else
        case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.dRPIdCUMTmax = nan;
        case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.dRPIdCUMTmaxID = nan;
        case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.dRPIdCUMTmaxCUMT = nan;
    end
    case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.InitialRPI = InjInitialRPI;
    case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.LastRPI = InjLastRPI;
    case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.RPIChange = InjRPIChange;
              
end

choice = questdlg('Calculation Completed,Do you want to save Figures?','Calculation Completed','Yes','No','Yes');
if strcmp(choice,'Yes')==1
    
% Generate and save figures of RPI for Producer
    if ~exist('ProdW_RPIplots','dir')
        mkdir('ProdW_RPIplots');
    else
        delete('ProdW_RPIplots/*.png');
    end
    cd 'ProdW_RPIplots';
        
    for i=1:num_cases        
        Case_name = case_data{i,1}.name;
        fig_name = [Case_name,'.png'];
        x = case_data{i,1}.Tvar.Time.cumt;
        y1 = case_data{i,1}.DerivedData.WPRO2.RPI.data;
        y2 = case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.dRPIdCUMT;
        InitialRPI = case_data{i,1}.DerivedData.WPRO2.RPI.data(2);
        
        figure('visible', 'off');
        subplot(2,1,1);        
        plot(x,y1);
        title(['Initial RPI (PRO2): ', num2str(InitialRPI,2), ' (psi/STB/D)']);
        xlabel('Time (Days)');
        ylabel('RPI (psi/STB/D)'); 
        
        subplot(2,1,2);
        plot(x,y2);
        xlabel('Time (Days)');
        ylabel('dRPI/dt'); 
        
        saveas(gcf,fig_name);
        
        if mod(i,num_cases/4)==0 || i ==num_cases
            disp(['Saving ProdW_RPI vs Time Plots--------',num2str(i/num_cases*100),'% --------']);
        end
        
    end
    
    cd '../';
    
% Generate and save figures of RPI for Injector
    if ~exist('InjW_RPIplots','dir')
        mkdir('InjW_RPIplots');
    else
        delete('InjW_RPIplots/*.png');
    end
    cd 'InjW_RPIplots';
        
    for i=1:num_cases        
        Case_name = case_data{i,1}.name;
        fig_name = [Case_name,'.png'];
        h = figure('visible','off');
        
        x = case_data{i,1}.Tvar.Time.cumt;
        y1 = case_data{i,1}.DerivedData.WINJ1.RPI.data;
        y2 = case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.dRPIdCUMT;
        
        InitialRPI = case_data{i,1}.DerivedData.WINJ1.RPI.data(2);
                
        figure('visible', 'off');
        subplot(2,1,1);        
        plot(x,y1);
        title(['Initial RPI (INJ1): ', num2str(InitialRPI,2), ' (psi/STB/D)']);
        xlabel('Time (Days)');
        ylabel('RPI (psi/STB/D)'); 
        
        subplot(2,1,2);
        plot(x,y2);
        xlabel('Time (Days)');
        ylabel('dRPI/dt'); 

        
        saveas(gcf,fig_name);
            
        if mod(i,num_cases/4)==0 || i ==num_cases
            disp(['Saving InjW_RPI vs Time Plots--------',num2str(i/num_cases*100),'% --------']);
        end
        
    end
    
    cd '../';    
    
end

end