function case_data = MHA(Pe,case_data)
%Perform Water Injection MHA Analysis
%
%
%SYNOPSIS:
%   case_data = MHA(Pe,case_data)
%
%DESCRIPTION:
%   This function analyze the water injection MHA behavior and can also
%   generate/save plots, it also incorporates a built-in GUI which can be
%   used to modify the results.
%
%PARAMETERS:
%   Pe       - Character Array that shows the field of pressure at boundary
%
%   case_data - The general structure that stores all data in MRDAT
%------------------------------------------------
%Initialization
num_cases = length(case_data);
MHA_case_idx = 1:num_cases;
well_list = fieldnames(case_data{1}.Tvar.Well);

%---------------------------------------------
%loop through all necessary cases
num_MHAcase = length(MHA_case_idx);
num_well = length(well_list);
for i = 1:num_MHAcase
    case_idx = MHA_case_idx(i);
    delt = case_data{i}.Tvar.Time.delt;
    for well_index = 1:num_well
        %--------------------------------------
        %Calculating HI and DHI
        Well_name = well_list{well_index};
        Pe_field = ['case_data{case_idx}.',Pe{well_index}];
        P_av = eval(Pe_field);
        num_data = length(P_av);
        P_bhp = eval(['case_data{case_idx}.Tvar.Well.',Well_name,'.BottomHolePressure.data']);   %load the BHP data from well list
        WIC = eval(['case_data{case_idx}.Tvar.Well.',Well_name,'.WaterInjectionCumulative.data']);   %load the Water Injection data from well list
        LWIC = log(WIC);
        LWIC(find(WIC==0)) = nan;  %remove the -inf data from LWIC
        P_diff= P_bhp- P_av;    %difference pressure
        P_diff(find(P_diff<=0))=nan;    %remove non injection pressure

        P_diff_dt_product = P_diff.* delt;
        P_diff_dt_product(1) = P_diff(1);            
        HI = cumsum(P_diff_dt_product);
        DHI = zeros(num_data,1);
        DHI([1 num_data]) = nan;
        for i = 2: num_data-1
            result = (HI(i+1)-HI(i-1))/(LWIC(i+1)-LWIC(i-1));
            if isfinite(result) ==1
                DHI(i) = result;
            else
                 DHI(i) = nan;
            end
        end

        [departure_WIC,departure_HI,departure_DHI] = find_departure(WIC,HI,DHI);

        %---------------------------------------------------------
        %Append HI/DHI into case_data
        eval(['case_data{case_idx}.Diagnostics.MHA.',Well_name,'.HI = HI;']);
        eval(['case_data{case_idx}.Diagnostics.MHA.',Well_name,'.DHI = DHI;']);
        eval(['case_data{case_idx}.Diagnostics.MHA.',Well_name,'.DepWIC = departure_WIC;']);
        eval(['case_data{case_idx}.Diagnostics.MHA.',Well_name,'.DepHI = departure_HI;']);
        eval(['case_data{case_idx}.Diagnostics.MHA.',Well_name,'.DepDHI = departure_DHI;']);
    end
    
end
choice = questdlg('Auto-Pick Completed,Do you want to save Figures?','Auto-Pick Completed','Yes','No','Yes');
% Handle response
if strcmp(choice,'Yes')==1
    Frame_data=save_MHAplot(MHA_case_idx,well_list,case_data);
    choice1 = questdlg('Do you want to open MHA interface to review them?','MHA interface','Yes','No','Yes');
    if strcmp(choice1,'Yes')
        MHA_gui(case_data,Frame_data,'frame');
    end
end

end


function [departure_x,departure_y1,departure_y2] = find_departure(x,y1,y2)  %find departure points
warning('off','all');   %turn off warnings
max_x = range(x);
num_points = 1001;
last_one_percent_index = round(num_points*0.99);
x_itp = linspace(0,max_x,num_points); %divide x into smaller interval

%---------------------------------------------------------------------
%removes infinite data in the dataset and do the interpolation
finite_x1y1 = [x, y1];
y1_finite_idx = find(isfinite(y1)==0);
finite_x1y1(y1_finite_idx,:)=[];
non_increse_idx = find(diff(finite_x1y1(:,1))==0);
finite_x1y1(non_increse_idx+1,:)=[];
x1_finite = finite_x1y1(:,1);
y1_finite = finite_x1y1(:,2);

