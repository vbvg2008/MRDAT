function case_data = WC(case_data)
% Calculte Water cut 
%
% Last Update Date: 03/12/2017 
%
%SYNOPSIS:
%   case_data = WC(case_data)
%DESCRIPTION:
%   THis function calculates WC from case data and it needs some
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
    WC = WaterRate./(OilRate + WaterRate);
    case_data{case_idx}.DerivedData.Field.WC.data= WC;
    WC_unit = 'STB/STB';
    case_data{case_idx}.DerivedData.Field.WC.unit= WC_unit;
end


end

