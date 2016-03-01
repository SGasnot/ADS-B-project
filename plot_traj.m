function [ ] = plot_traj( registre,Nb_trames )
% Fonction permettant l'affichage de l'avion.


MER_LON = -0.710648; % Longitude de l'aéroport de Mérignac
MER_LAT = 44.836316; % Latitude de l'aéroport de Mérignac

% On affiche l'aéroport de Mérignac sur la carte
plot(MER_LON,MER_LAT,'.r','MarkerSize',20);
text(MER_LON+0.05,MER_LAT,'Merignac airport','color','r')
% On affiche une carte sans le nom des villes
plot_google_map('MapType','terrain','ShowLabels',0);

xlabel('Longitude en degré');
ylabel('Lattitude en degré');

hold on;

for i=1:Nb_trames
    
    
    plane_lat=registre.trajectoire(i,1);
    plane_long=registre.trajectoire(i,2);
       

PLANE_LON = plane_long; % Longitude de l'avion
PLANE_LAT = plane_lat; % Latitude de l'avion
plot(PLANE_LON,PLANE_LAT,'+b','MarkerSize',8);


end

Id_airplane=registre.nom; % Nom de l'avion

plot(PLANE_LON,PLANE_LAT,'+b','MarkerSize',8);
text(PLANE_LON+0.05,PLANE_LAT,Id_airplane,'color','b');


end

