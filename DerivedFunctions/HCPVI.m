function case_data = HCPVI(case_data)
% Calculte Water Injected, Pores volume
%
% Last Update Date: 11/03/2017
%
%SYNOPSIS:
%   case_data = HCPVI(case_data)
%
%DESCRIPTION:
%   This function calculates the water injected in terms of pore volume and
%   hydrocarbon pore volume
%
%PARAMETERS:
%   case_data: data structure that is used in MRDAT
%
%----------------------------------------------------------

num_cases = length(case_data);

for case_idx = 1: num_cases
    % By field
    ResCumWaterInj = case_data{case_idx,1}.Tvar.Field.ReservoirVolumeInjectionCumulative.data;
    PoreVol = case_data{case_idx,1}.Tvar.Field.PoreVolumeAtReservoirConditions.data;
    HCPV = case_data{case_idx,1}.Tvar.Field.PoreVolumeContainingHydrocarbon.data;
    
    PVI = ResCumWaterInj./PoreVol;
    HCPVI = ResCumWaterInj./HCPV;
    
    case_data{case_idx,1}.DerivedData.Field.PVI.data= PVI;
    case_data{case_idx,1}.DerivedData.Field.PVI.unit= 'RB/RB';
    
    case_data{case_idx,1}.DerivedData.Field.HCPVI.data= HCPVI;
    case_data{case_idx,1}.DerivedData.Field.HCPVI.unit= 'RB/RB';
    
    % By well ... Use the pore volume at field level!!!! Update this
    % function!!!!
    well_list = fieldnames(case_data{case_idx}.Tvar.Well);
    num_wells = length(well_list);
    for well_idx = 1: num_wells
        well_name = well_list{well_idx};
        well_Tvar_list = fieldnames(eval(['case_data{case_idx}.Tvar.Well.', well_name]));
        ResInjCum_flag = contains(well_Tvar_list, 'ReservoirVolumeInjectionCumulative');
        if sum(ResInjCum_flag)==1 
            ResCumWaterInj = eval(['case_data{case_idx,1}.Tvar.Well.', well_name, '.ReservoirVolumeInjectionCumulative.data']);
%             PoreVol = case_data{case_idx,1}.Tvar.Field.PoreVolumeAtReservoirConditions.data;
%             HCPV = case_data{case_idx,1}.Tvar.Field.PoreVolumeContainingHydrocarbon.data;
            
            PVI = ResCumWaterInj./PoreVol;
            HCPVI = ResCumWaterInj./HCPV;
            
            eval(['case_data{case_idx,1}.DerivedData.Well.', well_name, '.PVI.data= PVI;']);
            eval(['case_data{case_idx,1}.DerivedData.Well.', well_name, '.PVI.unit= ''RB/RB'';']);
            
            eval(['case_data{case_idx,1}.DerivedData.Well.', well_name, '.HCPVI.data= HCPVI;']);
            eval(['case_data{case_idx,1}.DerivedData.Well.', well_name, '.HCPVI.unit= ''RB/RB'';']);            
        end
    end  
end

end