% testowy 

clear; close all; clc;

rolloff = 0.5;
symbols = 20;                   % szerokość odpowiedzi impulsowych

sps_recv = 32*8;                  % probek na symbol w odp. impulsowej odbiornika

DataL = 10;                     % ilość transmitowanych symboli;
data = 2*randi([0 1],DataL,1)-1;
data = data';

A = rcosdesign(rolloff, symbols, sps_recv, 'sqrt');     % transmitter, filter enery is one

B = rcosdesign(rolloff, symbols,  sps_recv, 'sqrt');    % receiver, filter enery is one


% TRANSMITER
y_transmit = upfirdn(data, A, sps_recv);  % shaped interpolated transmit data

% przesunicie 
p = 15;
y_transmit = [zeros(1, p) , y_transmit];
B = [zeros(1,p), B];

rec_filtered = conv(y_transmit, B);

% Kszatłowanie danych do transmisji
figure(1); grid on; hold on;
    stem((1 : sps_recv : sps_recv*(length(data))), data, 'kx'); 
    
    y_tran_delayed = y_transmit(floor(symbols*sps_recv/2) + 1 + p : end);
    y_tansmit_delayed_norm = y_tran_delayed/max(y_transmit);
    
    plot(y_tansmit_delayed_norm, 'o');
    xlim([0, DataL*sps_recv]);
    title("Shaped and interpolated data with SRRC filter");

filter_indxes = floor(length(B)/2) + symbols/2*sps_recv + 1 : sps_recv : length(rec_filtered) - ((floor(length(B)/2) + symbols/2*sps_recv));
% Porównanie danych po transmisji i po odebraniu ( odzyskaniu )
figure(2);grid on; hold on;
    stem(data, '*');
    stem(rec_filtered(filter_indxes));
    title("Comparison of transmit data with recovered receiver data");
