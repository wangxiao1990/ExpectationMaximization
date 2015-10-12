%clean all

clear all
close all
imtool close all

set(gcf,'color','w');
set(gca,'color','w');

%(d)
load('dataset3.mat');
inputData = data;
numberOfClusters = 2;
stopTolerance = 0.00001;
numberOfRuns = 10;
[clusterParameters, estimatedLabels, logLikelihood, costVsComplexity] = EM(inputData, numberOfClusters, stopTolerance, numberOfRuns);

subplot(1,3,1);
for i = 1:size(estimatedLabels)
    if  inputData(i,3) == 1 
        c1 = plot(inputData(i,1),inputData(i,2), 'r.');
        hold on;
    else c2 = plot(inputData(i,1),inputData(i,2), 'b.');
        hold on;
    end
end
title('True Clustering','FontSize',12);
legend([c1 c2],'Cluster 1','Cluster 2',4)
xlabel('x','FontSize',12);
ylabel('y','FontSize',12);

subplot(1,3,2);
for i = 1:size(estimatedLabels)
    if estimatedLabels(i) == 1 
        c1 = plot(inputData(i,1),inputData(i,2), 'r.');
        hold on;
    else c2 = plot(inputData(i,1),inputData(i,2), 'b.');
        hold on;
    end
end

x1 = clusterParameters(1).mu(1);
y1 = clusterParameters(1).mu(2);
a1 = sqrt(2*clusterParameters(1).covariance(1,1));
b1 = sqrt(2*clusterParameters(1).covariance(2,2));
[A1,~] = qr(clusterParameters(1).covariance);
phi1 = -atan(A1(1,2)/A1(1,1));
[X1, Y1] = plotEllipse(x1, y1, a1, b1, phi1);
plot(X1, Y1,'LineWidth',2,'Color','r');

x2 = clusterParameters(2).mu(1);
y2 = clusterParameters(2).mu(2);
a2 = sqrt(2*clusterParameters(2).covariance(1,1));
b2 = sqrt(2*clusterParameters(2).covariance(2,2));
[A2,~] = qr(clusterParameters(2).covariance);
phi2 = -atan(A2(1,2)/A2(1,1));
[X2, Y2] = plotEllipse(x2, y2, a2, b2, phi2);
plot(X2, Y2,'LineWidth',2,'Color','b');

% options = statset('Display','final');
% gm = fitgmdist(inputData(:,1:2),2,'Options',options);
% xRange = [floor(min(inputData(:,1))),ceil(max(inputData(:,1)))];
% yRange = [floor(min(inputData(:,2))),ceil(max(inputData(:,2)))];
% ezcontour(@(x,y)pdf(gm,[x y]),xRange,yRange);

title('EM Clustering','FontSize',12);
legend([c1,c2],'Cluster 1','Cluster 2',4)
xlabel('x','FontSize',12);
ylabel('y','FontSize',12);

subplot(1,3,3);
plot(1:size(logLikelihood,2),(logLikelihood(1:size(logLikelihood,2))),'LineWidth',2);
title('Log-likelihood','FontSize',12);
xlabel('iteration','FontSize',12);
ylabel('Log-likelihood','FontSize',12);

disp('iterations')
disp(size(logLikelihood,2))
disp('log-likelihood')
disp(logLikelihood(size(logLikelihood,2)))