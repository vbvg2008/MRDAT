function case_data = FOCTimeMinMax(varargin)
%Determines gradient of OC w.r.t. time.
%   Finds minima and maxima of the gradient and their locations.
%
%SYNOPSIS:
%   case_data = FOCTimeMinMax(case_data,plot_type,save_flag)
%
%DESCRIPTION:
%   This function determines gradient of OC w.r.t. time. 
%   Also finds minima and maxima of the gradient and their locations.
%
%   Currently performing at field level
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%   plot_type - Flag for plot types
%               1 - log-log (default)
%               2 - cartesian-cartesian
%               3 - cartesian-log
%               4 - log-cartesian
%               5 - all above
%
%   save_flag - Flag to save plot files
%------------------------------------------------
%Initialization
num_inputs = length(varargin);

if isempty(varargin)==1
   error('case_data must be the input of FOCTimeMinMax') ;
elseif num_inputs==1
   case_data = varargin{1};    
   plot_type = 1;
   save_flag = true;
elseif num_inputs==2
   case_data = varargin{1};    
   plot_type = varargin{2};
   save_flag = true;   
else
   case_data = varargin{1};
   plot_type = varargin{2};   
   save_flag = varargin{3};
end

num_cases = length(case_data);
FOC_case_idx = 1:num_cases;
%well_list = fieldnames(case_data{1}.Tvar.Well);

%---------------------------------------------
%loop through all necessary cases
num_FOCcase = length(FOC_case_idx);
%num_well = length(well_list);
for i = 1:num_FOCcase
    case_idx = FOC_case_idx(i);

    xa = case_data{i}.Tvar.Time.cumt;
    ya = case_data{i}.DerivedData.Field.OC.data;
    
    if plot_type == 1 
        x = log(xa);
        y = log(ya);
        x(1) = -10.0;
        y(1) = 0.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

        %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdLTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdLTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdLTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdLTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdLTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdLTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdLTimemaxTime = xmax;']); 

    elseif plot_type == 2
        x = xa;
        y = ya;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdTimemaxTime = xmax;']); 

    elseif plot_type == 3
        x = xa;
        y = log(ya);
        y(1) = 0.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdTimemaxTime = xmax;']); 
        
    elseif plot_type == 4
        x = log(xa);
        y = ya;
        x(1) = -10.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdLTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdLTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdLTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdLTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdLTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdLTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdLTimemaxTime = xmax;']); 
        
    elseif plot_type == 5
        x = log(xa);
        y = log(ya);
        x(1) = -10.0;
        y(1) = 0.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

        %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdLTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdLTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdLTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdLTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdLTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdLTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdLTimemaxTime = xmax;']); 

        x = xa;
        y = ya;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdTimemaxTime = xmax;']); 

        x = xa;
        y = log(ya);
        y(1) = 0.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dLFOCdTimemaxTime = xmax;']); 
        
        x = log(xa);
        y = ya;
        x(1) = -10.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdLTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdLTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdLTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdLTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdLTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdLTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.OC.dFOCdLTimemaxTime = xmax;']); 
        
    end        
    
end

% Handle response
if save_flag==1
    choice = questdlg('Calculation Completed,Do you want to save Figures?','Calculation Completed','Yes','No','Yes');
% Handle response
    if strcmp(choice,'Yes')==1
        Frame_data=save_FOCplot(FOC_case_idx,plot_type,case_data);
    end
end

end


function Frame_data=save_FOCplot(FOC_case_idx,plot_type,case_data)  %generate plots and frame data
if ~exist('FOCTplot','dir')
    mkdir('FOCTplot');
end
cd 'FOCTplot';


