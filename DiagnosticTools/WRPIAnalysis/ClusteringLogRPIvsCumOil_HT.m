function case_data = ClusteringLogRPIvsCumOil_HT(case_data)
% Clustering of Log(Initial RPI) vs Log(Final Cumulative Oil Production)
%
% Last Update Date: 07/17/2017 
%
%SYNOPSIS:
%   case_data = ClusteringLogRPIvsCumOil(case_data)
%
%DESCRIPTION:
%   Clustering of Initial RPI vs Final Cumulative Oil Production (Log-Log).
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
    FinalCumOil(i,1) = case_data{i,1}.Tvar.Field.OilProductionCumulative.data(TotalDaysIdx);
%     Kx_Lower(i,1) = case_data{i,1}.KX_LOWER;
%     Kx_Upper(i,1) = case_data{i,1}.KX_UPPER;
%     TransMultMiddle(i,1) = case_data{i,1}.TRANSMULT_MIDDLE;
%     Poro_Lower(i,1) = case_data{i,1}.PORO_LOWER;
%     Poro_Upper(i,1) = case_data{i,1}.PORO_UPPER;
%     KyKx_Upper(i,1) = case_data{i,1}.KYKX_UPPER;
%     KyKx_Lower(i,1) = case_data{i,1}.KYKX_LOWER;
%     OWC(i,1) = case_data{i,1}.OWC;
%     WOCPc(i,1) = case_data{i,1}.WOCPc;
%     OilAPI(i,1) = case_data{i,1}.OIL_API;
%     SolGOR(i,1) = case_data{i,1}.SOL_GOR;
%     KvKh_Upper(i,1) = case_data{i,1}.KVKH_UPPER;
%     KvKh_Lower(i,1) = case_data{i,1}.KVKH_LOWER;
%     Sw_Pc0(i,1) = case_data{i,1}.SW_PC0;
%     Sorw(i,1) = case_data{i,1}.SORW;
%     GasGravity(i,1) = case_data{i,1}.GASGRAV;
%     RockComp(i,1) = case_data{i,1}.COMPRESSIBILITY;
%     Swcr(i,1) = case_data{i,1}.SWCR;
%     Salinity(i,1) = case_data{i,1}.SALINITY;    
end

%% Clustering Analysis

D = [log10(InitialRPI), log10(FinalCumOil)];  

% % % % Cluster Evaluation (up to 20 clusters)
% % % eva1 = evalclusters(D,'kmeans','CalinskiHarabasz','KList',[1:20]);
% % % eva2 = evalclusters(D,'kmeans','DaviesBouldin','KList',[1:20]);
% % % eva3 = evalclusters(D,'kmeans','gap','KList',[1:20]);
% % % eva4 = evalclusters(D,'kmeans','silhouette','KList',[1:20]);
% % % MaxNumClusters = mode([eva1.OptimalK eva2.OptimalK eva3.OptimalK eva4.OptimalK]);
% % % % Optimal number of clusters is 2 (according to the cluster evaluation)
 
% When using kmeans, the clustering is always the same for a MaxNumClusters = 3
% When using clusterdata, the clustering is always the same, no matter the
% number of maxclust
MaxNumClusters = 5; 
% % % Colors for each cluster (blue, black, red, green, yellow, cyan, magenta, purple, gray, orange)
% % % c = [0 0.2 0.8; 0 0 0; 1 0 0; 0 0.6 0; 1 1 0; 0 1 1; 1 0 1; 0.4 0 0.8; 0.3 0.3 0.3; 1 0.4 0];
c = [1 0 0; 0.8 0.68 0.08; 0 0.95 0.2; 0 0.05 0.88; 0.8 0 1];

% Cluster Algorithm
% % ClusterGroup = kmeans(D, MaxNumClusters);  
ClusterGroup = clusterdata(D,'linkage','ward','maxclust',MaxNumClusters);
% % ClusterGroup = kmedoids(D,MaxNumClusters);


