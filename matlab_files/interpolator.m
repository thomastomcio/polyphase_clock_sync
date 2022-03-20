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
x=cos(2*pi*fx/fpr*n); % generacja sygna�u testowego x(n)
KNx=K*Nx;
xz=zeros(1,KNx); 
xz(1:K:KNx)=x(1:Nx); % dodanie zer

yz=conv(xz,hw); % filtracja xz(n) za pomoc� odp. impulsowej hw(n); otrzymujemy KNx+N?1 pr�bek
yp=yz(N:KNx); % odci�cie stan�w przej�ciowych (po N?1 pr�bek) z przodu i z ty�u sygna�u yz(n)
xp=xz(M+1:KNx-M); % odci�cie tych pr�bek w xz(n), dla kt�rych nie ma poprawnych odpowiednik�w w yz(n)

Ny=K*Nx; 
k=1:Ny; 
ti= k/(K*fpr);
ti = ti(M+1:KNx-M);

plot(ti, xp,'r*',ti, yp,'-bo', tt, x, 'g^-');
legend(["po wstawieniu zer", "po LPF(interpoluj�cym)", "sygna� testowy"]);
title('xp(n) i yp(n)');grid;


