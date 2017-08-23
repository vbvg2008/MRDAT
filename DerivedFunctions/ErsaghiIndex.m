function case_data = ErsaghiIndex(case_data)
% Calculte Ersaghi Index 
%
% Last Update Date: 04/06/2017 
%
%SYNOPSIS:
%   case_data = ErsaghiIndex(case_data)
%DESCRIPTION:
%   THis function calculates ErsaghiIndex from case data and it needs some
%   improvement
%
%PARAMETERS:
%   case_data: data structure that is used in MRDAT
%
%----------------------------------------------------------
num_cases = length(case_data);

for case_idx = 1: num_cases
    fw = case_data{case_idx}.DerivedData.Field.WC.data;
    ErsaghiId = log((1./fw)-1)-(1./fw);
    case_data{case_idx}.DerivedData.Field.ErsaghiId.data= ErsaghiId;
    ErsaghiId_unit = 'Unitless';
    case_data{case_idx}.DerivedData.Field.ErsaghiId.unit= ErsaghiId_unit;
end


end

