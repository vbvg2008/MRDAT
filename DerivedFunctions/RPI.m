function case_data = RPI(case_data)
% Calculte Reciprocal Productivity Index (RPI) for both type of wells
% (producers and injectors)
%
% Last Update Date: 03/15/2017 
%
% SYNOPSIS:
%   case_data = RPI(case_data)
%
% DESCRIPTION:
%   This function calculates RPI from case data and it needs some
%   improvement
%
% PARAMETERS:
%   case_data: data structure that is used in MRDAT
%
%----------------------------------------------------------

num_cases = length(case_data);

for case_idx = 1: num_cases
    
    % RPI for producer
    WPPI = case_data{case_idx,1}.Tvar.Well.WPRO2.ProductivityIndex.data;
    WPRPI = 1./WPPI;
    case_data{case_idx,1}.DerivedData.WPRO2.RPI.data= WPRPI;
    WPRPI_unit = 'psi/STB/D';
    case_data{case_idx,1}.DerivedData.WPRO2.RPI.unit= WPRPI_unit;
    
    % RPI for injector
    WIPI = case_data{case_idx,1}.Tvar.Well.WINJ1.ProductivityIndex.data;
    WIRPI = 1./WIPI;
    case_data{case_idx,1}.DerivedData.WINJ1.RPI.data= WIRPI;
    WIRPI_unit = 'psi/STB/D';
    case_data{case_idx,1}.DerivedData.WINJ1.RPI.unit= WIRPI_unit;    
       
end


end

