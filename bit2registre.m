function [ registre_maj ] = bit2registre( message, registre )

% Nous avons du effectuer un fliplr sur l'ensemble de la matrice trame
% fournie

Nb_trames = size(message,2);
    

for i=1:Nb_trames
    %% Detection d'erreur par le CRC

CRC_detec = crc.detector([1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1 ]);

%mess = fliplr(message(89:112,i)');

[outdata error] = detect(CRC_detec,fliplr(message));



if (error == 0)
    
    %% Format :

    registre.format = bi2de(fliplr(message(1:5,i)'));

    %% Adresse

    registre.adresse = dec2hex(bi2de(fliplr(message(9:32,i)')));

    %% Fromat Type Code

    registre.type = bi2de(fliplr(message(33:37,i)'));

    %% Si on est "dans" la trame d'identification

        if ((1<=registre.type) && (registre.type<=4))

    % Tableau de valeur pour les noms des avions
        tab_caract(1,:)= {'' 'P' ' ' '0'};
        tab_caract(2,:)= {'A' 'Q' '' '1'};
        tab_caract(3,:)= {'B' 'R' '' '2'};
        tab_caract(4,:)= {'C' 'S' '' '3'};
        tab_caract(5,:)= {'D' 'T' '' '4'};
        tab_caract(6,:)= {'E' 'U' '' '5'};
        tab_caract(7,:)= {'F' 'V' '' '6'};
        tab_caract(8,:)= {'G' 'W' '' '7'};
        tab_caract(9,:)= {'H' 'X' '' '8'};
        tab_caract(10,:)= {'I' 'Y' '' '9'};
        tab_caract(11,:)= {'J' 'Z' '' ''};
        tab_caract(12,:)= {'K' '' '' ''};
        tab_caract(13,:)= {'L' '' '' ''};
        tab_caract(14,:)= {'M' '' '' ''};
        tab_caract(15,:)= {'N' '' '' ''};
        tab_caract(16,:)= {'0' '' '' ''};
        
    name = '';
    for j=1:8
        vect_cara = fliplr(message(41+6*(j-1):41+6*j-1,i)');
        ligne=num2str(fliplr(vect_cara(1:4)));
        col=num2str(fliplr(vect_cara(5:6)));
        ligne_tab = bin2dec(ligne);
        col_tab = bin2dec(col);

    name = [name tab_caract{ligne_tab+1,col_tab+1}];


    registre.nom = name;

    end
    %% Si on est "dans" la trame de position

        elseif ((9<=registre.type) && (registre.type<=18) || (20<=registre.type) && (registre.type<=22))
    
        % Altitude    
        vect_altitude = fliplr(message(41:52,i)');
        res = [vect_altitude(1:7),vect_altitude(9:12)];
        registre.altitude = 25*bi2de(res)-1000;

        % timeFlag 

        registre.timeFlag = fliplr(message(53,i)');

        %cprFlag

        registre.cprFlag = fliplr(message(54,i)');

        % Latitude 

        Rlat=fliplr(message(55:71,i)');
        LAT=bi2de(Rlat);
        lat_ref = 44.836316;
        Nz=15;
        Nb=17;
        Dlat=360/(4*Nz-registre.cprFlag);
        j=floor(lat_ref/Dlat)+floor(1/2+mod(lat_ref,Dlat)/Dlat-LAT/2^Nb);
        lat=Dlat*(j+LAT/2^Nb);
        registre.latitude=lat;

        % Longitude

        Rlon=fliplr(message(72:88,i)');
        LON=bi2de(Rlon);
        lon_ref = -0.710648;

        if (cprNL(registre.latitude) > registre.cprFlag)
            Dlon = 360/(cprNL(lat)-registre.cprFlag);
        elseif (cprNL(lat) - registre.cprFlag == 0)
            Dlon = 360;
        end  

        m=floor(lon_ref/Dlon)+ floor(1/2+mod(lon_ref,Dlon)/Dlon-LON/2^Nb);
        lon=Dlon*(m+LON/2^Nb);
        registre.longitude=lon;

 
        end
        
%% Trajectoire

registre.trajectoire = [registre.trajectoire; registre.latitude, registre.longitude];

else

    display('Le CRC a detecté des erreurs');
    
end

registre_maj = registre % sans ";" pour afficher l'ensemble des trames


end



