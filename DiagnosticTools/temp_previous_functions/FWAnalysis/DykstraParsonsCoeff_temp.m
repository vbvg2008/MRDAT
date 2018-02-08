function [Vdp, Vdp_byZone] = DykstraParsonsCoeff(PERMX)
% Compute Dykstra-Parsons heterogeneity's coefficient
%
% Last Update Date: 11/28/2017
%
%SYNOPSIS:
%   [Vdp, Vdp_byZone] = DykstraParsonsCoeff(PERMX)
%
%DESCRIPTION:
%  This function computes Dykstra-Parsons heterogeneity's coefficient for 
%  each layer of the grid model
%
%PARAMETERS:
%   Vdp - a vector containing DP coefficient for each layer
%   Vdp_byZone - a vector containing DP coefficient for each
%   zone
%   PERMX - a matrix containing permeability values for each grid block
%

% Number of layers and data points in the grid model
[NumOfLayers dataPoints] = size(PERMX);

% Natural log of permx
LogPERM = log(PERMX);
LogPERM(isinf(LogPERM)) = nan;

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
Vdp = 1 - exp(-Sk);

Vdp_byZone(1) = mean(Vdp(1:20)); % Upper zone
Vdp_byZone(2) = mean(Vdp(21:22)); % Middle zone
Vdp_byZone(3) = mean(Vdp(23:52)); % Lower zone

end