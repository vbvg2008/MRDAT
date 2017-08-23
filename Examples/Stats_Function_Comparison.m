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

D = [InitialRPI, log(FinalCumOil)];

%% Clustering 

LinkageMethod = 'ward'; 

% Cluster Evaluation (up to 15 clusters)
eva1 = evalclusters(D,'linkage','CalinskiHarabasz','KList',[1:10]);
eva2 = evalclusters(D,'linkage','DaviesBouldin','KList',[1:10]);
eva3 = evalclusters(D,'linkage','gap','KList',[1:10]);
eva4 = evalclusters(D,'linkage','silhouette','KList',[1:10]);

%MaxNumClusters = 10;
MaxNumClusters = mode([eva1.OptimalK eva2.OptimalK eva3.OptimalK eva4.OptimalK]); % Optimal number of clusters

T1 = clusterdata(D,'linkage',LinkageMethod,'maxclust',MaxNumClusters);
T2 = kmeans(D, MaxNumClusters);
T3 = kmedoids(D,MaxNumClusters);

% Scatter plot by cluster 
figure; 
subplot(1,3,1);
scatter(D(:,1),D(:,2),[],T1, 'filled');
xlabel('Initial RPI (psi/STB/D)');
ylabel('Final Cumulative Oil Production (STB)');
title('clusterdata function');
grid on;

subplot(1,3,2);
scatter(D(:,1),D(:,2),[],T2, 'filled');
xlabel('Initial RPI (psi/STB/D)');
ylabel('Final Cumulative Oil Production (STB)');
title('kmeans function');
grid on;

subplot(1,3,3);
scatter(D(:,1),D(:,2),[],T3, 'filled');
xlabel('Initial RPI (psi/STB/D)');
ylabel('Final Cumulative Oil Production (STB)');
title('kmedoids function');
grid on;

% Cluster evaluation by Silhouette
figure; 
subplot(1,3,1);
silhouette(D,T1); grid on;
title('clusterdata function');

subplot(1,3,2);
silhouette(D,T2); grid on;
title('kmeans function');

subplot(1,3,3); 
silhouette(D,T3); grid on;
title('kmedoids function');

% Importance of attributes (predictors) using ReliefF algorithm
X = [Kx_Lower, Kx_Upper, TransMultMiddle, Poro_Lower, Poro_Upper, KyKx_Upper, KyKx_Lower, OWC, WOCPc, OilAPI, SolGOR, KvKh_Upper, KvKh_Lower, Sw_Pc0, Sorw, GasGravity, RockComp, Swcr, Salinity];
%[ranked,weights] = relieff(X,FinalCumOil,10);
[ranked,weights] = relieff(X,InitialRPI,10);
figure;
bar(weights(ranked));
xlabel('Attributes rank');
ylabel('Attributes importance weight');

% Factor analysis is a statistical method used to describe variability
% among observed, correlated variables in terms of a potentially lower
% number of unobserved variables called factors. For example, it is
% possible that variations in six observed variables mainly reflect the
% variations in two unobserved (underlying) variables


