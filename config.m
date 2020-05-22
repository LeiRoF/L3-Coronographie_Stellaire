function [n, ratio_N_D, resolution, mirrors_nb, mirrors_hide_nb, mirrors_diameter, mirrors_gap, mirror_orientation, pupil_diameter, pupil_obstruction, arms_nb, arms_width, arms_origin, lyot_diameter, lyot_obstruction, lyot_arms_width, lyot_based_on_pupil, apply_pupil, apply_mask, apply_lyot] = config(i)

  n                         = 0;           % Nombre de simulations à faire tourner
                                           % Le paramétre i va de 0 é n

  % __________________________________________________
  % Paramétres par défaut

  ratio_N_D                 = 4;           % Résolution (nombre de pixels de définition de la tache d'Airy)
  resolution                = 32;          % Résolution en micrométre/pixel

  mirrors_nb                = 7;           % Nombre de miroir consitituant le diamétre du miroir principal
  mirrors_hide_nb           = -1;          % Nombre de miroir centraux cachés (-1 pour ne pas utiliser ce type d'obstruction)
  mirrors_diameter          = 700;         % Rayon des miroirs en micrométre
  mirrors_gap               = 4;           % Espacement des miroirs en micrométre
  mirror_orientation        = 0;           % Change l'orientation des mirroirs

  pupil_diameter            = 7.7*1000;    % Diamétre de la pupille en micrométre
  pupil_obstruction         = 0.30;        % Obstruction centrale pupille en %

  arms_nb                   = 6;           % Nombre de bras pour l'araignée
  arms_width                = 0.1*1000;    % Largeur des bras en micrométre
  arms_origin               = 0;           % Angle du premier bras en é

  lyot_diameter             = 1.00;        % * pupil_diameter
  lyot_obstruction          = 1.00;        % * pupil_obstruction
  lyot_arms_width           = 1.00;        % * arms_width
  lyot_based_on_pupil       = 1;           % 1 = reprends l'image de la pupille (segments de miroirs inclus), 0 = non

  apply_pupil               = 1;           % 1 = appliquer une pupille, 0 = sans pupille (miroir seul)
  apply_mask                = 1;           % 1 = appliquer le masque, 0 = ignorer le masque
  apply_lyot                = 1;           % 1 = appliquer le lyot, 0 = sans lyot

  % __________________________________________________
  % Paramétres en fonction de la simulation


endfunction
