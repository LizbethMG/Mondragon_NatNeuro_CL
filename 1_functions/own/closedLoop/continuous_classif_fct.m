function [TimestampsPredict] = continuous_classif_fct(config)

% Configuring neural network paths
config.NNConf = fullfile('3_nns', [config.nn_experiment '.mat']);

% Setting up parameters and configurations
param = config.param;
divPower = config.param.divPower;
hasPower = config.param.hasPower;
config.recordPath = fullfile(config.recordRoot, config.subject);

% End of configuration

% Defining electrode configurations
config.TT1 = [8 9 10 3];
config.TT2 = [2 11 12 13];
config.TT3 = [14 15 16 17];
config.TT4 = [18 19 20 29];
config.TT5 = [28 21 22 23];
config.TT6 = [24 25 26 27];
config.TT7 = [30 31 0 1];
config.TT8 = [4 5 6 7];
config.all_electrodes = [config.TT1 config.TT2 config.TT3 config.TT4 config.TT5 config.TT6 config.TT7 config.TT8] + 1;
config.selectedElectrodes = config.all_electrodes(config.electrodes_to_keep);

% Duration calculation in milliseconds
duration = config.analysis_window_duration * 60 * 1000;

param.nElectrodes = length(config.selectedElectrodes);

isEnd = false;
resultCount = 0;
timeShiftSample = round(param.fcc.timeShift * param.fs / 1000);  % Number of fcc shift samples.

% Buffer initialization
Buffer = zeros(param.nElectrodes, ceil(param.fcc.windowLength / 1000 * param.fs));
BufMfcc = zeros(param.nElectrodes, param.fcc.nCoefs + hasPower, param.NN.winLength);
lastToken = zeros(1, param.nToken);
res = zeros(param.nElectrodes, 2);

% Loading neural network model
load(config.NNConf);
if isfield(NN, 'NN')
    NN = NN.NN;
end
sizeInputs = param.NN.winLength * (param.fcc.nCoefs + hasPower);

% Displaying experiment info
fprintf('Ready to start.\n');
fprintf('Signal to monitor:\t');
disp(config.selectedElectrodes);
fprintf('Reference(s):\t');
disp(config.references);
fprintf('Duration of experiment: %d minutes\n', config.analysis_window_duration);
fprintf('\n\n');

totalDuration = 0;
inhib = 1000;   % Inhibition duration for detection
stimulationCount = 0;
time_elapsed = 0;
TimestampsPredict = [];

tic_done = false;

% Ensuring recording starts from the beginning by managing session numbers
persistent session;
if isempty(session)
    session = 1;
else
    session = session + 1;
end

while (~isEnd)
    Buffer(:, 1:end - timeShiftSample) = Buffer(:, timeShiftSample + 1:end);
    BufMfcc(:, :, 1:end - 1) = BufMfcc(:, :, 2:end);
    lastToken(1:end - 1) = lastToken(2:end);

    if ~tic_done
        time_elapsed = 0;
        tic_done = true;
    end

    % Acquiring the next data sample
    for i = 1:timeShiftSample
        [Buffer(:, end - timeShiftSample + i), isEnd] = slmg_nextFromRecordedData(config, session);
    end
    time_elapsed = time_elapsed + timeShiftSample / param.fs;

    % Computing fcc and power for each electrode
    for iEl = 1:param.nElectrodes
        [BufMfcc(iEl, 1:end - hasPower, end), ~, ~] = slmg_mfcc(Buffer(iEl, :), param.fs, param.fcc.windowLength, param.fcc.timeShift, [], [], [param.fcc.lf param.fcc.hf], param.fcc.nFilterBank, param.fcc.nCoefs, param.fcc.sineLift);

        % Normalizing fcc
        BufMfcc(iEl, 1:end - hasPower, end) = BufMfcc(iEl, 1:end - hasPower, end) - mean(BufMfcc(iEl, 1:end - hasPower, end), 2); % Centering per sample
        BufMfcc(iEl, 1:end - hasPower, end) = BufMfcc(iEl, 1:end - hasPower, end) ./ max(BufMfcc(iEl, 1:end - hasPower, end), [], 2); % Normalizing per sample

        % Computing signal power
        if hasPower == 1
            power = slmg_power(Buffer(iEl, :), param.fcc.windowLength, param.fcc.timeShift, param.fs);
            power = (power - divPower) / divPower;
            BufMfcc(iEl, end, end) = power;
        end
    end

    % Decision-making process
    resultCount = resultCount + 1;

    % Computing a decision if there's no inhibition
    if inhib == 0
        [Result] = slmg_ClassNNdecision(res, param.nElectrodes, param);
        detectionNotFiltered(resultCount) = Result(:, 1);
        lastToken(end) = Result(:, 1);
        detectionFiltered(resultCount) = sum(lastToken) > param.nToken / 2;

        % Handling a positive prediction
        if detectionFiltered(resultCount) == 1
            inhib = max(0, config.inhibition_duration * 1000 - param.fcc.timeShift);
            stimulationCount = stimulationCount + 1;
            TimestampsPredict = [TimestampsPredict, time_elapsed];
        end
    else
        inhib = max(inhib - param.fcc.timeShift, 0);
        detectionNotFiltered(resultCount) = false;
        lastToken(end) = 0;
        detectionFiltered(resultCount) = false;
    end

    % Neural network computation for each electrode
    for iEl = 1:param.nElectrodes
        inputs = reshape(BufMfcc(iEl, :, :), 1, sizeInputs);
        NN.inputs = inputs;
        NN = slmg_NNCompute(NN);
        res(iEl, :) = NN.outputLayer.Outputs';
    end

    % Checking total elapsed time and ending if the duration is reached
    if config.stopOnDuration
        totalDuration = totalDuration + param.fcc.timeShift;
        if totalDuration >= duration
            isEnd = true;
        end
    end
end

% Displaying the number of predictions at the end of the recording
num_predictions = length(TimestampsPredict);
fprintf('End of recording, number of predictions: %d \n', num_predictions);

