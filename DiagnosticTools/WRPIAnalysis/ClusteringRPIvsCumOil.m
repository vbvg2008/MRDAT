function case_data = ClusteringRPIvsCumOil(case_data)
% Clustering of Initial RPI vs Final Cumulative Oil Production
%
% Last Update Date: 04/14/2017 
%
%SYNOPSIS:
%   case_data = ClusteringRPIvsCumOil(case_data)
%
%DESCRIPTION:
%   Clustering of Initial RPI vs Final Cumulative Oil Production.
%
%
%PARAMETERS:
%   case_data - The general structure that stores all data in MRDAT
%

num_cases = length(case_data);
TotalDaysIdx = length(case_data{1,1}.Tvar.Time.cumt);
for i=1:num_cases
    InitialRPI(i,1) = case_data{i,1}.DerivedData.WPRO2.RPI.data(2);
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

D = [InitialRPI, log(FinalCumOil)];  

% % % % Cluster Evaluation (up to 15 clusters)
% % % eva1 = evalclusters(D,'kmeans','CalinskiHarabasz','KList',[1:15]);
% % % eva2 = evalclusters(D,'kmeans','DaviesBouldin','KList',[1:15]);
% % % eva3 = evalclusters(D,'kmeans','gap','KList',[1:15]);
% % % eva4 = evalclusters(D,'kmeans','silhouette','KList',[1:15]);


% Optimal number of clusters
% % MaxNumClusters = mode([eva1.OptimalK eva2.OptimalK eva3.OptimalK eva4.OptimalK]); 
MaxNumClusters = 4;


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
    case_data{i,1}.Diagnostics.Clustering.InitialRPIvsCumOil = ClusterGroup(i);
end

cd 'RPI_Analysis';

% Scatter plot by cluster group
figure; 
scatter(D(:,1),D(:,2),[],ClusterGroup, 'filled');
xlabel('Initial RPI (psi/STB/D)');
ylabel('Final Cumulative Oil Production (STB)');
grid on;
saveas(gcf,'InitialRPIvsFinalCumOil_Clusters.png');

% Distribution of clusters
figure;
histogram(ClusterGroup);
xlabel('Cluster group');
ylabel('Number of cases');
grid on;
saveas(gcf,'InitialRPIvsFinalCumOil_DistributionOfClusters.png');

% Clusters relationship with some of the 19 parameters
figure; 
subplot(3, 2, 1);
scatter(ClusterGroup, Kx_Lower, 50, ClusterGroup, 'filled');
xlabel('Cluster');
ylabel('Kx Lower');
grid on;

subplot(3, 2, 2);
scatter(ClusterGroup, TransMultMiddle, 50, ClusterGroup, 'filled');
xlabel('Cluster');
ylabel('TransMultMiddle');
grid on;

subplot(3, 2, 3);
scatter(ClusterGroup, Kx_Upper, 50, ClusterGroup, 'filled');
xlabel('Cluster');
ylabel('Kx Upper');
grid on;

subplot(3, 2, 4);
scatter(ClusterGroup, Poro_Lower, 50, ClusterGroup, 'filled');
xlabel('Cluster');
ylabel('Poro Lower');
grid on;

subplot(3, 2, 5);
scatter(ClusterGroup, Poro_Upper, 50, ClusterGroup, 'filled');
xlabel('Cluster');
ylabel('Poro Upper');
grid on;

subplot(3, 2, 6);
scatter(ClusterGroup, OWC, 50, ClusterGroup, 'filled');
xlabel('Cluster');
ylabel('OWC');
grid on;
saveas(gcf,'InitialRPIvsFinalCumOil_ScatterPlotsByClusters.png');

% Matrix of scatter plots by group
Param = [Kx_Lower, Kx_Upper, TransMultMiddle, Poro_Lower, Poro_Upper, KyKx_Upper, KyKx_Lower, OWC];
figure;
gplotmatrix(Param,D,ClusterGroup, 'bcgr','++++');
saveas(gcf,'InitialRPIvsFinalCumOil_ScatterPlotsByClusters2.png');

% 3D Scatter plot
figure;
scatter3(Kx_Lower, TransMultMiddle, Kx_Upper, 50, ClusterGroup, 'filled');
xlabel('Kx Lower');
ylabel('TransMultMiddle');
zlabel('Kx Upper');
title('Kx Lower vs TransMultMiddle vs Kx Upper Relationship');
saveas(gcf,'InitialRPIvsFinalCumOil_ScatterPlotsByClusters3.png');

cd '../';

%% Factor Analysis

% Factor analysis is a statistical method used to describe variability
% among observed, correlated variables in terms of a potentially lower
% number of unobserved variables called factors. For example, it is
% possible that variations in six observed variables mainly reflect the
% variations in two unobserved (underlying) variables


