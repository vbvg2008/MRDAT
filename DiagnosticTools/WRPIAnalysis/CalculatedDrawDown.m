num_cases = length(case_data);
TotalDaysIdx = length(case_data{1,1}.Tvar.Time.cumt);
figure;
for i=1:num_cases
    if case_data{i,1}.Diagnostics.Clustering.InitialRPIvsCumOil==1
        Qo = case_data{i,1}.Tvar.Field.OilProductionRate.data;
        PI = case_data{i,1}.Tvar.Well.WPRO2.ProductivityIndex.data;
        CumTime = case_data{i,1}.Tvar.Time.cumt;
        DD = Qo./PI;
        plot(CumTime, DD);
        xlabel('Time (Days)');
        ylabel('Drawdown (psi)');
        title('Calculated Drawdown for Cases in Cluster 01');
        hold on;
    else
        continue;
    end
end

figure;
for i=1:num_cases
    if case_data{i,1}.Diagnostics.Clustering.InitialRPIvsCumOil==2
        Qo = case_data{i,1}.Tvar.Field.OilProductionRate.data;
        PI = case_data{i,1}.Tvar.Well.WPRO2.ProductivityIndex.data;
        CumTime = case_data{i,1}.Tvar.Time.cumt;
        DD = Qo./PI;
        plot(CumTime, DD);
        xlabel('Time (Days)');
        ylabel('Drawdown (psi)');
        title('Calculated Drawdown for Cases in Cluster 02');
        hold on;
    else
        continue;
    end
end

figure;
for i=1:num_cases
    if case_data{i,1}.Diagnostics.Clustering.InitialRPIvsCumOil==3
        Qo = case_data{i,1}.Tvar.Field.OilProductionRate.data;
        PI = case_data{i,1}.Tvar.Well.WPRO2.ProductivityIndex.data;
        CumTime = case_data{i,1}.Tvar.Time.cumt;
        DD = Qo./PI;
        plot(CumTime, DD);
        xlabel('Time (Days)');
        ylabel('Drawdown (psi)');
        title('Calculated Drawdown for Cases in Cluster 03');
        hold on;
    else
        continue;
    end
end

figure;
for i=1:num_cases
    if case_data{i,1}.Diagnostics.Clustering.InitialRPIvsCumOil==4
        Qo = case_data{i,1}.Tvar.Field.OilProductionRate.data;
        PI = case_data{i,1}.Tvar.Well.WPRO2.ProductivityIndex.data;
        CumTime = case_data{i,1}.Tvar.Time.cumt;
        DD = Qo./PI;
        plot(CumTime, DD);
        xlabel('Time (Days)');
        ylabel('Drawdown (psi)');
        title('Calculated Drawdown for Cases in Cluster 04');
        hold on;
    else
        continue;
    end
end

figure;
for i=1:num_cases
    if case_data{i,1}.Diagnostics.Clustering.InitialRPIvsCumOil==5
        Qo = case_data{i,1}.Tvar.Field.OilProductionRate.data;
        PI = case_data{i,1}.Tvar.Well.WPRO2.ProductivityIndex.data;
        CumTime = case_data{i,1}.Tvar.Time.cumt;
        DD = Qo./PI;
        plot(CumTime, DD);
        xlabel('Time (Days)');
        ylabel('Drawdown (psi)');
        title('Calculated Drawdown for Cases in Cluster 05');
        hold on;
    else
        continue;
    end
end

figure;
for i=1:num_cases
    if case_data{i,1}.Diagnostics.Clustering.InitialRPIvsCumOil==6
        Qo = case_data{i,1}.Tvar.Field.OilProductionRate.data;
        PI = case_data{i,1}.Tvar.Well.WPRO2.ProductivityIndex.data;
        CumTime = case_data{i,1}.Tvar.Time.cumt;
        DD = Qo./PI;
        plot(CumTime, DD);
        xlabel('Time (Days)');
        ylabel('Drawdown (psi)');
        title('Calculated Drawdown for Cases in Cluster 06');
        hold on;
    else
        continue;
    end
end

figure;
for i=1:num_cases
    if case_data{i,1}.Diagnostics.Clustering.InitialRPIvsCumOil==7
        Qo = case_data{i,1}.Tvar.Field.OilProductionRate.data;
        PI = case_data{i,1}.Tvar.Well.WPRO2.ProductivityIndex.data;
        CumTime = case_data{i,1}.Tvar.Time.cumt;
        DD = Qo./PI;
        plot(CumTime, DD);
        xlabel('Time (Days)');
        ylabel('Drawdown (psi)');
        title('Calculated Drawdown for Cases in Cluster 07');
        hold on;
    else
        continue;
    end
end

figure;
for i=1:num_cases
    if case_data{i,1}.Diagnostics.Clustering.InitialRPIvsCumOil==8
       Qo = case_data{i,1}.Tvar.Field.OilProductionRate.data;
        PI = case_data{i,1}.Tvar.Well.WPRO2.ProductivityIndex.data;
        CumTime = case_data{i,1}.Tvar.Time.cumt;
        DD = Qo./PI;
        plot(CumTime, DD);
        xlabel('Time (Days)');
        ylabel('Drawdown (psi)');
        title('Calculated Drawdown for Cases in Cluster 08');
        hold on;
    else
        continue;
    end
end

figure;
for i=1:num_cases
    if case_data{i,1}.Diagnostics.Clustering.InitialRPIvsCumOil==9
        Qo = case_data{i,1}.Tvar.Field.OilProductionRate.data;
        PI = case_data{i,1}.Tvar.Well.WPRO2.ProductivityIndex.data;
        CumTime = case_data{i,1}.Tvar.Time.cumt;
        DD = Qo./PI;
        plot(CumTime, DD);
        xlabel('Time (Days)');
        ylabel('Drawdown (psi)');
        title('Calculated Drawdown for Cases in Cluster 09');
        hold on;
    else
        continue;
    end
end

figure;
for i=1:num_cases
    if case_data{i,1}.Diagnostics.Clustering.InitialRPIvsCumOil==10
        Qo = case_data{i,1}.Tvar.Field.OilProductionRate.data;
        PI = case_data{i,1}.Tvar.Well.WPRO2.ProductivityIndex.data;
        CumTime = case_data{i,1}.Tvar.Time.cumt;
        DD = Qo./PI;
        plot(CumTime, DD);
        xlabel('Time (Days)');
        ylabel('Drawdown (psi)');
        title('Calculated Drawdown for Cases in Cluster 10');
        hold on;
    else
        continue;
    end
end
