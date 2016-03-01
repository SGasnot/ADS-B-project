%% CAYLA Théo - GASNOT Sacha

clc
close all
clear all

%% -------------------------------- Question 14 ------------------------


fe = 20000000;
Te = 1/fe;
fs = 1000000;
Ts = 1/fs;
Fse = 20;
Nfft = 512;
N = 10000;
M = 2;

p0=zeros(1,Fse);
p0(1:Fse/2) = 1;

p1=zeros(1,Fse);
p1(Fse/2+1:Fse) = 1;


SNR=0:10;
SNR_lin=10.^(SNR/10);
TEB=zeros(1,length(SNR));


%% Emetteur

Sb = randi([0 1],1,N); 

%% Association bit->symbole

%Ss=pammod(Sb,M,0);

Ss = zeros(1,N);

for i=1:length(Ss)
    if (Sb(i) == 1)
        Ss(i) = -1;
    elseif (Sb(i) == 0)
        Ss(i) = 1;
    end
end

%% Filtrage

g1 = -0.5*ones(1,Fse/2);
g2 = 0.5*ones(1,Fse/2);
g = [g1 g2];

%% On sur-échantillonne à Fse

Se = upsample(Ss, Fse);

%% Filtre de mise en forme

Sl = 0.5 + conv(Se,g);

%% Ajout du bruit

Nl = sqrt(3)/2*(randn(1,length(Sl))+sqrt(5)/2*1i*randn(1,length(Sl)));

%On choisir sqrt(3) pour le tracé mais on peut augmenter cette valeur pour
%augmenter le teb

Yl = Sl + Nl; 

%% Sortie du filtre de réception

Rl0=conv(Yl,p0);
Rl1=conv(Yl,p1);

%% Sous-Echantillonage

Rln0=downsample(Rl0(Fse:N*Fse),Fse);
Rln1=downsample(Rl1(Fse:N*Fse),Fse);

Rln=zeros(1,N);

%% Décision

for i=1:N
    if Rln0(i)<Rln1(i)
        Rln(i)=1;
    end
end

teb = sum(abs(Rln-Sb))/N;
 
%% Calcul du TEB

Eg=sum(g.^2);


for j=1:length(SNR)
    TEB_err=[];
    erreur=[];
    sigma2=Eg/(2*SNR_lin(j)); 
    
    
    while sum(erreur)<100

        nl=sqrt(sigma2)*randn(1,length(Sl));

        Yl = Sl + nl;

        rl0=conv(Yl,p0);
        rl1=conv(Yl,p1);

        rln0=downsample(rl0(Fse:N*Fse),Fse);
        rln1=downsample(rl1(Fse:N*Fse),Fse);

        rln=zeros(1,N);

        for i=1:N
            if rln0(i)<rln1(i)
                rln(i)=1;
            end
        end
        
        TEB_err = [TEB_err sum(abs(rln-Sb))/N];
        erreur = [erreur sum(abs(rln-Sb))];

    end
    
    TEB(j)=sum(TEB_err)/length(TEB_err);

end


figure(4)
semilogy(SNR,TEB)
hold on
semilogy(SNR,1/2*erfc(sqrt(SNR_lin)),'r')
title ('comparaison du TEB experimental et theorique')
xlabel('Eb/No en dB')
legend('TEB expérimental', 'TEB théorique')
grid on
