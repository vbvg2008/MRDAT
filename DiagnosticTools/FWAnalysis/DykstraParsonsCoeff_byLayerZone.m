function [Vdp_byLayer, Vdp_byZone] = DykstraParsonsCoeff_byLayerZone(grid_data, zones)
% Compute Dykstra-Parsons heterogeneity's coefficient
%
% Last Update Date: 1/11/2018
%
%SYNOPSIS:
%   [Vdp_byLayer, Vdp_byZone] = DykstraParsonsCoeff_byLayerZone(grid_data, zones)
%
%DESCRIPTION:
%  This function computes Dykstra-Parsons heterogeneity's coefficient
%  by layer and by zone
%
%PARAMETERS:
%   Vdp_byLayer - a vector containing DP coefficient for each layer
%   Vdp_byZone - a vector containing DP coefficient for each zone
%   grid_data - a structure containing grid permeability data
%   zones - a vector containg the number of layers for each zone
%


if ~exist('zones','var')
    zones = [20 2 30];
end

num_cases = length(grid_data);

for case_idx = 1:num_cases
    
    PERMX = grid_data{case_idx,1}.PERMX;
    
    % Ignore zero values from PERMX matrix (inactive cells)
    PERMX(PERMX == 0) = NaN;
    
    % Number of data points by layer
    dataPoints = size(PERMX,2);
    
    % Natural log of permx
    LogPERM = log(PERMX);
    
    % ----------------------
    % by Layer....
    % ----------------------
    
    % Mean of LogPerm by layer
    AvgLogPERM = mean(LogPERM, 2, 'omitnan');
    
    % Sum of the squared difference of LogPerm
    PermDiff = LogPERM - AvgLogPERM;
    PermSqDiff = PermDiff.^2;
    SumOfPermSqDiff = sum(PermSqDiff, 2, 'omitnan');
    
    % Constant values
    Acoeff = 1+(0.25/(dataPoints - 1));
    Bcoeff = 1/(dataPoints - 1);
    
    % Dykstra-Parsons coefficient
    Sk = Acoeff.*sqrt(Bcoeff.*SumOfPermSqDiff);
    Vdp_byLayer(:,case_idx) = 1 - exp(-Sk);
    
    % ----------------------
    % by Zone...
    % ----------------------
    
    NumOfZones=length(zones);
    layerTop = 1;
    layerBase = zones(1);
    
    for i=1:NumOfZones
        % Permx and logPerm by zone
        PERM_byZone = PERMX(layerTop:layerBase, :);
        LogPERM_byZone = LogPERM(layerTop:layerBase, :);
        dataPoints_byZone = numel(PERM_byZone);
        
        % Mean of LogPerm by zone
        AvgLogPERM_byZone = mean(mean(LogPERM_byZone, 'omitnan'), 'omitnan');
        
        % Sum of the squared difference of LogPerm
        PermDiff_byZone = LogPERM_byZone - AvgLogPERM_byZone;
        PermSqDiff_byZone = PermDiff_byZone.^2;
        SumOfPermSqDiff_byZone = sum(sum(PermSqDiff_byZone, 'omitnan'), 'omitnan');
        
        % Constant values
        Acoeff_byZone = 1+(0.25/(dataPoints_byZone - 1));
        Bcoeff_byZone = 1/(dataPoints_byZone - 1);
        
        % Dykstra-Parsons coefficient
        Sk_byZone = Acoeff_byZone.*sqrt(Bcoeff_byZone.*SumOfPermSqDiff_byZone);
        Vdp_byZone(i,case_idx) = 1 - exp(-Sk_byZone);
        
        if i<NumOfZones
            layerTop = layerBase + 1;
            layerBase = layerTop + zones(i+1) - 1;
        else
            break;
        end
        
    end
end

end