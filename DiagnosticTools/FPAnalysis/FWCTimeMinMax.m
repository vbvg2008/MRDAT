function case_data = FWCTimeMinMax(varargin)
%Determines gradient of WCR w.r.t. time.
%   Finds minima and maxima of the gradient and their locations.
%
%SYNOPSIS:
%   case_data = FWCTimeMinMax(case_data,plot_type,save_flag)
%
%DESCRIPTION:
%   This function determines gradient of WC w.r.t. time. 
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
   error('case_data must be the input of FWCTimeMinMax') ;
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
FWC_case_idx = 1:num_cases;
%well_list = fieldnames(case_data{1}.Tvar.Well);

%---------------------------------------------
%loop through all necessary cases
num_FWCcase = length(FWC_case_idx);
%num_well = length(well_list);
for i = 1:num_FWCcase
    case_idx = FWC_case_idx(i);

    xa = case_data{i}.Tvar.Time.cumt;
    ya = case_data{i}.DerivedData.Field.WC.data;
    
    if plot_type == 1 
        x = log(xa);
        y = log(ya);
        x(1) = -10.0;
        y(1) = 0.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

        %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdLTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdLTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdLTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdLTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdLTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdLTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdLTimemaxTime = xmax;']); 

    elseif plot_type == 2
        x = xa;
        y = ya;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdTimemaxTime = xmax;']); 

    elseif plot_type == 3
        x = xa;
        y = log(ya);
        y(1) = 0.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdTimemaxTime = xmax;']); 
        
    elseif plot_type == 4
        x = log(xa);
        y = ya;
        x(1) = -10.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdLTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdLTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdLTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdLTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdLTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdLTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdLTimemaxTime = xmax;']); 
        
    elseif plot_type == 5
        x = log(xa);
        y = log(ya);
        x(1) = -10.0;
        y(1) = 0.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

        %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdLTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdLTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdLTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdLTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdLTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdLTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdLTimemaxTime = xmax;']); 

        x = xa;
        y = ya;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdTimemaxTime = xmax;']); 

        x = xa;
        y = log(ya);
        y(1) = 0.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dLFWCdTimemaxTime = xmax;']); 
        
        x = log(xa);
        y = ya;
        x(1) = -10.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdLTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdLTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdLTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdLTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdLTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdLTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.WC.dFWCdLTimemaxTime = xmax;']); 
        
    end        
    
end

% Handle response
if save_flag==1
    choice = questdlg('Calculation Completed,Do you want to save Figures?','Calculation Completed','Yes','No','Yes');
% Handle response
    if strcmp(choice,'Yes')==1
        Frame_data=save_FWCplot(FWC_case_idx,plot_type,case_data);
    end
end

end


function Frame_data=save_FWCplot(FWC_case_idx,plot_type,case_data)  %generate plots and frame data
if ~exist('FWCTplot','dir')
    mkdir('FWCTplot');
end
cd 'FWCTplot';


