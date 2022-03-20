% implementacja filtru interpolatora
clc; clear all; close all;

M = 40;
N = 2*M+1; 
n = -M : M;

K = 5;
wc = pi/K;
fc = wc/(2*pi);
h = sinc(n/K); %sin(n*pi/K)./(n*pi/K);
% h(1) = 1;

w = blackman(N); w = w';
hw = h .* w;

Nx=50;
fx=50;
fpr=1000;
n=0:Nx-1;
tt=n/fpr;
x=cos(2*pi*fx/fpr*n); % generacja sygna³u testowego x(n)
KNx=K*Nx;
xz=zeros(1,KNx); 
xz(1:K:KNx)=x(1:Nx); % dodanie zer

yz=conv(xz,hw); % filtracja xz(n) za pomoc¹ odp. impulsowej hw(n); otrzymujemy KNx+N?1 próbek
yp=yz(N:KNx); % odciêcie stanów przejœciowych (po N?1 próbek) z przodu i z ty³u sygna³u yz(n)
xp=xz(M+1:KNx-M); % odciêcie tych próbek w xz(n), dla których nie ma poprawnych odpowiedników w yz(n)

Ny=K*Nx; 
k=1:Ny; 
ti= k/(K*fpr);
ti = ti(M+1:KNx-M);

plot(ti, xp,'r*',ti, yp,'-bo', tt, x, 'g^-');
legend(["po wstawieniu zer", "po LPF(interpoluj¹cym)", "sygna³ testowy"]);
title('xp(n) i yp(n)');grid;


