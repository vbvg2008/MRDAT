function case_data = ClusteringAvgDPvsNp(case_data)
% Clustering of average pressure drop in the first 50 or 100 days of
% production vs Final Oil Cumulative Production
%
% Last Update Date: 04/17/2017 
%
%SYNOPSIS:
%   case_data = ClusteringAvgDPvsNp(case_data)
%
%DESCRIPTION:
%   Clustering of average pressure drop in the first 50 or 100 days of
% production vs Final Oil Cumulative Production
%
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%

num_cases = length(case_data);
TotalDaysIdx = length(case_data{1,1}.Tvar.Time.cumt);
for i=1:num_cases
    
    dPdt50(i,1) = case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.AvgDP.dPdt50;
    dPdt100(i,1) = case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.AvgDP.dPdt100;
    
    dPdNp50(i,1) = case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.AvgDP.dPdNp50;
    dPdNp100(i,1) = case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.AvgDP.dPdNp100;
    
    dPdRVCP50(i,1) = case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.AvgDP.dPdRVCP50;
    dPdRVCP100(i,1) = case_data{i,1}.Diagnostics.WRPIA.Field.Pressure.AvgDP.dPdRVCP100;  
    
    FinalCumOil(i,1) = case_data{i,1}.Tvar.Field.OilProductionCumulative.data(TotalDaysIdx);
    Kx_Lower(i,1) = case_data{i,1}.KX_LOWER;
    Kx_Upper(i,1) = case_data{i,1}.KX_UPPER;
    TransMultMiddle(i,1) = case_data{i,1}.TRANSMULT_MIDDLE;
    Poro_Lower(i,1) = case_data{i,1}.PORO_LOWER;
    Poro_Upper(i,1) = case_data{i,1}.PORO_UPPER;
    KyKx_Upper(i,1) = case_data{i,1}.KYKX_UPPER;
    KyKx_Lower(i,1) = case_data{i,1}.KYKX_LOWER;
    OWC(i,1) = case_data{i,1}.OWC;
    WOCPc(i,1) = case_data{i,1}.WOCPc;
    OilAPI(i,1) = case_data{i,1}.OIL_API;
    SolGOR(i,1) = case_data{i,1}.SOL_GOR;
    KvKh_Upper(i,1) = case_data{i,1}.KVKH_UPPER;
    KvKh_Lower(i,1) = case_data{i,1}.KVKH_LOWER;
    Sw_Pc0(i,1) = case_data{i,1}.SW_PC0;
    Sorw(i,1) = case_data{i,1}.SORW;
    GasGravity(i,1) = case_data{i,1}.GASGRAV;
    RockComp(i,1) = case_data{i,1}.COMPRESSIBILITY;
    Swcr(i,1) = case_data{i,1}.SWCR;
    Salinity(i,1) = case_data{i,1}.SALINITY;    
end

%% Clustering Analysis

 D = [dPdt50, log10(FinalCumOil)];  
% D = [dPdt100, log10(FinalCumOil)]; 
% D = [dPdNp50, log10(FinalCumOil)];
% D = [dPdNp100, log10(FinalCumOil)];
% D = [dPdRVCP50, log10(FinalCumOil)];
% D = [dPdRVCP100, log10(FinalCumOil)];


% Cluster Evaluation (up to 15 clusters)
% % eva1 = evalclusters(D,'kmeans','CalinskiHarabasz','KList',[1:15]);
% % eva2 = evalclusters(D,'kmeans','DaviesBouldin','KList',[1:15]);
% % eva3 = evalclusters(D,'kmeans','gap','KList',[1:15]);
% % eva4 = evalclusters(D,'kmeans','silhouette','KList',[1:15]);


% Optimal number of clusters
% MaxNumClusters = mode([eva1.OptimalK eva2.OptimalK eva3.OptimalK eva4.OptimalK]); 
MaxNumClusters = 10;


% Cluster Algorithm
[ClusterGroup, CenterPoint] = kmeans(D, MaxNumClusters);  
% % [ClusterGroup, CenterPoint] = kmedoids(D,MaxNumClusters);
% % ClusterGroup = clusterdata(D,'linkage','ward','maxclust',MaxNumClusters);