%num_well = length(well_list);
num_required_cases = length(FWC_case_idx);
total_num_i = num_required_cases;
Frame_data = cell(total_num_i,1);
i = 1;
total_num_h = min(max(total_num_i/50,10),25);
for loop_idx = 1:num_required_cases
    case_idx = FWC_case_idx(loop_idx);
    Case_name = case_data{case_idx}.name;

    if plot_type == 1
        
        Time = case_data{case_idx}.Tvar.Time.cumt;
        TimeL = log(Time);
        WC = case_data{case_idx}.DerivedData.Field.WC.data;
        WCL = log(WC);
        dLFWCdLTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.WC','.dLFWCdLTime;']);
        dLFWCdLTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.WC','.dLFWCdLTimeminTime;']); 

        pic_name = [Case_name,'.png'];
        h = figure('visible','off');
        s(1) = subplot(2,1,1); % top subplot
        s(2) = subplot(2,1,2); % bottom subplot

        plot(s(1),TimeL,WCL); 

        xlabel(s(1),'Time');
        ylabel(s(1),'WC');

        plot(s(2),TimeL,dLFWCdLTime);

        xlabel(s(2),'Time');
        ylabel(s(2),'dFWCdTime');

    elseif plot_type == 2
            
        Time = case_data{case_idx}.Tvar.Time.cumt;
        WC = case_data{case_idx}.DerivedData.Field.WC.data;
        dFWCdTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.WC','.dFWCdTime;']);
        dFWCdTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.WC','.dFWCdTimeminTime;']); 

        pic_name = [Case_name,'.png'];
        h = figure('visible','off');
        s(1) = subplot(2,1,1); % top subplot
        s(2) = subplot(2,1,2); % bottom subplot

        plot(s(1),Time,WC); 

        xlabel(s(1),'Time');
        ylabel(s(1),'WC');

        plot(s(2),Time,dFWCdTime);

        xlabel(s(2),'Time');
        ylabel(s(2),'dFWCdTime');

    elseif plot_type == 3
            
        Time = case_data{case_idx}.Tvar.Time.cumt;
        WC = case_data{case_idx}.DerivedData.Field.WC.data;
        WCL = log(WC);
        dLFWCdTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.WC','.dLFWCdTime;']);
        dLFWCdTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.WC','.dLFWCdTimeminTime;']); 

        pic_name = [Case_name,'.png'];
        h = figure('visible','off');
        s(1) = subplot(2,1,1); % top subplot
        s(2) = subplot(2,1,2); % bottom subplot

        plot(s(1),Time,WCL); 

        xlabel(s(1),'Time');
        ylabel(s(1),'WC');

        plot(s(2),Time,dLFWCdLTime);

        xlabel(s(2),'Time');
        ylabel(s(2),'dFWCdTime');

    elseif plot_type == 4

        Time = case_data{case_idx}.Tvar.Time.cumt;
        TimeL = log(Time);
        WC = case_data{case_idx}.DerivedData.Field.WC.data;
        dFWCdLTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.WC','.dFWCdLTime;']);
        dFWCdLTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.WC','.dFWCdLTimeminTime;']); 

        pic_name = [Case_name,'.png'];
        h = figure('visible','off');
        s(1) = subplot(2,1,1); % top subplot
        s(2) = subplot(2,1,2); % bottom subplot

        plot(s(1),TimeL,WC); 

        xlabel(s(1),'Time');
        ylabel(s(1),'WC');

        plot(s(2),TimeL,dFWCdLTime);

        xlabel(s(2),'Time');
        ylabel(s(2),'dFWCdTime');

    elseif plot_type == 5

        Time = case_data{case_idx}.Tvar.Time.cumt;
        TimeL = log(Time);
        WC = case_data{case_idx}.DerivedData.Field.WC.data;
        WCL = log(WC);

        dLFWCdLTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.WC','.dLFWCdLTime;']);
        dLFWCdLTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.WC','.dLFWCdLTimeminTime;']); 
        
        dFWCdTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.WC','.dFWCdTime;']);
        dFWCdTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.WC','.dFWCdTimeminTime;']); 

        dLFWCdTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.WC','.dLFWCdTime;']);
        dLFWCdTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.WC','.dLFWCdTimeminTime;']); 

        dFWCdLTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.WC','.dFWCdLTime;']);
        dFWCdLTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.WC','.dFWCdLTimeminTime;']); 

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

        
        plot(s(1),TimeL,WCL); 

        xlabel(s(1),'Time');
        ylabel(s(1),'WC');

        plot(s(5),TimeL,dLFWCdLTime);

        xlabel(s(5),'Time');
        ylabel(s(5),'dFWCdTime');
 

        plot(s(2),Time,WC); 

        xlabel(s(2),'Time');
        ylabel(s(2),'WC');

        plot(s(6),Time,dFWCdTime);

        xlabel(s(6),'Time');
        ylabel(s(6),'dFWCdTime');

        
        plot(s(3),Time,WCL); 

        xlabel(s(3),'Time');
        ylabel(s(3),'WC');

        plot(s(7),Time,dLFWCdLTime);

        xlabel(s(7),'Time');
        ylabel(s(7),'dFWCdTime');
        
 
        plot(s(4),TimeL,WC); 

        xlabel(s(4),'Time');
        ylabel(s(4),'WC');

        plot(s(8),TimeL,dFWCdLTime);

        xlabel(s(8),'Time');
        ylabel(s(8),'dFWCdTime');
       
    end
 
        
    hold off
    Frame_data{i} = getframe(h);
    saveas(h,pic_name);
    close(h);
    i=i+1;
    
    if mod(i,total_num_h)==0 || i ==total_num_i
        disp(['Saving FWC Plots--------',num2str(i/total_num_i*100),'% --------']);
    end
    
end

cd '../';

end