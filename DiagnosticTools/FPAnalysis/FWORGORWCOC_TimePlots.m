function case_data = FWORGORWCOC_TimePlots(case_data)
%Combines WOR, GOR, WC, OC diagnostic plots w.r.t. elapsed time. 
%   
%SYNOPSIS:
%   case_data = FWORGORWCOC_TimePlots(case_data)
%
%DESCRIPTION:
%Combines WOR, GOR, WC, OC diagnostic plots w.r.t. elapsed time. 
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
    Frame_data=save_FWORGORWCOCTimePlots(FWGO_case_idx,case_data);
end

end


function Frame_data=save_FWORGORWCOCTimePlots(FWGO_case_idx,case_data);  %generate plots and frame data
if ~exist('FWORGORWCOC_TPlot','dir')
    mkdir('FWORGORWCOC_TPlot');
end
cd 'FWORGORWCOC_TPlot';

%num_well = length(well_list);
num_required_cases = length(FWGO_case_idx);
total_num_i = num_required_cases;
Frame_data = cell(total_num_i,1);
i = 1;
total_num_h = min(max(total_num_i/10,20),25);
for loop_idx = 1:num_required_cases
    case_idx = FWGO_case_idx(loop_idx);
    Case_name = case_data{case_idx}.name;

    Time = case_data{case_idx}.Tvar.Time.cumt;
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
    s(1) = subplot(2,2,1); 
    s(2) = subplot(2,2,2); 
    s(3) = subplot(2,2,3); 
    s(4) = subplot(2,2,4); 
    
    plot(s(1),log(Time),log(WOR)); 

    xlabel(s(1),'Time');
    ylabel(s(1),'WOR');
    
    plot(s(2),log(Time),log(WC)); 

    xlabel(s(2),'Time');
    ylabel(s(2),'WC');
   
    
    plot(s(3),log(Time),log(GOR)); 

    xlabel(s(3),'Time');
    ylabel(s(3),'GOR');

   
    plot(s(4),log(Time),log(OC)); 

    xlabel(s(4),'Time');
    ylabel(s(4),'OC');
    
    
    hold on

    hold off
    Frame_data{i} = getframe(h);
    saveas(h,pic_name);
    close(h);
    i=i+1;
    
    if mod(i,total_num_h)==0 || i ==total_num_i
        disp(['Saving FWOR/FGOR/FWC Time Plots--------',num2str(i/total_num_i*100),'% --------']);
    end
    
end

cd '../';

end