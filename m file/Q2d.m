%clean all

clear all
close all
imtool close all

set(gcf,'color','w');
set(gca,'color','w');

%(d)
run('dataset4.m');
inputData = x;
K = 10;
stopTolerance = 0.00001;
numberOfRuns = 10;

[LK, BICK, maxK] = BIC(inputData, K, stopTolerance, numberOfRuns);