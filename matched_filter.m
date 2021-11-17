%filtr dopasowujący - matched filter
clc; clear all; close all;

N = 100;
fs = 10000;
fx = 100;
dt = 1/fs;
t1 = (0:N-1);
x0 = 10*[zeros(1, N/4), ones(1, N/2), zeros(1, N/4)];
xn = x0 + 10*rand(1, length(x0));

h = xn(end:-1:1);

x_ex = xn; %[xn, zeros(1, N)];
% y = filter(x_ex, 1, x_ex);
% y = xcorr(x_ex, x_ex);
y = conv(h, xn);
t2 = (0:(length(y)-1));

figure(1);
plot(t1, xn, 'r.-'); grid on; hold on;

figure(2);
title("Matched filter");
plot(t2, y, 'b.-'); grid on; hold on;
% legend(["sygnal wejsciowy", "sygnal po filtracji(autokorelacja)"]);