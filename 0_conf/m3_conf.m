function [config] = m3_conf()
%M1_CONF configuration file for demo data of experiment m1

config.subject = 'm3';
config.nn_experiment = 'NN_m3';
config.analysis_window_duration = 10; % Duration in minutes of the analysis timeframe

config.recordRoot = fullfile(pwd,'4_data');

% Hardware setup
% Specifies the electrodes used for the neural network, excluding the reference electrode(s).
config.electrodes_to_keep = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24];

% Reference electrodes configuration.
% Use 0 for no reference.
config.references = 0;

% Timing configurations
% Post detection IDLE period in seconds.
config.inhibition_duration = 4; 

% If true, the analysis stops at analysis_window_duration.
% otherwise, it stops when reaching the end of the recording
config.stopOnDuration = true; 

% Cepstral coeficient parameters
config.param.fs = 20000; % Should align with the sampling rate selected for the ADC.
config.param.fcc.windowLength = 1000; % Window length in milliseconds.
config.param.fcc.timeShift = 200; % Time shift in milliseconds.
config.param.fcc.lf = 1;
config.param.fcc.hf = 5;
config.param.fcc.nFilterBank = 7;
config.param.fcc.nCoefs = 7;
config.param.fcc.sineLift = 20;

config.param.divPower = 2;
config.param.hasPower = 1;

config.param.NN.winLength = 5;

% output step function threshold.
config.param.decision_threshold = -0.3;

% Minimum required percentage of simultaneous electrode detection.
config.param.percent_min = 0.9;

config.param.nToken = 1; 

end
