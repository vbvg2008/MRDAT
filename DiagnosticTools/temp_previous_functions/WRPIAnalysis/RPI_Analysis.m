function RPI_Analysis(case_data)
% Creates diagnostic plots using RPI, Pressure, GOR, Cumulative Oil/Water 
%production and Water injection relationship.
%
% Last Update Date: 04/10/2017 
%
%SYNOPSIS:
%   RPI_Analysis(case_data)
%
%DESCRIPTION:
%   Creates diagnostic plots using RPI, Pressure, GOR, Cumulative Oil/Water 
%production and Water injection relationship.
%
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%

num_cases = length(case_data);
TotalDaysIdx = length(case_data{1,1}.Tvar.Time.cumt);
for i=1:num_cases
  %Producer  
    % Pressure derivatives wrt Time
    dPdt_max(i) = case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dFPdCUMTmax;
    dPdt_maxT(i) = case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dFPdCUMTmaxCUMT;
    dPdt_min(i) = case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dFPdCUMTmin;
    dPdt_minT(i) = case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dFPdCUMTminCUMT;
    % Pressure Change
    PressureDrop(i)= case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.PressureDrop;
    % RPI Derivatives wrt Time - Producer
    dRPIdt_max(i) = case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.dRPIdCUMTmax;
    dRPIdt_maxT(i) = case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.dRPIdCUMTmaxCUMT;
    dRPIdt_min(i) = case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.dRPIdCUMTmin;
    dRPIdt_minT(i) = case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.dRPIdCUMTminCUMT;     
    % RPI Change - Producer
    InitialRPI(i) = case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.InitialRPI;
    LastRPI(i)= case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.LastRPI;
    RPIChange(i) = case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.RPIChange; 
    % GOR Derivatives wrt Time
    dGORdt_min(i)= case_data{i,1}.Diagnostics.WRPIA.Field.GOR.dFGORdCUMTmin;
    dGORdt_minT(i) = case_data{i,1}.Diagnostics.WRPIA.Field.GOR.dFGORdCUMTminCUMT;    
    dGORdt_max(i) = case_data{i,1}.Diagnostics.WRPIA.Field.GOR.dFGORdCUMTmax;
    dGORdt_maxT(i) = case_data{i,1}.Diagnostics.WRPIA.Field.GOR.dFGORdCUMTmaxCUMT; 
    % Final Cumulative Oil Production
    LastCumOil(i) = case_data{i,1}.Tvar.Field.OilProductionCumulative.data(TotalDaysIdx); 
    
  %Injector
    % RPI Derivatives wrt Time - Injector
    dRPIdt_max_Inj(i) = case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.dRPIdCUMTmax;
    dRPIdt_maxT_Inj(i) = case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.dRPIdCUMTmaxCUMT;
    dRPIdt_min_Inj(i) = case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.dRPIdCUMTmin;
    dRPIdt_minT_Inj(i) = case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.dRPIdCUMTminCUMT;     
    % RPI Change - Injector
    InitialRPI_Inj(i) = case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.InitialRPI;
    LastRPI_Inj(i)= case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.LastRPI;
    RPIChange_Inj(i) = case_data{i,1}.Diagnostics.WRPIA.WINJ1.RPI.RPIChange; 
    % Final Cumulative Water Injection and Production
    LastCumWaterProd(i) = case_data{i,1}.Tvar.Field.WaterProductionCumulative.data(TotalDaysIdx);
    LastCumWaterInj(i) = case_data{i,1}.Tvar.Field.WaterInjectionCumulative.data(TotalDaysIdx);
end

% Scatter plots
if ~exist('RPI_Analysis','dir')
    mkdir('RPI_Analysis');
else
    delete('RPI_Analysis/*.png');
end
cd 'RPI_Analysis';

%*********** Producer ***********

% Fig 1 - Increase in RPI coincides with a sharp drop in pressure?
figure('visible', 'off');
plot(dPdt_minT, dRPIdt_maxT,'+');
title('Producer');
ylabel('Time of marked increase in RPI (days)');
xlabel('Time of sharp drop in Pressure (days)');
print('01_FPvsRPI','-dpng');

% Fig 2 - Increase in RPI coincides with a sharp rise in pressure?
figure('visible', 'off');
plot(dPdt_maxT, dRPIdt_maxT, '+'); %test
title('Producer');
ylabel('Time of marked increase in RPI (days)');
xlabel('Time of sharp rise in Pressure (days)');
print('02_FPvsRPI','-dpng');

