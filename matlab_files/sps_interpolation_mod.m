% > transmisja danych ukształtowanych filtrem SRRC
% > odbiór danych przy użyciu jednego filtru z dekompozycji polifazowej
%   filtra odbiorczego SRRC
% > sprawdzenie błędu synchronizacji

clear; close all; clc;

rolloff = 0.5;
symbols = 20;            % szerokość odpowiedzi impulsowych

sps_tran = 8;           % probek na symbol w odp. impulsowej tranmitera
% F = 2;                 % poziom nadpróbkowania odp. impulsowej transmitera -> odp. impulsowa odbiornika  
sps_recv = 32 ;%F*sps_tran;  % probek na symbol w odp. impulsowej odbiornika
F = sps_recv/sps_tran; % poziom nadpróbkowania odp. impulsowej transmitera -> odp. impulsowa odbiornika  

DataL = 2000;          % ilość transmitowanych symboli;
snr = 15;

data = 2*randi([0 1],DataL,1)-1;
data = data';

A = rcosdesign(rolloff, symbols, sps_tran, 'sqrt'); % nadajnik, filter enery is one

% TRANSMITER
y_transmit = upfirdn(data, A, sps_recv);  % shaped interpolated transmit data

% interpolacja
y_transmit = interp(y_transmit, F); % rate = sps = N2*N1

% przesunicie 
p = 15;
y_transmit = [zeros(1, p) , y_transmit];

% RECEIVER
% y_transmit = awgn(y_transmit, snr, 'measured');   % dodanie szumu do sygnału nadajnika

difftaps = [diff(A), 0];
y_transmit = y_transmit(1 : F : end);

rec_filtered = conv(A, y_transmit);
diff_rec_filtered = conv(difftaps, y_transmit);

% #####################################
% sprzężenie zwrotne - pętla PLL
% #####################################

filter_indexes = [];
new_index = 1;  % obliczany indeks filtru z banków filtrów

CNT = 1;
CNT_next = 1;
underflow = 1;
vi = 0;

autocorr = xcorr(A);
slopes = diff(diff(autocorr));
slope = min(slopes);
Eavg = 1;
K = max(y_transmit) - min(y_transmit);

% na podstawie http://www.trondeau.com/blog/2011/8/13/control-loop-gain-values.html
K0 = -1;
Kp = K*Eavg*slope;

damping_factor = 0.707;
loop_bw = 2*pi/100;
theta = loop_bw/((damping_factor+(1/(4*damping_factor))));

denom = K0*Kp*(1 + 2*damping_factor*theta + theta*theta);
K1= (4*damping_factor*theta)/denom;
K2= (4*theta*theta)/denom;

% bez opóźnienia
num_of_samples = length(rec_filtered);

mu_history = [];
% counter = 0;
mu = 0;
mu_next = 0;

for n=2:num_of_samples
    CNT = CNT_next;
    mu = mu_next;
    
    if underflow == 1
        prev_pulse = rec_filtered(n-1);
        prev_deriv = diff_rec_filtered(n-1);
        
        pulse = rec_filtered(n);
        deriv = diff_rec_filtered(n);
        
        xI = mu*pulse + (1-mu)*prev_pulse;
        xdotI = mu*deriv + (1-mu)*prev_deriv;

        e = sign(xI) * xdotI;
    else
        e = 0;
    end
        
    % Loop filter - second order IIR
    vp = K1*e;
    vi = vi + K2*e;
    v = vp + vi;
    W = 1/sps_tran + v;        

    CNT_next = CNT - W;
    
%     counter = counter + 1;
    if CNT_next < 0
%         counter = 0;
        mu_history = [mu_history, mu_next];
        CNT_next = 1 + CNT_next;        
        
        mu_next = CNT/W;
        underflow = 1;
    else
        underflow = 0;
        mu_next = mu;        
    end
end

figure(4);
    grid on; hold on;
    plot(mu_history);
    
% figure(5);
%     grid on; hold on;
%     plot(filter_indexes-1, 'b.-');
%     title("Ustalanie indexu filtru z banków fitrów");    
% figure(6);
%     grid on; hold on;
%     stem(rec_filtered(filter_indexes(end), : ));
    


