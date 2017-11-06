function case_data = RPI(case_data)
% Calculte Reciprocal Productivity Index (RPI) for both type of wells
% (producers and injectors)
%
% Last Update Date: 10/30/2017 
%
% SYNOPSIS:
%   case_data = RPI(case_data)
%
% DESCRIPTION:
%   This function calculates RPI from case data at well level
%
% PARAMETERS:
%   case_data: data structure that is used in MRDAT
%
%----------------------------------------------------------

num_cases = length(case_data);

for case_idx = 1: num_cases
    
    % List and number of wells
    well_list = fieldnames(case_data{case_idx}.Tvar.Well);
    num_wells = length(well_list);
    
    % Well Reciprocal Productivity Index
    for well_idx = 1: num_wells
        % Check if productivity index variable is available per well
        well_name = well_list{well_idx};
        well_Tvar_list = fieldnames(eval(['case_data{case_idx}.Tvar.Well.', well_name]));
        PI_flag = contains(well_Tvar_list, 'ProductivityIndex');
        % Compute RPI for each well
        if sum(PI_flag)==1
            PI = eval(['case_data{case_idx}.Tvar.Well.',well_name, '.ProductivityIndex.data']);
            RPI = 1./PI;
            eval(['case_data{case_idx}.DerivedData.Well.', well_name, '.RPI.data= RPI;']);
            RPI_unit = 'psi/STB/D';
            eval(['case_data{case_idx}.DerivedData.Well.', well_name, '.RPI.unit= RPI_unit;']);
        end
    end
    
end

end

