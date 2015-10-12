%clean all

clear all
close all
imtool close all

set(gcf,'color','w');
set(gca,'color','w');

%(c)
load('dataset3.mat');
inputData = data;
K = 10;
stopTolerance = 0.00001;
numberOfRuns = 10;

[LK, BICK, maxK] = BIC(inputData, K, stopTolerance, numberOfRuns);