% > transmisja danych ukształtowanych filtrem SRRC
% > odbiór danych przy użyciu jednego filtru z dekompozycji polifazowej
%   filtra odbiorczego SRRC
% > sprawdzenie błędu synchronizacji

clear; close all; clc;

rolloff = 0.5;
symbols = 11;               % szerokość odpowiedzi impulsowych

sps_tran = 8;               % probek na symbol w odp. impulsowej tranmitera
F = 32;                     % poziom nadpróbkowania odp. impulsowej transmitera -> odp. impulsowa odbiornika  
sps_recv = F*sps_tran;      % probek na symbol w odp. impulsowej odbiornika

DataL = 8000;               % ilość transmitowanych symboli;
snr = 15;

data = 2*randi([0 1],DataL,1)-1;
data = data';

A = rcosdesign(rolloff, symbols, sps_tran, 'sqrt'); % nadajnik, filter enery is one

B = rcosdesign(rolloff, symbols,  sps_recv, 'sqrt'); % odbiornik, filter enery is one

% TRANSMITER
y_transmit = upfirdn(data, A, sps_tran);  % shaped interpolated transmit data


y_transmit = interp(y_transmit, F);

% przesunicie 
p = 15;

y_transmit = [zeros(1, p) , y_transmit];
y_transmit = y_transmit(1 : F : end); 

% scale data and write to file
y_transmit_1024 = round(1024*y_transmit);

fid = fopen(getenv("QPSK_DATA_FILE"), 'wt');
fprintf(fid, "%d\n", y_transmit_1024); 
disp("ok");

% figure(1);
%     hold on; grid on;
%     stem((1 : sps_tran : sps_tran*(length(data))), data, 'kx'); 
%     y_tran_delayed = y_transmit(floor(symbols*sps_tran/2) +1  : end);
%     plot(y_tran_delayed, 'o-');
%     xlim([0, sps_tran*symbols*5]);
%     title("Shaped and interpolated data with SRRC filter");
% return;

y_transmit = y_transmit_1024;

% RECEIVER

% dodanie szumu
% y_transmit = awgn(y_transmit, snr, 'measured');   % dodanie szumu do sygnału nadajnika

rec_filtered = [];
diff_rec_filtered = [];

taps_per_filter = ceil(length(B)/F);

B1 = B;
B = round(1024*B);% scale by 1024
B = [B, zeros(1, F*taps_per_filter-length(B))];

% wyliczenie pochodnej wraz z normalizacją do mocy równej 1 na symbol
difftaps = diff(B);
difftaps = [difftaps, zeros(1, F*taps_per_filter-length(difftaps))];

% dekompozycja polifazowa filtru (jego odp. impulsowej) wcześniej zinterpolowanego
for n=0:F-1
   x = n : F : F*taps_per_filter - 1;   
   
   skladowa = conv(B(x+1), y_transmit);
%    przesuniecie o polowe dlugosci filtra
%    skladowa = skladowa(floor(taps_per_filter/2) + 1: end); 
   rec_filtered = [rec_filtered; skladowa];   
   
   
   diff_skladowa = conv(difftaps(x+1), y_transmit);   
%    przesuniecie o polowe dlugosci filtra
%    diff_skladowa = diff_skladowa(floor(taps_per_filter/2) + 1: end);
   diff_rec_filtered = [diff_rec_filtered; diff_skladowa];

end

filter_indexes = [];
new_index = 1;  % obliczany indeks filtru z banków filtrów

% sprzężenie zwrotne - pętla PLL
CNT = 1;
CNT_next = 1;
underflow = 1;
vi = 0;

autocorr = xcorr(A);
slopes = diff(diff(autocorr)); % 32 - timing error definition
slope = min(slopes);

M = 2;          % quantity of possible patterns mapped later to symbols
Amp = 1;        % QAM data minimum amplitude
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

% długość splotu z przesunięciem wynikającym z opóźnienia filtra
% num_of_samples = length(y_transmit) + taps_per_filter - 1 - floor(taps_per_filter/2);

% bez opóźnienia
num_of_samples = length(y_transmit) - taps_per_filter + 1;

CNT_history = [];
odebrane = [];

half_symbol = floor(sps_tran/2);

for n=half_symbol + 1 : num_of_samples
    CNT = CNT_next;
    if underflow == 1
        e = sign(rec_filtered(new_index, n)) * diff_rec_filtered(new_index, n) / power(1024,2);               
        odebrane = [odebrane, rec_filtered(new_index, n-half_symbol)];
    else
        e = 0;
    end
        
    % Loop filter - second order IIR
    vp = K1*e;
    vi = vi + K2*e;
    v = vp + vi;
    W = 1/sps_tran + v;        

    CNT_next = CNT - W;
    if CNT_next < 0         
        u = CNT/W;         
        new_index = floor(rem(F*abs(u), F)) + 1;
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
        
        str = sprintf("Detekcja opóźnienia (delay = %d)", p);
        title(str);
    
    subplot(1, 2, 2); grid on; hold on;
        num_of_samps = 50;
        delay = symbols;
        stem(odebrane( end-num_of_samps+1+delay : end ), 'bo');

        data = data*max(odebrane( end-num_of_samps : end ) ); % normalizacja do max wartości odebranej
        plot(data( end-num_of_samps : end-delay-1 ), 'X');
        legend(["odebrane"], ["nadane"]);

        title("Dane nadane (NRZ) vs odebrane (NRZ)");    
        set(gcf, 'WindowState', 'maximized');
    


