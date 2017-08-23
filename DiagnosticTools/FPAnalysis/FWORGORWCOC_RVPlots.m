function case_data = FWORGORWCOC_RVPlots(case_data)
%Combines WOR, GOR, WC, OC diagnostic plots w.r.t. reservoir volume production 
%   cumulative. Finds minima and maxima of the gradient and their locations.
%
%SYNOPSIS:
%   case_data = FWORGORWCOC_RVPlots(case_data)
%
%DESCRIPTION:
%   This function Combines WOR, GOR, WC, OC diagnostic plots w.r.t. reservoir 
%   volume production cumulative. Finds minima and maxima of the gradient 
%   and their locations.
%
%   Currently performing at field level
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%------------------------------------------------
%Initialization
case_data = FGORResVolMinMax(case_data,0);
case_data = FWORResVolMinMax(case_data,0);
case_data = FWCResVolMinMax(case_data,0);
case_data = FOCResVolMinMax(case_data,0);

%---------------------------------------------
%loop through all necessary cases
num_cases = length(case_data);
FWGO_case_idx = 1:num_cases;

choice = questdlg('Calculation Completed,Do you want to save Figures?','Calculation Completed','Yes','No','Yes');
% Handle response
if strcmp(choice,'Yes')==1
    Frame_data=save_FWORGORWCOCPlots(FWGO_case_idx,case_data);
end

end


function Frame_data=save_FWORGORWCOCPlots(FWGO_case_idx,case_data);  %generate plots and frame data
if ~exist('FWORGORWCOCplot','dir')
    mkdir('FWORGORWCOCplot');
end
cd 'FWORGORWCOCplot';

%num_well = length(well_list);
num_required_cases = length(FWGO_case_idx);
total_num_i = num_required_cases;
Frame_data = cell(total_num_i,1);
i = 1;
total_num_h = max(total_num_i/10,20);
for loop_idx = 1:num_required_cases
    case_idx = FWGO_case_idx(loop_idx);
    Case_name = case_data{case_idx}.name;

    RVPC = case_data{case_idx}.Tvar.Field.ReservoirVolumeProductionCumulative.data;
    WOR = case_data{case_idx}.DerivedData.Field.WOR.data;
    GOR = case_data{case_idx}.DerivedData.Field.GOR.data;
    WC = case_data{case_idx}.DerivedData.Field.WC.data;
    OC = case_data{case_idx}.DerivedData.Field.OC.data;    
    
    dFWORdRVPC = eval(['case_data{case_idx}.Diagnostics.FPA.Field.WOR','.dFWORdRVPC;']);
    dFWORdRVPCminRVPC = eval(['case_data{i}.Diagnostics.FPA.Field.WOR','.dFWORdRVPCminRVPC;']); 
    
    dFGORdRVPC = eval(['case_data{case_idx}.Diagnostics.FPA.Field.GOR','.dFGORdRVPC;']);
    dFGORdRVPCminRVPC = eval(['case_data{i}.Diagnostics.FPA.Field.GOR','.dFGORdRVPCminRVPC;']); 
    
    dFWCdRVPC = eval(['case_data{case_idx}.Diagnostics.FPA.Field.WC','.dFWCdRVPC;']);
    dFWCdRVPCminRVPC = eval(['case_data{i}.Diagnostics.FPA.Field.WC','.dFWCdRVPCminRVPC;']);     

    dFOCdRVPC = eval(['case_data{case_idx}.Diagnostics.FPA.Field.OC','.dFOCdRVPC;']);
    dFOCdRVPCminRVPC = eval(['case_data{i}.Diagnostics.FPA.Field.OC','.dFOCdRVPCminRVPC;']);    
    
    pic_name = [Case_name,'.png'];
    h = figure('visible','off');
    s(1) = subplot(2,4,1); 
    s(2) = subplot(2,4,2); 
    s(3) = subplot(2,4,3); 
    s(4) = subplot(2,4,4); 
    s(5) = subplot(2,4,5); 
    s(6) = subplot(2,4,6); 
    s(7) = subplot(2,4,7); 
    s(8) = subplot(2,4,8); 
    
    plot(s(1),RVPC,WOR); 

    xlabel(s(1),'RVPC');
    ylabel(s(1),'WOR');
    
    plot(s(5),RVPC,dFWORdRVPC);

    xlabel(s(5),'RVPC');
    ylabel(s(5),'dFWORdRVPC');

    
    plot(s(2),RVPC,WC); 

    xlabel(s(2),'RVPC');
    ylabel(s(2),'WC');
    
    plot(s(6),RVPC,dFWCdRVPC);

    xlabel(s(6),'RVPC');
    ylabel(s(6),'dFWCdRVPC');
    
    
    plot(s(3),RVPC,GOR); 

    xlabel(s(3),'RVPC');
    ylabel(s(3),'GOR');
    
    plot(s(7),RVPC,dFGORdRVPC);

    xlabel(s(7),'RVPC');
    ylabel(s(7),'dFGORdRVPC');

   
    plot(s(4),RVPC,OC); 

    xlabel(s(4),'RVPC');
    ylabel(s(4),'OC');
    
    plot(s(8),RVPC,dFOCdRVPC);

    xlabel(s(8),'RVPC');
    ylabel(s(8),'dFOCdRVPC');
    
    
    hold on

    hold off
    Frame_data{i} = getframe(h);
    saveas(h,pic_name);
    close(h);
    i=i+1;
    
    if mod(i,total_num_h)==0 || i ==total_num_i
        disp(['Saving FWOR/FGOR/FWC Plots--------',num2str(i/total_num_i*100),'% --------']);
    end
    
end

cd '../';

end