function case_data = DP_GORWCOC(case_data)
%Creates diagnostic plots using GOR/OC decline and sharp rise in WC.
%   cumulative. Ancillary plots are constructed.
%
%SYNOPSIS:
%   case_data = DP_GORWCOC(case_data)
%
%DESCRIPTION:
%   Creates diagnostic plots using GOR/OC decline and sharp rise in WC.
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

case_data = FGORTimeMinMax(case_data,5,0);
case_data = FGORTimeMinMax(case_data,5,0);
case_data = FGORTimeMinMax(case_data,5,0);
case_data = FGORTimeMinMax(case_data,5,0);
%---------------------------------------------
%loop through all necessary cases
num_cases = length(case_data);
FWGO_case_idx = 1:num_cases;
lastTimeID = length(case_data{1}.Tvar.Time.cumt);
%

for i = 1:num_cases
    RPV(i) = eval(['case_data{i}.Tvar.Field.PoreVolumeAtReservoirConditions.data(1);']);
    HCPV(i) = eval(['case_data{i}.Tvar.Field.PoreVolumeContainingHydrocarbon.data(1);']);
%
%   RVPC 
%
    GOR_RVPCIdx(i) = eval(['case_data{i}.Diagnostics.FPA.Field.GOR','.dFGORdRVPCminID;']);
    GORRVPCMin(i) = eval(['case_data{i}.Diagnostics.FPA.Field.GOR','.dFGORdRVPCminRVPC;']);
    GORRVPCMinOPC(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(GOR_RVPCIdx(i));']);
    GORRVPCMinOPCLast(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(lastTimeID);']);
    GORRVPCMinGPCLast(i) = eval(['case_data{i}.Tvar.Field.GasProductionCumulative.data(lastTimeID);']);
    GORRVPCMinOPC_HCRF(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(GOR_RVPCIdx(i));'])/HCPV(i);
    GORRVPCMinOPC_HCRFLast(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(lastTimeID);'])/HCPV(i);
    GORRVPCMinGPC_HCRFLast(i) = eval(['case_data{i}.Tvar.Field.GasProductionCumulative.data(lastTimeID);'])/HCPV(i);
%
    OC_RVPCIdx(i) = eval(['case_data{i}.Diagnostics.FPA.Field.OC','.dFOCdRVPCminID;']);
    OCRVPCMin(i) = eval(['case_data{i}.Diagnostics.FPA.Field.OC','.dFOCdRVPCminRVPC;']);
    OCRVPCMinOPC(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(OC_RVPCIdx(i));']);  
    OCRVPCMinOPCLast(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(lastTimeID);']); 
    OCRVPCMinGPCLast(i) = eval(['case_data{i}.Tvar.Field.GasProductionCumulative.data(lastTimeID);']);     
    OCRVPCMinOPC_HCRF(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(OC_RVPCIdx(i));'])/HCPV(i);  
    OCRVPCMinOPC_HCRFLast(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(lastTimeID);'])/HCPV(i); 
    OCRVPCMinGPC_HCRFLast(i) = eval(['case_data{i}.Tvar.Field.GasProductionCumulative.data(lastTimeID);'])/HCPV(i);     
%
    WC_RVPCIdx(i) = eval(['case_data{i}.Diagnostics.FPA.Field.WC','.dFWCdRVPCmaxID;']);
    WCRVPCMax(i) = eval(['case_data{i}.Diagnostics.FPA.Field.WC','.dFWCdRVPCmaxRVPC;']);
    WCRVPCMaxOPC(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(WC_RVPCIdx(i));']);  
    WCRVPCMaxOPCLast(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(lastTimeID);']); 
    WCRVPCMaxGPCLast(i) = eval(['case_data{i}.Tvar.Field.GasProductionCumulative.data(lastTimeID);']);     
    WCRVPCMaxOPC_HCRF(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(WC_RVPCIdx(i));'])/HCPV(i);  
    WCRVPCMaxOPC_HCRFLast(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(lastTimeID);'])/HCPV(i); 
    WCRVPCMaxGPC_HCRFLast(i) = eval(['case_data{i}.Tvar.Field.GasProductionCumulative.data(lastTimeID);'])/HCPV(i); 
%
%   Time 
%
    GOR_TimeIdx(i) = eval(['case_data{i}.Diagnostics.FPA.Field.GOR','.dFGORdTimeminID;']);
    GORTimeMin(i) = eval(['case_data{i}.Diagnostics.FPA.Field.GOR','.dFGORdTimeminTime;']);
    GORTimeMinOPC(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(GOR_TimeIdx(i));']);
    GORTimeMinOPCLast(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(lastTimeID);']);
    GORTimeMinGPCLast(i) = eval(['case_data{i}.Tvar.Field.GasProductionCumulative.data(lastTimeID);']);
    GORTimeMinOPC_HCRF(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(GOR_TimeIdx(i));'])/HCPV(i);
    GORTimeMinOPC_HCRFLast(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(lastTimeID);'])/HCPV(i);
    GORTimeMinGPC_HCRFLast(i) = eval(['case_data{i}.Tvar.Field.GasProductionCumulative.data(lastTimeID);'])/HCPV(i);
%
    OC_TimeIdx(i) = eval(['case_data{i}.Diagnostics.FPA.Field.OC','.dFOCdTimeminID;']);
    OCTimeMin(i) = eval(['case_data{i}.Diagnostics.FPA.Field.OC','.dFOCdTimeminTime;']);
    OCTimeMinOPC(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(OC_TimeIdx(i));']);  
    OCTimeMinOPCLast(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(lastTimeID);']); 
    OCTimeMinGPCLast(i) = eval(['case_data{i}.Tvar.Field.GasProductionCumulative.data(lastTimeID);']);     
    OCTimeMinOPC_HCRF(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(OC_TimeIdx(i));'])/HCPV(i);  
    OCTimeMinOPC_HCRFLast(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(lastTimeID);'])/HCPV(i); 
    OCTimeMinGPC_HCRFLast(i) = eval(['case_data{i}.Tvar.Field.GasProductionCumulative.data(lastTimeID);'])/HCPV(i);     
%
    WC_TimeIdx(i) = eval(['case_data{i}.Diagnostics.FPA.Field.WC','.dFWCdTimemaxID;']);
    WCTimeMax(i) = eval(['case_data{i}.Diagnostics.FPA.Field.WC','.dFWCdTimemaxTime;']);
    WCTimeMaxOPC(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(WC_TimeIdx(i));']);  
    WCTimeMaxOPCLast(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(lastTimeID);']); 
    WCTimeMaxGPCLast(i) = eval(['case_data{i}.Tvar.Field.GasProductionCumulative.data(lastTimeID);']);     
    WCTimeMaxOPC_HCRF(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(WC_TimeIdx(i));'])/HCPV(i);  
    WCTimeMaxOPC_HCRFLast(i) = eval(['case_data{i}.Tvar.Field.OilProductionCumulative.data(lastTimeID);'])/HCPV(i); 
    WCTimeMaxGPC_HCRFLast(i) = eval(['case_data{i}.Tvar.Field.GasProductionCumulative.data(lastTimeID);'])/HCPV(i); 
%
end

if ~exist('DP_Plots','dir')
    mkdir('DP_Plots');
end
cd 'DP_Plots';

i = 0;
total_num_i = 100;
Frame_data = cell(total_num_i,1);
%
%  RVPC
%
i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(GORRVPCMin,OCRVPCMin,'*');
xlabel('RVPC at GOR decline');
ylabel('RVPC at OC decline');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);

i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(GORRVPCMin,WCRVPCMax,'*');
xlabel('RVPC at GOR decline');
ylabel('RVPC at sharp WC rise');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);


i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(GORRVPCMinOPC,WCRVPCMaxOPC,'b+');
xlabel('OPC at GOR decline');
ylabel('OPC at sharp WC rise');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(OCRVPCMin,OCRVPCMinOPCLast,'g+');
xlabel('RVPC at OC decline');
ylabel('Final OPC');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);


i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(GORRVPCMin,GORRVPCMinOPCLast,'g+');
xlabel('RVPC at GOR decline');
ylabel('Final OPC');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);


i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(WCRVPCMax,WCRVPCMaxOPCLast,'r+');
xlabel('RVPC at sharp WC rise');
ylabel('Final OPC');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(OCRVPCMin,OCRVPCMinOPC_HCRFLast,'g+');
xlabel('RVPC at OC decline');
ylabel('Final OPC_HCRF');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);


i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(GORRVPCMin,GORRVPCMinOPC_HCRFLast,'g+');
xlabel('RVPC at GOR decline');
ylabel('Final OPC_HCRF');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);


i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(WCRVPCMax,WCRVPCMaxOPC_HCRFLast,'r+');
xlabel('RVPC at sharp WC rise');
ylabel('Final OPC_HCRF');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);


i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(OCRVPCMin,OCRVPCMinGPCLast,'g*');
xlabel('RVPC at OC decline');
ylabel('Final GPC');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);


i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(GORRVPCMin,GORRVPCMinGPCLast,'g*');
xlabel('RVPC at GOR decline');
ylabel('Final GPC');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(WCRVPCMax,WCRVPCMaxGPCLast,'r*');
xlabel('RVPC at sharp WC rise');
ylabel('Final GPC');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(OCRVPCMin,OCRVPCMinGPC_HCRFLast,'g*');
xlabel('RVPC at OC decline');
ylabel('Final GPC_HCRF');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(GORRVPCMin,GORRVPCMinGPC_HCRFLast,'g*');
xlabel('RVPC at GOR decline');
ylabel('Final GPC_HCRF');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);




i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(WCRVPCMax,WCRVPCMaxGPC_HCRFLast,'r*');
xlabel('RVPC at sharp WC rise');
ylabel('Final GPC_HCRF');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(log(OCRVPCMin),log(OCRVPCMinOPCLast),'g+');
xlabel('Log(RVPC at OC decline)');
ylabel('Log(Final OPC)');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(log(GORRVPCMin),log(GORRVPCMinOPCLast),'g+');
xlabel('Log(RVPC at GOR decline)');
ylabel('Log(Final OPC)');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(log(WCRVPCMax),log(WCRVPCMaxOPCLast),'r+');
xlabel('Log(RVPC at sharp WC rise)');
ylabel('Log(Final OPC)');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(log(OCRVPCMin),log(OCRVPCMinOPC_HCRFLast),'g+');
xlabel('Log(RVPC at OC decline)');
ylabel('Log(Final OPC_HCRF)');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(log(GORRVPCMin),log(GORRVPCMinOPC_HCRFLast),'g+');
xlabel('Log(RVPC at GOR decline)');
ylabel('Log(Final OPC_HCRF)');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(log(WCRVPCMax),log(WCRVPCMaxOPC_HCRFLast),'r+');
xlabel('Log(RVPC at sharp WC rise)');
ylabel('Log(Final OPC_HCRF)');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);

%
%  Time
%
i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(GORTimeMin,OCTimeMin,'*');
xlabel('Time at GOR decline');
ylabel('Time at OC decline');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);

i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(GORTimeMin,WCTimeMax,'*');
xlabel('Time at GOR decline');
ylabel('Time at sharp WC rise');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);


i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(GORTimeMinOPC,WCTimeMaxOPC,'b+');
xlabel('OPC at GOR decline');
ylabel('OPC at sharp WC rise');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(OCTimeMin,OCTimeMinOPCLast,'g+');
xlabel('Time at OC decline');
ylabel('Final OPC');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);


i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(GORTimeMin,GORTimeMinOPCLast,'g+');
xlabel('Time at GOR decline');
ylabel('Final OPC');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);


i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(WCTimeMax,WCTimeMaxOPCLast,'r+');
xlabel('Time at sharp WC rise');
ylabel('Final OPC');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(OCTimeMin,OCTimeMinOPC_HCRFLast,'g+');
xlabel('Time at OC decline');
ylabel('Final OPC_HCRF');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);


i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(GORTimeMin,GORTimeMinOPC_HCRFLast,'g+');
xlabel('Time at GOR decline');
ylabel('Final OPC_HCRF');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);


i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(WCTimeMax,WCTimeMaxOPC_HCRFLast,'r+');
xlabel('Time at sharp WC rise');
ylabel('Final OPC_HCRF');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);


i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(OCTimeMin,OCTimeMinGPCLast,'g*');
xlabel('Time at OC decline');
ylabel('Final GPC');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);


i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(GORTimeMin,GORTimeMinGPCLast,'g*');
xlabel('Time at GOR decline');
ylabel('Final GPC');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(WCTimeMax,WCTimeMaxGPCLast,'r*');
xlabel('Time at sharp WC rise');
ylabel('Final GPC');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(OCTimeMin,OCTimeMinGPC_HCRFLast,'g*');
xlabel('Time at OC decline');
ylabel('Final GPC_HCRF');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(GORTimeMin,GORTimeMinGPC_HCRFLast,'g*');
xlabel('Time at GOR decline');
ylabel('Final GPC_HCRF');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);




i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(WCTimeMax,WCTimeMaxGPC_HCRFLast,'r*');
xlabel('Time at sharp WC rise');
ylabel('Final GPC_HCRF');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(log(OCTimeMin),log(OCTimeMinOPCLast),'g+');
xlabel('Log(Time at OC decline)');
ylabel('Log(Final OPC)');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(log(GORTimeMin),log(GORTimeMinOPCLast),'g+');
xlabel('Log(Time at GOR decline)');
ylabel('Log(Final OPC)');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(log(WCTimeMax),log(WCTimeMaxOPCLast),'r+');
xlabel('Log(Time at sharp WC rise)');
ylabel('Log(Final OPC)');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(log(OCTimeMin),log(OCTimeMinOPC_HCRFLast),'g+');
xlabel('Log(Time at OC decline)');
ylabel('Log(Final OPC_HCRF)');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(log(GORTimeMin),log(GORTimeMinOPC_HCRFLast),'g+');
xlabel('Log(Time at GOR decline)');
ylabel('Log(Final OPC_HCRF)');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);



i = i+1;
pic_name = ['DP_Plots_',int2str(i),'.png'];
h = figure('visible','off');

plot(log(WCTimeMax),log(WCTimeMaxOPC_HCRFLast),'r+');
xlabel('Log(Time at sharp WC rise)');
ylabel('Log(Final OPC_HCRF)');

Frame_data{i} = getframe(h);
saveas(h,pic_name);
close(h);




%i = i+1;
%pic_name = ['DP_Plots_',int2str(i),'.png'];
%h = figure('visible','off');

%surf(log(GORTimeMin),log(GORTimeMinOPC_HCRFLast),log(WCTimeMax),'g+');
%xlabel('Log(Time at GOR decline)');
%ylabel('Log(Final OPC_HCRF)');
%zlabel('Log(Time at WC Rise)');

%Frame_data{i} = getframe(h);
%saveas(h,pic_name);
%close(h);


cd '..\';

end
