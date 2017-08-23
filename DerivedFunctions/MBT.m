function case_data = MBT(case_data)
% Calculte Material Balance Time 
%
% Last Update Date: 04/06/2017 
%
%SYNOPSIS:
%   case_data = MBT(case_data)
%DESCRIPTION:
%   THis function calculates Material Balance Time from case data
%
%PARAMETERS:
%   case_data: data structure that is used in MRDAT
%
%----------------------------------------------------------
num_cases = length(case_data);

for i = 1:num_cases
    qo = case_data{i,1}.Tvar.Field.OilProductionRate.data;
    qw = case_data{i,1}.Tvar.Field.WaterProductionRate.data;
    Np = case_data{i,1}.Tvar.Field.OilProductionCumulative.data;
    Wp = case_data{i,1}.Tvar.Field.WaterProductionCumulative.data;
    
    OilMBT = Np./qo;
    WaterMBT = Wp./qw;
    TotalMBT = (Np + Wp)./(qo + qw);
    MBT_unit = 'Days';
    
    case_data{i,1}.DerivedData.Field.OilMBT.data = OilMBT;
    case_data{i,1}.DerivedData.Field.OilMBT.unit= MBT_unit;
    
    case_data{i,1}.DerivedData.Field.WaterMBT.data = WaterMBT;
    case_data{i,1}.DerivedData.Field.WaterMBT.unit= MBT_unit;
    
    case_data{i,1}.DerivedData.Field.TotalMBT.data = TotalMBT;
    case_data{i,1}.DerivedData.Field.TotalMBT.unit= MBT_unit;
    
end
