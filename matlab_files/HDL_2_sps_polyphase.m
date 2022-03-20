% > transmisja danych ukszta³towanych filtrem SRRC
% > odbiór danych przy u¿yciu jednego filtru z dekompozycji polifazowej
% filtra odbiorczego SRRC
% > sprawdzenie b³êdu synchronizacji

clear; close all; clc;

rolloff = 0.8;
symbols = 20; % szerokoœæ odpowiedzi impulsowych

sps_tran = 2; % probek na symbol w odp. impulsowej tranmitera
N2 = 32; % poziom nadpróbkowania odp. impulsowej transmitera -> odp. impulsowa odbiornika  

sps_recv = sps_tran*N2; % probek na symbol w odp. impulsowej odbiornika
DataL = 40000; % iloœæ transmitowanych symboli;

snr = 20;

data_bin = randi([0 1],DataL,1);
data = 2*data_bin-1;
data = data';
% data = [-1, 1, -1, ones(1,10)]';

A = rcosdesign(rolloff, symbols, sps_tran, 'sqrt'); % nadajnik, filter enery is one
B = rcosdesign(rolloff, symbols,  sps_recv, 'sqrt'); % odbiornik, filter enery is one

% TRANSMITER
y_transmit = upfirdn(data, A, sps_tran);  % shaped interpolated transmit data

% figure(1);
%     hold on; grid on;
%     stem((1 : N1 : N1*(length(data))), data, 'kx'); 
%     plot(y_transmit(floor(symbols*N1/2) + 1 : end), 'o-');
%     title("Shaped and interpolated data with SRRC filter");
% return;

y_transmit = interp(y_transmit, N2); % rate = sps = N2*N1

% figure(2);
%     hold on; grid on;
%     stem((1 : sps : sps*(length(data))), data, 'kx'); 
%     plot(y_transmit(floor(symbols*sps/2) + 1 : end), 'gx-');
%     title("Linear interpolation of SRRC filter output");


% przesuniecie 
p = 2;
y_transmit = [zeros(1, p) , y_transmit];
y_transmit = y_transmit(1 : N2 : end);   % rate = N1

% scale data and write to file
y_transmit_1024 = round(1024*y_transmit);

fid = fopen(getenv("QPSK_DATA_FILE"), 'wt');
fprintf(fid, "%d\n", y_transmit_1024); 
disp("ok");

%################
% for psuedo_polyphase sim
%################

% fid2 = fopen(getenv("SRRC_2_sps_data"), 'wt');
% fprintf(fid2, "%d\n", y_transmit_1024); 
% 
% fid3 = fopen(getenv("binary_2_sps_data"), 'wt');
% fprintf(fid3, "%d\n", data_bin); 

%################
% for psuedo_polyphase sim
%################

y_transmit = y_transmit_1024;

% RECEIVER
% dekompozycja polifazowa filtru (jego odp. impulsowej) uprzednio zinterpolowanego

% dodanie szumu
% y_transmit = awgn(y_transmit, snr, 'measured');

rec_filtered = [];
diff_rec_filtered = [];

taps_per_filter = ceil(length(B)/N2);

B1 = B;
B = round(1024*B);% scale by 1024
B = [B, zeros(1, N2*taps_per_filter-length(B))];

% wyliczenie pochodnej wraz z normalizacj¹ do mocy równej 1 na symbol
difftaps = round(1024*licz_diff(B1, N2)); % scale by 1024
% return;
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

filter_indexes = [];
new_index = 1;  % obliczany indeks filtru z banków filtrów

% sprzê¿enie zwrotne - pêtla PLL
CNT = 1;
CNT_next = 1;
underflow = 1;
vi = 0;

autocorr = xcorr(A);
slopes = diff(diff(autocorr)); % 32 - timing error definition
slope = min(slopes);

M = 2; % quantity of possible patterns mapped later to symbols
Amp = 1; % QAM data minimum amplitude
Eavg = ((M.^2-1)/3)*Amp.^2;
K = max(abs(A));

K0 = -1;
Kp = K*Eavg*slope/sps_recv;

damping_factor = sqrt(2)/2;
loop_bw = 0.005/sps_recv;
theta = loop_bw/((damping_factor+(1/(4*damping_factor))));

denom = K0*Kp*(1 + 2*damping_factor*theta + theta*theta);
K1= (4*damping_factor*theta)/denom;
K2= (4*theta*theta)/denom;

% d³ugoœæ splotu z przesuniêciem wynikaj¹cym z opóŸnienia filtra
% num_of_samples = length(y_transmit) + taps_per_filter - 1 - floor(taps_per_filter/2);

% bez opóŸnienia
num_of_samples = length(y_transmit) - taps_per_filter + 1;

CNT_history = [];
odebrane = [];

half_symbol = floor(sps_tran/2);

for n=half_symbol + 1 : num_of_samples
    CNT = CNT_next;
    if underflow == 1
        e = sign(rec_filtered(new_index, n)) * diff_rec_filtered(new_index, n)/power(1024,2);
        odebrane = [odebrane, rec_filtered(new_index, n-half_symbol)];
    else
        e = 0;
    end

    % Loop filter - second order IIR
    vp = K1*e;
    vi = vi + K2*e;
    v = vp + vi;
    W = 1/2 + v;

    CNT_next = CNT - W;

    if CNT_next < 0         
        u = CNT/W;         
        new_index = floor(rem(N2*abs(u), N2)) + 1;
        filter_indexes = [filter_indexes, new_index];
       
        CNT_history = [CNT_history, CNT_next];
        CNT_next = 1 + CNT_next;        
        
        underflow = 1;
    else
        underflow = 0;
    end
end

figure(4);
    subplot(1, 2, 1); grid on; hold on;
        plot(filter_indexes-1);
        ylim([0, 32]);    
        
        str = sprintf("Detekcja opÃ³Åºnienia (delay = %d)", p);
        title(str);
    
    subplot(1, 2, 2); grid on; hold on;
        num_of_samps = 50;
        delay = symbols;
        stem(odebrane( end-num_of_samps+delay : end ), 'bo');

        data = data*max(odebrane( end-num_of_samps : end ) ); % normalizacja do max wartoÅ›ci odebranej
        plot(data( end-num_of_samps : end-delay ), 'X');
        legend(["odebrane"], ["nadane"]);

        title("Dane nadane (NRZ) vs odebrane (NRZ)");    
        set(gcf, 'WindowState', 'maximized');
