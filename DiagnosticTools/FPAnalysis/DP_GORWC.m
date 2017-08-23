function case_data = DP_GORWC(case_data)
%Creates diagnostic plots using GOR decline and sharp rise in WC.
%   cumulative. Ancillary plots are constructed.
%
%SYNOPSIS:
%   case_data = DP_GORWC(case_data)
%
%DESCRIPTION:
%   Creates diagnostic plots using GOR decline and sharp rise in WC.
%   cumulative. Ancillary plots are constructed.
%
%   Currently performing at field level
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%------------------------------------------------
%Initialization
case_data = FGORResVolMinMax(case_data,0);
case_data = FWORResVolMinMax(case_data,0);
case_data = FWCResVolMinMax(case_data,0);
case_data = FOCResVolMinMax(case_data,0);

%---------------------------------------------
%loop through all necessary cases
num_cases = length(case_data);
FWGO_case_idx = 1:num_cases;
lastTimeID = length(case_data{1}.Tvar.Time.cumt);

for i = 1:num_cases
    RPV(i) = eval(['case_data{i}.Tvar.Field.PoreVolumeAtReservoirConditions.data(1);']);
    HCPV(i) = eval(['case_data{i}.Tvar.Field.PoreVolumeContainingHydrocarbon.data(1);']);
    GORIdx(i) = eval(['case_data{i}.Diagnostics.FPA.Field.GOR','.dFGORdRVPCminID;']);
    GORRVPCMin(i) = eval(['case_data{i}.Diagnostics.FPA.Field.GOR','.dFGORdRVPCminRVPC;']);
    GORRVPCMinOPC(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(GORIdx(i));']);
    GORRVPCMinOPCLast(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(lastTimeID);']);
    GORRVPCMinGPCLast(i) = eval(['case_data{i}.Tvar.Field.GasProductionCumulative.data(lastTimeID);']);
    WCIdx(i) = eval(['case_data{i}.Diagnostics.FPA.Field.WC','.dFWCdRVPCmaxID;']);
    WCRVPCMax(i) = eval(['case_data{i}.Diagnostics.FPA.Field.WC','.dFWCdRVPCmaxRVPC;']);
    WCRVPCMaxOPC(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(WCIdx(i));']);  
    WCRVPCMaxOPCLast(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(lastTimeID);']); 
    WCRVPCMaxGPCLast(i) = eval(['case_data{i}.Tvar.Field.GasProductionCumulative.data(lastTimeID);']);     
end

figure;
plot(GORRVPCMin,WCRVPCMax,'*');
xlabel('RVPC at GOR decline');
ylabel('RVPC at sharp WC rise');


figure;
plot(GORRVPCMinOPC,WCRVPCMaxOPC,'b+');
xlabel('OPC at GOR decline');
ylabel('OPC at sharp WC rise');


figure;
plot(GORRVPCMin,GORRVPCMinOPCLast,'g+');
xlabel('RVPC at GOR decline');
ylabel('Final OPC');


figure;
plot(WCRVPCMax,WCRVPCMaxOPCLast,'r+');
xlabel('RVPC at sharp WC rise');
ylabel('Final OPC');


figure;
plot(GORRVPCMin,GORRVPCMinGPCLast,'g*');
xlabel('RVPC at GOR decline');
ylabel('Final GPC');

figure;
plot(WCRVPCMax,WCRVPCMaxGPCLast,'r*');
xlabel('RVPC at sharp WC rise');
ylabel('Final GPC');


figure;
plot(log(GORRVPCMin),log(GORRVPCMinOPCLast),'g+');
xlabel('Log(RVPC at GOR decline)');
ylabel('Log(Final OPC)');


figure;
plot(log(WCRVPCMax),log(WCRVPCMaxOPCLast),'r+');
xlabel('Log(RVPC at sharp WC rise)');
ylabel('Log(Final OPC)');


end
