% [VECTEUR_RESEAU]=construire_reseau(R,R_B,GAP,N)
%
% R = segment's radius
% R_B = base radius <=> sqrt(3)*R/2
% GAP = intersegment's distance
% N = order (number of rings around the center segment)
%
% Fonction permettant de construire vecteur_reseau qui contient la position
% des centres de chaque segment tout en respectant la forme hexagonale pour
% la pupille
% 
% 
% 
% 
%                _______________________________________
%               |                                       |  
%               |                                       |
%               |                                       |
%               |                   .                   |
%               |                .     .                |
%               |             .     .     .             |
%               |          .     .     .     .          | 
%               |       .     .     .     .     .       |
%               |          .     .     .     .          | 
%               |       .     .     .     .     .       |
%               |          .     .     .     .          |
%               |       .     .     .     .     .       |
%               |          .     .     .     .          |
%               |       .     .     .     .     .       |
%               |          .     .     .     .          |
%               |       .     .     .     .     .       |
%               |          .     .     .     .          |
%               |             .     .     .             |
%               |                .     .                |
%               |                   .                   |
%               |                                       |
%               |                           L. De Vinci |
%               |_______________________________________|  
%
%                      R�seau hexagonal de Vitruve      
%









function[Grid]=BuildGrid(R,Rb,mirrors_gap,N,ParentProgress)

    Progress = waitbar(0.0, 'BuildGrid X');
    pos_w1=get(ParentProgress,'position');
    pos_w2=[pos_w1(1) pos_w1(2)+pos_w1(4) pos_w1(3) pos_w1(4)];
    set(Progress,'position',pos_w2,'doublebuffer','on')
    
Progress2 = waitbar(0.0, 'BuildGrid Y');
        pos_w1=get(Progress,'position');
        pos_w2=[pos_w1(1) pos_w1(2)+pos_w1(4) pos_w1(3) pos_w1(4)];
        set(Progress2,'position',pos_w2,'doublebuffer','on')

%D�FINITION D'UN COMPTEUR D'OCCURENCE
compteur=1;

%D�FINITION DE LA LONGEUR ET DE LA LARGUEUR DE LA PUPILLE
X=((3*N+2)*R+N*sqrt(3)*mirrors_gap);
Y=((4*N+2)*Rb+2*N*mirrors_gap)+R;

%D�FINITION DE LA PENTE DES BORDS DU R�SEAU N�CESSAIRE POUR CONTRAINDRE LES
%SEGMENT � LA FORME HEXAGONALE DE LA PUPILLE
pente=(2*Rb+mirrors_gap)/(3*R+sqrt(3)*mirrors_gap);

%INITIALISATION DU VECTEUR CONTENANT LES POSITIONS DES CENTRES
Grid=zeros(3*N*(N+1)+1, 2);

%D�FINITION DU PAS VERTICAL ET HORIZONTAL DU R�SEAU
grid_X=3*R+sqrt(3)*mirrors_gap;
grid_Y=2*Rb+mirrors_gap;

%CONDITION SUR N N�CESSAIRE POUR AVOIR LE BON FORMAT
if(mod(N,2)==0)
    disp("\b");

    
    %CR�ATION DU R�SEAU PRINCIPAL
    waitbar(0.0, Progress, 'BuildGrid X');

    for i=0:grid_X:X
        waitbar(i/X, Progress, 'BuildGrid X');
        waitbar(0.0, Progress2, 'BuildGrid Y');
        

        for j=0:grid_Y:Y
            waitbar(j/Y, Progress2, 'BuildGrid Y');
            
            %D�FINITION DES �QUATION DES C�T�S DE L'HEXAGONE PUPILLAIRE
            A=(4*Rb+2*mirrors_gap)*N/4 - pente*i;
            B=-A;
            C=A+(4*N+2)*Rb+2*N*mirrors_gap+R*sqrt(3)/3;
            D=B+(4*N+2)*Rb+2*N*mirrors_gap+R*sqrt(3)/3;

            %CR�ATION DE BOOL�EN TESTANT L'APPARTENANCE OU NON DES POINTS
            %AU R�SEAU
            bool_1=(j>=A+1);
            bool_2=(j>=B+1);
            bool_3=(j<=C);
            bool_4=(j<=D);

            if(bool_1&&bool_2&&bool_3&&bool_4&&i<=X-grid_X/2)

                %REMPLISSAGE DE VECTEUR R�SEAU AVEC LES COORDONN�ES (PLUS
                %D�CALLAGE POUR PRENDRE COMPTE DE LA DISTANCE AUX BORDS)
                Grid(compteur,1)=i+3*R;
                Grid(compteur,2)=j+R;

                %INCR�MENTATION DU COMPTEUR
                compteur=compteur+1;

            end

        end

    end
  
  
       
    %CR�ATION DU R�SEAU SECONDAIRE (ENTRE LES MAILLES DU PRINCIPAL)
    waitbar(0.0, Progress, 'BuildGrid2 X');
    
    for i=grid_X/2:grid_X:X
        
        waitbar(i/X, Progress, 'BuildGrid2 X');
        waitbar(0.0, Progress2, 'BuildGrid2 Y');
        
        
        for j=grid_Y/2:grid_Y:Y
            waitbar(j/Y, Progress, 'BuildGrid2 Y');

            %D�FINITION DES �QUATION DES C�T�S DE L'HEXAGONE PUPILLAIRE
            A=(4*Rb+2*mirrors_gap)*N/4- pente*i;
            B=-A;
            C=A+(4*N+2)*Rb+2*N*mirrors_gap+R*sqrt(3)/3;
            D=B+(4*N+2)*Rb+2*N*mirrors_gap+R*sqrt(3)/3;

            %CR�ATION DE BOOL�EN TESTANT L'APPARTENANCE OU NON DES POINTS
            %AU R�SEAU
            bool_1=(j>=A+1);
            bool_2=(j>=B+1);
            bool_3=(j<=C);
            bool_4=(j<=D);

            if(bool_1&&bool_2&&bool_3&&bool_4&&i<=X-grid_X/2)

                %REMPLISSAGE DE VECTEUR R�SEAU AVEC LES COORDONN�ES (PLUS
                %D�CALLAGE POUR PRENDRE COMPTE DE LA DISTANCE AUX BORDS)
                Grid(compteur,1)=i+3*R;
                Grid(compteur,2)=j+R;

                %INCR�MENTATION DU COMPTEUR
                compteur=compteur+1;

            end

        end

    end

