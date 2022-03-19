% > transmisja danych ukszta³towanych filtrem SRRC
% > odbiór danych przy u¿yciu jednego filtru z dekompozycji polifazowej
% filtra odbiorczego SRRC
% > sprawdzenie b³êdu synchronizacji

clear; close all; clc;

rolloff = 0.4;
symbols =  8; % szerokoœæ odpowiedzi impulsowych
N1 = 16; % probek na symbol w odp. impulsowej tranmitera
N2 = 32; % poziom nadpróbkowania odp. impulsowej transmitera -> odp. impulsowa odbiornika  
sps = N1*N2; % probek na symbol w odp. impulsowej odbiornika
DataL = 4000; % iloœæ transmitowanych symboli;
snr = 15;

data = 2*randi([0 1],DataL,1)-1;

data = data';
% data = [-1, 1, -1, ones(1,10)]';

A = rcosdesign(rolloff, symbols, N1, 'sqrt'); % nadajnik, filter energy is one
B = rcosdesign(rolloff, symbols,  N2, 'sqrt'); % odbiornik, filter energy is one

% TRANSMITER
y_transmit = upfirdn(data, A, N1);  % shaped interpolated transmit data

y_transmit = interp(y_transmit, N2); % rate = sps = N2*N1
% energia !!!!

% figure(2);
%     hold on; grid on;
%     stem((1 : sps : sps*(length(data))), data, 'kx'); 
%     plot(y_transmit(floor(symbols*sps/2) + 1 : end), 'gx-');
%     title("Linear interpolation of SRRC filter output");

% przesunicie 
p = 28;
y_transmit = [zeros(1, p) , y_transmit];

y_transmit = y_transmit(1 : N2 : end);   % rate = N1

y_transmit = y_transmit;

% signal transmited
% plot(y_transmit);


% RECEIVER
% dekompozycja polifazowa filtru (jego odp. impulsowej) uprzednio zinterpolowanego

% y_transmit = awgn(y_transmit, snr, 'measured');   % dodanie szumu do sygna³u nadajnika

rec_filtered = [];
diff_rec_filtered = [];

taps_per_filter = ceil(length(B)/N2);

B1 = B;
B = [B, zeros(1, N2*taps_per_filter-length(B))];

% wyliczenie pochodnej wraz z normalizacj¹ do mocy równej 1 na symbol
difftaps = diff(B1);

difftaps = [difftaps, zeros(1, N2*taps_per_filter-length(difftaps))];

for n=0:N2-1
   x = n : N2 : N2*taps_per_filter - 1;   

   skladowa = conv(B(x+1), y_transmit); 
   % przesuniecie o polowe dlugosci filtra
%    skladowa = skladowa(floor(taps_per_filter/2) + 1: end); 
   rec_filtered = [rec_filtered; skladowa];   

   diff_skladowa = conv(difftaps(x+1), y_transmit);
   % przesuniecie o polowe dlugosci filtra
%    diff_skladowa = diff_skladowa(floor(taps_per_filter/2) + 1: end);
   diff_rec_filtered = [diff_rec_filtered; diff_skladowa];

end
% return;

filter_indexes = [];
new_index = 1;  % obliczany indeks filtru z banków filtrów

% sprzê¿enie zwrotne - pêtla PLL
CNT = 1;
CNT_next = 1;
underflow = 1;
vi = 0;

slopes = diff(diff(32*8*A));
slope = slopes(find(slopes == min(slopes))),
Eavg = sum(power(A, 2))/symbols;
K = 32*max(y_transmit);
KE = K*Eavg;

% na podstawie http://www.trondeau.com/blog/2011/8/13/control-loop-gain-values.html
K0 = -1;
Kp = K*Eavg*slope;

damping_factor = 1/sqrt(2);
loop_bw = 0.005/16;
T = 1;
theta = loop_bw*T/(damping_factor+1/(4*damping_factor));

Kp = 0.235;
denom = K0*Kp*(1 + 2*damping_factor*theta + theta*theta);
K1= (4*damping_factor*theta)/denom;
K2= (4*theta*theta)/denom;

% d³ugoœæ splotu z przesuniêciem wynikaj¹cym z opóŸnienia filtra
% num_of_samples = length(y_transmit) + taps_per_filter - 1 - floor(taps_per_filter/2);

% bez opóŸnienia
num_of_samples = length(y_transmit) - taps_per_filter + 1;
CNT_history = [];

for n=1:num_of_samples
    CNT = CNT_next;
    if underflow == 1
        e = sign(rec_filtered(new_index, n)) * diff_rec_filtered(new_index, n);
    else
        e = 0;
    end

    % Loop filter - second order IIR
    vp = K1*e;
    vi = vi + K2*e;
    v = vp + vi;
    W = 1/N1 + v;

    CNT_next = CNT - W;

    if CNT_next < 0
        new_index = floor(rem(sps*abs(CNT_next), N2)) + 1;
        filter_indexes = [filter_indexes, new_index];
        CNT_history = [CNT_history, CNT_next];
        CNT_next = 1 + CNT_next;
        underflow = 1;
    else
        underflow = 0;
    end
end

figure(4);
    grid on; hold on;
    plot(CNT_history, 'b.-');
    title("Ustalanie indexu filtru z banków fitrów");


    


