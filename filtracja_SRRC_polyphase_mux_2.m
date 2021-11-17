% > transmisja danych ukszta³towanych filtrem SRRC
% > odbiór danych przy u¿yciu jednego filtru z dekompozycji polifazowej
% filtra odbiorczego SRRC
% > sprawdzenie b³êdu synchronizacji

clear; close all; clc;

rolloff = 0.9;
symbols = 10; % szerokoœæ odpowiedzi impulsowych
N1 = 2; % probek na symbol w odp. impulsowej tranmitera
N2 =32; % poziom nadpróbkowania odp. impulsowej transmitera -> odp. impulsowa odbiornika  
sps = N1*N2; % probek na symbol w odp. impulsowej odbiornika
DataL = 1000; % iloœæ transmitowanych symboli;
snr = 15;

% rxSig = awgn(delayedSig, snr, 'measured');

data = 2*randi([0 1],DataL,1)-1;
data = data';
% data = [-1, 1, -1, ones(1,10)]';

A = rcosdesign(rolloff, symbols, N1, 'sqrt'); % nadajnik, filter enery is one
B = rcosdesign(rolloff, symbols,  sps, 'sqrt'); % odbiornik, filter enery is one


% TRANSMITER
y_transmit = upfirdn(data, A, N1);  % shaped interpolated transmit data
% y_transmit = conv(A, data); % shaped data
% y_transmit = conv(A, data)'; % shaped data
% y_transmit = filter(A, 1, data);
% y_transmit = y_transmit(floor(symbols*N1/2) + 1 : end);

% figure(1);
%     hold on; grid on;
%     stem((1 : N1 : N1*(length(data))), data, 'kx'); 
%     plot(y_transmit(floor(symbols*N1/2) + 1 : end), 'o-');
%     title("Shaped and interpolated data with SRRC filter");
    
y_transmit = interp(y_transmit, N2); % rate = sps = N2*N1
% energia !!!!

% figure(2);
%     hold on; grid on;
%     stem((1 : sps : sps*(length(data))), data, 'kx'); 
%     plot(y_transmit(floor(symbols*sps/2) + 1 : end), 'gx-');
%     title("Linear interpolation of SRRC filter output");

% przesunicie 
p = 18;
y_transmit = [zeros(1, p) , y_transmit];

y_transmit = y_transmit(1 : N2 : end);   % rate = N1


% RECEIVER
% dekompozycja polifazowa filtru (jego odp. impulsowej) uprzednio zinterpolowanego

y_transmit = awgn(y_transmit, snr, 'measured');   % dodanie szumu do
% sygna³u nadajnika

rec_filtered = [];
diff_rec_filtered = [];

taps_per_filter = ceil(length(B)/N2);

B = [B, zeros(1, N2*taps_per_filter-length(B))];

difftaps = licz_diff(B, N2);
difftaps = [difftaps, zeros(1, N2*taps_per_filter-length(difftaps))];

for n=0:N2-1
   x = n : N2 : N2*taps_per_filter - 1;   

   skladowa = conv(B(x+1), y_transmit);
   % przesuniecie o polowe dlugosci filtra
   skladowa = skladowa(floor(taps_per_filter/2) + 1: end); 
   rec_filtered = [rec_filtered; skladowa];   

   diff_skladowa = conv(difftaps(x+1), y_transmit);
   % przesuniecie o polowe dlugosci filtra
   diff_skladowa = diff_skladowa(floor(taps_per_filter/2) + 1: end);
   diff_rec_filtered = [diff_rec_filtered; diff_skladowa];
   
%    figure(3);
%        grid on; hold on;   
%        plot(rec_filtered(n+1, :), '.-'); 
%        plot(diff_rec_filtered(n+1, :), '.-');

end
% return;

% mult = sign(rec_filtered) .* diff_rec_filtered;
% % sumowanie iloczynów i porównanie z zerem
% sumy = [];
% for n=1:N2
%     skladowa = mult(n, :);
%     suma = sum(skladowa);
%     sumy = [sumy, suma];
%     disp("dla m=" + string(n-1) + ": " + string(suma));
% end
% 
% index = find( abs(sumy) == min(abs(sumy)) );
% disp("najblizej error=0 dla m=" + string(index-1));
% return;

filter_indexes = [];
new_index = 1;  % obliczany indeks filtru z banków filtrów

% sprzê¿enie zwrotne - pêtla PLL
CNT = 1;
CNT_next = 1;
underflow = 1;
vi = 0;

Kp = 1;
damping_factor = 0.707;
loop_bw = 0.0628;

denom = Kp*(1 + 2*damping_factor*loop_bw + loop_bw*loop_bw);
K1= (4*damping_factor*loop_bw)/denom;
K2= (4*loop_bw*loop_bw)/denom;

num_of_samples = length(y_transmit) + taps_per_filter - 1 - floor(taps_per_filter/2);
for n=1:num_of_samples
    CNT = CNT_next;
    if underflow == 1
        e = sign(rec_filtered(new_index, n)) * diff_rec_filtered(new_index, n);
    else
        e = 0;
    end

    vp = K1*e;
    vi = vi + K2*e;
    v = vp + vi;
    W = 1/2 + v;

    CNT_next = CNT - W;

    if CNT_next < 0
        new_index = floor(rem(2*N2*abs(CNT_next), N2)) + 1;
        filter_indexes = [filter_indexes, new_index];
        CNT_next = 1 + CNT_next;
        underflow = 1;
    else
        underflow = 0;
    end
end

figure(4);
    grid on; hold on;
    plot(filter_indexes, 'b.-');
    title("Ustalanie indexu filtru z banków fitrów");


