function case_data = GOR(case_data)
% Calculte Gas Oil Ratio 
%
% Last Update Date: 03/10/2017 
%
%SYNOPSIS:
%   case_data = GOR(case_data)
%DESCRIPTION:
%   THis function calculates GOR from case data and it needs some
%   improvement
%
%PARAMETERS:
%   case_data: data structure that is used in MRDAT
%
%----------------------------------------------------------
num_cases = length(case_data);

for case_idx = 1: num_cases
    GasRate = case_data{case_idx}.Tvar.Field.GasProductionRate.data;
    OilRate = case_data{case_idx}.Tvar.Field.OilProductionRate.data;
    GOR = GasRate./OilRate;
    case_data{case_idx}.DerivedData.GOR.data= GOR;
    GOR_unit = 'MSCF/STB';
    case_data{case_idx}.DerivedData.GOR.unit= GOR_unit;
end


end

