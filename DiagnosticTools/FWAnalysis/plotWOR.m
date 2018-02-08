function plotWOR(case_data)

figure;
curveNum = 1;
num_cases = length(case_data);
for case_idx=1:5
    well_list = fieldnames(case_data{case_idx}.Tvar.Well);
    num_wells = length(well_list);
    % WBT by well
    for well_idx = 1: num_wells
        well_name = well_list{well_idx};
        if contains(well_name, 'PRO')
            WOR = eval(['case_data{case_idx,1}.DerivedData.Well.',well_name,'.WOR.data']);
            Time = case_data{case_idx,1}.Tvar.Time.cumt;
            TotalDaysIdx = length(Time);
            if WOR(TotalDaysIdx)>0
                loglog(Time, WOR);
                legendName{curveNum} = ([num2str(case_idx), '-',well_name]);
                hold on;
                curveNum = curveNum+1;
                WBT_days = eval(['case_data{case_idx,1}.Diagnostics.Well.', well_name, '.WaterBreakthrough.Time;']);
                disp(['Case: ', num2str(case_idx), ' - ', well_name, ' - WBT: ',num2str(WBT_days), ' days']);
            end      
        end
    end
end
xlabel('Time');
ylabel('WOR');
grid on;
legend(legendName);
end