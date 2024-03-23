function [ NN ] = slmg_NNCompute( NN )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    dec = NN.params.windowSize - NN.params.overlapping;

    % Perform the computation of the hidden layer
    for iPartialLayer = 1:NN.params.numPartialLayers
        
        iFirstInput = (iPartialLayer - 1) * dec * NN.params.sampleSize + 1;
        iLastInput = iFirstInput + (NN.params.singleInputSize-1);
        
        NN.hiddenLayer.WeightedInputs(:, iPartialLayer) = NN.hiddenLayer.Weights(:,:, iPartialLayer) * ...
            [NN.inputs(iFirstInput:iLastInput) 1]';
        
        iFirst = (iPartialLayer - 1) * NN.params.sizeHiddenLayer + 1;
        iLast = iFirst + NN.params.sizeHiddenLayer - 1;
        
        % transfer function
        NN.hiddenLayer.Outputs(iFirst:iLast, 1) = tansig(NN.hiddenLayer.WeightedInputs(:, iPartialLayer));
        
    end
    
    % perform the computation of the output layer
    NN.outputLayer.WeightedInputs = NN.outputLayer.Weights(:,:) * [NN.hiddenLayer.Outputs; 1];

    % transfer function
    NN.outputLayer.Outputs = tansig(NN.outputLayer.WeightedInputs);

end

