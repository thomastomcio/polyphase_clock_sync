clear; close all; clc;

% ###### TRANSMITER #####
Nsym = 6;           % Filter span in symbol durations
beta = 0.5;         % Roll-off factor
sampsPerSym = 32;    % Upsampling factor

% Parameters
DataL = 20;             % Data length in symbols
R = 1000;               % Data rate
Fs = R * sampsPerSym;   % Sampling frequency

% data for filtering
data = 2*randi([0 1],DataL,1) - 1;

% Design raised cosine filter with given order in symbols
srrc_transmit_filter = comm.RaisedCosineTransmitFilter(...
  'Shape',                  'Square root', ...
  'RolloffFactor',          beta, ...
  'FilterSpanInSymbols',    Nsym, ...
  'OutputSamplesPerSymbol', 2*sampsPerSym);


filteredData_transmit = srrc_transmit_filter([data; zeros(Nsym/2,1)]);

% Upsample and filter.
% yc = rctFilt3([x; zeros(Nsym/2,1)]);
% Correct for propagation delay by removing filter transients
fltDelay = Nsym / (2*R);
filteredData_transmit = filteredData_transmit(fltDelay*Fs+1:end);

t_trasmit = (fltDelay*Fs:length(filteredData_transmit)-1+fltDelay*Fs)/(sampsPerSym * Fs);
leg = [];
figure(1);
plot(t_trasmit, filteredData_transmit, 'r.'); hold on;
leg = ["transmit filtered data", leg];
legend(leg); hold on;

% ###### RECEIVER #####

% data for filtering
data_rec = filteredData_transmit;
% data = 2*randi([0 1],DataL,1) - 1;
% data = [zeros(DataL*sampsPerSym*sampsPerSym/2, 1); 1; zeros(DataL*sampsPerSym*sampsPerSym/2, 1)];

% Design and normalize filter.
prev = 0;

for k=0:sampsPerSym-1

rcrFilt = comm.RaisedCosineReceiveFilter(...
  'Shape',                  'Square root', ...
  'RolloffFactor',          beta, ...
  'FilterSpanInSymbols',    Nsym, ...
  'InputSamplesPerSymbol',  2*sampsPerSym, ...
  'DecimationFactor',       sampsPerSym, ...
  'DecimationOffset', k);

x = [data_rec; zeros(sampsPerSym - rem(length(data_rec), sampsPerSym), 1)];
filtered_data = rcrFilt(x);
fltDelay = Nsym / (2*R);

filtered_data = filtered_data(fltDelay*Fs/sampsPerSym+1:end);
tk =((k/sampsPerSym) : (length(filtered_data) + k/sampsPerSym - 1/sampsPerSym)) * 1/Fs;

if (max(filtered_data - prev) == 0)
    wynik = 'tak';
else
    wynik = 'nie';
end
% disp(wynik);

prev = filtered_data ;

figure(1);
    leg = [leg; [string(k)]];
    plot(tk, filtered_data); hold on; grid on;
    legend(leg);        
    pause(0.1);
end;

    tx = (fltDelay*Fs/sampsPerSym : ( fltDelay*Fs/sampsPerSym + DataL - 1)) * 2/Fs;

% to = 1000 * (0: DataL*sampsPerSym - 1) / Fs;

% % Plot data.
    figure(1);
    stem(tx, data, 'kx'); hold on;

return;
% 
% Nsym = 6;           % Filter span in symbol durations
% beta = 0.5;         % Roll-off factor
% sampsPerSym = 2;    % Upsampling factor
% 
% % Parameters
% DataL = 20;             % Data length in symbols
% R = 1000;               % Data rate
% Fs = R * sampsPerSym;   % Sampling frequency
% 
% % data for filtering
% data = 2*randi([0 1],DataL,1) - 1;
% 
% % Design raised cosine filter with given order in symbols
% srrc_transmit_filter = comm.RaisedCosineTransmitFilter(...
%   'Shape',                  'Square root', ...
%   'RolloffFactor',          beta, ...
%   'FilterSpanInSymbols',    Nsym, ...
%   'OutputSamplesPerSymbol', sampsPerSym);
% 
% fltDelay = Nsym / (2*R);
% 
% filteredData_transmit = srrc_transmit_filter([data; zeros(Nsym/2,1)]);

% Upsample and filter.
% yc = rctFilt3([x; zeros(Nsym/2,1)]);
% Correct for propagation delay by removing filter transients
% filteredData_transmit = filteredData_transmit(fltDelay*Fs+1:end);

% tx = 1000 * (0: DataL - 1) / R;
% to = 1000 * (0: DataL*sampsPerSym - 1) / Fs;

% % Plot data.
% figure(1);
% stem(tx, data, 'kx'); hold on;
% % Plot filtered data.
% plot(to, filteredData, 'm-'); hold off;
% % Set axes and labels.
% axis([0 25 -1.7 1.7]);  xlabel('Time (ms)'); ylabel('Amplitude');
% legend('Transmitted Data','Sqrt. Raised Cosine','Location','southeast')