else

    %CR�ATION DU R�SEAU PRINCIPAL
    waitbar(0.0, Progress, 'BuildGrid3 X');
    
    for i=0:grid_X:X
        waitbar(i/X, Progress, 'BuildGrid3 X');
        waitbar(0.0, Progress2, 'BuildGrid3 Y');

        for j=0:grid_Y:Y
            waitbar(j/Y, Progress, 'BuildGrid3 Y');

            %D�FINITION DES �QUATION DES C�T�S DE L'HEXAGONE PUPILLAIRE
            A=(4*Rb+2*mirrors_gap)*N/4 - pente*i;
            B=-A;
            C=A+(4*N+2)*Rb+2*N*mirrors_gap+R*sqrt(3)/3;
            D=B+(4*N+2)*Rb+2*N*mirrors_gap+R*sqrt(3)/3;

            %CR�ATION DE BOOL�EN TESTANT L'APPARTENANCE OU NON DES POINTS
            %AU R�SEAU
            bool_1=(j>=A);
            bool_2=(j>=B);
            bool_3=(j<=C);
            bool_4=(j<=D);

            if(bool_1&&bool_2&&bool_3&&bool_4&&i<=X-grid_X/2)

                %REMPLISSAGE DE VECTEUR R�SEAU AVEC LES COORDONN�ES (PLUS
                %D�CALLAGE POUR PRENDRE COMPTE DE LA DISTANCE AUX BORDS)
                Grid(compteur,1)=i+3*R;
                Grid(compteur,2)=j+2*R;

                %INCR�MENTATION DU COMPTEUR
                compteur=compteur+1;

            end

        end

    end

    %CR�ATION DU R�SEAU SECONDAIRE (ENTRE LES MAILLES DU PRINCIPAL)
    waitbar(0.0, Progress, 'BuildGrid4 X');
        
    for i=grid_X/2:grid_X:X
        waitbar(i/X, Progress, 'BuildGrid4 X');
        waitbar(0.0, Progress2, 'BuildGrid4 Y');

        for j=grid_Y/2:grid_Y:Y
            waitbar(j/Y, Progress, 'BuildGrid4 Y');

            %D�FINITION DES �QUATION DES C�T�S DE L'HEXAGONE PUPILLAIRE
            A=(4*Rb+2*mirrors_gap)*N/4- pente*i;
            B=-A;
            C=A+(4*N+2)*Rb+2*N*mirrors_gap+R*sqrt(3)/3;
            D=B+(4*N+2)*Rb+2*N*mirrors_gap+R*sqrt(3)/3;

            %CR�ATION DE BOOL�EN TESTANT L'APPARTENANCE OU NON DES POINTS
            %AU R�SEAU
            bool_1=(j>=A);
            bool_2=(j>=B);
            bool_3=(j<=C);
            bool_4=(j<=D);

            if(bool_1&&bool_2&&bool_3&&bool_4&&i<=X-grid_X/2)

                %REMPLISSAGE DE VECTEUR R�SEAU AVEC LES COORDONN�ES (PLUS
                %D�CALLAGE POUR PRENDRE COMPTE DE LA DISTANCE AUX BORDS)
                Grid(compteur,1)=i+3*R;
                Grid(compteur,2)=j+2*R;

                %INCR�MENTATION DU COMPTEUR
                compteur=compteur+1;

            end

        end
        

    end
  

end

close(Progress2);
close(Progress);
    
end


