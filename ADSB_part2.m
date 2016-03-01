%% CAYLA THEO - GASNOT SACHA

clc
close all
clear all

%% PARTIE 2 : Traitement / D�codage de signaux r�els
registre = struct('adresse',[],'format',[],'type',[],'nom',[], ...
                   'altitude',[],'timeFlag',[],'cprFlag',[], ...
                  'latitude',[],'longitude',[],'trajectoire',[]);
              
load('trames_20141120.mat');
message = trames_20141120;


Nb_trames = size(trames_20141120,2);

registre_maj=bit2registre(message,registre); 
plot_traj(registre_maj, Nb_trames);

