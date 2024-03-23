function [ D ] = slmg_NNdecision( X, nElectrodes )
%UNTITLED3 Summary of this function goes here
% return value:
%   1 : Class 1
%   2 : Class 2
%   0 : No class
    if nargin==1
        nElectrodes=1;
    end

    X = X>0;
    D = (X(:,1) ~=X(:,2)) .* X;

    % Regroup 
    n = size(D,1) / nElectrodes;
    M = reshape(repmat(reshape(eye(n),1,n*n), nElectrodes, 1), nElectrodes*n, n);
    
    % More than 50% of the electrodes
    percent_min = 0.5; % 50%:0.5
    D1 = (D(:,1)' * M)'>(nElectrodes*percent_min);
    D2 = (D(:,2)' * M)'>(nElectrodes*(1-percent_min));
    D = [D1 D2] * 1;
end

