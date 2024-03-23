function [ D ] = slmg_ClassNNdecision( X, nElectrodes, param )
%slmg_ClassNNdecision Perform the decision
% Inputs:
%   X: result(s) (output) of the neural network(s), first column is the result of
%       the Grooming detected output and second, the output of Other Behavior detected.
%       X has one row per electrode
%   nElectrodes: number of electrodes. (shall)
%   param:
%       param.percent_min: minimum ratio of electrodes on which a grooming is detected
%               to get a global decision equivalent
%       param.decision_threshold: threshold of detection of a class. If it is a vector,
%               will perform the decision for each specified values. It's value is between
%               -1 (never detected) and 1 (always detected), default is 0
% return value:
%   1 : Class 1 (Grooming)
%   2 : Class 2 (Other Behavior)
%   0 : No class

    % default electrodes number: 1
    if nargin==1
        nElectrodes=1;
    end
    % default percent_min: 0.5, default decision_threshold: 0
    if nargin<=2
        param.percent_min=0.5;
        param.decision_threshold=0;
    end

    % number of decision threshold provided
    nDecisionThreshold = length(param.decision_threshold);
    
    % for each decision threshold, compute the decision result
    for i=1:nDecisionThreshold
        % add a decision threshold to tune the sensitivity
        Decision = [(X(:,1)>param.decision_threshold(i))   (X(:,2) >= -param.decision_threshold(i))];
        Dtemp = (Decision(:,1) ~=Decision(:,2)) .* Decision;
        
        % Regroup 
        n = size(Dtemp,1) / nElectrodes;
        M = reshape(repmat(reshape(eye(n),1,n*n), nElectrodes, 1), nElectrodes*n, n);
        
        D1 = (Dtemp(:,1)' * M)'>=(nElectrodes * param.percent_min);
        D2 = (Dtemp(:,2)' * M)'>(nElectrodes * (1-param.percent_min));
        Dtemp = [D1 D2] * 1;

        % if D doesn't exists yet, create it
        if ~exist('D','var')
            D = zeros(size(Dtemp,1), size(Dtemp,2), nDecisionThreshold);
        end
        D(:,:,i) = Dtemp;
    end
end