% X is an n-by-d matrix where each row is an observation of d variables: 1512 x 19
% Rows (Observations - Cases) and Columns (Variables - Each sensitivity parameter) 
X = [Kx_Lower, Kx_Upper, TransMultMiddle, Poro_Lower, Poro_Upper, KyKx_Upper, KyKx_Lower, OWC, WOCPc, OilAPI, SolGOR, KvKh_Upper, KvKh_Lower, Sw_Pc0, Sorw, GasGravity, RockComp, Swcr, Salinity];

% Assuming the data can be correlated with two common factors
[Loadings2, specVar2,T2,stats2] = factoran(X,2);

% Assuming the data can be correlated with three common factors
[Loadings3, specVar3,T3,stats3] = factoran(X,3);

% Legend
VarLabels = {'01-Kx Lower', '02-Kx Upper', '03-TransMultMiddle', '04-Poro Lower', '05-Poro Upper', '06-KyKx Upper','07-KyKx Lower', '08-OWC', '09-WOC Pc=0', '10-Oil API', '11-Sol GOR', '12-KvKh Upper', '13-KvKh Lower', '14-Sw Pc=0','15-Sorw', '16-GasGrav', '17-RockComp', '18-Swcr', '19-Salinity'};

% Plotting results
figure; % Two Common Factors
biplot(Loadings2,'LineWidth',2,'MarkerSize',20, 'varlabels', num2str((1:19)'));
annotation('textbox',[0.2 0.5 0.3 0.3],'String',VarLabels,'FitBoxToText','on');
title('Two common factors');

figure; % Three Common Factors
biplot(Loadings3,'LineWidth',2,'MarkerSize',20, 'varlabels', num2str((1:19)'));
annotation('textbox',[0.2 0.5 0.3 0.3],'String',VarLabels,'FitBoxToText','on');
title('Three common factors');


% % % % --------- Using just the first 5 variables in FOPT Pareto Chart)-----------
% % % % Warning for X with 6 and 7 variables (+ Poro_Upper, OWC): Some unique variances are zero.
% % % X = [Kx_Lower, TransMultMiddle, Kx_Upper, Poro_Lower, KyKx_Upper];
% % % [Loadings2, specVar2,T2,stats2] = factoran(X,2);  
% % % [Loadings3, specVar3,T3,stats3] = factoran(X,3); % Error: The number of factors requested, m = 3, is too large for the number of the observed variables. 
% % % VarLabels = {'01-Kx Lower', '02-TransMultMiddle', '03-Kx Upper', '04-Poro Lower', '05-KyKx Upper'};
% % % figure; 
% % % biplot(Loadings2,'LineWidth',2,'MarkerSize',20, 'varlabels', num2str((1:5)'));
% % % annotation('textbox',[0.2 0.5 0.3 0.3],'String',VarLabels,'FitBoxToText','on');


% % % % % % % --------- Using Initial RPI, FinalCumOil and all 19 parameters -----------
% % % X = [InitialRPI, FinalCumOil, Kx_Lower, Kx_Upper, TransMultMiddle, Poro_Lower, Poro_Upper, KyKx_Upper, KyKx_Lower, OWC, WOCPc, OilAPI, SolGOR, KvKh_Upper, KvKh_Lower, Sw_Pc0, Sorw, GasGravity, RockComp, Swcr, Salinity];
% % % [Loadings2, specVar2,T2,stats2] = factoran(X,2); % Warning: Some unique variances are zero
% % % [Loadings3, specVar3,T3,stats3] = factoran(X,3); % Warning: Some unique variances are zero
% % % VarLabels = {'01-Initial RPI', '02-FinalCumOil', '03-Kx Lower', '04-Kx Upper', '05-TransMultMiddle', '06-Poro Lower', '07-Poro Upper', '08-KyKx Upper','09-KyKx Lower', '10-OWC', '11-WOC Pc=0', '12-Oil API', '13-Sol GOR', '14-KvKh Upper', '15-KvKh Lower', '16-Sw Pc=0','17-Sorw', '18-GasGrav', '19-RockComp', '20-Swcr', '21-Salinity'};
% % % figure; % Two Common Factors
% % % biplot(Loadings2,'LineWidth',2,'MarkerSize',20, 'varlabels', num2str((1:21)'));
% % % annotation('textbox',[0.2 0.5 0.3 0.3],'String',VarLabels,'FitBoxToText','on');
% % % title('Two common factors');
% % % 
% % % figure; % Three Common Factors
% % % biplot(Loadings3,'LineWidth',2,'MarkerSize',20, 'varlabels', num2str((1:21)'));
% % % annotation('textbox',[0.2 0.5 0.3 0.3],'String',VarLabels,'FitBoxToText','on');
% % % title('Three common factors');


% % % % % % % % % % --------- Using Initial RPI, FInalCumOil and some parameters -----------
% % % X = [InitialRPI, FinalCumOil, Kx_Lower, Kx_Upper, TransMultMiddle, Poro_Lower, Poro_Upper, KyKx_Upper, KyKx_Lower, OWC];
% % % [Loadings2, specVar2,T2,stats2] = factoran(X,2); % Warning: Some unique variances are zero: cannot compute significance.
% % % [Loadings3, specVar3,T3,stats3] = factoran(X,3); % Warning: Some unique variances are zero: cannot compute significance.
% % % 
% % % VarLabels = {'01-Initial RPI', '02-FinalCumOil', '03-Kx Lower', '04-Kx Upper', '05-TransMultMiddle', '06-Poro Lower', '07-Poro Upper', '08-KyKx Upper','09-KyKx Lower', '10-OWC'};
% % % figure; % Two Common Factors
% % % biplot(Loadings2,'LineWidth',2,'MarkerSize',20, 'varlabels', num2str((1:10)'));
% % % annotation('textbox',[0.2 0.5 0.3 0.3],'String',VarLabels,'FitBoxToText','on');
% % % title('Two common factors');

% % % % % % % --------- Using 19 parameters by cluster -----------
% % % ClusterIdx = find(ClusterGroup==1); % from 1 to 4
% % % X = [Kx_Lower(ClusterIdx), Kx_Upper(ClusterIdx), TransMultMiddle(ClusterIdx), Poro_Lower(ClusterIdx), Poro_Upper(ClusterIdx), KyKx_Upper(ClusterIdx), KyKx_Lower(ClusterIdx), OWC(ClusterIdx), WOCPc(ClusterIdx), OilAPI(ClusterIdx), SolGOR(ClusterIdx), KvKh_Upper(ClusterIdx), KvKh_Lower(ClusterIdx), Sw_Pc0(ClusterIdx), Sorw(ClusterIdx), GasGravity(ClusterIdx), RockComp(ClusterIdx), Swcr(ClusterIdx), Salinity(ClusterIdx)];
% % % [Loadings2, specVar2,T2,stats2] = factoran(X,2);
% % % VarLabels = {'01-Kx Lower', '02-Kx Upper', '03-TransMultMiddle', '04-Poro Lower', '05-Poro Upper', '06-KyKx Upper','07-KyKx Lower', '08-OWC', '09-WOC Pc=0', '10-Oil API', '11-Sol GOR', '12-KvKh Upper', '13-KvKh Lower', '14-Sw Pc=0','15-Sorw', '16-GasGrav', '17-RockComp', '18-Swcr', '19-Salinity'};
% % % 
% % % figure; % Two Common Factors
% % % biplot(Loadings2,'LineWidth',2,'MarkerSize',20, 'varlabels', num2str((1:19)'));
% % % annotation('textbox',[0.2 0.5 0.3 0.3],'String',VarLabels,'FitBoxToText','on');
% % % title('Two common factors');


%% PCA
% Principal component analysis of raw data
% Similar to Factor Analysis, but the number of common factors (or principal 
% components) is equal to the number of variables and from the explained
% output we can see the percentage of the total variance explained by each principal component 

% % % X = [InitialRPI, FinalCumOil, Kx_Lower, Kx_Upper, TransMultMiddle, Poro_Lower, Poro_Upper, KyKx_Upper, KyKx_Lower, OWC, WOCPc, OilAPI, SolGOR, KvKh_Upper, KvKh_Lower, Sw_Pc0, Sorw, GasGravity, RockComp, Swcr, Salinity];
X = [Kx_Lower, Kx_Upper, TransMultMiddle, Poro_Lower, Poro_Upper, KyKx_Upper, KyKx_Lower, OWC, WOCPc, OilAPI, SolGOR, KvKh_Upper, KvKh_Lower, Sw_Pc0, Sorw, GasGravity, RockComp, Swcr, Salinity];
[coeff,score,latent] = pca(X);
% % % [coeff,score,latent,tsquared,explained,mu] = pca(X); 


%% Manova
% Multivariate analysis of variance (MANOVA) is a procedure for comparing
% multivariate sample means. 

% manova1: performs a one-way Multivariate Analysis of Variance (MANOVA) for
% comparing the multivariate means of the columns of X, grouped by group. X
% is an m-by-n matrix of data values, and each row is a vector of
% measurements on n variables for a single observation. group is a grouping
% variable defined as a categorical variable, vector, character array, or
% cell array of character vectors. The function returns d, an estimate of the dimension of the space
% containing the group means. 

% D is a matrix of dependent variables and ClusterGroup is a vector with the
% independent variable (independent groups)
[d,p,stats] = manova1(D,ClusterGroup); 
figure; 
manovacluster(stats);

% % % [d,p,stats] = manova1(Kx_Lower,ClusterGroup); 
% % % figure; 
% % % manovacluster(stats);



end
