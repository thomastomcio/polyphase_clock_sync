clear; close all; clc;

rolloff = 0.5; symbols = 8; N1 = 8;

A = rcosdesign(rolloff, symbols, N1, 'sqrt'); % nadajnik, filter enery is one
DataL = 1000; % iloœæ transmitowanych symboli;
% data = 2*randi([0 1],DataL,1)-1;
data = [-1, 1, -1, ones(1,10)];
data = data';

y_transmit = upfirdn(data, A, N1);  % shaped interpolated transmit data
p= conv(A, y_transmit);
p = p(floor(length(A)/2) + 1 + floor(N1*symbols/2) : end);
p = p(1:8:end);

figure(); grid on; hold on;
% plot((1 : N1 : N1*(length(data))), data, 'o'); 
plot(data, 'o'); 
plot(p, 'x');
