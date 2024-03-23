function [ power ] = slmg_power( data, window, windowShift, fs )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

windowLength = ceil(window*fs/1000);
shiftLength = ceil(windowShift*fs/1000);

nVal = round((length(data)-windowLength)/shiftLength+1);
power = zeros(1, nVal);

for i=1:nVal
   start = i*shiftLength+1;
   stop = min(windowLength + i*shiftLength, length(data));
   dataWin = data(start:stop)/1000; % divide by 1000 because mV
   power(i) = dataWin*dataWin'/(2*(stop-start+1));
end


end