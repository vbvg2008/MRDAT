function Yfunction(case_data)

% Determine the Y-function and generate diagnostic plots proposed by Yang (2009)
%
% Last Update Date: 01/05/2018
%
%SYNOPSIS:
%   Yfunction(case_data)
%
%DESCRIPTION:
% This function determines the Y-function values and generates: 1) loglog plots
% of Y-function vs cumulative liquid production; and 2) cartesian plots of
% Y-function vs reciprocal of cumulative liquid production
%
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT

num_cases = length(case_data);

if ~exist('WD/Y-function Plots','dir')
    mkdir('WD/Y-function Plots');
end
cd 'WD/Y-function Plots';

for i = 1: num_cases
    % Input data
    OilCut = case_data{i,1}.DerivedData.Field.OC.data; % oil fractional flow
    WaterCut = case_data{i,1}.DerivedData.Field.WC.data; % water fractional flow
    LiqCum = case_data{i,1}.Tvar.Field.LiquidProductionCumulative.data; % cumulative liquid production
    ResLiqCum = case_data{i,1}.Tvar.Field.ReservoirVolumeProductionCumulative.data;
    PV = case_data{i,1}.Tvar.Field.PoreVolumeAtReservoirConditions.data;
    tD = ResLiqCum./PV; % Displacement time (PV)
    
    % Determine Y-function and append values to case_data structure
    Yfunction = OilCut.*WaterCut;
    case_data{i,1}.Diagnostics.FWA.Field.Yfunction = Yfunction;
    
    % Generate and save plots
    %if sum(WaterCut, 'omitnan')>0
    if min(WaterCut, 'omitnan')>0.5
        % loglog plots
        figure('visible', 'off');
        loglog(LiqCum, Yfunction, '-s');
        xlabel('Cumulative Liquid Production (STB)');
        ylabel('Y-function = fo*(1-fo)');
        title('Log-log Diagnostic Plot');
        grid on;
        saveas(gcf, [case_data{i,1}.name,'_LoglogPlot.png']);
        close;
        
        % cartesian plots (reciprocal of time)
        figure('visible', 'off');
        plot(1./LiqCum, Yfunction, '-o');
        xlabel('1/QL');
        ylabel('Y-function = fo*(1-fo)');
        title('Reciprocal of QL Diagnostic Plot');
        grid on;
        saveas(gcf, [case_data{i,1}.name,'_ReciprocalPlot.png']);
        close;
    end
end

cd '../';
cd '../';

end