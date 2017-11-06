function ErsaghiIndexPlots(case_data)
% Plot Ersaghi Index vs Time and Cumulative Oil Production
%
% Last Update Date: 07/14/2017
%
%SYNOPSIS:
%   ErsaghiIndexPlots(case_data)
%
%DESCRIPTION:
%   This function plots Ersaghi Index
%
%PARAMETERS:
%   case_data: data structure that is used in MRDAT
%
%----------------------------------------------------------
if ~exist('Ersaghi_Plots','dir')
    mkdir('Ersaghi_Plots');
else
    delete('Ersaghi_Plots/*.png');
end

cd 'Ersaghi_Plots';


num_cases = length(case_data);

% Ersaghi Index vs Time
for i=1:num_cases
    fw = case_data{i,1}.DerivedData.Field.WC.data;
    if sum(fw, 'omitnan')>0
        Time = case_data{i,1}.Tvar.Time.cumt;
        Xfunction = case_data{i,1}.DerivedData.Field.ErsaghiId.data;
        figure('Visible', 'off');
        
        subplot(2,1,1);
        plot(Time, Xfunction);
        axis([0 inf -inf 0]);
        xlabel('Time (Days)');
        ylabel('ln((1/fw)-1)-1/fw');
        title('Ersaghi Index vs Time');
        subplot(2,1,2);
        plot(Time, fw);
        axis([0 inf 0 inf]);
        xlabel('Time (Days)');
        ylabel('Water cut');
        saveas(gcf, [case_data{i,1}.name, '.png']);
    else
        continue;
    end
    
end


% % % % Ersaghi Index vs Cumulative Oil Production
% % % figure;
% % % for i=1:num_cases
% % %     fw = case_data{i,1}.DerivedData.Field.WC.data;
% % %     ErsaghiIdx = find(fw>0.1);
% % %     if ~isempty(ErsaghiIdx)
% % %         Xfunction = case_data{i,1}.DerivedData.Field.ErsaghiId.data(ErsaghiIdx);
% % %         Np = case_data{i,1}.Tvar.Field.OilProductionCumulative.data(ErsaghiIdx);
% % %         plot(Xfunction, Np);
% % %         hold on;
% % %     else
% % %         continue;
% % %     end
% % %
% % % end
% % % xlabel('X-function = ln((1/fw)-1)-1/fw');
% % % ylabel('Cumulative Oil Production (STB)');
% % % title('Ersaghi Index');

cd '../';

end



