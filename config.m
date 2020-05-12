function [n, airy, div, D, nb_arms, arms_width, nb_Mirrors, Diametre, Gap, Op, Ol, l, mask] = config(i)
  
  n              = 0;           % Nombre de simulations à faire tourner
                                % Le paramètre i va de 0 à n
  
  % __________________________________________________ 
  % Paramètres de base
  
  airy         = 4;           % Résolution (nombre de pixels de définition de la tache d'Airy)
  div            = 64;          % Résolution en pixel/micromètre
  D              = 7.7*1000;    % Diamètre de la pupille en micromètre

  nb_arms        = 6;           % Nombre de bras pour l'araignée
  arms_width     = 0.1*1000;    % Largeur des bras en micromètre
              
  nb_Mirrors     = 7;           % Nombre de miroir consitituant le diamètre du miroir principal
  Diametre       = 700;         % Rayon des miroirs en micromètre
  Gap            = 4;           % Espacement des miroirs en micromètre

  Op             = 0.30;        % Obstruction centrale pupille en %
  Ol             = 0.30;        % Obstruction centrale Lyot en %
  l              = 0.95;        % Diamètre Lyot en % de la pupille principale
  mask           = 1;           % 1 = appliquer le masque, 0 = ignorer le masque
  
  
  % __________________________________________________ 
  % Paramètres en fonction de la simulation
  
  if i != 0
     Ol = 0.30 + i/10;
  end
            
            
endfunction
