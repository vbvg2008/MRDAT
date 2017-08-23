function case_data = WOR(case_data)
% Calculte Water Oil Ratio 
%
% Last Update Date: 03/13/2017 
%
%SYNOPSIS:
%   case_data = WOR(case_data)
%DESCRIPTION:
%   This function calculates WOR from case data and it needs some
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
    WOR = WaterRate./OilRate;
    case_data{case_idx}.DerivedData.Field.WOR.data= WOR;
    WOR_unit = 'STB/STB';
    case_data{case_idx}.DerivedData.Field.WOR.unit= WOR_unit;
end


end

