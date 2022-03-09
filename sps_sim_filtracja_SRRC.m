% > transmisja danych ukształtowanych filtrem SRRC
% > odbiór danych przy użyciu jednego filtru z dekompozycji polifazowej
%   filtra odbiorczego SRRC
% > sprawdzenie błędu synchronizacji

clear; close all; clc;

rolloff = 0.5;
symbols = 8;            % szerokość odpowiedzi impulsowych

sps_tran = 32;           % probek na symbol w odp. impulsowej tranmitera
F = 32;                 % poziom nadpróbkowania odp. impulsowej transmitera -> odp. impulsowa odbiornika  
sps_recv = F*sps_tran;  % probek na symbol w odp. impulsowej odbiornika

DataL = 2000;          % ilość transmitowanych symboli;
snr = 15;

data = 2*randi([0 1],DataL,1)-1;
data = data';

A = rcosdesign(rolloff, symbols, sps_tran, 'sqrt'); % nadajnik, filter enery is one
% B = interp(A, F);
B = rcosdesign(rolloff, symbols,  sps_recv, 'sqrt'); % odbiornik, filter enery is one

% TRANSMITER
y_transmit = upfirdn(data, A, sps_tran);  % shaped interpolated transmit data


y_transmit = interp(y_transmit, F);

% przesunicie 
p = 18;

y_transmit = [zeros(1, p) , y_transmit];
y_transmit = y_transmit(1 : F : end); 

% signal transmited
% plot(y_transmit);

% RECEIVER
% dekompozycja polifazowa filtru (jego odp. impulsowej) wcześniej zinterpolowanego

% y_transmit = awgn(y_transmit, snr, 'measured');   % dodanie szumu do sygnału nadajnika

rec_filtered = [];
diff_rec_filtered = [];

taps_per_filter = ceil(length(B)/F);

B1 = B;
B = [B, zeros(1, F*taps_per_filter-length(B))];

% wyliczenie pochodnej wraz z normalizacją do mocy równej 1 na symbol
difftaps = diff(B1);
difftaps = [difftaps, zeros(1, F*taps_per_filter-length(difftaps))];

% return;

for n=0:F-1
   x = n : F : F*taps_per_filter - 1;   

%    B_tmp = B(x+1);
%    B_tmp = B_tmp(end:-1:1);
   skladowa = conv(B(x+1), y_transmit);
%    przesuniecie o polowe dlugosci filtra
%    skladowa = skladowa(floor(taps_per_filter/2) + 1: end); 
   rec_filtered = [rec_filtered; skladowa];   

%    tmp_diff_skladowa = difftaps(x+1);
%    tmp_diff_skladowa = tmp_diff_skladowa(end:-1:1);
   diff_skladowa = conv(difftaps(x+1), y_transmit);
%    przesuniecie o polowe dlugosci filtra
%    diff_skladowa = diff_skladowa(floor(taps_per_filter/2) + 1: end);
   diff_rec_filtered = [diff_rec_filtered; diff_skladowa];
   
%    figure(3);
%        grid on; hold on;   
%        plot(rec_filtered(n+1, :), '.-'); 
%        plot(diff_rec_filtered(n+1, :), '.-');

end
% return;

filter_indexes = [];
new_index = 1;  % obliczany indeks filtru z banków filtrów

% sprzężenie zwrotne - pętla PLL
CNT = 1;
CNT_next = 1;
underflow = 1;
vi = 0;

slopes = diff(diff(A));
slope = slopes(find(slopes == min(slopes)));
Eavg = sum(power(A, 2))/symbols;
K = max(y_transmit);

% na podstawie http://www.trondeau.com/blog/2011/8/13/control-loop-gain-values.html
K0 = -1;
Kp = slope*Eavg*K*sps_tran;

damping_factor = 0.707;
loop_bw = 0.062832;
theta = loop_bw/((damping_factor+(1/(4*damping_factor))));

denom = K0*Kp*(1 + 2*damping_factor*theta + theta*theta);
K1= (4*damping_factor*theta)/denom;
K2= (4*theta*theta)/denom;
% długość splotu z przesunięciem wynikającym z opóźnienia filtra
% num_of_samples = length(y_transmit) + taps_per_filter - 1 - floor(taps_per_filter/2);

% bez opóźnienia
num_of_samples = length(y_transmit) - taps_per_filter + 1;

CNT_history = [];
counter = 0;

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
    W = 1/sps_tran + v;        

    CNT_next = CNT - W;
    
%     counter = counter + 1;
    if CNT_next < 0
%         counter = 0;
        new_index = floor(mod(sps_recv*abs(CNT_next), F)) + 1;
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
    plot(filter_indexes);
% figure(5);
%     grid on; hold on;
%     plot(filter_indexes-1, 'b.-');
%     title("Ustalanie indexu filtru z banków fitrów");    
% figure(6);
%     grid on; hold on;
%     stem(rec_filtered(filter_indexes(end), : ));
    


