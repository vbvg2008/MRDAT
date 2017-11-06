function WellSpacingEffect(case_data)
% Analyze the effect of well spacing on the scatter plot 
% of Log(Initial RPI) vs Log(FinalCumOil)
%
% Last Update Date: 10/27/2017 
%
%SYNOPSIS:
%   WellSpacingEffect(case_data)
%
%DESCRIPTION:
%   This function generates a comparative plot to analyze the effect of 
% well spacing on the scatter plot of Log(Initial RPI) 
% vs Log(FinalCumOil)
%
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%
%
% Before using this function, import data from 20ac, 80ac and 320ac
% scenarios, and merge them into one case_data structure
%
% load 20ac_80ac_320ac.mat;
% load 20acNG_80ac_320acNG.mat

num_cases = length(case_data);
TotalDaysIdx = length(case_data{1,1}.Tvar.Time.cumt);

for i=1:num_cases
    InitialRPI(i,1) = case_data{i,1}.DerivedData.WPRO2.RPI.data(2);
    FinalCumOil(i,1) = case_data{i,1}.Tvar.Field.OilProductionCumulative.data(TotalDaysIdx);
    if contains(case_data{i,1}.name, 'BC_80AC_SENS') 
        Case(i) = 80; % 80ac
    elseif contains(case_data{i,1}.name, 'BC_320AC_NG_SENS') 
        Case(i) = 320; % 320ac
    else 
        Case(i) = 20; % BC_20AC_NG_SENS
    end

end

figure;
gscatter(log10(InitialRPI),log10(FinalCumOil), Case, 'brg', 'xo+');
xlabel('Logarithm of Initial RPI');
ylabel('Logarithm of Final Cumulative Oil');
% title('Well spacing effect');
grid on;
legend('show');

end

