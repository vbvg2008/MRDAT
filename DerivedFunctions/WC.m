function case_data = WC(case_data)
% Calculte Water cut 
%
% Last Update Date: 10/30/2017 
%
%SYNOPSIS:
%   case_data = WC(case_data)
%DESCRIPTION:
%   This function calculates water cut from case data at field and well
%   level
%
%PARAMETERS:
%   case_data: data structure that is used in MRDAT
%
%----------------------------------------------------------
num_cases = length(case_data);

% Field Water Cut
for case_idx = 1: num_cases
    WaterRate = case_data{case_idx}.Tvar.Field.WaterProductionRate.data;
    OilRate = case_data{case_idx}.Tvar.Field.OilProductionRate.data;
    WC = WaterRate./(OilRate + WaterRate);
    case_data{case_idx}.DerivedData.Field.WC.data= WC;
    WC_unit = 'STB/STB';
    case_data{case_idx}.DerivedData.Field.WC.unit= WC_unit;
    
    % List and number of wells
    well_list = fieldnames(case_data{case_idx}.Tvar.Well);
    num_wells = length(well_list);
    
    % Well Water Cut
    for well_idx = 1: num_wells
        % Check if water and oil rate variables are available per well
        well_name = well_list{well_idx};
        well_Tvar_list = fieldnames(eval(['case_data{case_idx}.Tvar.Well.', well_name]));
        WaterRate_flag = contains(well_Tvar_list, 'WaterProductionRate');
        OilRate_flag = contains(well_Tvar_list, 'OilProductionRate');
        % Compute WC for each well
        if sum(WaterRate_flag)==1 && sum(OilRate_flag)==1
            WaterRate = eval(['case_data{case_idx}.Tvar.Well.',well_name, '.WaterProductionRate.data']);
            OilRate = eval(['case_data{case_idx}.Tvar.Well.',well_name, '.OilProductionRate.data']);
            WC = WaterRate./(OilRate + WaterRate);
            eval(['case_data{case_idx}.DerivedData.Well.', well_name, '.WC.data= WC;']);
            WC_unit = 'STB/STB';
            eval(['case_data{case_idx}.DerivedData.Well.', well_name, '.WC.unit= WC_unit;']);
        end
    end    
    
end

end

