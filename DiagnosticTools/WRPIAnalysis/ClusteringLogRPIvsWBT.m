function ClusteringLogRPIvsWBT(case_data)
% Clustering of Log(Initial RPI) vs Log(Water Breakthrough Time)
%
% Last Update Date: 07/28/2017 
%
%SYNOPSIS:
%   ClusteringLogRPIvsWBT(case_data)
%
%DESCRIPTION:
%   Clustering of Initial RPI vs Water Breakthrough Time.
%
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%
%
num_cases = length(case_data);
for i=1:num_cases
    InitialRPI(i,1) = case_data{i,1}.DerivedData.WPRO2.RPI.data(2);
    WBTime(i,1) = case_data{i,1}.Diagnostics.FWA.Field.WaterBreakthrough.Time;
    WBCumOilProd(i,1) = case_data{i,1}.Diagnostics.FWA.Field.WaterBreakthrough.CumOil;
    WBCumResVolProd(i,1) = case_data{i,1}.Diagnostics.FWA.Field.WaterBreakthrough.CumResVolProd;
    WBHCPVI(i,1) = case_data{i,1}.Diagnostics.FWA.Field.WaterBreakthrough.HCPVI;
    ClusterGroup(i) = case_data{i,1}.Diagnostics.Clustering.InitialRPIvsCumOil;

end
disp(WBTime);

D1 = [log10(InitialRPI), log10(WBTime)];
D2 = [log10(InitialRPI), log10(WBCumOilProd)];
D3 = [log10(InitialRPI), log10(WBCumResVolProd)];
D4 = [log10(InitialRPI), log10(WBHCPVI)];


% MaxNumClusters = 5; 
c = [1 0 0; 0.8 0.68 0.08; 0 0.95 0.2; 0 0.05 0.88; 0.8 0 1];

% ClusterGroup = clusterdata(D1,'linkage','ward','maxclust',MaxNumClusters);

if ~exist('Results','dir')
    mkdir('Results');
end

cd 'Results';

figure;
gscatter(D1(:,1),D1(:,2),ClusterGroup, c, '.', 15);
xlabel('Logarithm of Initial RPI');
ylabel('Logarithm of Elapsed Prod Days at Water Breakthrough');
grid on;
saveas(gcf, 'RPIvsWB_Time_Cluster.png');

figure;
gscatter(D2(:,1),D2(:,2),ClusterGroup, c, '.', 15);
xlabel('Logarithm of Initial RPI');
ylabel('Logarithm of Cum Oil Prod at Water Breakthrough');
grid on;
saveas(gcf, 'RPIvsWB_Np_Cluster.png');

figure;
gscatter(D3(:,1),D3(:,2),ClusterGroup, c, '.', 15);
xlabel('Logarithm of Initial RPI');
ylabel('Logarithm of Cum Res Vol Prod at Water Breakthrough');
grid on;
saveas(gcf, 'RPIvsWB_RVPC_Cluster.png');

figure;
gscatter(D4(:,1),D4(:,2),ClusterGroup, c, '.', 15);
xlabel('Logarithm of Initial RPI');
ylabel('Logarithm of HCPVI at Water Breakthrough');
grid on;
saveas(gcf, 'RPIvsWBHCPVI_Cluster.png');

% Case list by cluster
for i=1:num_cases
    if ClusterGroup(i)==1
        Cluster_01{i,1} = case_data{i,1}.name;
    elseif ClusterGroup(i)==2
        Cluster_02{i,2} = case_data{i,1}.name;
    elseif ClusterGroup(i)==3
        Cluster_03{i,1} = case_data{i,1}.name;
    elseif ClusterGroup(i)==4
        Cluster_04{i,1} = case_data{i,1}.name;
    elseif ClusterGroup(i)==5
        Cluster_05{i,1} = case_data{i,1}.name;
    end
end

Cluster_01 = Cluster_01(~cellfun('isempty',Cluster_01));
Cluster_02 = Cluster_02(~cellfun('isempty',Cluster_02));
Cluster_03 = Cluster_03(~cellfun('isempty',Cluster_03));
Cluster_04 = Cluster_04(~cellfun('isempty',Cluster_04));
Cluster_05 = Cluster_05(~cellfun('isempty',Cluster_05));

fileID = fopen('LogRPIvsLogWB.txt','w');
fprintf(fileID,'%-20s\n','Cluster 01');
fprintf(fileID,'%-20s\n','-------------------');
fprintf(fileID,'%-20s\n',string(Cluster_01));
fprintf(fileID,'\n\n');
fprintf(fileID,'%-20s\n','Cluster 02');
fprintf(fileID,'%-20s\n','-------------------');
fprintf(fileID,'%-20s\n',string(Cluster_02));
fprintf(fileID,'\n\n');
fprintf(fileID,'%-20s\n','Cluster 03');
fprintf(fileID,'%-20s\n','-------------------');
fprintf(fileID,'%-20s\n',string(Cluster_03));
fprintf(fileID,'\n\n');
fprintf(fileID,'%-20s\n','Cluster 04');
fprintf(fileID,'%-20s\n','-------------------');
fprintf(fileID,'%-20s\n',string(Cluster_04));
fprintf(fileID,'\n\n');
fprintf(fileID,'%-20s\n','Cluster 05');
fprintf(fileID,'%-20s\n','-------------------');
fprintf(fileID,'%-20s\n',string(Cluster_05));
fclose(fileID);


cd '../';


end