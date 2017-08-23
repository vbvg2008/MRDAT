function case_data = FGORResVolMinMax(varargin)
%Determines gradient of GOR w.r.t. reservoir volume production cumulative
%   Finds minima and maxima of the gradient and their locations.
%
%SYNOPSIS:
%   case_data = FGORResVolMinMax(case_data,save_flag)
%
%DESCRIPTION:
%   This function determines gradient of GOR w.r.t. reservoir volume 
%   production cumulative. Also finds minima and maxima of the gradient  
%   and their locations.
%
%   Currently performing at field level
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%   save_flag - Flag to save plot files
%------------------------------------------------
%Initialization
num_inputs = length(varargin);

if isempty(varargin)==1
   error('case_data must be the input of FGORResVolMinMax') ;
elseif num_inputs==1
   case_data = varargin{1};    
   save_flag = true;
elseif num_inputs==2
   case_data = varargin{1};    
   save_flag = varargin{2};
else
   case_data = varargin{1};    
   save_flag = varargin{2};
end

num_cases = length(case_data);
FGOR_case_idx = 1:num_cases;
%well_list = fieldnames(case_data{1}.Tvar.Well);

%---------------------------------------------
%loop through all necessary cases
num_FGORcase = length(FGOR_case_idx);
%num_well = length(well_list);
for i = 1:num_FGORcase
    case_idx = FGOR_case_idx(i);

    x = case_data{i}.Tvar.Field.ReservoirVolumeProductionCumulative.data;
    y = case_data{i}.DerivedData.Field.GOR.data;

    [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

        %---------------------------------------------------------
    %Append into case_data
    eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdRVPC = dydx;']);
    eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdRVPCmin = dydxmin;']);
    eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdRVPCminID = idydxmin;']);
    eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdRVPCminRVPC = xmin;']);    
    eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdRVPCmax = dydxmax;']);
    eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdRVPCmaxID = idydxmax;']);
    eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdRVPCmaxRVPC = xmax;']); 
    
end

% Handle response
if save_flag==1
    choice = questdlg('Calculation Completed,Do you want to save Figures?','Calculation Completed','Yes','No','Yes');
% Handle response
    if strcmp(choice,'Yes')==1
        Frame_data=save_FGORplot(FGOR_case_idx,case_data);
    end
end

end


function Frame_data=save_FGORplot(FGOR_case_idx,case_data)  %generate plots and frame data
if ~exist('FGORplot','dir')
    mkdir('FGORplot');
end
cd 'FGORplot';


%num_well = length(well_list);
num_required_cases = length(FGOR_case_idx);
total_num_i = num_required_cases;
Frame_data = cell(total_num_i,1);
i = 1;
total_num_h = max(total_num_i/50,10);
for loop_idx = 1:num_required_cases
    case_idx = FGOR_case_idx(loop_idx);
    Case_name = case_data{case_idx}.name;

    RVPC = case_data{case_idx}.Tvar.Field.ReservoirVolumeProductionCumulative.data;
    GOR = case_data{case_idx}.DerivedData.Field.GOR.data;
    dFGORdRVPC = eval(['case_data{case_idx}.Diagnostics.FPA.Field.GOR','.dFGORdRVPC;']);
    dFGORdRVPCminRVPC = eval(['case_data{i}.Diagnostics.FPA.Field.GOR','.dFGORdRVPCminRVPC;']); 
    
    pic_name = [Case_name,'.png'];
    h = figure('visible','off');
    s(1) = subplot(2,1,1); % top subplot
    s(2) = subplot(2,1,2); % bottom subplot
    
    plot(s(1),RVPC,GOR); 

    xlabel(s(1),'Reservoir Volume Production Cumulative');
    ylabel(s(1),'GOR');
    
    plot(s(2),RVPC,dFGORdRVPC);

    xlabel(s(2),'Reservoir Volume Production Cumulative');
    ylabel(s(2),'dFGORdRVPC');

    hold on

    hold off
    Frame_data{i} = getframe(h);
    saveas(h,pic_name);
    close(h);
    i=i+1;
    
    if mod(i,total_num_h)==0 || i ==total_num_i
        disp(['Saving FGOR Plots--------',num2str(i/total_num_i*100),'% --------']);
    end
    
end

cd '../';

end