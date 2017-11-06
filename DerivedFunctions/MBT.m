function case_data = MBT(case_data)
% Calculte Material Balance Time
%
% Last Update Date: 10/31/2017
%
%SYNOPSIS:
%   case_data = MBT(case_data)
%DESCRIPTION:
%   This function calculates Material Balance Time from case data
%
%PARAMETERS:
%   case_data: data structure that is used in MRDAT
%
%----------------------------------------------------------
num_cases = length(case_data);

for case_idx = 1:num_cases
    % By field
    qo = case_data{case_idx,1}.Tvar.Field.OilProductionRate.data;
    qw = case_data{case_idx,1}.Tvar.Field.WaterProductionRate.data;
    Np = case_data{case_idx,1}.Tvar.Field.OilProductionCumulative.data;
    Wp = case_data{case_idx,1}.Tvar.Field.WaterProductionCumulative.data;
    
    OilMBT = Np./qo;
    WaterMBT = Wp./qw;
    TotalMBT = (Np + Wp)./(qo + qw);
    MBT_unit = 'Days';
    
    case_data{case_idx,1}.DerivedData.Field.OilMBT.data = OilMBT;
    case_data{case_idx,1}.DerivedData.Field.OilMBT.unit= MBT_unit;
    
    case_data{case_idx,1}.DerivedData.Field.WaterMBT.data = WaterMBT;
    case_data{case_idx,1}.DerivedData.Field.WaterMBT.unit= MBT_unit;
    
    case_data{case_idx,1}.DerivedData.Field.TotalMBT.data = TotalMBT;
    case_data{case_idx,1}.DerivedData.Field.TotalMBT.unit= MBT_unit;
    
    % By well
    well_list = fieldnames(case_data{case_idx}.Tvar.Well);
    num_wells = length(well_list);
    for well_idx = 1: num_wells
        well_name = well_list{well_idx};
        well_Tvar_list = fieldnames(eval(['case_data{case_idx}.Tvar.Well.', well_name]));
        WaterRate_flag = contains(well_Tvar_list, 'WaterProductionRate');
        OilRate_flag = contains(well_Tvar_list, 'OilProductionRate');
        WaterCum_flag = contains(well_Tvar_list, 'WaterProductionCumulative');
        OilCum_flag = contains(well_Tvar_list, 'OilProductionCumulative');
        if sum(WaterRate_flag)==1 && sum(OilRate_flag)==1 && sum(WaterCum_flag)==1 && sum(OilCum_flag)==1 
            qo = eval(['case_data{case_idx,1}.Tvar.Well.', well_name, '.OilProductionRate.data']);
            qw = eval(['case_data{case_idx,1}.Tvar.Well.', well_name, '.WaterProductionRate.data']);
            Np = eval(['case_data{case_idx,1}.Tvar.Well.', well_name, '.OilProductionCumulative.data']);
            Wp = eval(['case_data{case_idx,1}.Tvar.Well.', well_name, '.WaterProductionCumulative.data']);
            
            OilMBT = Np./qo;
            WaterMBT = Wp./qw;
            TotalMBT = (Np + Wp)./(qo + qw);
            MBT_unit = 'Days';
            
            eval(['case_data{case_idx,1}.DerivedData.Well.', well_name, '.OilMBT.data = OilMBT;']);
            eval(['case_data{case_idx,1}.DerivedData.Well.', well_name, '.OilMBT.unit= MBT_unit;']);
            
            eval(['case_data{case_idx,1}.DerivedData.Well.', well_name, '.WaterMBT.data = WaterMBT;']);
            eval(['case_data{case_idx,1}.DerivedData.Well.', well_name, '.WaterMBT.unit= MBT_unit;']);
            
            eval(['case_data{case_idx,1}.DerivedData.Well.', well_name, '.TotalMBT.data = TotalMBT;']);
            eval(['case_data{case_idx,1}.DerivedData.Well.', well_name, '.TotalMBT.unit= MBT_unit;']);
            
        end
    end
    
end