finite_x2y2 = [x, y2];
y2_finite_idx = find(isfinite(y2)==0);
finite_x2y2(y2_finite_idx,:)=[];
non_increse_idx = find(diff(finite_x2y2(:,1))==0);
finite_x2y2(non_increse_idx+1,:)=[];
x2_finite = finite_x2y2(:,1);
y2_finite = finite_x2y2(:,2);

y1_itp = interp1(x1_finite,y1_finite,x_itp,'pchip');
y2_itp = interp1(x2_finite,y2_finite,x_itp,'pchip');

%---------------------------------------------------------------------
%extract ranges and slope differences
weight = [350 150 250 7000];
pic_range = range(y1)*7/6;
difference = y2_itp-y1_itp;
rigorous_tolerance = pic_range/weight(1);
end_tolerance = pic_range/weight(2);
lenient_tolerance = pic_range/weight(3);
slope_tolerance = pic_range/weight(4);
slope_difference = [0,abs(diff(y2_itp)-diff(y1_itp))];

rigorous_violation_index = abs(difference)>rigorous_tolerance;
lenient_violation_index = abs(difference)>lenient_tolerance;
slope_violation_index = slope_difference > slope_tolerance;
end_violation_index = abs(difference) > end_tolerance;

rigorous_index = find(rigorous_violation_index==0);
if isempty(rigorous_index)==1  %if two lines are separate at the beginning
    departure_x = x_itp(1);
    departure_y1 = y1_itp(1);
    departure_y2 = y2_itp(1);
else
    end_index = find(end_violation_index==0);
    lenient_index = find(lenient_violation_index==0);
    if end_index(end) > last_one_percent_index     %if their difference at last is within lenient tolerance
        departure_x = x_itp(end_index(end));
        departure_y1 = y1_itp(end_index(end));
        departure_y2 = y2_itp(end_index(end));
    elseif  slope_violation_index(lenient_index(end))==0   %use linient tolerance within tolerance slope
        departure_x = x_itp(lenient_index(end));
        departure_y1 = y1_itp(lenient_index(end));
        departure_y2 = y2_itp(lenient_index(end));
    else    %otherwise, be rogorous
        departure_x = x_itp(rigorous_index(end));
        departure_y1 = y1_itp(rigorous_index(end));
        departure_y2 = y2_itp(rigorous_index(end));
    end
end

end

function Frame_data=save_MHAplot(MHA_case_idx,well_list,case_data)  %generate plots and frame data
mkdir('MHAplot');
cd 'MHAplot';

num_well = length(well_list);
num_required_cases = length(MHA_case_idx);
total_num_i = num_required_cases*num_well;
Frame_data = cell(total_num_i,1);
i = 1;
for loop_idx = 1:num_required_cases
    case_idx = MHA_case_idx(loop_idx);
    Case_name = case_data{case_idx}.name;
    for well_index = 1:num_well
        Well_name = well_list{well_index};
        HI = eval(['case_data{case_idx}.Diagnostics.MHA.',Well_name,'.HI;']);
        DHI = eval(['case_data{case_idx}.Diagnostics.MHA.',Well_name,'.DHI;']);
        WIC = eval(['case_data{case_idx}.Tvar.Well.',Well_name,'.WaterInjectionCumulative.data']); 
        departure_WIC = eval(['case_data{case_idx}.Diagnostics.MHA.',Well_name,'.DepWIC;']);
        departure_HI = eval(['case_data{case_idx}.Diagnostics.MHA.',Well_name,'.DepHI;']);
        departure_DHI = eval(['case_data{case_idx}.Diagnostics.MHA.',Well_name,'.DepDHI;']);
        pic_name = [Case_name,'_',Well_name,'.png'];
        h = figure('visible','off');
        plot(WIC,HI,WIC,DHI);
        axis([0 range(WIC)*7/6 0 range(HI)*7/6]);
        xlabel('Water Injection Cumulative');
        ylabel('HI/DHI');
        legend('HI','DHI');
        legend('boxoff')
        hold on
        scatter(departure_WIC,0.5*(departure_HI+departure_DHI),'filled');
        hold off
        Frame_data{i} = getframe(h);
        saveas(h,pic_name);
        close(h);
        i=i+1;
        if mod(i,10)==0 || i ==total_num_i
            disp(['Saving MHA Plots--------',num2str(i/total_num_i*100),'% --------']);
        end
    end
    
end

end



