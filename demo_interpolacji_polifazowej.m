% demo_interpolacji_polifazowej.m
% 
%
% P.Korohoda, 26/10/2021 (na podstawie kilku wczesniejszych demonstracji);

clc; clear; close all;

Mpr=4; % krotnosc nadprobkowania;
fpr=1000;  dt=1/fpr;  N=2^8;  Npr=N*Mpr; t=0:dt:(N-1)*dt;  dtM=dt/Mpr; tpr=0:dtM:(Npr-1)*dtM;

dlugosc_filtru=3;
typ_filtru=2;
sygnal_testowy=2;

switch sygnal_testowy
    case 1, f1=fpr/10; x=cos(2*pi*f1*t);  xref=cos(2*pi*f1*tpr);
    case 2, f1=fpr*[1/16, 1/12, 1/10]; A=[1/2, 1/4 ,1/8];
            x=A(1)*cos(2*pi*f1(1)*t); xref=A(1)*cos(2*pi*f1(1)*tpr);
            for k=2:3, x=x+A(k)*cos(2*pi*f1(k)*t); xref=xref+A(k)*cos(2*pi*f1(k)*tpr);end;
    case 3, K=5; f1=fpr*rand(1,K)/2; A=rand(1,K);
            x=A(1)*cos(2*pi*f1(1)*t);  xref=A(1)*cos(2*pi*f1(1)*tpr);
            for k=2:K, x=x+A(k)*cos(2*pi*f1(k)*t);  xref=xref+A(k)*cos(2*pi*f1(k)*tpr);end;
end

switch dlugosc_filtru
    case 1, Mh=10;
    case 2, Mh=11;
    case 3, Mh=50;
    case 4, Mh=51;
end

n=0:Mh; D0=floor(Mh/2);
H(1,:)=zeros(1,Mh); H(1,D0+1)=1;
for k=1:Mpr-1
    D=floor(Mh/2)+k/Mpr; % opoznienie pojedynczego filtru w banku;
    switch typ_filtru
        case 1, h=sinc(n-D);
        case 2, w=hamming(Mh+1); h=sinc(n-D).*w';
    end        
    H(k+1,1:Mh+1)=h;
end

% filtrujemy bankiem filtrow:
y=zeros(1,Mpr*N);
for k=0:Mpr-1
    y0=filter(H(k+1,:),1,x);
    Y(1+k,:)=y0;
    y(1+(Mpr-k-1):Mpr:end)=y0;
end

% dd=1/Mpr; nh=0:Mh;
for k=1:Mpr
   hh(k,:)=H(k,:);
   h0(k:Mpr:Mpr*(Mh+1))=fliplr(hh(k,:));
end    

x2=zeros(1,Mpr*N); x2(1:Mpr:Mpr*N)=x;
y2=filter(h0,1,x2); % filtracja jednym "calosciowym" filtrem po wstawieniu zer do sygnalu;

nx=0:N; nx=nx(1:end-1);
n1=(1:Mpr*N)/Mpr;

    figure(1);
        for k=1:Mpr
            [H1,f2]=freqz(H(k,:),1,1000,fpr);
            subplot(Mpr,3,3*k-2); plot(0:Mh,H(k,:),'g.-'); grid on; ylim([-0.5,1.5]);            
            subplot(Mpr,3,3*k-1); plot(f2,abs(H1),'r.-'); grid on; ylim([0,1.2]);
%             subplot(Mpr,3,3*k); plot(f2,angle(H1)/pi,'b.-'); grid on;
        end
            %     figure(3);
            %     [H1,f2]=freqz(H(2,:),1,1000,fpr);
            %     plot(f2,angle(H1)/pi,'r.-'); grid on; hold on;
            %     [H1,f2]=freqz(H(3,:),1,1000,fpr);
            %     plot(f2,angle(H1)/pi,'b.-'); grid on; hold on;

            %     return;
        
    figure(2); clf;
        plot(nx+floor(Mh/2)+1,x,'bo'); grid on; hold on;
        plot(n1,y,'r.-');
        plot(n1,y2,'c.-');
        
% EOF