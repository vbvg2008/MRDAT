function VDPvsIRPI_byWell(case_data)
% Generate a scatter plot with the Initial RPI vs Dykstra-Parsons coefficient 
% per completion layer by well
%
% Last Update Date: 12/26/2017
%
%SYNOPSIS:
%   VDPvsIRPI_byWell(case_data)
%
%DESCRIPTION:
% This function generates a scatter plot with the Initial RPI vs 
% Dykstra-Parsons coefficient per completion   
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT

Completions = [5 18; 10 18; 5 19; 1 14; 4 18; 5 18; 11 20; 1 13; 4 17];
num_cases = length(case_data);

for prod_well_idx = 1:9
prod_well_name = ['WPRO', num2str(prod_well_idx)];
First_layer = Completions(prod_well_idx, 1);
Last_layer = Completions(prod_well_idx, 2);
numCompLayers = Last_layer - First_layer + 1;
k =0;
for case_idx = 1:num_cases
    Well_Vdp(k+1:k+numCompLayers,1) = eval(['case_data{case_idx, 1}.Diagnostics.Well.', prod_well_name, '.Vdp;']);
    IRPI(k+1:k+numCompLayers,1) = eval(['case_data{case_idx,1}.DerivedData.Well.', prod_well_name, '.RPI.data(2)']);
    CL_Color(k+1:k+numCompLayers,1) =  [First_layer:1:Last_layer]';
    k = k + numCompLayers;    
end

figure;
gscatter(Well_Vdp, log10(IRPI),CL_Color, [],'.', 15);
xlabel('Dykstra-Parsons Coefficient by Completion Layer');
ylabel('Initial RPI, psi/BPD');
title(prod_well_name);

clear Well_Vdp IRPI CL_Color;
end

end