%num_well = length(well_list);
num_required_cases = length(FOC_case_idx);
total_num_i = num_required_cases;
Frame_data = cell(total_num_i,1);
i = 1;
total_num_h = min(max(total_num_i/50,10),25);
for loop_idx = 1:num_required_cases
    case_idx = FOC_case_idx(loop_idx);
    Case_name = case_data{case_idx}.name;

    if plot_type == 1
        
        Time = case_data{case_idx}.Tvar.Time.cumt;
        TimeL = log(Time);
        OC = case_data{case_idx}.DerivedData.Field.OC.data;
        OCL = log(OC);
        dLFOCdLTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.OC','.dLFOCdLTime;']);
        dLFOCdLTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.OC','.dLFOCdLTimeminTime;']); 

        pic_name = [Case_name,'.png'];
        h = figure('visible','off');
        s(1) = subplot(2,1,1); % top subplot
        s(2) = subplot(2,1,2); % bottom subplot

        plot(s(1),TimeL,OCL); 

        xlabel(s(1),'Time');
        ylabel(s(1),'OC');

        plot(s(2),TimeL,dLFOCdLTime);

        xlabel(s(2),'Time');
        ylabel(s(2),'dFOCdTime');

    elseif plot_type == 2
            
        Time = case_data{case_idx}.Tvar.Time.cumt;
        OC = case_data{case_idx}.DerivedData.Field.OC.data;
        dFOCdTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.OC','.dFOCdTime;']);
        dFOCdTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.OC','.dFOCdTimeminTime;']); 

        pic_name = [Case_name,'.png'];
        h = figure('visible','off');
        s(1) = subplot(2,1,1); % top subplot
        s(2) = subplot(2,1,2); % bottom subplot

        plot(s(1),Time,OC); 

        xlabel(s(1),'Time');
        ylabel(s(1),'OC');

        plot(s(2),Time,dFOCdTime);

        xlabel(s(2),'Time');
        ylabel(s(2),'dFOCdTime');

    elseif plot_type == 3
            
        Time = case_data{case_idx}.Tvar.Time.cumt;
        OC = case_data{case_idx}.DerivedData.Field.OC.data;
        OCL = log(OC);
        dLFOCdTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.OC','.dLFOCdTime;']);
        dLFOCdTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.OC','.dLFOCdTimeminTime;']); 

        pic_name = [Case_name,'.png'];
        h = figure('visible','off');
        s(1) = subplot(2,1,1); % top subplot
        s(2) = subplot(2,1,2); % bottom subplot

        plot(s(1),Time,OCL); 

        xlabel(s(1),'Time');
        ylabel(s(1),'OC');

        plot(s(2),Time,dLFOCdLTime);

        xlabel(s(2),'Time');
        ylabel(s(2),'dFOCdTime');

    elseif plot_type == 4

        Time = case_data{case_idx}.Tvar.Time.cumt;
        TimeL = log(Time);
        OC = case_data{case_idx}.DerivedData.Field.OC.data;
        dFOCdLTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.OC','.dFOCdLTime;']);
        dFOCdLTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.OC','.dFOCdLTimeminTime;']); 

        pic_name = [Case_name,'.png'];
        h = figure('visible','off');
        s(1) = subplot(2,1,1); % top subplot
        s(2) = subplot(2,1,2); % bottom subplot

        plot(s(1),TimeL,OC); 

        xlabel(s(1),'Time');
        ylabel(s(1),'OC');

        plot(s(2),TimeL,dFOCdLTime);

        xlabel(s(2),'Time');
        ylabel(s(2),'dFOCdTime');

    elseif plot_type == 5

        Time = case_data{case_idx}.Tvar.Time.cumt;
        TimeL = log(Time);
        OC = case_data{case_idx}.DerivedData.Field.OC.data;
        OCL = log(OC);

        dLFOCdLTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.OC','.dLFOCdLTime;']);
        dLFOCdLTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.OC','.dLFOCdLTimeminTime;']); 
        
        dFOCdTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.OC','.dFOCdTime;']);
        dFOCdTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.OC','.dFOCdTimeminTime;']); 

        dLFOCdTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.OC','.dLFOCdTime;']);
        dLFOCdTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.OC','.dLFOCdTimeminTime;']); 

        dFOCdLTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.OC','.dFOCdLTime;']);
        dFOCdLTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.OC','.dFOCdLTimeminTime;']); 

        pic_name = [Case_name,'.png'];
        h = figure('visible','off');
        s(1) = subplot(2,4,1); % top subplot
        s(2) = subplot(2,4,2); % bottom subplot
        s(3) = subplot(2,4,3); % top subplot
        s(4) = subplot(2,4,4); % bottom subplot
        s(5) = subplot(2,4,5); % top subplot
        s(6) = subplot(2,4,6); % bottom subplot
        s(7) = subplot(2,4,7); % top subplot
        s(8) = subplot(2,4,8); % bottom subplot

        
        plot(s(1),TimeL,OCL); 

        xlabel(s(1),'Time');
        ylabel(s(1),'OC');

        plot(s(5),TimeL,dLFOCdLTime);

        xlabel(s(5),'Time');
        ylabel(s(5),'dFOCdTime');
 

        plot(s(2),Time,OC); 

        xlabel(s(2),'Time');
        ylabel(s(2),'OC');

        plot(s(6),Time,dFOCdTime);

        xlabel(s(6),'Time');
        ylabel(s(6),'dFOCdTime');

        
        plot(s(3),Time,OCL); 

        xlabel(s(3),'Time');
        ylabel(s(3),'OC');

        plot(s(7),Time,dLFOCdLTime);

        xlabel(s(7),'Time');
        ylabel(s(7),'dFOCdTime');
        
 
        plot(s(4),TimeL,OC); 

        xlabel(s(4),'Time');
        ylabel(s(4),'OC');

        plot(s(8),TimeL,dFOCdLTime);

        xlabel(s(8),'Time');
        ylabel(s(8),'dFOCdTime');
       
    end
 
        
    hold off
    Frame_data{i} = getframe(h);
    saveas(h,pic_name);
    close(h);
    i=i+1;
    
    if mod(i,total_num_h)==0 || i ==total_num_i
        disp(['Saving FOC Plots--------',num2str(i/total_num_i*100),'% --------']);
    end
    
end

cd '../';

end