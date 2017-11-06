function case_data = FGOR_MinMaxPlots(case_data)
% Determines gradient of GOR w.r.t. cumulative time (days)
%   Finds minimum and maximum values of the gradient and their locations
%   Plot and save Field GOR and dGOR/dt vs. time plots for every case
%
% Last Update Date: 04/04/2017 
%
% SYNOPSIS:
%   case_data = FGOR_MinMaxPlots(case_data)
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
for i = 1:num_cases
   
    x = case_data{i,1}.Tvar.Time.cumt;
    y = case_data{i,1}.DerivedData.Field.GOR.data;

    [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);
        
    %Append into case_data
    case_data{i,1}.Diagnostics.WRPIA.Field.GOR.dFGORdCUMT = dydx;
    if dydxmin < 0
        case_data{i,1}.Diagnostics.WRPIA.Field.GOR.dFGORdCUMTmin = dydxmin;
        case_data{i,1}.Diagnostics.WRPIA.Field.GOR.dFGORdCUMTminID = idydxmin;
        case_data{i,1}.Diagnostics.WRPIA.Field.GOR.dFGORdCUMTminCUMT = xmin;
    else 
        case_data{i,1}.Diagnostics.WRPIA.Field.GOR.dFGORdCUMTmin = nan;
        case_data{i,1}.Diagnostics.WRPIA.Field.GOR.dFGORdCUMTminID = nan;
        case_data{i,1}.Diagnostics.WRPIA.Field.GOR.dFGORdCUMTminCUMT = nan;
    end
    if dydxmax > 0
        case_data{i,1}.Diagnostics.WRPIA.Field.GOR.dFGORdCUMTmax = dydxmax;
        case_data{i,1}.Diagnostics.WRPIA.Field.GOR.dFGORdCUMTmaxID = idydxmax;
        case_data{i,1}.Diagnostics.WRPIA.Field.GOR.dFGORdCUMTmaxCUMT = xmax;
    else
        case_data{i,1}.Diagnostics.WRPIA.Field.GOR.dFGORdCUMTmax = dydxmax;
        case_data{i,1}.Diagnostics.WRPIA.Field.GOR.dFGORdCUMTmaxID = idydxmax;
        case_data{i,1}.Diagnostics.WRPIA.Field.GOR.dFGORdCUMTmaxCUMT = xmax;
    end

end

% Plots

choice = questdlg('Calculation Completed,Do you want to save Figures?','Calculation Completed','Yes','No','Yes');
if strcmp(choice,'Yes')==1
    
    if ~exist('FGORvsTplots','dir')
        mkdir('FGORvsTplots');
    else
        delete('FGORvsTplots/*.png');
    end
    cd 'FGORvsTplots';
    
    for i=1:num_cases        
        Case_name = case_data{i,1}.name;
        fig_name = [Case_name,'.png'];
        x = case_data{i,1}.Tvar.Time.cumt;
        y1 = case_data{i,1}.DerivedData.Field.GOR.data;
        y2 = case_data{i,1}.Diagnostics.WRPIA.Field.GOR.dFGORdCUMT;
        
        figure('visible','off');
        
        subplot(2,1,1);        
        plot(x,y1);
        xlabel('Time (Days)');
        ylabel('GOR (MSCF/STB)'); 
        
        subplot(2,1,2);
        plot(x,y2);
        xlabel('Time (Days)');
        ylabel('dGOR/dt'); 
        
        saveas(gcf,fig_name);
        
        if mod(i,num_cases/4)==0 || i ==num_cases
            disp(['Saving Field GOR vs Time Plots--------',num2str(i/num_cases*100),'% --------']);
        end
        
    end
    
    cd '../';
end

end