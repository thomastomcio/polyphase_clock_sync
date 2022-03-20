% modelowanie filtra SRRC

clc; clear; close all;

sps_in = 2; % input singal samples/symbol
M = 32; % number of filters in polyphase filterbank
sps = sps_in * M; % SRRC filter sps
H = [];

for m=1:M
    h = rcosdesign(0.5, 6, sps, 'sqrt');
    H(m, : ) = [h(m : end) zeros(1, m)];
    length(h),
end


figure(1);
    plot(H);