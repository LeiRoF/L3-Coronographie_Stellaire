function [n, airy, div, D, nb_arms, arms_width, nb_Mirrors, Diametre, Gap, Op, Ol, l, mask] = config(i)
  
  n              = 0;           % Nombre de simulations � faire tourner
                                % Le param�tre i va de 0 � n
  
  % __________________________________________________ 
  % Param�tres de base
  
  airy         = 4;           % R�solution (nombre de pixels de d�finition de la tache d'Airy)
  div            = 64;          % R�solution en pixel/microm�tre
  D              = 7.7*1000;    % Diam�tre de la pupille en microm�tre

  nb_arms        = 6;           % Nombre de bras pour l'araign�e
  arms_width     = 0.1*1000;    % Largeur des bras en microm�tre
              
  nb_Mirrors     = 7;           % Nombre de miroir consitituant le diam�tre du miroir principal
  Diametre       = 700;         % Rayon des miroirs en microm�tre
  Gap            = 4;           % Espacement des miroirs en microm�tre

  Op             = 0.30;        % Obstruction centrale pupille en %
  Ol             = 0.30;        % Obstruction centrale Lyot en %
  l              = 0.95;        % Diam�tre Lyot en % de la pupille principale
  mask           = 1;           % 1 = appliquer le masque, 0 = ignorer le masque
  
  
  % __________________________________________________ 
  % Param�tres en fonction de la simulation
  
  if i != 0
     Ol = 0.30 + i/10;
  end
            
            
endfunction
