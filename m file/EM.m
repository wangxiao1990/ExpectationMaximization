function [clusterParameters, estimatedLabels, logLikelihood, costVsComplexity] = EM(inputData, numberOfClusters, stopTolerance, numberOfRuns)
% The implementation MUST be a function that takes the following inputs:
% i. inputData: nSamples x dDimensions array with the data to be clustered
% ii. numberOfClusters: number of cluster for algorithm
% iii. stopTolerance: parameter for convergence criteria
% iv. numberOfRuns: number of times the algorithm will run with random initializations
% The function should output the results for best EM clustering. The outputs should be:
% i. clusterParameters: numberOfClusters x 1 struct array with the Gaussian mixture parameters:
% ? .mu - mean of the Gaussian component
% ? .covariance - covariance of the Gaussian component
% ? .prior - prior of the Gaussian component
% ii. estimatedLabels: nSamples x 1 vector with labels based on maximum probability. 
% iii. logLikelihood: 1 x numberOfIterations vector with the log-likelihood as a function of iteration number
% iv. costVsComplexity: 1 x maxNumberOfClusters vector with BIC criteria as a function of number of clusters 

n = size(inputData,1);
if size(inputData,2) > 2
    d = size(inputData,2) - 1;
else d = size(inputData,2);
end

estimatedLabels = zeros(n,1);
estimatedMeans = cell(numberOfClusters, 1);
estimatedPrior = cell(numberOfClusters, 1);

threshold = ones(d,1);
for i = 1:d
    threshold(i,1) = cov(inputData(:,d)) * 0.0001;
end

for num = 1:numberOfRuns
    cov_temp = cell(numberOfClusters, 1);
    cov_temp(:) = {eye(d)};
    prior_temp = ones(numberOfClusters, 1)/numberOfClusters;
    means_temp = zeros(numberOfClusters, d);
    probability = ones(1,n)/n;
    for j = 1:numberOfClusters
        means_temp(j,1:d) = inputData(randsrc(1,1,[(1:n); probability]),1:d);
        dx = pdist2(inputData(:,1:d),means_temp(1:j,1:d)).^2;
        Dx = min(dx,[],2);
        probability = Dx'/sum(Dx);
    end
    
    newLogLikelihood = inf;
    oldLogLikelihood = 0;
    firstLogLikelihood = 0;
    
    iteration = 0;
    while iteration == 0 || (abs(newLogLikelihood - oldLogLikelihood) > stopTolerance * abs(newLogLikelihood - firstLogLikelihood) && iteration < 100)
        iteration = iteration + 1;
        oldLogLikelihood = newLogLikelihood;
        
        Ez = zeros(n,numberOfClusters);
        py = zeros(n,1);
        
        for i = 1:n
            pj = zeros(1,numberOfClusters);
            for j = 1:numberOfClusters
                pj(j) = (2*pi)^(-d/2)*(det(cov_temp{j,1}))^(-1/2)*exp((-1/2)*(inputData(i,1:d)-means_temp(j,:))/cov_temp{j,1}*(inputData(i,1:d)-means_temp(j,:))')*prior_temp(j);
            end
            py(i,1) = sum(pj);
            Ez(i,:) = pj./sum(pj);  
        end

        newLogLikelihood = sum(log(py));
        logLikelihood_temp(iteration) = newLogLikelihood;             
        [~,labels] = max(Ez,[],2);
   
        if iteration == 1
            firstLogLikelihood = newLogLikelihood;
        end
        
        pk = numberOfClusters - 1 + numberOfClusters * d + numberOfClusters * d*(d+1)/2;
        BIC = newLogLikelihood - pk / 2 * log(n);
               
        prior_temp = sum(Ez,1) ./ n;
        for j = 1:numberOfClusters
            means_temp(j,:) = (inputData(:,1:d)'*Ez(:,j))' / (n*prior_temp(j));
            temp = zeros(d,d);
            for i = 1:n
                temp = temp + Ez(i,j)*(inputData(i,1:d)-means_temp(j,:))'*(inputData(i,1:d)-means_temp(j,:));
            end
            cov_temp{j,1} = temp / (n*prior_temp(j));
            
            for k = 1:d
                if cov_temp{j,1}(k,k) < threshold(k)
                    cov_temp{j,1}(k,k) = threshold(k);
                end              
            end
        end
    end
    
    if num == 1 || logLikelihood(size(logLikelihood,1)) < logLikelihood_temp(iteration)
        estimatedCov = cov_temp;
        for i = 1:numberOfClusters
            estimatedMeans(i,1) = {means_temp(i,:)};
            estimatedPrior(i,1) = {prior_temp(i)};
        end
        clusterParameters = struct('mu', estimatedMeans, 'covariance', estimatedCov, 'prior', estimatedPrior);
        estimatedLabels = labels;
        logLikelihood = logLikelihood_temp;
        costVsComplexity = BIC;
    end
    logLikelihood_temp = [];
end