% Silhouette - For Cluster Evaluation
% The silhouette value ranges from -1 to +1. A high silhouette
% value indicates that i is well-matched to its own cluster, and
% poorly-matched to neighboring clusters. If most points have a high
% silhouette value, then the clustering solution is appropriate. 
figure; 
silhouette(D,ClusterGroup); grid on;


% Append cluster group to case_data structure
for i=1:num_cases
    case_data{i,1}.Diagnostics.Clustering.AvgDPvsNp = ClusterGroup(i);
end

% Scatter plot by cluster group
figure; 
scatter(D(:,1),D(:,2),[],ClusterGroup, 'filled');
xlabel('Averga Pressure Drop (psi)');
ylabel('Final Cumulative Oil Production (STB)');
grid on;

% Distribution of clusters
figure;
histogram(ClusterGroup);
xlabel('Cluster group');
ylabel('Number of cases');
grid on;

% Clusters relationship with some of the 19 parameters
figure; 
subplot(4, 3, 1);
scatter(ClusterGroup, log10(Kx_Lower), 50, ClusterGroup, 'filled');
xlabel('Cluster');
ylabel('Kx Lower');
grid on;

subplot(4, 3, 2);
scatter(ClusterGroup, log10(Kx_Upper), 50, ClusterGroup, 'filled');
xlabel('Cluster');
ylabel('Kx Upper');
grid on;

subplot(4, 3, 3);
scatter(ClusterGroup, log10(TransMultMiddle), 50, ClusterGroup, 'filled');
xlabel('Cluster');
ylabel('TransMultMiddle');
grid on;

subplot(4, 3, 4);
scatter(ClusterGroup, Poro_Lower, 50, ClusterGroup, 'filled');
xlabel('Cluster');
ylabel('Poro Lower');
grid on;

subplot(4, 3, 5);
scatter(ClusterGroup, Poro_Upper, 50, ClusterGroup, 'filled');
xlabel('Cluster');
ylabel('Poro Upper');
grid on;

subplot(4, 3, 6);
scatter(ClusterGroup, OilAPI, 50, ClusterGroup, 'filled');
xlabel('Cluster');
ylabel('Oil API');
grid on;

subplot(4, 3, 7);
scatter(ClusterGroup, WOCPc, 50, ClusterGroup, 'filled');
xlabel('Cluster');
ylabel('WOCPc');
grid on;

subplot(4, 3, 8);
scatter(ClusterGroup, OWC, 50, ClusterGroup, 'filled');
xlabel('Cluster');
ylabel('OWC');
grid on;

subplot(4, 3, 9);
scatter(ClusterGroup, SolGOR, 50, ClusterGroup, 'filled');
xlabel('Cluster');
ylabel('Sol GOR');
grid on;

subplot(4, 3, 10);
scatter(ClusterGroup, log10(KyKx_Lower), 50, ClusterGroup, 'filled');
xlabel('Cluster');
ylabel('KyKx Lower');
grid on;

subplot(4, 3, 11);
scatter(ClusterGroup, log10(KvKh_Lower), 50, ClusterGroup, 'filled');
xlabel('Cluster');
ylabel('KvKh Lower');
grid on;

subplot(4, 3, 12);
scatter(ClusterGroup, log10(KvKh_Upper), 50, ClusterGroup, 'filled');
xlabel('Cluster');
ylabel('KvKh Upper');
grid on;

% Matrix of scatter plots by group
Param = [Kx_Lower, Kx_Upper, TransMultMiddle, Poro_Lower, Poro_Upper, OilAPI, WOCPc, OWC, SolGOR, KyKx_Lower, KvKh_Lower, KvKh_Upper];
figure;
gplotmatrix(Param,D,ClusterGroup, 'bcgr','++++');

% % % % 3D Scatter plot
% % % figure;
% % % scatter3(Kx_Lower, TransMultMiddle, Kx_Upper, 50, ClusterGroup, 'filled');
% % % xlabel('Kx Lower');
% % % ylabel('TransMultMiddle');
% % % zlabel('Kx Upper');
% % % title('Kx Lower vs TransMultMiddle vs Kx Upper Relationship');

end