% % % % Silhouette - For Cluster Evaluation
% % % % The silhouette value ranges from -1 to +1. A high silhouette
% % % % value indicates that i is well-matched to its own cluster, and
% % % % poorly-matched to neighboring clusters. If most points have a high
% % % % silhouette value, then the clustering solution is appropriate. 
% % % figure; 
% % % silhouette(D,ClusterGroup); grid on;


%% Append cluster group to case_data structure
for i=1:num_cases
    case_data{i,1}.Diagnostics.Clustering.InitialRPIvsCumOil = ClusterGroup(i);
end

%% Create directory to store figures and text files with results
if ~exist('Results','dir')
    mkdir('Results');
else
    delete('Results/*.png');
    delete('Results/*.txt');
end

cd 'Results';


% Scatter plot by cluster group
figure;
gscatter(D(:,1),D(:,2),ClusterGroup, c, '.', 15);
xlabel('Logarithm of Initial RPI');
ylabel('Logarithm of Final Cumulative Oil Production');
grid on;
% saveas(gcf, 'RPIvsNp_Cluster.png');

% % % % Distribution of clusters (Histogram)
% % % figure;
% % % histogram(ClusterGroup);
% % % xlabel('Cluster group');
% % % ylabel('Number of cases');
% % % grid on; 
% % % saveas(gcf, 'RPIvsNp_ClusterHistogram.png');
% % % 

