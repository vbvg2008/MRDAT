function case_data = MPV(case_data)
% Calculte Movable Pore volume 
%
% Last Update Date: 08/08/2017 
%
%SYNOPSIS:
%   case_data = MPV(case_data)
%
%DESCRIPTION:
%   This function calculates the movable pore volume in terms of the pore
%   volume, residual oil saturation and connate/critical water saturation
%
%PARAMETERS:
%   case_data: data structure that is used in MRDAT
%
%----------------------------------------------------------

num_cases = length(case_data);
Time = case_data{1,1}.Tvar.Time.cumt;
TotalDaysIdx = length(Time);

for i=1:num_cases
    ResCumWaterInj = case_data{i,1}.Tvar.Field.ReservoirVolumeInjectionCumulative.data;
    HCPV = case_data{i,1}.Tvar.Field.PoreVolumeContainingHydrocarbon.data;
    
    PoreVol = case_data{i,1}.Tvar.Field.PoreVolumeAtReservoirConditions.data;
    Sor = case_data{i,1}.SORW;
    Swc = case_data{i,1}.SWCR;
    
    MPV = PoreVol.*(1- Sor - Swc);
        
    case_data{i,1}.DerivedData.Field.MPV.data= MPV;
    case_data{i,1}.DerivedData.Field.MPV.unit= 'RB';
    
end

end