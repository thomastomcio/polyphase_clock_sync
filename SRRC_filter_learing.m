clc; clear; close all;

Nsym = 6;           % Filter span in symbol durations
beta = 0.5;         % Roll-off factor
sampsPerSym = 2;    % Upsampling factor

% Parameters
DataL = 20;             % Data length in symbols
R = 1000;               % Data rate
Fs = R * sampsPerSym;   % Sampling frequency

% Create a local random stream to be used by random number generators for
% repeatability
hStr = RandStream('mt19937ar','Seed',0);

% Generate random data
x = 2*randi(hStr,[0 1],DataL,1)-1;
% Time vector sampled at symbol rate in milliseconds
tx = 1000 * (0: DataL - 1) / R;

% Design raised cosine filter with given order in symbols
rctFilt3 = comm.RaisedCosineTransmitFilter(...
  'Shape',                  'Square root', ...
  'RolloffFactor',          beta, ...
  'FilterSpanInSymbols',    Nsym, ...
  'OutputSamplesPerSymbol', sampsPerSym);


fltDelay = Nsym / (2*R);
to = 1000 * (0: DataL*sampsPerSym - 1) / Fs;


% Upsample and filter.
yc = rctFilt3([x; zeros(Nsym/2,1)]);
% Correct for propagation delay by removing filter transients
yc = yc(fltDelay*Fs+1:end);
% Plot data.
figure(1);
stem(tx, x, 'kx'); hold on;
% Plot filtered data.
stem(to, yc, 'm-'); hold off;
% Set axes and labels.
axis([0 25 -1.7 1.7]);  xlabel('Time (ms)'); ylabel('Amplitude');
legend('Transmitted Data','Sqrt. Raised Cosine','Location','southeast')


% Design and normalize filter.
rcrFilt = comm.RaisedCosineReceiveFilter(...
  'Shape',                  'Square root', ...
  'RolloffFactor',          beta, ...
  'FilterSpanInSymbols',    Nsym, ...
  'InputSamplesPerSymbol',  sampsPerSym, ...
  'DecimationFactor',       1);


fltDelay = Nsym / (2*R);
% Correct for propagation delay by removing filter transients


% Filter at the receiver.
yr = rcrFilt([yc; zeros(Nsym*sampsPerSym/2, 1)]);
% Correct for propagation delay by removing filter transients
yr = yr(fltDelay*Fs+1:end);


% Filter at the receiver.
yr = rcrFilt([yc; zeros(Nsym*sampsPerSym/2, 1)]);
% Correct for propagation delay by removing filter transients
yr = yr(fltDelay*Fs+1:end);
% Plot data.
figure(2);
stem(tx, x, 'kx'); hold on;
% Plot filtered data.
stem(to, yr, 'b-'); hold off; %,to, yo, 'm:'
% Set axes and labels.
axis([0 25 -1.7 1.7]);  xlabel('Time (ms)'); ylabel('Amplitude');
legend('Transmitted Data','Rcv Filter Output', ...
    'Raised Cosine Filter Output','Location','southeast')