% % Cluster relationship with 18 parameters (all, except salinity)
% 
% figure; % Fig 1 (Grid properties)
% 
% subplot(3, 3, 1);
% gscatter(ClusterGroup, log10(Kx_Upper),ClusterGroup, c, '.', 15);
% %scatter(ClusterGroup, log10(Kx_Upper), 50, ClusterGroup, 'filled');
% xlabel('Cluster');
% ylabel('Kx Upper');
% grid on; legend('off');
% 
% subplot(3, 3, 2);
% gscatter(ClusterGroup, log10(KyKx_Upper),ClusterGroup, c, '.', 15);
% %scatter(ClusterGroup, log10(KyKx_Upper), 50, ClusterGroup, 'filled');
% xlabel('Cluster');
% ylabel('KyKx Upper');
% grid on; legend('off');
% 
% subplot(3, 3, 3);
% gscatter(ClusterGroup, log10(KvKh_Upper),ClusterGroup, c, '.', 15);
% %scatter(ClusterGroup, log10(KvKh_Upper), 50, ClusterGroup, 'filled');
% xlabel('Cluster');
% ylabel('KvKh Upper');
% grid on; legend('off');
% 
% subplot(3, 3, 4);
% gscatter(ClusterGroup, log10(Kx_Lower),ClusterGroup, c, '.', 15);
% %scatter(ClusterGroup, log10(Kx_Lower), 50, ClusterGroup, 'filled');
% xlabel('Cluster');
% ylabel('Kx Lower');
% grid on; legend('off');
% 
% subplot(3, 3, 5);
% gscatter(ClusterGroup, log10(KyKx_Lower),ClusterGroup, c, '.', 15);
% %scatter(ClusterGroup, log10(KyKx_Lower), 50, ClusterGroup, 'filled');
% xlabel('Cluster');
% ylabel('KyKx Lower');
% grid on; legend('off');
% 
% subplot(3, 3, 6);
% gscatter(ClusterGroup, log10(KvKh_Lower),ClusterGroup, c, '.', 15);
% %scatter(ClusterGroup, log10(KvKh_Lower), 50, ClusterGroup, 'filled');
% xlabel('Cluster');
% ylabel('KvKh Lower');
% grid on; legend('off');
% 
% subplot(3, 3, 7);
% gscatter(ClusterGroup, Poro_Upper,ClusterGroup, c, '.', 15);
% %scatter(ClusterGroup, Poro_Upper, 50, ClusterGroup, 'filled');
% xlabel('Cluster');
% ylabel('Poro Upper');
% grid on; legend('off');
% 
% subplot(3, 3, 8);
% gscatter(ClusterGroup, Poro_Lower,ClusterGroup, c, '.', 15);
% %scatter(ClusterGroup, Poro_Lower, 50, ClusterGroup, 'filled');
% xlabel('Cluster');
% ylabel('Poro Lower');
% grid on; legend('off');
% 
% subplot(3, 3, 9);
% gscatter(ClusterGroup, log10(TransMultMiddle),ClusterGroup, c, '.', 15);
% %scatter(ClusterGroup, log10(TransMultMiddle), 50, ClusterGroup, 'filled');
% xlabel('Cluster');
% ylabel('TransMultMiddle');
% grid on; 
% leg1 = legend('show');
% rect = [0.92, 0.33, .09, .25];
% set(leg1, 'Position', rect);
% saveas(gcf, 'RPIvsNp_ClusterProps1.png');
% 
% 
% figure; % Fig 2 (Fluid and rock properties)
% 
% subplot(3, 3, 1);
% gscatter(ClusterGroup, OilAPI,ClusterGroup, c, '.', 15);
% %scatter(ClusterGroup, OilAPI, 50, ClusterGroup, 'filled');
% xlabel('Cluster');
% ylabel('Oil API');
% grid on; legend('off');
% 
% subplot(3, 3, 2);
% gscatter(ClusterGroup, GasGravity,ClusterGroup, c, '.', 15);
% %scatter(ClusterGroup, GasGravity, 50, ClusterGroup, 'filled');
% xlabel('Cluster');
% ylabel('Gas Gravity');
% grid on; legend('off');
% 
% subplot(3, 3, 3);
% gscatter(ClusterGroup, SolGOR,ClusterGroup, c, '.', 15);
% %scatter(ClusterGroup, SolGOR, 50, ClusterGroup, 'filled');
% xlabel('Cluster');
% ylabel('Sol GOR');
% grid on; legend('off');
% 
% subplot(3, 3, 4);
% gscatter(ClusterGroup, OWC,ClusterGroup, c, '.', 15);
% %scatter(ClusterGroup, OWC, 50, ClusterGroup, 'filled');
% xlabel('Cluster');
% ylabel('OWC');
% grid on; legend('off');
% 
% subplot(3, 3, 5);
% gscatter(ClusterGroup, WOCPc,ClusterGroup, c, '.', 15);
% %scatter(ClusterGroup, WOCPc, 50, ClusterGroup, 'filled');
% xlabel('Cluster');
% ylabel('Pc at OWC');
% grid on; legend('off');
% 
% subplot(3, 3, 6);
% gscatter(ClusterGroup, RockComp,ClusterGroup, c, '.', 15);
% %scatter(ClusterGroup, RockComp, 50, ClusterGroup, 'filled');
% xlabel('Cluster');
% ylabel('Rock Compressibility');
% grid on; legend('off');
% 
% subplot(3, 3, 7);
% gscatter(ClusterGroup, Swcr,ClusterGroup, c, '.', 15);
% %scatter(ClusterGroup, Swcr, 50, ClusterGroup, 'filled');
% xlabel('Cluster');
% ylabel('Swcr');
% grid on; legend('off');
% 
% subplot(3, 3, 8);
% gscatter(ClusterGroup, Sorw,ClusterGroup, c, '.', 15);
% %scatter(ClusterGroup, Sorw, 50, ClusterGroup, 'filled');
% xlabel('Cluster');
% ylabel('Sorw');
% grid on; legend('off');
% 
% subplot(3, 3, 9);
% gscatter(ClusterGroup, Sw_Pc0,ClusterGroup, c, '.', 15);
% %scatter(ClusterGroup, Sw_Pc0, 50, ClusterGroup, 'filled');
% xlabel('Cluster');
% ylabel('Sw at Pc=0');
% grid on; 
% leg2 = legend('show');
% rect = [0.92, 0.33, .09, .25];
% set(leg2, 'Position', rect);
% 
% saveas(gcf, 'RPIvsNp_ClusterProps2.png');


