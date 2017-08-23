function case_data = FWORTimeMinMax(varargin)
%Determines gradient of WOR w.r.t. time.
%   Finds minima and maxima of the gradient and their locations.
%
%SYNOPSIS:
%   case_data = FWORTimeMinMax(case_data,plot_type,save_flag)
%
%DESCRIPTION:
%   This function determines gradient of WOR w.r.t. time. 
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
   error('case_data must be the input of FWORTimeMinMax') ;
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
FWOR_case_idx = 1:num_cases;
%well_list = fieldnames(case_data{1}.Tvar.Well);

%---------------------------------------------
%loop through all necessary cases
num_FWORcase = length(FWOR_case_idx);
%num_well = length(well_list);
for i = 1:num_FWORcase
    case_idx = FWOR_case_idx(i);

    xa = case_data{i}.Tvar.Time.cumt;
    ya = case_data{i}.DerivedData.Field.WOR.data;
    
    if plot_type == 1 
        x = log(xa);
        y = log(ya);
        x(1) = -10.0;
        y(1) = 0.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

        %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdLTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdLTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdLTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdLTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdLTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdLTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdLTimemaxTime = xmax;']); 

    elseif plot_type == 2
        x = xa;
        y = ya;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdTimemaxTime = xmax;']); 

    elseif plot_type == 3
        x = xa;
        y = log(ya);
        y(1) = 0.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdTimemaxTime = xmax;']); 
        
    elseif plot_type == 4
        x = log(xa);
        y = ya;
        x(1) = -10.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdLTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdLTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdLTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdLTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdLTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdLTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdLTimemaxTime = xmax;']); 
        
    elseif plot_type == 5
        x = log(xa);
        y = log(ya);
        x(1) = -10.0;
        y(1) = 0.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

        %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdLTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdLTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdLTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdLTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdLTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdLTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdLTimemaxTime = xmax;']); 

        x = xa;
        y = ya;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdTimemaxTime = xmax;']); 

        x = xa;
        y = log(ya);
        y(1) = 0.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dLFWORdTimemaxTime = xmax;']); 
        
        x = log(xa);
        y = ya;
        x(1) = -10.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdLTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdLTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdLTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdLTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdLTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdLTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WOR.dFWORdLTimemaxTime = xmax;']); 
        
    end        
    
end

% Handle response
if save_flag==1
    choice = questdlg('Calculation Completed,Do you want to save Figures?','Calculation Completed','Yes','No','Yes');
% Handle response
    if strcmp(choice,'Yes')==1
        Frame_data=save_FWORplot(FWOR_case_idx,plot_type,case_data);
    end
end

end


function Frame_data=save_FWORplot(FWOR_case_idx,plot_type,case_data)  %generate plots and frame data
if ~exist('FWORTplot','dir')
    mkdir('FWORTplot');
end
cd 'FWORTplot';


