num_cases = length(case_data);
TotalDaysIdx = length(case_data{1,1}.Tvar.Time.cumt);
for i=1:num_cases
    % RPI Change - Producer
    InitialRPI(i) = case_data{i,1}.Diagnostics.WRPIA.WPRO2.RPI.InitialRPI;
    % Final Cumulative Oil Production
    LastCumOil(i) = case_data{i,1}.Tvar.Field.OilProductionCumulative.data(TotalDaysIdx); 
    
    KxLower(i) = case_data{i,1}.KX_LOWER;
    TransMiddle(i) = case_data{i,1}.TRANSMULT_MIDDLE;
    
    
end

D = [InitialRPI', log(LastCumOil')];

% Clusterdata function
T = clusterdata(D,'maxclust',12);
figure; 
scatter(D(:,1),D(:,2),[],T, 'filled');
xlabel('Initial RPI (psi/STB/D)');
ylabel('Final Cumulative Oil Production (STB)');


% Kmeans function
IDX = kmeans(D,12);
figure; 
scatter(D(:,1),D(:,2),[],IDX, 'filled');
xlabel('Initial RPI (psi/STB/D)');
ylabel('Final Cumulative Oil Production (STB)');

figure;
plot3(log(KxLower'), log(TransMiddle'), T, '+');