% X is an n-by-d matrix where each row is an observation of d variables: 1512 x 19
% Rows (Observations - Cases) and Columns (Variables - Each sensitivity parameter) 
X = [Kx_Lower, Kx_Upper, TransMultMiddle, Poro_Lower, Poro_Upper, KyKx_Upper, KyKx_Lower, OWC, WOCPc, OilAPI, SolGOR, KvKh_Upper, KvKh_Lower, Sw_Pc0, Sorw, GasGravity, RockComp, Swcr, Salinity];
% Assuming the data can be correlated with two common factors
Loadings2F = factoran(X,2);
% Assuming the data can be correlated with three common factors
Loadings3F = factoran(X,3);
% Legend
VarLabels = {'01-Kx Lower', '02-Kx Upper', '03-TransMultMiddle', '04-Poro Lower', '05-Poro Upper', '06-KyKx Upper','07-KyKx Lower', '08-OWC', '09-WOC Pc=0', '10-Oil API', '11-Sol GOR', '12-KvKh Upper', '13-KvKh Lower', '14-Sw Pc=0','15-Sorw', '16-GasGrav', '17-RockComp', '18-Swcr', '19-Salinity'};
% Plotting results
figure; % Two Common Factors
biplot(Loadings2F,'LineWidth',2,'MarkerSize',20, 'varlabels', num2str((1:19)'));
annotation('textbox',[0.2 0.5 0.3 0.3],'String',VarLabels,'FitBoxToText','on');
title('Two common factors');

figure; % Three Common Factors
biplot(Loadings3F,'LineWidth',2,'MarkerSize',20, 'varlabels', num2str((1:19)'));
annotation('textbox',[0.2 0.5 0.3 0.3],'String',VarLabels,'FitBoxToText','on');
title('Three common factors');


% % % % --------- Using just the first 5 variables in FOPT Pareto Chart)-----------
% % % % Warning for X with 6 and 7 variables (+ Poro_Upper, OWC): Some unique variances are zero. With the first 5 variables works fine
% % % X = [Kx_Lower, TransMultMiddle, Kx_Upper, Poro_Lower, KyKx_Upper];
% % % Loadings2F = factoran(X,2);  
% % % Loadings3F = factoran(X,3); % Error: The number of factors requested, M, is too large for the number of the observed variables. 
% % % VarLabels = {'01-Kx Lower', '02-TransMultMiddle', '03-Kx Upper', '04-Poro Lower', '05-KyKx Upper'};
% % % figure; 
% % % biplot(Loadings2F,'LineWidth',2,'MarkerSize',20, 'varlabels', num2str((1:5)'));
% % % annotation('textbox',[0.2 0.5 0.3 0.3],'String',VarLabels,'FitBoxToText','on');


% % % % % % % --------- Using Initial RPI, FInalCumOil and all 19 parameters -----------
% % % X = [InitialRPI, FinalCumOil, Kx_Lower, Kx_Upper, TransMultMiddle, Poro_Lower, Poro_Upper, KyKx_Upper, KyKx_Lower, OWC, WOCPc, OilAPI, SolGOR, KvKh_Upper, KvKh_Lower, Sw_Pc0, Sorw, GasGravity, RockComp, Swcr, Salinity];
% % % Loadings2F = factoran(X,2); % Warning: Some unique variances are zero
% % % Loadings3F = factoran(X,3); % Warning: Some unique variances are zero
% % % VarLabels = {'01-Initial RPI', '02-FinalCumOil', '03-Kx Lower', '04-Kx Upper', '05-TransMultMiddle', '06-Poro Lower', '07-Poro Upper', '08-KyKx Upper','09-KyKx Lower', '10-OWC', '11-WOC Pc=0', '12-Oil API', '13-Sol GOR', '14-KvKh Upper', '15-KvKh Lower', '16-Sw Pc=0','17-Sorw', '18-GasGrav', '19-RockComp', '20-Swcr', '21-Salinity'};
% % % figure; % Two Common Factors
% % % biplot(Loadings2F,'LineWidth',2,'MarkerSize',20, 'varlabels', num2str((1:21)'));
% % % annotation('textbox',[0.2 0.5 0.3 0.3],'String',VarLabels,'FitBoxToText','on');
% % % title('Two common factors');
% % % 
% % % figure; % Three Common Factors
% % % biplot(Loadings3F,'LineWidth',2,'MarkerSize',20, 'varlabels', num2str((1:21)'));
% % % annotation('textbox',[0.2 0.5 0.3 0.3],'String',VarLabels,'FitBoxToText','on');
% % % title('Three common factors');


% % % % % % % --------- Using Initial RPI, FInalCumOil and some parameters -----------
% % % X = [InitialRPI, FinalCumOil, Kx_Lower, Kx_Upper, TransMultMiddle, Poro_Lower, Poro_Upper, KyKx_Upper, KyKx_Lower, OWC];
% % % Loadings2F = factoran(X,2); % Warning: Some unique variances are zero
% % % Loadings3F = factoran(X,3); % Warning: Some unique variances are zero
% % % VarLabels = {'01-Initial RPI', '02-FinalCumOil', '03-Kx Lower', '04-Kx Upper', '05-TransMultMiddle', '06-Poro Lower', '07-Poro Upper', '08-KyKx Upper','09-KyKx Lower', '10-OWC'};
% % % figure; % Two Common Factors
% % % biplot(Loadings2F,'LineWidth',2,'MarkerSize',20, 'varlabels', num2str((1:10)'));
% % % annotation('textbox',[0.2 0.5 0.3 0.3],'String',VarLabels,'FitBoxToText','on');
% % % title('Two common factors');
% % % 
% % % figure; % Three Common Factors
% % % biplot(Loadings3F,'LineWidth',2,'MarkerSize',20, 'varlabels', num2str((1:10)'));
% % % annotation('textbox',[0.2 0.5 0.3 0.3],'String',VarLabels,'FitBoxToText','on');
% % % title('Three common factors');


%% Manova
% Multivariate analysis of variance (MANOVA) is a procedure for comparing
% multivariate sample means. As a multivariate procedure, it is used when
% there are two or more dependent variables, and is typically followed
% by significance tests involving individual dependent variables
% separately. It helps to answer:
% 1. Do changes in the independent variable(s) have significant effects on the dependent variables?
% 2. What are the relationships among the dependent variables?
% 3. What are the relationships among the independent variables?


% D is a matrix of dependent variables and ClusterGroup is a vector with the
% independent variable (independent groups)
[d,p,stats] = manova1(D,ClusterGroup); 
figure; 
manovacluster(stats,'ward');


%%%
x = [InitialRPI, FinalCumOil, Kx_Lower, Kx_Upper, TransMultMiddle];
figure;
gplotmatrix(x,[],ClusterGroup,[],'+');

