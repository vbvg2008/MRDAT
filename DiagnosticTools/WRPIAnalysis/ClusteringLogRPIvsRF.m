function case_data = ClusteringLogRPIvsRF(case_data)
% Clustering of Log(Initial RPI) vs Final Recovery
%
% Last Update Date: 07/07/2017 
%
%SYNOPSIS:
%   case_data = ClusteringLogRPIvsRF(case_data)
%
%DESCRIPTION:
%   Clustering of Initial RPI vs Final Recovery.
%
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%
%% Data
num_cases = length(case_data);
TotalDaysIdx = length(case_data{1,1}.Tvar.Time.cumt);
for i=1:num_cases
    InitialRPI(i,1) = case_data{i,1}.DerivedData.WPRO2.RPI.data(2);
    FinalRF(i,1) = case_data{i,1}.Tvar.Field.OilRecoveryEfficiency.data(TotalDaysIdx);  
%     ClusterGroup(i) = case_data{i,1}.Diagnostics.Clustering.InitialRPIvsCumOil;
    
end

%% Clustering Analysis

D = [log10(InitialRPI), log10(FinalRF)];  
c = [1 0 0; 0.8 0.68 0.08; 0 0.95 0.2; 0 0.05 0.88; 0.8 0 1];
MaxNumClusters = 5;

% % % Cluster Algorithm
% % % % ClusterGroup = kmeans(D, MaxNumClusters);  
ClusterGroup = clusterdata(D,'linkage','ward','maxclust',MaxNumClusters);
% % % % ClusterGroup = kmedoids(D,MaxNumClusters);


%% Append cluster group to case_data structure
for i=1:num_cases
    case_data{i,1}.Diagnostics.Clustering.InitialRPIvsRF = ClusterGroup(i);
end

%% Create directory to store figures and text files with results
if ~exist('Results','dir')
    mkdir('Results');
end

cd 'Results';


% Scatter plot by cluster group
figure;
gscatter(D(:,1),D(:,2),ClusterGroup, c, '.', 15);
xlabel('Logarithm of Initial RPI');
ylabel('Logarithm of Final Recovery');
grid on;
saveas(gcf, 'RPIvsRF_Cluster.png');

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

fileID = fopen('LogRPIvsLogRF.txt','w');
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