%num_well = length(well_list);
num_required_cases = length(FWOR_case_idx);
total_num_i = num_required_cases;
Frame_data = cell(total_num_i,1);
i = 1;
total_num_h = min(max(total_num_i/50,10),25);
for loop_idx = 1:num_required_cases
    case_idx = FWOR_case_idx(loop_idx);
    Case_name = case_data{case_idx}.name;

    if plot_type == 1
        
        Time = case_data{case_idx}.Tvar.Time.cumt;
        TimeL = log(Time);
        WOR = case_data{case_idx}.DerivedData.Field.WOR.data;
        WORL = log(WOR);
        dLFWORdLTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.WOR','.dLFWORdLTime;']);
        dLFWORdLTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.WOR','.dLFWORdLTimeminTime;']); 

        pic_name = [Case_name,'.png'];
        h = figure('visible','off');
        s(1) = subplot(2,1,1); % top subplot
        s(2) = subplot(2,1,2); % bottom subplot

        plot(s(1),TimeL,WORL); 

        xlabel(s(1),'Time');
        ylabel(s(1),'WOR');

        plot(s(2),TimeL,dLFWORdLTime);

        xlabel(s(2),'Time');
        ylabel(s(2),'dFWORdTime');

    elseif plot_type == 2
            
        Time = case_data{case_idx}.Tvar.Time.cumt;
        WOR = case_data{case_idx}.DerivedData.Field.WOR.data;
        dFWORdTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.WOR','.dFWORdTime;']);
        dFWORdTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.WOR','.dFWORdTimeminTime;']); 

        pic_name = [Case_name,'.png'];
        h = figure('visible','off');
        s(1) = subplot(2,1,1); % top subplot
        s(2) = subplot(2,1,2); % bottom subplot

        plot(s(1),Time,WOR); 

        xlabel(s(1),'Time');
        ylabel(s(1),'WOR');

        plot(s(2),Time,dFWORdTime);

        xlabel(s(2),'Time');
        ylabel(s(2),'dFWORdTime');

    elseif plot_type == 3
            
        Time = case_data{case_idx}.Tvar.Time.cumt;
        WOR = case_data{case_idx}.DerivedData.Field.WOR.data;
        WORL = log(WOR);
        dLFWORdTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.WOR','.dLFWORdTime;']);
        dLFWORdTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.WOR','.dLFWORdTimeminTime;']); 

        pic_name = [Case_name,'.png'];
        h = figure('visible','off');
        s(1) = subplot(2,1,1); % top subplot
        s(2) = subplot(2,1,2); % bottom subplot

        plot(s(1),Time,WORL); 

        xlabel(s(1),'Time');
        ylabel(s(1),'WOR');

        plot(s(2),Time,dLFWORdLTime);

        xlabel(s(2),'Time');
        ylabel(s(2),'dFWORdTime');

    elseif plot_type == 4

        Time = case_data{case_idx}.Tvar.Time.cumt;
        TimeL = log(Time);
        WOR = case_data{case_idx}.DerivedData.Field.WOR.data;
        dFWORdLTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.WOR','.dFWORdLTime;']);
        dFWORdLTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.WOR','.dFWORdLTimeminTime;']); 

        pic_name = [Case_name,'.png'];
        h = figure('visible','off');
        s(1) = subplot(2,1,1); % top subplot
        s(2) = subplot(2,1,2); % bottom subplot

        plot(s(1),TimeL,WOR); 

        xlabel(s(1),'Time');
        ylabel(s(1),'WOR');

        plot(s(2),TimeL,dFWORdLTime);

        xlabel(s(2),'Time');
        ylabel(s(2),'dFWORdTime');

    elseif plot_type == 5

        Time = case_data{case_idx}.Tvar.Time.cumt;
        TimeL = log(Time);
        WOR = case_data{case_idx}.DerivedData.Field.WOR.data;
        WORL = log(WOR);

        dLFWORdLTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.WOR','.dLFWORdLTime;']);
        dLFWORdLTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.WOR','.dLFWORdLTimeminTime;']); 
        
        dFWORdTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.WOR','.dFWORdTime;']);
        dFWORdTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.WOR','.dFWORdTimeminTime;']); 

        dLFWORdTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.WOR','.dLFWORdTime;']);
        dLFWORdTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.WOR','.dLFWORdTimeminTime;']); 

        dFWORdLTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.WOR','.dFWORdLTime;']);
        dFWORdLTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.WOR','.dFWORdLTimeminTime;']); 

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

        
        plot(s(1),TimeL,WORL); 

        xlabel(s(1),'Time');
        ylabel(s(1),'WOR');

        plot(s(5),TimeL,dLFWORdLTime);

        xlabel(s(5),'Time');
        ylabel(s(5),'dFWORdTime');
 

        plot(s(2),Time,WOR); 

        xlabel(s(2),'Time');
        ylabel(s(2),'WOR');

        plot(s(6),Time,dFWORdTime);

        xlabel(s(6),'Time');
        ylabel(s(6),'dFWORdTime');

        
        plot(s(3),Time,WORL); 

        xlabel(s(3),'Time');
        ylabel(s(3),'WOR');

        plot(s(7),Time,dLFWORdLTime);

        xlabel(s(7),'Time');
        ylabel(s(7),'dFWORdTime');
        
 
        plot(s(4),TimeL,WOR); 

        xlabel(s(4),'Time');
        ylabel(s(4),'WOR');

        plot(s(8),TimeL,dFWORdLTime);

        xlabel(s(8),'Time');
        ylabel(s(8),'dFWORdTime');
       
    end
 
        
    hold off
    Frame_data{i} = getframe(h);
    saveas(h,pic_name);
    close(h);
    i=i+1;
    
    if mod(i,total_num_h)==0 || i ==total_num_i
        disp(['Saving FWOR Plots--------',num2str(i/total_num_i*100),'% --------']);
    end
    
end

cd '../';

end