% % % BloxPlot
% % figure;
% % boxplot(log10(FinalCumOil),ClusterGroup)
% % %boxplot(Kx_Lower,ClusterGroup);
% % title('Final Cumulative Oil Production by Cluster');
% % xlabel('Cluster Group');
% % ylabel('Final Cumulative Oil Production');
% % saveas(gcf, 'RPIvsNp_ClusterBoxplot.png');


% % % Matrix of scatter plots by group
% % Param = [Kx_Lower, Kx_Upper, TransMultMiddle, Poro_Lower, Poro_Upper, OilAPI, WOCPc, OWC, SolGOR, KyKx_Lower, KvKh_Lower, KvKh_Upper];
% % figure;
% % gplotmatrix(Param,D,ClusterGroup, 'bcgr','++++');

% % % % 3D Scatter plot
% % % figure;
% % % scatter3(Kx_Lower, TransMultMiddle, Kx_Upper, 50, ClusterGroup, 'filled');
% % % xlabel('Kx Lower');
% % % ylabel('TransMultMiddle');
% % % zlabel('Kx Upper');
% % % title('Kx Lower vs TransMultMiddle vs Kx Upper Relationship');


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
%     elseif ClusterGroup(i)==6
%         Cluster_06{i,1} = case_data{i,1}.name;
%     elseif ClusterGroup(i)==7
%         Cluster_07{i,1} = case_data{i,1}.name;
%     elseif ClusterGroup(i)==8
%         Cluster_08{i,1} = case_data{i,1}.name;
%     elseif ClusterGroup(i)==9
%         Cluster_09{i,1} = case_data{i,1}.name;
%     else
%         Cluster_10{i,1} = case_data{i,1}.name;
    end
end

Cluster_01 = Cluster_01(~cellfun('isempty',Cluster_01));
Cluster_02 = Cluster_02(~cellfun('isempty',Cluster_02));
Cluster_03 = Cluster_03(~cellfun('isempty',Cluster_03));
Cluster_04 = Cluster_04(~cellfun('isempty',Cluster_04));
Cluster_05 = Cluster_05(~cellfun('isempty',Cluster_05));
% Cluster_06 = Cluster_06(~cellfun('isempty',Cluster_06));
% Cluster_07 = Cluster_07(~cellfun('isempty',Cluster_07));
% Cluster_08 = Cluster_08(~cellfun('isempty',Cluster_08));
% Cluster_09 = Cluster_09(~cellfun('isempty',Cluster_09));
% Cluster_10 = Cluster_10(~cellfun('isempty',Cluster_10));

fileID = fopen('LogRPIvsLogNp.txt','w');
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
% fprintf(fileID,'\n\n');
% fprintf(fileID,'%-20s\n','Cluster 06');
% fprintf(fileID,'%-20s\n','-------------------');
% fprintf(fileID,'%-20s\n',string(Cluster_06));
% fprintf(fileID,'\n\n');
% fprintf(fileID,'%-20s\n','Cluster 07');
% fprintf(fileID,'%-20s\n','-------------------');
% fprintf(fileID,'%-20s\n',string(Cluster_07));
% fprintf(fileID,'\n\n');
% fprintf(fileID,'%-20s\n','Cluster 08');
% fprintf(fileID,'%-20s\n','-------------------');
% fprintf(fileID,'%-20s\n',string(Cluster_08));
% fprintf(fileID,'\n\n');
% fprintf(fileID,'%-20s\n','Cluster 09');
% fprintf(fileID,'%-20s\n','-------------------');
% fprintf(fileID,'%-20s\n',string(Cluster_09));
% fprintf(fileID,'\n\n');
% fprintf(fileID,'%-20s\n','Cluster 10');
% fprintf(fileID,'%-20s\n','-------------------');
% fprintf(fileID,'%-20s\n',string(Cluster_10));
fclose(fileID);

cd '../';


end
