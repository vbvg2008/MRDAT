function case_data = FWCvsNpMinMax(case_data)


num_cases = length(case_data);
lastTimeID = length(case_data{1,1}.Tvar.Time.cumt);
for i=1:num_cases
   
    x = case_data{i}.Tvar.Field.OilProductionCumulative.data;
    y = case_data{i}.DerivedData.Field.WC.data;

    [dydx, dydxmin, idydxmin, xmin, dydxmax, idydxmax, xmax] = SlopeFuncMinMax(x,y);

    %Append into case_data
    case_data{i,1}.Diagnostics.FPA.Field.WC.dFWCdNp = dydx;
    case_data{i,1}.Diagnostics.FPA.Field.WC.dFWCdNpmin = dydxmin;
    case_data{i,1}.Diagnostics.FPA.Field.WC.dFWCdNpminID = idydxmin;
    case_data{i,1}.Diagnostics.FPA.Field.WC.dFWCdNpminNp = xmin;    
    case_data{i,1}.Diagnostics.FPA.Field.WC.dFWCdNpmax = dydxmax;
    case_data{i,1}.Diagnostics.FPA.Field.WC.dFWCdNpmaxID = idydxmax;
    case_data{i,1}.Diagnostics.FPA.Field.WC.dFWCdNpmaxNp = xmax; 
    
end




for i=1:num_cases
    WCvsNpMaxValue(i,1) =  case_data{i,1}.Diagnostics.FPA.Field.WC.dFWCdNpmax;  
    WCvsNpMaxId(i,1) = case_data{i,1}.Diagnostics.FPA.Field.WC.dFWCdNpmaxID;
    WCvsNpMax(i,1) = case_data{i,1}.Tvar.Field.OilProductionCumulative.data(WCvsNpMaxId(i));
    
    
%     WCRVPCMax(i,1) = case_data{i,1}.Diagnostics.FPA.Field.WC.dFWCdRVPCmaxRVPC;
%     WCTimeMax(i,1) = case_data{i,1}.Diagnostics.FPA.Field.WC.dFWCdTimemaxTime;
%     FinalCumOil(i,1) = case_data{i,1}.Tvar.Field.OilProductionCumulative.data(lastTimeID); 
    

end


figure;
subplot(2, 1, 1);
scatter(WCRVPCMax, FinalCumOil);
ylabel('Final Cum Oil [STB]');
xlabel('RVPC at WB [RB]');

subplot(2, 1, 2);
scatter(WCTimeMax, FinalCumOil);
ylabel('Final Cum Oil [STB]');
xlabel('Time at WB [RB]');

end




