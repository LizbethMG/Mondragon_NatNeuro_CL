function [ data End ] = slmg_nextFromRecordedData( param, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin > 1
    session = varargin{1};
else
    session = -1;
end

persistent sampleNum;   % current sample number in the buffer
persistent rec;
persistent lastSession;

refElectrode = zeros(size(param.references));
refIndex=find(param.references~=0);
refElectrode(refIndex) = param.all_electrodes(param.references(refIndex));% [];

bufSize = 300;
persistent lastBuf;     % indicate that the end of the record is in the buffer.
persistent lastBufTime; % timestamp of the last sample in the buffer
persistent isEnd;       % flag that indicate that it is the end of the record

length = 60*60; %in seconds. %30 minutes

if (isempty(lastSession))
    newSession = true
elseif (lastSession~=session)
    newSession = true;
else
    newSession = false;
end

lastSession = session;

% in the case it is the first call,
% persistent variables shall be initialized
if newSession   % first callto the function
    lastBuf = false;
    isEnd = false;
    
    % if the length of the record is smaller than the buffersize
    if length<=bufSize
        lastBuf = true;
        lastBufTime = length;   %
    else
        lastBufTime = bufSize;
    end
    
    sampleNum = 1;
    
    [rec.data, rec.fs] = ...
        slmg_read_Intan_files(param.recordPath, [0 lastBufTime]);
    
    if size(rec.data.data,1) == size(param.selectedElectrodes,2)
        if ~(isempty(refElectrode) || (refElectrode==0))
            indice = find(param.selectedElectrodes == refElectrode(1));
            rec.data.data = rec.data.data - rec.data.data(indice, :); % select electrodes
        end
    else
        if (isempty(refElectrode) || (refElectrode==0))
            rec.data.data = rec.data.data(param.selectedElectrodes, :); % select electrodes
        else
            rec.data.data = rec.data.data(param.selectedElectrodes, :) - rec.data.data(refElectrode(1), :); % select electrodes
        end
    end
else
    sampleNum = sampleNum + 1; % get next sample
    
    if sampleNum>size(rec.data.data,2)  % if al the buffer has been read, need to load more
        if (lastBuf)    % end of the record reached
            isEnd = true;
        else
            sampleNum = 1;  % reset sample number in the buffer
            prevTime = lastBufTime + 1/rec.fs;
            lastBufTime = lastBufTime + bufSize;
            if length<=lastBufTime % check if it will be the last buffer
                lastBuf = true;
                lastBufTime = length;
            end
            
            [rec.data, rec.fs] = ...
                slmg_read_Intan_files(param.recordPath, [prevTime lastBufTime]);
            if (isempty(rec.data.data))
                isEnd=true;
            else
                if (isempty(refElectrode) || (refElectrode==0))
                    rec.data.data = rec.data.data(param.selectedElectrodes, :); % select electrodes
                else
                    rec.data.data = rec.data.data(param.selectedElectrodes, :) - rec.data.data(refElectrode, :); % select electrodes
                end
            end
        end
    end
    
end

if (~isEnd)
    data =  rec.data.data(:, sampleNum);
else
    data = zeros(size(param.selectedElectrodes'));
end

End = isEnd;

end

