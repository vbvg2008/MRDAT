function case_data = FGORTimeMinMax(varargin)
%Determines gradient of GOR w.r.t. time.
%   Finds minima and maxima of the gradient and their locations.
%
%SYNOPSIS:
%   case_data = FGORTimeMinMax(case_data,plot_type,save_flag)
%
%DESCRIPTION:
%   This function determines gradient of GOR w.r.t. time. 
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
   error('case_data must be the input of FGORResVolMinMax') ;
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
FGOR_case_idx = 1:num_cases;
%well_list = fieldnames(case_data{1}.Tvar.Well);

%---------------------------------------------
%loop through all necessary cases
num_FGORcase = length(FGOR_case_idx);
%num_well = length(well_list);
for i = 1:num_FGORcase
    case_idx = FGOR_case_idx(i);

    xa = case_data{i}.Tvar.Time.cumt;
    ya = case_data{i}.DerivedData.Field.GOR.data;
    
    if plot_type == 1 
        x = log(xa);
        y = log(ya);
        x(1) = -10.0;
        y(1) = 0.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

        %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdLTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdLTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdLTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdLTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdLTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdLTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdLTimemaxTime = xmax;']); 

    elseif plot_type == 2
        x = xa;
        y = ya;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdTimemaxTime = xmax;']); 

    elseif plot_type == 3
        x = xa;
        y = log(ya);
        y(1) = 0.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdTimemaxTime = xmax;']); 
        
    elseif plot_type == 4
        x = log(xa);
        y = ya;
        x(1) = -10.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdLTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdLTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdLTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdLTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdLTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdLTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdLTimemaxTime = xmax;']); 
        
    elseif plot_type == 5
        x = log(xa);
        y = log(ya);
        x(1) = -10.0;
        y(1) = 0.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

        %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdLTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdLTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdLTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdLTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdLTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdLTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdLTimemaxTime = xmax;']); 

        x = xa;
        y = ya;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdTimemaxTime = xmax;']); 

        x = xa;
        y = log(ya);
        y(1) = 0.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dLFGORdTimemaxTime = xmax;']); 
        
        x = log(xa);
        y = ya;
        x(1) = -10.0;

        [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

            %---------------------------------------------------------
        %Append into case_data
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdLTime = dydx;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdLTimemin = dydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdLTimeminID = idydxmin;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdLTimeminTime = xmin;']);    
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdLTimemax = dydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdLTimemaxID = idydxmax;']);
        eval(['case_data{i}.Diagnostics.FPA.Field','.GOR.dFGORdLTimemaxTime = xmax;']); 
        
    end        
    
end

% Handle response
if save_flag==1
    choice = questdlg('Calculation Completed,Do you want to save Figures?','Calculation Completed','Yes','No','Yes');
% Handle response
    if strcmp(choice,'Yes')==1
        Frame_data=save_FGORplot(FGOR_case_idx,plot_type,case_data);
    end
end

end


function Frame_data=save_FGORplot(FGOR_case_idx,plot_type,case_data)  %generate plots and frame data
if ~exist('FGORTplot','dir')
    mkdir('FGORTplot');
end
cd 'FGORTplot';


%num_well = length(well_list);
num_required_cases = length(FGOR_case_idx);
total_num_i = num_required_cases;
Frame_data = cell(total_num_i,1);
i = 1;
total_num_h = min(max(total_num_i/50,10),25);
for loop_idx = 1:num_required_cases
    case_idx = FGOR_case_idx(loop_idx);
    Case_name = case_data{case_idx}.name;

    if plot_type == 1
        
        Time = case_data{case_idx}.Tvar.Time.cumt;
        TimeL = log(Time);
        GOR = case_data{case_idx}.DerivedData.Field.GOR.data;
        GORL = log(GOR);
        dLFGORdLTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.GOR','.dLFGORdLTime;']);
        dLFGORdLTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.GOR','.dLFGORdLTimeminTime;']); 

        pic_name = [Case_name,'.png'];
        h = figure('visible','off');
        s(1) = subplot(2,1,1); % top subplot
        s(2) = subplot(2,1,2); % bottom subplot

        plot(s(1),TimeL,GORL); 

        xlabel(s(1),'Time');
        ylabel(s(1),'GOR');

        plot(s(2),TimeL,dLFGORdLTime);

        xlabel(s(2),'Time');
        ylabel(s(2),'dFGORdTime');

    elseif plot_type == 2
            
        Time = case_data{case_idx}.Tvar.Time.cumt;
        GOR = case_data{case_idx}.DerivedData.Field.GOR.data;
        dFGORdTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.GOR','.dFGORdTime;']);
        dFGORdTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.GOR','.dFGORdTimeminTime;']); 

        pic_name = [Case_name,'.png'];
        h = figure('visible','off');
        s(1) = subplot(2,1,1); % top subplot
        s(2) = subplot(2,1,2); % bottom subplot

        plot(s(1),Time,GOR); 

        xlabel(s(1),'Time');
        ylabel(s(1),'GOR');

        plot(s(2),Time,dFGORdTime);

        xlabel(s(2),'Time');
        ylabel(s(2),'dFGORdTime');

    elseif plot_type == 3
            
        Time = case_data{case_idx}.Tvar.Time.cumt;
        GOR = case_data{case_idx}.DerivedData.Field.GOR.data;
        GORL = log(GOR);
        dLFGORdTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.GOR','.dLFGORdTime;']);
        dLFGORdTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.GOR','.dLFGORdTimeminTime;']); 

        pic_name = [Case_name,'.png'];
        h = figure('visible','off');
        s(1) = subplot(2,1,1); % top subplot
        s(2) = subplot(2,1,2); % bottom subplot

        plot(s(1),Time,GORL); 

        xlabel(s(1),'Time');
        ylabel(s(1),'GOR');

        plot(s(2),Time,dLFGORdLTime);

        xlabel(s(2),'Time');
        ylabel(s(2),'dFGORdTime');

    elseif plot_type == 4

        Time = case_data{case_idx}.Tvar.Time.cumt;
        TimeL = log(Time);
        GOR = case_data{case_idx}.DerivedData.Field.GOR.data;
        dFGORdLTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.GOR','.dFGORdLTime;']);
        dFGORdLTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.GOR','.dFGORdLTimeminTime;']); 

        pic_name = [Case_name,'.png'];
        h = figure('visible','off');
        s(1) = subplot(2,1,1); % top subplot
        s(2) = subplot(2,1,2); % bottom subplot

        plot(s(1),TimeL,GOR); 

        xlabel(s(1),'Time');
        ylabel(s(1),'GOR');

        plot(s(2),TimeL,dFGORdLTime);

        xlabel(s(2),'Time');
        ylabel(s(2),'dFGORdTime');

    elseif plot_type == 5

        Time = case_data{case_idx}.Tvar.Time.cumt;
        TimeL = log(Time);
        GOR = case_data{case_idx}.DerivedData.Field.GOR.data;
        GORL = log(GOR);

        dLFGORdLTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.GOR','.dLFGORdLTime;']);
        dLFGORdLTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.GOR','.dLFGORdLTimeminTime;']); 
        
        dFGORdTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.GOR','.dFGORdTime;']);
        dFGORdTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.GOR','.dFGORdTimeminTime;']); 

        dLFGORdTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.GOR','.dLFGORdTime;']);
        dLFGORdTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.GOR','.dLFGORdTimeminTime;']); 

        dFGORdLTime = eval(['case_data{case_idx}.Diagnostics.FPA.Field.GOR','.dFGORdLTime;']);
        dFGORdLTimeminTime = eval(['case_data{i}.Diagnostics.FPA.Field.GOR','.dFGORdLTimeminTime;']); 

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

        
        plot(s(1),TimeL,GORL); 

        xlabel(s(1),'Time');
        ylabel(s(1),'GOR');

        plot(s(5),TimeL,dLFGORdLTime);

        xlabel(s(5),'Time');
        ylabel(s(5),'dFGORdTime');
 

        plot(s(2),Time,GOR); 

        xlabel(s(2),'Time');
        ylabel(s(2),'GOR');

        plot(s(6),Time,dFGORdTime);

        xlabel(s(6),'Time');
        ylabel(s(6),'dFGORdTime');

        
        plot(s(3),Time,GORL); 

        xlabel(s(3),'Time');
        ylabel(s(3),'GOR');

        plot(s(7),Time,dLFGORdLTime);

        xlabel(s(7),'Time');
        ylabel(s(7),'dFGORdTime');
        
 
        plot(s(4),TimeL,GOR); 

        xlabel(s(4),'Time');
        ylabel(s(4),'GOR');

        plot(s(8),TimeL,dFGORdLTime);

        xlabel(s(8),'Time');
        ylabel(s(8),'dFGORdTime');
       
    end
 
        
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