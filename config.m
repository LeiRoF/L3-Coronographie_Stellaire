function [n, ratio_N_D, resolution, mirrors_nb, mirrors_hide_nb, mirrors_diameter, mirrors_gap, mirror_orientation, pupil_diameter, pupil_obstruction, arms_nb, arms_width, arms_origin, lyot_diameter, lyot_obstruction, lyot_arms_width, lyot_based_on_pupil, apply_pupil, apply_mask, apply_lyot] = config(i)

  n                         = 0;           % Nombre de simulations � faire tourner
                                           % Le param�tre i va de 0 � n

  % __________________________________________________
  % Param�tres par d�faut

  ratio_N_D                 = 4;           % R�solution (nombre de pixels de d�finition de la tache d'Airy)
  resolution                = 32;          % R�solution en microm�tre/pixel

  mirrors_nb                = 7;           % Nombre de miroir consitituant le diam�tre du miroir principal
  mirrors_hide_nb           = -1;          % Nombre de miroir centraux cach�s (-1 pour ne pas utiliser ce type d'obstruction)
  mirrors_diameter          = 700;         % Rayon des miroirs en microm�tre
  mirrors_gap               = 4;           % Espacement des miroirs en microm�tre
  mirror_orientation        = 0;           % Change l'orientation des mirroirs

  pupil_diameter            = 7.7*1000;    % Diam�tre de la pupille en microm�tre
  pupil_obstruction         = 0.30;        % Obstruction centrale pupille en %

  arms_nb                   = 6;           % Nombre de bras pour l'araign�e
  arms_width                = 0.1*1000;    % Largeur des bras en microm�tre
  arms_origin               = 0;           % Angle du premier bras en �

  lyot_diameter             = 1.00;        % * pupil_diameter
  lyot_obstruction          = 1.00;        % * pupil_obstruction
  lyot_arms_width           = 1.00;        % * arms_width
  lyot_based_on_pupil       = 1;           % 1 = reprends l'image de la pupille (segments de miroirs inclus), 0 = non

  apply_pupil               = 1;           % 1 = appliquer une pupille, 0 = sans pupille (miroir seul)
  apply_mask                = 1;           % 1 = appliquer le masque, 0 = ignorer le masque
  apply_lyot                = 1;           % 1 = appliquer le lyot, 0 = sans lyot

  % __________________________________________________
  % Param�tres en fonction de la simulation


endfunction
