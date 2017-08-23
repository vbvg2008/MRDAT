function RPIFGORFP_Plots(case_data)
% Creates plots of RPI, GOR and Pressure vs time with its derivatives
%
% Last Update Date: 04/05/2017 
%
%SYNOPSIS:
%   RPIFGORFP_Plots(case_data)
%
%DESCRIPTION:
%   Creates plots of RPI, GOR and Pressure vs time with its derivatives.
%
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%
% ------------------------------------------------------------------------

choice = questdlg('Do you want to save the figures?','Save Figures','Yes','No','Yes');
if strcmp(choice,'Yes')==1
    if ~exist('RPIFGORFP_Plots','dir')
        mkdir('RPIFGORFP_Plots');
    else
        delete('RPIFGORFP_Plots/*.png');
    end
    cd 'RPIFGORFP_Plots';
    
    num_cases = length(case_data);
    for i=1:num_cases
        time = case_data{i,1}.Tvar.Time.cumt;
        RPI = case_data{i,1}.DerivedData.WPRO2.RPI.data;
        dRPIdt = case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.dRPIdCUMT;
        GOR = case_data{i,1}.DerivedData.Field.GOR.data;
        dGORdt = case_data{i,1}.Diagnostics.WRPIA.Field.GOR.dFGORdCUMT;
        Pressure = case_data{i,1}.Tvar.Field.Pressure.data;
        dPdt = case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dFPdCUMT;
        
        figure('visible', 'off');
        subplot(2,3,1);
        plot(time, RPI);
        xlabel('Time (Days)');
        ylabel('RPI (psi/STB/D)');
        
        subplot(2,3,2);
        plot(time, GOR);
        xlabel('Time (Days)');
        ylabel('GOR (MSCF/STB)');
        
        subplot(2,3,3);
        plot(time, Pressure);
        xlabel('Time (Days)');
        ylabel('Field Pressure (psi)');
        
        subplot(2,3,4);
        plot(time, dRPIdt);
        xlabel('Time (Days)');
        ylabel('dRPI/dt');
        
        subplot(2,3,5)
        plot(time, dGORdt);
        xlabel('Time (Days)');
        ylabel('dGOR/dt');
        
        subplot(2,3,6)
        plot(time, dPdt);
        xlabel('Time (Days)');
        ylabel('dP/dt');
        
        Case_name = case_data{i,1}.name;
        filename = [Case_name, '.png'];
        saveas(gcf, filename);
        
        if mod(i,num_cases/4)==0 || i ==num_cases
            disp(['Saving RPIFGORFP Plots--------',num2str(i/num_cases*100),'% --------']);
        end
        
    end
    
    cd '../';
end

end

