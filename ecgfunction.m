function [filtered_signal] = ecgfunction(rec1)
% Function to filter ecg signals
%   Two filters used, a moving acerage filter and a high pass filter. A
%   notch filter is used if signal is from a source connected to the mains
%   power supply of 50 hz frequency.

%for simulation
%%% Unfiltered signal "First row of the signal matrix"
 data1 = rec1;
 Fs = 500;            %% the frequency of signals according to info
 
 % high pass filter
[b,a] = cheby2(4,20,0.6/(Fs/2),'high'); %% cheby2(order,stopband ripple,stopband-edge frequency)
%%% Zero-phase forward and reverse digital IIR filtering
HPdata1 = filtfilt(b,a,data1);

% Moving average Filter
avgFiltB = ones(1,7)/7; %% Window design of 7-points

%%% filtering data using One-dimensional digital filter.
MAdata1 = filter(avgFiltB,1,HPdata1);

%notch filter
Wo = 50/(Fs/2);  BW = Wo/35;
[b,a] = iirnotch(Wo,BW);  
notchnew = filter(b,a,MAdata1);
filtered_signal = notchnew;

end

