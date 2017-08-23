function case_data = AvgDPvsTNpRVPC(case_data)
% Determines gradient of Field Pressure w.r.t. cumulative time, cumulative
% oil production and reservoir volume production cumulative and its
% avergave value during the first 50 and 100 days of production
%
% Last Update Date: 04/17/2017 
%
% SYNOPSIS:
%   case_data = AvgDPvsTNpRVPC(case_data)
%
% DESCRIPTION:
%   This function calculates gradient of Field Pressure w.r.t. cumulative time, cumulative
% oil production and reservoir volume production cumulative and its
% avergave value during the first 50 and 100 days of production
%
% PARAMETERS:
%   case_data: data structure that is used in MRDAT
%
%----------------------------------------------------------

num_cases = length(case_data);
TotalDaysIdx = length(case_data{1,1}.Tvar.Time.cumt);
for i = 1:num_cases
   
    time = case_data{i,1}.Tvar.Time.cumt;
    Np = case_data{i,1}.Tvar.Field.OilProductionCumulative.data;
    RVCP = case_data{i,1}.Tvar.Field.ReservoirVolumeProductionCumulative.data;

    pressure = case_data{i,1}.Tvar.Field.Pressure.data;

    [dPdt, dPdtmin, dPdtminID, dPdtminT, dPdtmax, dPdtmaxID, dPdtmaxT] = SlopeFuncMinMax(time,pressure);
    [dPdNp, dPdNpmin, dPdNpminID, dPdNpminNp, dPdNpmax, dPdNpmaxID, dPdNpmaxNp] = SlopeFuncMinMax(Np,pressure);
    [dPdRVCP, dPdRVCPmin, dPdRVCPminID, dPdRVCPminRVCP, dPdRVCPmax, dPdRVCPmaxID, dPdRVCPmaxRVCP] = SlopeFuncMinMax(RVCP,pressure);
    
    dPdt50 = mean(dPdt(1:50));
    dPdt100 = mean(dPdt(1:100));

    dPdNp50 = mean(dPdNp(1:50));
    dPdNp100 = mean(dPdNp(1:100));
    
    dPdRVCP50 = mean(dPdRVCP(1:50));
    dPdRVCP100 = mean(dPdRVCP(1:100));
    
    %Append into case_data
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dPdt = dPdt;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dPdtmin = dPdtmin;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dPdtminID = dPdtminID;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dPdtminT = dPdtminT;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dPdtmax = dPdtmax;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dPdtmaxID = dPdtmaxID;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dPdtmaxT = dPdtmaxT;
    
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dPdNp = dPdNp;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dPdNpmin = dPdNpmin;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dPdNpminID = dPdNpminID;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dPdNpminNp = dPdNpminNp;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dPdNpmax = dPdNpmax;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dPdNpmaxID = dPdNpmaxID;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dPdNpmaxNp = dPdNpmaxNp;
    
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dPdRVCP = dPdRVCP;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dPdRVCPmin = dPdRVCPmin;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dPdRVCPminID = dPdRVCPminID;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dPdRVCPminRVCP = dPdRVCPminRVCP;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dPdRVCPmax = dPdRVCPmax;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dPdRVCPmaxID = dPdRVCPmaxID;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.dPdRVCPmaxRVCP = dPdRVCPmaxRVCP;
      
% Averages    
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.AvgDP.dPdt50 = dPdt50;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.AvgDP.dPdt100 = dPdt100;
    
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.AvgDP.dPdNp50 = dPdNp50;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.AvgDP.dPdNp100 = dPdNp100;
    
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.AvgDP.dPdRVCP50 = dPdRVCP50;
    case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.AvgDP.dPdRVCP100 = dPdRVCP100;   

end