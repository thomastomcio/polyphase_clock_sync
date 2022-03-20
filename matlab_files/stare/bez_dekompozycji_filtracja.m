% > transmisja danych ukszta³towanych filtrem SRRC
% > odbiór danych przy u¿yciu jednego filtru z dekompozycji polifazowej
% filtra odbiorczego SRRC
% > sprawdzenie b³êdu synchronizacji

clear; close all; clc;

rolloff = 0.9;
symbols = 10; % szerokoœæ odpowiedzi impulsowych
N1 = 2; % probek na symbol w odp. impulsowej tranmitera
N2 = 2; % poziom nadpróbkowania odp. impulsowej transmitera -> odp. impulsowa odbiornika  
sps = N1*N2; % probek na symbol w odp. impulsowej odbiornika
DataL = 50; % iloœæ transmitowanych symboli;
snr = 15;


% rxSig = awgn(delayedSig, snr, 'measured');

data = randi([0 1],DataL,1);
data = data';
% data = [1,1,1,-1,1,-1,-1,1,-1,1,-1,-1,1,1,1,1,-1,-1,1,-1,1,1,1,1,1,-1,-1,1,-1,1,-1,1,1,-1,-1,1,1,-1,-1,1,-1,-1,1,1,1,1,1,-1,-1,-1];


B = rcosdesign(rolloff, symbols, sps, 'sqrt'); % odbiornik

% TRANSMITER

% y_transmit = conv(B, data); % shaped data
% y_transmit = y_transmit(floor(symbols*N1/2) + 1 : end);

maxy = [];
mmaxy = [];
for p = 0 : sps
    for k = 1 : sps
y_transmit = upfirdn(data, B, sps);
y_transmit = [zeros(1, p) , y_transmit(1:end-p)]';
% y_transmit = y_transmit(1:N2:end);-

% x = (1:N1:N1*(length(data)));
% figure(1);
% stem(data, 'kx'); hold on;
% plot(y_transmit, 'o-');

% RECEIVER
% dekompozycja polifazowa filtru (jego odp. impulsowej) uprzednio zinterpolowanego

% y_transmit = awgn(y_transmit, snr, 'measured');
B1 = [B(k:end), zeros(1, k-1)];
taps_per_filter = length(B1);

skladowa = conv(B1, y_transmit');
% przesuniecie o polowe dlugosci filtra
skladowa = skladowa(floor(taps_per_filter/2) + 1: end); 

% figure(2);
% plot(skladowa, '.-'); grid on; hold on;

%dodane zero na koncu wektora

difftaps = licz_diff(B1);
difftaps = [zeros(1, 1), difftaps(1: end), zeros(1, 2)];

diff_skladowa = conv(difftaps, y_transmit');
% diff_skladowa = difftaps;

% przesuniecie o polowe dlugosci filtra
diff_skladowa = diff_skladowa(floor(taps_per_filter/2) + 1: end);

% figure(2);
% plot(diff_skladowa, '.-'); grid on; hold on;


% Obliczanie b³êdu
mult = skladowa .* diff_skladowa;

% figure(4);
% plot(mult, 'b.'); hold on;
max = 0;
index = 0;
for n = 0:length(mult)/sps-1
    new = abs(sum(mult(n*sps+1 : (n+1)*sps)));
    if new > max
       max = new;
    end
end

maxy = [maxy, max];
% disp(string(max));

% sumowanie iloczynów i porównanie z zerem
% sumy = [];
% for n=1:N2
%     skladowa = mult(n, 1:2);
%     suma = sum(skladowa);
%     sumy = [sumy, suma];
%     disp("dla m=" + string(n-1) + ": " + string(suma));
% end
% 
% index = find( abs(sumy) == min(abs(sumy)) );
% disp("najblizej error=0 dla m=" + string(index-1));
    end
    mmaxy = [mmaxy; maxy];
    maxy = [];
end
for j=1:sps
disp("for "+string(j)+" shift in B: "+string(mmaxy(j, 1)));
disp("for "+string(j-1)+" shift in y_transmit: "+string(mmaxy(1, j)));
end
return;
