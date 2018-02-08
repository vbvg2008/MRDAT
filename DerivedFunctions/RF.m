function case_data = RF(case_data)
% Calculte Oil Recovery Factor 
%
% Last Update Date: 11/10/2017 
%
%SYNOPSIS:
%   case_data = RF(case_data)
%DESCRIPTION:
%   This function calculates oil recovery efficiency
%
%PARAMETERS:
%   case_data: data structure that is used in MRDAT
%
%----------------------------------------------------------
num_cases = length(case_data);

for case_idx = 1: num_cases
    field_Tvar_list = fieldnames(case_data{case_idx}.Tvar.Field);
    RF_flag = contains(field_Tvar_list, 'OilRecoveryEfficiency');
    OIP_flag = contains(field_Tvar_list, 'OilInPlace');
    if sum(RF_flag)==0 && sum(OIP_flag)==1       
        OIP = case_data{case_idx}.Tvar.Field.OilInPlace.data;
        RF = (OIP(1) - OIP)./OIP(1);
        case_data{case_idx}.Tvar.Field.OilRecoveryEfficiency.data= RF;
        RF_unit = 'Unitless';
        case_data{case_idx}.Tvar.Field.OilRecoveryEfficiency.unit= RF_unit;
    end    
end

end
