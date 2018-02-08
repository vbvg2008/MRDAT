function case_data = DykstraParsonsCoeff(grid_data, case_data, Completions)
% Compute Dykstra-Parsons heterogeneity's coefficient
%
% Last Update Date: 1/11/2018
%
%SYNOPSIS:
%   case_data = DykstraParsonsCoeff(grid_data, case_data, Completions)
%
%DESCRIPTION:
%  This function computes Dykstra-Parsons heterogeneity's coefficient
%  by layer in the nearwellbore region
%
%PARAMETERS:
%   grid_data - a structure containing grid permeability data and well
%   region indices
%   case_data - The general structure that stores all data in MRDAT 
%

nK = 52;
num_cases = length(grid_data);

% Vdp by layer in the near wellbore region...
for case_idx = 1:num_cases 
    well_list = fieldnames(case_data{case_idx}.Tvar.Well);
    prod_well_list = well_list(contains(well_list, 'PRO'));
    num_prod_wells = length(prod_well_list);
    
    for prod_well_idx=1:num_prod_wells
        prod_well_name = prod_well_list{prod_well_idx};
        WellRegion = 10 + prod_well_idx;
        PERMX = grid_data{case_idx,1}.PERMX;
        % Permeability values in the near wellbore zone
        PERMX(grid_data{1,1}.WellRegion~=WellRegion)=NaN;
        % Ignore zero values from PERMX matrix (inactive cells)
        PERMX(PERMX == 0) = NaN;
        
        % Number of data points by layer and well region
        for layer=1:nK
            dataPoints(layer,1) = length(find(~isnan(PERMX(layer,:))));
        end
        
        % Natural log of permx
        LogPERM = log(PERMX);
        
        % Mean of LogPerm by layer
        AvgLogPERM = mean(LogPERM, 2, 'omitnan');
        
        % Sum of the squared difference of LogPerm
        PermDiff = LogPERM - AvgLogPERM;
        PermSqDiff = PermDiff.^2;
        SumOfPermSqDiff = sum(PermSqDiff, 2, 'omitnan');
        
        % Constant values
        Acoeff = 1+(0.25./(dataPoints - 1));
        Bcoeff = 1./(dataPoints - 1);
        
        % Dykstra-Parsons coefficient
        Sk = Acoeff.*sqrt(Bcoeff.*SumOfPermSqDiff);
        Vdp = 1 - exp(-Sk);
        %Vdp{case_idx,1}.Well(:,prod_well_idx) = 1 - exp(-Sk);
        
        % Completion layers by well 
        FirstCL = Completions(prod_well_idx, 1);
        LastCL = Completions(prod_well_idx, 2);
        
        % Append Vdp by well to the case_data structure
        eval(['case_data{case_idx, 1}.Diagnostics.Well.', prod_well_name, '.Vdp = Vdp(FirstCL:LastCL);']);
        
    end 
end
    
%------------------------------------------------------------------------

% Vdp by near wellbore region...
for case_idx = 1:num_cases 
    well_list = fieldnames(case_data{case_idx}.Tvar.Well);
    prod_well_list = well_list(contains(well_list, 'PRO'));
    num_prod_wells = length(prod_well_list);
    
    for prod_well_idx=1:num_prod_wells
        prod_well_name = prod_well_list{prod_well_idx};
        WellRegion = 10 + prod_well_idx;
        PERMX = grid_data{case_idx,1}.PERMX;
        % Permeability values in the near wellbore zone
        PERMX(grid_data{1,1}.WellRegion~=WellRegion)=NaN;
        % Ignore zero values from PERMX matrix (inactive cells)
        PERMX(PERMX == 0) = NaN;
        
        % Completion layers by well 
        FirstCL = Completions(prod_well_idx, 1);
        LastCL = Completions(prod_well_idx, 2);
        
        % Ignore values above the first completion layer 
        if FirstCL==2
            PERMX(1,:) = NaN;
        elseif FirstCL>2
            PERMX(1:FirstCL-1,:)= NaN;
        end
        % Ignore values below the last completion layer
        if LastCL==19
            PERMX(20,:) = NaN;
        elseif LastCL<19
            PERMX(LastCL+1:20,:)= NaN;
        end
        
        % Number of data points by well region
        for layer=1:nK
            dataPoints_byLayer(layer,1) = length(find(~isnan(PERMX(layer,:))));
        end
        dataPoints_byWR = sum(dataPoints_byLayer, 'omitnan');
        
        % Natural log of permx
        LogPERM_byWR = log(PERMX);
        
        % Mean of LogPerm by layer
        AvgLogPERM_byWR = mean(mean(LogPERM_byWR, 'omitnan'), 'omitnan'); 
        
        % Sum of the squared difference of LogPerm
        PermDiff_byWR = LogPERM_byWR - AvgLogPERM_byWR;
        PermSqDiff_byWR = PermDiff_byWR.^2;
        SumOfPermSqDiff_byWR = sum(sum(PermSqDiff_byWR, 2, 'omitnan'), 'omitnan');
        
        % Constant values
        Acoeff_byWR = 1+(0.25./(dataPoints_byWR - 1));
        Bcoeff_byWR = 1./(dataPoints_byWR - 1);
        
        % Dykstra-Parsons coefficient
        Sk_byWR = Acoeff_byWR.*sqrt(Bcoeff_byWR.*SumOfPermSqDiff_byWR);
        Vdp_byWR = 1 - exp(-Sk_byWR);
       
        % Append Vdp by well region to the case_data structure
        eval(['case_data{case_idx, 1}.Diagnostics.Well.', prod_well_name, '.Vdp_WR = Vdp_byWR;']);
        
    end
end

end