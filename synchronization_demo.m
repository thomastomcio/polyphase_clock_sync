clc; clear; close all;

rolloff = 0.1;
M = 2;         % Modulation order for BPSK
N_sym = 10;
nSym = 20000;  % Number of symbols in a packet
sampsPerSym = 4;       % Samples per symbol
timingErr = 1; % Samples of timing error
snr = 15;      % Signal-to-noise ratio (dB)

A = rcosdesign(rolloff, N_sym, sampsPerSym, 'sqrt'); % nadajnik

plot(A, 'kx');
hold on;

txfilter = comm.RaisedCosineTransmitFilter(...
'Shape',                  'Square root', ...
'RolloffFactor',          rolloff, ...
...% 'FilterSpanInSymbols',    N_sym, ...
'OutputSamplesPerSymbol', sampsPerSym);

rxfilter = comm.RaisedCosineReceiveFilter(...
  'Shape',                  'Square root', ...
  'RolloffFactor',          rolloff, ...
...%   'FilterSpanInSymbols',    N_sym, ... 
  'InputSamplesPerSymbol',  sampsPerSym, ...
  'DecimationFactor',       1);
%   'DecimationOffset', k);

tx_coeff = txfilter.coeffs.Numerator;
rx_coeff = rxfilter.coeffs.Numerator;
plot(rx_coeff, 'bo')
hold on; plot(tx_coeff, 'r.')

max( rx_coeff - A),
max( tx_coeff - A),
data = randi([0 M-1],nSym,1);
modSig = pskmod(data,M);
% stem(modSig(1:100));

fixedDelay = dsp.Delay(timingErr);
fixedDelaySym = ceil(fixedDelay.Length/sampsPerSym); % Round fixed delay to nearest integer in symbols

txSig = txfilter(modSig);
figure();
plot(real(txSig(1:10)), 'bo'); hold on;

delayedSig = fixedDelay(real(txSig));
plot(real(delayedSig(1:10)), 'k.');

rxSig = delayedSig;
rxSig = awgn(delayedSig,snr,'measured');
rxSample = rxfilter(rxSig);
scatterplot(rxSample(N_sym*sampsPerSym/2 + 1:end),2)


symbolSync = comm.SymbolSynchronizer(...
    'SamplesPerSymbol',sampsPerSym, ...
    'NormalizedLoopBandwidth',0.01, ...
    'DampingFactor',1.0, ...
    'TimingErrorDetector','Early-Late (non-data-aided)');

rxSync = symbolSync(rxSample);
scatterplot(rxSync(N_sym*sampsPerSym/2 + 1:end),2);