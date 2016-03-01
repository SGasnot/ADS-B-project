%% CAYLA Théo - GASNOT Sacha

clc
close all
clear all

fe = 20000000;
Te = 1/fe;
fs = 1000000;
Ts = 1/fs;
Fse = 20;
Nfft = 512;
N=1000;
M=2;


%% Emetteur

Sb=randi([0 1],1,N);

%% Association bit->symbole

%Ss=pammod(Sb,M,0);

Ss = zeros(1,N);

for i=1:length(Ss)
    if (Sb(i) == 0)
        Ss(i) = 1;
    elseif (Sb(i) == 1)
        Ss(i) = -1;
    end
end

%% Filtrage

g1 = -0.5*ones(1,Fse/2);
g2 = 0.5*ones(1,Fse/2);
g = [g1 g2];

%% On échantillonne à Fse

Se = upsample(Ss, Fse);

%% Filtre de mise en forme

Sl = 0.5 + conv(g,Se);

%% Ajout du bruit

%Nl = randn(1,length(Sl));

Nl = sqrt(3)/2*(randn(1,length(Sl))+sqrt(5)/2*1i*randn(1,length(Sl)));

Yl = Sl; % +Nl;  %On ne rajoute pas de bruit pour l'instant

%% --------------------------- Question 11 -------------------------


figure;
plot(Sl(1:25*Fse));
axis ([ 0 500 -0.2 1.2])
xlabel('Temps en millisecondes')
ylabel('Amplitude')

title('Allure de Sl en fonction du temps')

%% --------------------------- Question 12 --------------------------

eyediagram(Sl(1:Fse*100), 2*Fse, 2*Ts);
title('Diagramme de l oeil de Sl pour les 100 premiers symboles')

%% --------------------------- Question 13 ---------------------------

figure(),
[DSP_exp,f]=pwelch(Sl,ones(1,Nfft),0,Nfft,1/Te,'centered');
semilogy(f,DSP_exp,'r');

hold on;

DSP_th = 1/(4/Ts)*(sinc(f/(2/Ts)).^2).*(sin(pi*f/(2/Ts)).^2);
% dirac en 0
DSP_th(length(f)/2)=DSP_th(length(f)/2)+1/4;

semilogy(f,DSP_th);
axis([-1e7 1e7 10^(-20) 8])
title('DSP de Sl(t)')
legend('DSP expérimentale', 'DSP théorique')