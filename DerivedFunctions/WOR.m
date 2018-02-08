function case_data = WOR(case_data)
% Calculte Water Oil Ratio 
%
% Last Update Date: 11/06/2017 
%
%SYNOPSIS:
%   case_data = WOR(case_data)
%DESCRIPTION:
%   This function calculates WOR from case data at field and well level
%
%PARAMETERS:
%   case_data: data structure that is used in MRDAT
%
%----------------------------------------------------------
num_cases = length(case_data);

% Field Water-Oil Ratio 
for case_idx = 1: num_cases
    field_Tvar_list = fieldnames(case_data{case_idx}.Tvar.Field);
    FWaterRate_flag = contains(field_Tvar_list, 'WaterProductionRate');
    FOilRate_flag = contains(field_Tvar_list, 'OilProductionRate');
    if sum(FWaterRate_flag)==1 && sum(FOilRate_flag)==1        
        WaterRate = case_data{case_idx}.Tvar.Field.WaterProductionRate.data;
        OilRate = case_data{case_idx}.Tvar.Field.OilProductionRate.data;
        WOR = WaterRate./OilRate;
        case_data{case_idx}.DerivedData.Field.WOR.data= WOR;
        WOR_unit = 'STB/STB';
        case_data{case_idx}.DerivedData.Field.WOR.unit= WOR_unit;
    end
    
    % List and number of wells
    well_list = fieldnames(case_data{case_idx}.Tvar.Well);
    num_wells = length(well_list);
    
    % Well Water-Oil Ratio
    for well_idx = 1: num_wells
        % Check if water and oil rate variables are available per well
        well_name = well_list{well_idx};
        well_Tvar_list = fieldnames(eval(['case_data{case_idx}.Tvar.Well.', well_name]));
        WaterRate_flag = contains(well_Tvar_list, 'WaterProductionRate');
        OilRate_flag = contains(well_Tvar_list, 'OilProductionRate');
        % Compute WOR for each well
        if sum(WaterRate_flag)==1 && sum(OilRate_flag)==1
            WaterRate = eval(['case_data{case_idx}.Tvar.Well.',well_name, '.WaterProductionRate.data']);
            OilRate = eval(['case_data{case_idx}.Tvar.Well.',well_name, '.OilProductionRate.data']);
            WOR = WaterRate./OilRate;
            eval(['case_data{case_idx}.DerivedData.Well.', well_name, '.WOR.data= WOR;']);
            WOR_unit = 'STB/STB';
            eval(['case_data{case_idx}.DerivedData.Well.', well_name, '.WOR.unit= WOR_unit;']);
        end
    end
    
end

end
