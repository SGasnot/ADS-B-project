%% CAYLA Théo - GASNOT Sacha

clc
close all
clear all

%% -------------------------------- Question 17 ------------------------


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

Sp = [ones(1,10) zeros(1,10) ones(1,10) zeros(1,40) ones(1,10) zeros(1,10) ones(1,10) zeros(1,60)];




for j=1:length(SNR)
    TEB_err=[];
    erreur=[]; 
    
    
    while sum(erreur)<100
       
        
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
        
        Se = upsample(Ss, Fse);


        %% Filtrage

        g1 = -0.5*ones(1,Fse/2);
        g2 = 0.5*ones(1,Fse/2);
        g = [g1 g2];
        
        Eg=sum(g.^2);
        sigma2=Eg/(2*SNR_lin(j));
        
        Sl = 0.5 + conv(g,Se);

        Sl1 = [ Sp Sl ];

        %% Décalages temporel et fréquentiel

        del_t = randi([1 101],1,1);

        del_f = -1000 + randi([1 2001],1,1);
        
        %% 

        Nl = sqrt(sigma2)*randn(1,length(Sl1)); %+ sqrt(sigma2)*1i*randn(1,length(Sl1)
        
        yl = [zeros(1,del_t) Sl1];
        
        %% Synchronisation
        
        t=(0:Te:(length(yl)*Te)-Te);
        yl = yl.*exp(-1i*2*pi*del_f*t);
        
        [delta_t,delta_f] = estim_delta(yl);
        
        
        %% Désynchronisation
        
        
        yl=yl.*exp(1i*2*pi*delta_f*t);
        Yl=yl(delta_t+length(Sp)+1:end);
        
        %% Suite de la chaine de communication
        
      
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
        
        
        
        
        