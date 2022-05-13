
%%get real life signal from mcu. this is for the physical implementation
data = thingSpeakRead(1701579,'Fields',[1],'NumPoints',100,'ReadKey','S9C30E0VKKUQ4PX7');
dataw = data';
i = 1;
dataa = [];
%increasing the size of the matrix
for i = i:10
    dataa = horzcat(dataa,dataw);
end
Fs = 500;            %% the frequency of signals according to info
 Ts = 1/Fs;           %% sampling period of signals
 max = 2;            %% Duration of signals
 time = 0:Ts:max-Ts;  %% Time vector from 0 to 20 sec by 0.002 step
 
figure;
plot(time,dataa);
title('Raw mcu signal');
xlabel('Time(s)')
ylabel('Amplitude')
filtered_signal = ecgfunction(dataa);

% Showing the QRS complex and other features
t = 1:length(filtered_signal);
%for P waves
[~,locs_Pwave] = findpeaks(filtered_signal,'MinPeakHeight',-0.09,...
                                      'MinPeakDistance',25);

% for R waves
[~,locs_Rwave] = findpeaks(filtered_signal,'MinPeakHeight',0.25,...
                                    'MinPeakDistance',60);

%for S waves
ECG_inverted = -filtered_signal;
[~,locs_Swave] = findpeaks(ECG_inverted,'MinPeakHeight',0.5,...
                                        'MinPeakDistance',70);  

%for Q waves
[~,min_locs] = findpeaks(-filtered_signal,'MinPeakDistance',0.01);
locs_Qwave = min_locs(filtered_signal(min_locs)>-6.5 & filtered_signal(min_locs)<-4.5);

%for T waves
[~,locs_Twave] = findpeaks(filtered_signal,'MinPeakHeight',-0.02,...
                                      'MinPeakDistance',50);
figure
hold on 
plot(t,filtered_signal)
%plot(locs_Pwave,filtered_signal(locs_Pwave),'rs','MarkerFaceColor','y')
plot(locs_Qwave,filtered_signal(locs_Qwave),'rs','MarkerFaceColor','g')
plot(locs_Rwave,filtered_signal(locs_Rwave),'rv','MarkerFaceColor','r')
plot(locs_Swave,filtered_signal(locs_Swave),'rs','MarkerFaceColor','b')
%plot(locs_Twave,filtered_signal(locs_Twave),'rs','MarkerFaceColor','c')
grid on
title('Thresholding Peaks in Signal')
xlabel('Samples')
ylabel('Voltage(mV)')
legend('Filtered ECG signal','Q wave','R wave','S wave')   


%finding heart rate
distanceBetweenFirstAndLastPeaks = locs_Rwave(end) - locs_Rwave(1);
averageDistanceBetweenPeaks = distanceBetweenFirstAndLastPeaks/length(locs_Rwave);
averageHeartRate = 60 * Fs/averageDistanceBetweenPeaks;
disp('Heart Rate = ');
disp(averageHeartRate);

%QRS Duration
QRSlength = length(locs_Qwave) + length(locs_Rwave) + length(locs_Swave);
disp('QRS Duration = ');
disp(QRSlength);

%PR Interval
PRInterval = (locs_Rwave(1) - locs_Pwave(1));
disp('PR Interval = ');
disp(PRInterval);

%P Duration
disp('P Duration = ');
disp(length(locs_Pwave));
%% this is for the simulation
%load the signal;
rec1 = importdata('rec_1m.mat');

Fs = 500;            %% the frequency of signals according to info
 Ts = 1/Fs;           %% sampling period of signals
 max = 20;            %% Duration of signals
 time = 0:Ts:max-Ts;  %% Time vector from 0 to 20 sec by 0.002 step
%unfiltered part of signal
data1 = rec1(1,:);
%plot raw signal
figure; 
plot(time,data1);
title('Signal (rec_1)Original');
xlabel('Time(s)')
ylabel('Amplitude')

%filter the signal and show
filtered_signal = ecgfunction(data1);
figure;
plot(time,filtered_signal);
title('Signal (rec_1) Final Edition(after all filters)');
xlabel('Time(s)');
ylabel('Amplitude(mV)');


% Showing the QRS complex and other features
t = 1:length(filtered_signal);

%for P waves
[~,locs_Pwave] = findpeaks(filtered_signal,'MinPeakHeight',-0.09,...
                                      'MinPeakDistance',25);

% for R waves
[~,locs_Rwave] = findpeaks(filtered_signal,'MinPeakHeight',0.5,...
                                    'MinPeakDistance',200);

%for S waves
ECG_inverted = -filtered_signal;
[~,locs_Swave] = findpeaks(ECG_inverted,'MinPeakHeight',0.5,...
                                        'MinPeakDistance',200);  

%for Q waves
[~,min_locs] = findpeaks(-filtered_signal,'MinPeakDistance',40);
locs_Qwave = min_locs(filtered_signal(min_locs)>-20 & filtered_signal(min_locs)<-15);

%for T waves
[~,locs_Twave] = findpeaks(filtered_signal,'MinPeakHeight',-0.02,...
                                      'MinPeakDistance',50);

figure
hold on 
plot(t,filtered_signal)
%plot(locs_Pwave,filtered_signal(locs_Pwave),'rs','MarkerFaceColor','y')
plot(locs_Qwave,filtered_signal(locs_Qwave),'rs','MarkerFaceColor','g')
plot(locs_Rwave,filtered_signal(locs_Rwave),'rv','MarkerFaceColor','r')
plot(locs_Swave,filtered_signal(locs_Swave),'rs','MarkerFaceColor','b')
%plot(locs_Twave,filtered_signal(locs_Twave),'rs','MarkerFaceColor','c')
grid on
title('Thresholding Peaks in Signal')
xlabel('Samples')
ylabel('Voltage(mV)')
legend('Filtered ECG signal','Q wave','R wave','S wave')                           


%finding heart rate
distanceBetweenFirstAndLastPeaks = locs_Rwave(end) - locs_Rwave(1);
averageDistanceBetweenPeaks = distanceBetweenFirstAndLastPeaks/length(locs_Rwave);
averageHeartRate = 60 * Fs/averageDistanceBetweenPeaks;
disp('Heart Rate = ');
disp(averageHeartRate);

%QRS Duration
QRSlength = length(locs_Qwave) + length(locs_Rwave) + length(locs_Swave);
disp('QRS Duration = ');
disp(QRSlength);

%PR Interval
PRInterval = (locs_Rwave(1) - locs_Pwave(1));
disp('PR Interval = ');
disp(PRInterval);

%P Duration
disp('P Duration = ');
disp(length(locs_Pwave));



