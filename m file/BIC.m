function [LK, BICK, maxK] = BIC(inputData, K, stopTolerance, numberOfRuns)
% LK; Log-likelihood for each value of K
% BICK: BIC for each value of K
% maxK: K value that maximizes the BIC criterion 

LK = zeros(1,K);
BICK = zeros(1,K);

for numberOfClusters = 1:K
[~, ~, logLikelihood, costVsComplexity] = EM(inputData, numberOfClusters, stopTolerance, numberOfRuns);
LK(numberOfClusters) = logLikelihood(size(logLikelihood,2));
BICK(numberOfClusters) = costVsComplexity;
end

[~,maxK] = max(BICK,[],2);

plot(1:K,BICK(1,:),'LineWidth',2);
xlabel('K');
ylabel('BIC');
title('BIC for k from 1 to 10');