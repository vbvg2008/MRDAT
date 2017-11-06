function case_data = OC(case_data)
% Calculte Oil cut 
%
% Last Update Date: 10/30/2017 
%
%SYNOPSIS:
%   case_data = OC(case_data)
%DESCRIPTION:
%   This function calculates oil cut from case data at field and well level
%
%PARAMETERS:
%   case_data: data structure that is used in MRDAT
%
%----------------------------------------------------------
num_cases = length(case_data);

% Field Oil Cut
for case_idx = 1: num_cases
    WaterRate = case_data{case_idx}.Tvar.Field.WaterProductionRate.data;
    OilRate = case_data{case_idx}.Tvar.Field.OilProductionRate.data;
    OC = OilRate./(OilRate + WaterRate);
    case_data{case_idx}.DerivedData.Field.OC.data= OC;
    OC_unit = 'STB/STB';
    case_data{case_idx}.DerivedData.Field.OC.unit= OC_unit;
    
    % List and number of wells
    well_list = fieldnames(case_data{case_idx}.Tvar.Well);
    num_wells = length(well_list);
    
    % Well Oil Cut
    for well_idx = 1: num_wells
        % Check if water and oil rate variables are available per well
        well_name = well_list{well_idx};
        well_Tvar_list = fieldnames(eval(['case_data{case_idx}.Tvar.Well.', well_name]));
        WaterRate_flag = contains(well_Tvar_list, 'WaterProductionRate');
        OilRate_flag = contains(well_Tvar_list, 'OilProductionRate');
        % Compute OC for each well
        if sum(WaterRate_flag)==1 && sum(OilRate_flag)==1
            WaterRate = eval(['case_data{case_idx}.Tvar.Well.',well_name, '.WaterProductionRate.data']);
            OilRate = eval(['case_data{case_idx}.Tvar.Well.',well_name, '.OilProductionRate.data']);
            OC = OilRate./(OilRate + WaterRate);
            eval(['case_data{case_idx}.DerivedData.Well.', well_name, '.OC.data= OC;']);
            OC_unit = 'STB/STB';
            eval(['case_data{case_idx}.DerivedData.Well.', well_name, '.OC.unit= OC_unit;']);
        end
    end
end

end

