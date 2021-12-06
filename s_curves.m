% Wyznaczenie S-curve dla wyjœcia dektora fazowego TED (sygna³u b³êdu)
clear; close all; clc;

symbols =100;
N1 = 2;
N2 = 32;
sps = N1*N2;
rolloff = 0.2;

B = rcosdesign(rolloff, symbols,  N2, 'sqrt'); % odbiornik, filter enery is one

% B = sqrt(symbols)*N2*B; % energia na 1 symbol

taps_per_filter = ceil(length(B)/N2);
% B = [B, zeros(1, N2*taps_per_filter-length(B))];

% difftaps = licz_diff(B, N2);
difftaps = diff(B);
difftaps = [difftaps, zeros(1, N2*taps_per_filter-length(difftaps))];

sumy = [];
for n=1:N2
    sumy = [sumy, sum(difftaps(n:N2:end))];
end

% sumy = 10e8*sumy;
% i_min = find(abs(sumy) == min(abs(sumy)));
d_sumy = diff(sumy);
max(d_sumy),

figure(1);
plot(sumy);
hold on;
plot(d_sumy);

return;

dx = 1/length(sumy);
x = -0.5:dx:(0.5-dx); % normalizacja okresu próbkowania do czasy trwania symbolu

% obliczanie pochodnej 
n = length(x);
dy = zeros(n,1); % preallocate derivative vectors
for i=2:n-1
    dy(i) = (sumy(i-1)+sumy(i+1))/2/dx;
end

figure(1);
plot(x, sumy); hold on; 
plot(x, dy);

% plot(diff(sumy));


% sumy = []
% A = rcosdesign(0.4, 100, 32, 'sqrt')
% dA = diff(A);
% for n=1:32
% sumy = [sumy, sum(dA(n:32:end))];
% end
% plot(sumy)

