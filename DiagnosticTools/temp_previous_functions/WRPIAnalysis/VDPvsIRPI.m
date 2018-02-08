function [Well_Vdp, IRPI] = VDPvsIRPI(case_data,Vdp_byLayer)
% Generate a Initial RPI vs Dykstra-Parsons coefficient per completion
% layer
%
% Last Update Date: 12/11/2017
%
%SYNOPSIS:
%   [Well_Vdp, IRPI] = VDPvsIRPI(case_data,Vdp_byLayer)
%
%DESCRIPTION:
% This function generates a Initial RPI vs Dykstra-Parsons coefficient 
% per completion scatter plot  
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%   Vdp_byLayer - Vector containing the DP coefficients by layer

% Completion layers by well: 9 producing wells
Completions = [5 18; 10 18; 5 19; 1 14; 4 18; 5 18; 11 20; 1 13; 4 17];
num_cases = length(case_data);
k =0;
maxCompLayers = max(Completions(:,2) - Completions(:,1));

for case_idx = 1:num_cases
    well_list = fieldnames(case_data{case_idx}.Tvar.Well);
    prod_well_list = well_list(contains(well_list, 'PRO'));
    num_prod_wells = length(prod_well_list);
    for prod_well_idx=1:num_prod_wells
        First_layer = Completions(prod_well_idx, 1);
        Last_layer = Completions(prod_well_idx, 2);
        numCompLayers = Last_layer - First_layer + 1;
        Well_Vdp(k+1:k+numCompLayers,1) = Vdp_byLayer(First_layer:Last_layer, case_idx);
        
        prod_well_name = prod_well_list{prod_well_idx};
        IRPI(k+1:k+numCompLayers,1) = eval(['case_data{case_idx,1}.DerivedData.Well.', prod_well_name, '.RPI.data(2)']);
        
        WellColor(k+1:k+numCompLayers,1) =  prod_well_idx;
        k = k + numCompLayers;
    end
end

% % % Colors for each well (blue, red, green, yellow, cyan, magenta, purple, gray, orange)
c = [0 0.2 0.8; 1 0 0; 0 0.6 0; 1 1 0; 0 1 1; 1 0 1; 0.4 0 0.8; 0.3 0.3 0.3; 1 0.4 0];
figure;
% scatter(Well_Vdp, IRPI, '+');
% gscatter(log10(Well_Vdp), log10(IRPI),WellColor, c,'.', 15);
gscatter(Well_Vdp, log10(IRPI),WellColor, c,'.', 15);
% gscatter(Well_Vdp, IRPI,WellColor, c,'.', 15);
xlabel('Dykstra-Parsons Coefficient by Completion Layer');
ylabel('Initial RPI, psi/BPD');


end