function [n, airy, div, D, nb_arms, arms_width, arms_width_lyot, nb_Mirrors, Diametre, Gap, Op, Ol, l, mask, pupil, lyot] = config(i)
  
  n                = 0;           % Nombre de simulations à faire tourner
                                  % Le paramètre i va de 0 à n
  
  % __________________________________________________ 
  % Paramètres par défaut
  
  airy             = 4;           % Résolution (nombre de pixels de définition de la tache d'Airy)
  div              = 16;          % Résolution en micromètre/pixel
  D                = 7.7*1000;    % Diamètre de la pupille en micromètre

  nb_arms          = 6;           % Nombre de bras pour l'araignée
  arms_width       = 0.1*1000;    % Largeur des bras en micromètre
  arms_width_lyot  = 1;           % * arms_width
              
  nb_Mirrors       = 7;           % Nombre de miroir consitituant le diamètre du miroir principal
  Diametre         = 700;         % Rayon des miroirs en micromètre
  Gap              = 4;           % Espacement des miroirs en micromètre

  Op               = 0.30;        % Obstruction centrale pupille en %
  Ol               = 0.50;        % Obstruction centrale Lyot en %
  l                = 0.95;        % Diamètre Lyot en % de la pupille principale
  
  mask             = 1;           % 1 = appliquer le masque, 0 = ignorer le masque
  pupil            = 1            % 1 = appliquer une pupille, 0 = sans pupille
  lyot             = 1            % 1 = appliquer le lyot, 0 = sans lyot
  
  % __________________________________________________ 
  % Paramètres en fonction de la simulation
  
  
  % Paramètres pour le 2-ring    https://cdn.discordapp.com/attachments/669836399079587846/712322665217523792/unknown.png
    nb_arms=0;
    Op=0;
    Ol=0;
    lyot=0;
    pupil=0;
    nb_Mirrors = 2;
            
endfunction
