%Purpose: Demonstrate how to match filter correctly
clc; clear all; close all;
BW=3.84e6;
fs = 50*BW; %sample rate
T= 1/fs; %sample period
fc = 330e6; %center freq
chirpLen=0.075; %chirp length
A=3; %amplitude of voltage signal (normally unknown)
Ar=2; %amplitude of reference voltage signal (normally unknown)


%create the signal withought noise and zero padded on either side (zero
%padding not necessary because xcorr does that, I'm just demonstrating that
%signals don't need to be the same length.)
sig=[zeros(1,ceil(chirpLen*fs)),A*chirp(t,0,t(end),BW),zeros(1,ceil(chirpLen*fs))];

%create the reference chirp
ref_chirp=Ar*chirp(t,0,t(end),BW);

%normalize reference chirp: The reference chirp needs to have energy of 1 
%so that it doesn't bias the output of the match filter. A filter shouldn't
%be applying gain to the signal or changing the units. The signal is in
%volts, so we divide by the square root of the energy to normalize it.

%If you know the signal's amplitude (for CW or FMCW):
energy=Ar^2/2*chirpLen;
%If you don't know the signal's amplitude, integrate to find energy (if it is noiseless):
    %energy=trapz(t,ref_chirp.^2)
ref_chirp=ref_chirp/sqrt(energy);


% perform match filtering
[R,lags] = xcorr(sig,ref_chirp); %signals don't need to be the same length

%R is the sum of each data sample as the signals are shifted past
%eachother, so to make the numerical integration correct, you need to
%multiply by dx which is T in this case. Then to get the filtered voltage
%signal in units of energy, you need to square it.
R=(abs(R*T)).^2; %absolute value only necessary if signals are complex
% take only positive side
R = R(lags>=0);
lags=lags(lags>=0);

[matchFiltPeak,index]=max(R);

figure()
plot(lags*T,R)
xlim([index-250 index+250]*T)

display(['Energy in signal was: ',num2str(A.^2/2*chirpLen)])
display(['which is the same as the peak of the match filter: ',num2str(matchFiltPeak)])