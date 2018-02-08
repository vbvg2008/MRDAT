function case_data = GOR(case_data)
% Calculte Gas Oil Ratio
%
% Last Update Date: 11/06/2017 
%
%SYNOPSIS:
%   case_data = GOR(case_data)
%DESCRIPTION:
%   This function calculates GOR from case data at field and well level
%
%PARAMETERS:
%   case_data: data structure that is used in MRDAT
%
%----------------------------------------------------------
num_cases = length(case_data);

% Field Gas-Oil Ratio
for case_idx = 1: num_cases
    field_Tvar_list = fieldnames(case_data{case_idx}.Tvar.Field);
    FGasRate_flag = contains(field_Tvar_list, 'GasProductionRate');
    FOilRate_flag = contains(field_Tvar_list, 'OilProductionRate');
    if sum(FGasRate_flag)==1 && sum(FOilRate_flag)==1
        GasRate = case_data{case_idx}.Tvar.Field.GasProductionRate.data;
        OilRate = case_data{case_idx}.Tvar.Field.OilProductionRate.data;
        GOR = GasRate./OilRate;
        case_data{case_idx}.DerivedData.Field.GOR.data= GOR;
        GOR_unit = 'MSCF/STB';
        case_data{case_idx}.DerivedData.Field.GOR.unit= GOR_unit;
    end
    
    % List and number of wells
    well_list = fieldnames(case_data{case_idx}.Tvar.Well);
    num_wells = length(well_list);
       
    % Well Gas-Oil Ratio
    for well_idx = 1: num_wells
        % Check if gas and oil rate variables are available per well
        well_name = well_list{well_idx};
        well_Tvar_list = fieldnames(eval(['case_data{case_idx}.Tvar.Well.', well_name]));
        GasRate_flag = contains(well_Tvar_list, 'GasProductionRate');
        OilRate_flag = contains(well_Tvar_list, 'OilProductionRate');
        % Compute GOR for each well
        if sum(GasRate_flag)==1 && sum(OilRate_flag)==1
            GasRate = eval(['case_data{case_idx}.Tvar.Well.',well_name, '.GasProductionRate.data']);
            OilRate = eval(['case_data{case_idx}.Tvar.Well.',well_name, '.OilProductionRate.data']);
            GOR = GasRate./OilRate;
            eval(['case_data{case_idx}.DerivedData.Well.', well_name, '.GOR.data= GOR;']);
            GOR_unit = 'MSCF/STB';
            eval(['case_data{case_idx}.DerivedData.Well.', well_name, '.GOR.unit= GOR_unit;']);
        end
    end
    
end

end
