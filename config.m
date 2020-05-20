function [n, airy, div, D, nb_arms, arms_width, arms_width_lyot, nb_Mirrors, Diametre, Gap, Op, Ol, l, mask, pupil, lyot] = config(i)
  
  n                = 0;           % Nombre de simulations � faire tourner
                                  % Le param�tre i va de 0 � n
  
  % __________________________________________________ 
  % Param�tres par d�faut
  
  airy             = 4;           % R�solution (nombre de pixels de d�finition de la tache d'Airy)
  div              = 16;          % R�solution en microm�tre/pixel
  D                = 7.7*1000;    % Diam�tre de la pupille en microm�tre

  nb_arms          = 6;           % Nombre de bras pour l'araign�e
  arms_width       = 0.1*1000;    % Largeur des bras en microm�tre
  arms_width_lyot  = 1;           % * arms_width
              
  nb_Mirrors       = 7;           % Nombre de miroir consitituant le diam�tre du miroir principal
  Diametre         = 700;         % Rayon des miroirs en microm�tre
  Gap              = 4;           % Espacement des miroirs en microm�tre

  Op               = 0.30;        % Obstruction centrale pupille en %
  Ol               = 0.50;        % Obstruction centrale Lyot en %
  l                = 0.95;        % Diam�tre Lyot en % de la pupille principale
  
  mask             = 1;           % 1 = appliquer le masque, 0 = ignorer le masque
  pupil            = 1            % 1 = appliquer une pupille, 0 = sans pupille
  lyot             = 1            % 1 = appliquer le lyot, 0 = sans lyot
  
  % __________________________________________________ 
  % Param�tres en fonction de la simulation
  
  
  % Param�tres pour le 2-ring    https://cdn.discordapp.com/attachments/669836399079587846/712322665217523792/unknown.png
    nb_arms=0;
    Op=0;
    Ol=0;
    lyot=0;
    pupil=0;
    nb_Mirrors = 2;
            
endfunction
