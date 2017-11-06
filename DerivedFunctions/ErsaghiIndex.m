function case_data = ErsaghiIndex(case_data)
% Calculte Ersaghi Index 
%
% Last Update Date: 10/30/2017 
%
%SYNOPSIS:
%   case_data = ErsaghiIndex(case_data)
%DESCRIPTION:
%   This function calculates ErsaghiIndex from case data at field and well
%   level
%
%PARAMETERS:
%   case_data: data structure that is used in MRDAT
%
%----------------------------------------------------------
num_cases = length(case_data);

% Field Ersaghi Index
for case_idx = 1: num_cases
    fw = case_data{case_idx}.DerivedData.Field.WC.data;
    ErsaghiId = log((1./fw)-1)-(1./fw);
    case_data{case_idx}.DerivedData.Field.ErsaghiId.data= ErsaghiId;
    ErsaghiId_unit = 'Unitless';
    case_data{case_idx}.DerivedData.Field.ErsaghiId.unit= ErsaghiId_unit;
    
    % List and number of wells
    well_list = fieldnames(case_data{case_idx}.Tvar.Well);
    num_wells = length(well_list);
    
    % Well Ersaghi Index
    for well_idx = 1: num_wells
        % Check if water cut variable is available per well
        well_name = well_list{well_idx};
        well_Tvar_list = fieldnames(eval(['case_data{case_idx}.DerivedData.Well.', well_name]));
        WaterCut_flag = contains(well_Tvar_list, 'WC');
        % Compute Ersaghi Index for each well
        if sum(WaterCut_flag)==1
            fw = eval(['case_data{case_idx}.DerivedData.Well.',well_name, '.WC.data']);
            ErsaghiId = log((1./fw)-1)-(1./fw);
            eval(['case_data{case_idx}.DerivedData.Well.', well_name, '.ErsaghiId.data= ErsaghiId;']);
            ErsaghiId_unit = 'Unitless';
            eval(['case_data{case_idx}.DerivedData.Well.', well_name, '.ErsaghiId.unit= ErsaghiId_unit;']);
        end
    end
       
end

end