% Fig 3 - Decrease in RPI coincides with a marked increase in pressure?
figure('visible', 'off');
plot(dPdt_maxT, dRPIdt_minT, '+');
title('Producer');
ylabel('Time of shrap drop in RPI (days)');
xlabel('Time of marked increase in Pressure (days)');
print('03_FPvsRPI','-dpng');

% Fig 4 - Decrease in RPI coincides with a marked drop in pressure?
figure('visible', 'off');
plot(dPdt_minT, dRPIdt_minT, '+'); %test
title('Producer');
ylabel('Time of shrap drop in RPI (days)');
xlabel('Time of marked drop in Pressure (days)');
print('04_FPvsRPI','-dpng');

% Fig 5 - Decrease in RPI coincides with a marked drop in GOR?
figure('visible', 'off');
plot(dGORdt_minT, dRPIdt_minT, '+');
title('Producer');
ylabel('Time of shrap drop in RPI (days)');
xlabel('Time of shrap drop in GOR (days)');
print('05_GORvsRPI','-dpng');

% Fig 6 - Increase in RPI coincides with a marked rise in GOR?
figure('visible', 'off');
plot(dGORdt_maxT, dRPIdt_maxT, '+');
title('Producer');
ylabel('Time of marked increase in RPI (days)');
xlabel('Time of marked increase in GOR (days)');
print('06_GORvsRPI','-dpng');

% Fig 7 - Relationship between initial RPI and final cumulative oil production
figure('visible', 'off');
plot(InitialRPI, LastCumOil, 'g+');
title('Producer');
ylabel('Final Cumulative Oil Production (STB)');
xlabel('Initial RPI (psi/STB/D)');
print('07_InitialRPIvsCumOil','-dpng');

% Fig 8 - Relationship between initial RPI and final cumulative water production
figure('visible', 'off');
plot(InitialRPI, LastCumWaterProd, 'b+');
title('Producer');
ylabel('Final Cumulative Water Production (STB)');
xlabel('Initial RPI (psi/STB/D)');
print('08_InitialRPIvsCumProdWater','-dpng');

% Fig 9 - Relationship between current pressure drop/rise and final cumulative oil production
figure('visible', 'off');
plot(PressureDrop, LastCumOil, 'r+');
ylabel('Final Cumulative Oil Production (STB)');
xlabel('Current Pressure Drop(+)/Rise(-) (psi)');
print('09_CurrentDPvsFinalCumOil','-dpng');

% Fig 10 - Relationship between current RPI change and final cumulative oil production
figure('visible', 'off');
plot(RPIChange, LastCumOil,'g+');
title('Producer');
ylabel('Final Cumulative Oil Production (STB)');
xlabel('Current RPI Change (psi/STB/D)');
print('10_CurrentRPIChangevsFinalCumOil','-dpng');


%*********** Injector ***********

% Fig 11 - Relationship between Initial RPI and final cumulative water production
figure('visible', 'off');
plot(InitialRPI_Inj, LastCumWaterProd, 'b+');
title('Injector');
ylabel('Final Cumulative Water Production (STB)');
xlabel('Initial RPI (psi/STB/D)');
print('11_InitialRPIvsCumProdWater','-dpng');

% Fig 12 - Relationship between Initial RPI and final cumulative water injection
figure('visible', 'off');
plot(InitialRPI_Inj, LastCumWaterInj, 'b+');
title('Injector');
ylabel('Final Cumulative Water Injection (STB)');
xlabel('Initial RPI (psi/STB/D)');
print('12_InitialRPIvsCumInjWater','-dpng');

% Fig 13 - Relationship between Total RPI change and final cumulative water production
figure('visible', 'off');
plot(RPIChange_Inj, LastCumWaterProd, 'b+');
title('Injector');
ylabel('Final Cumulative Water Production (STB)');
xlabel('Total RPI Change (psi/STB/D)');
print('13_RPIChangevsCumProdWater','-dpng');

% Fig 14 - Relationship between Total RPI change and final cumulative water injection
figure('visible', 'off');
plot(RPIChange_Inj, LastCumWaterInj, 'b+');
title('Injector');
ylabel('Final Cumulative Water Injection (STB)');
xlabel('Total RPI Change (psi/STB/D)');
print('14_ChangeRPIvsCumInjWater','-dpng');


cd '../';
 
end