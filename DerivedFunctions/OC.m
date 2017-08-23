function case_data = OC(case_data)
% Calculte Oil cut 
%
% Last Update Date: 03/12/2017 
%
%SYNOPSIS:
%   case_data = OC(case_data)
%DESCRIPTION:
%   THis function calculates OC from case data and it needs some
%   improvement
%
%PARAMETERS:
%   case_data: data structure that is used in MRDAT
%
%----------------------------------------------------------
num_cases = length(case_data);

for case_idx = 1: num_cases
    WaterRate = case_data{case_idx}.Tvar.Field.WaterProductionRate.data;
    OilRate = case_data{case_idx}.Tvar.Field.OilProductionRate.data;
    OC = OilRate./(OilRate + WaterRate);
    case_data{case_idx}.DerivedData.Field.OC.data= OC;
    OC_unit = 'STB/STB';
    case_data{case_idx}.DerivedData.Field.OC.unit= OC_unit;
end


end

