function [delta_t, delta_f] = estim_delta(yl)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

fe = 20000000;
Te = 1/fe;
Tp = 8*10^-6;

Sp = [ones(1,10) zeros(1,10) ones(1,10) zeros(1,40) ones(1,10) zeros(1,10) ones(1,10) zeros(1,60)];

% Nous sotckons l'ensemble des valeurs que peut prendre la corrélation
% dans une matrice de taille (100*2001)

corr=zeros(100,2001);

for x=1:101 
    for y=1:2002
        corr(x,y) = sum(yl(x:x+160-1).*Sp.*exp(1i*2*pi*(y-1000)*((x:x+160-1)*Te)))/((sqrt(sum(Sp.^2))*(sqrt(sum(yl(x:x+160-1)).^2))));
    end
end

%% Nous récupérons les indices de delta_t et delta_f : 

               
[max_col,index] = max(abs(corr)); % Nous récupérons l'index pour les valeurs max par colonne;
[~,index_del_f] = max(max_col); % Nous récupérons l'index du del_f correspondant dans la matrice;

delta_f = index_del_f - 1000;
delta_t = index(index_del_f)-1; % Nous récupérons l'index du del_t correspondant (numéro de la ligne);

     
end


