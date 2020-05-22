function main

  % __________________________________________________
  % Installation des prérequis

  close("all");
  addpath('./utils');

  if !any(strcmp({ver.Name}, 'image'))
    pkg install -forge image
  end

  pkg load image

  figure;

  % __________________________________________________
  % Récupération de la configuration

  [n, ratio_N_D, resolution, mirrors_nb, mirrors_hide_nb, mirrors_diameter, mirrors_gap, mirror_orientation, pupil_diameter, pupil_obstruction, arms_nb, arms_width, arms_origin, lyot_diameter, lyot_obstruction, lyot_arms_width, lyot_based_on_pupil, apply_pupil, apply_mask, apply_lyot] = config(0);

  % __________________________________________________
  % Barres de progression

  ParentProgress = waitbar(0.0, 'Simulation');
  pos_w1=get(ParentProgress,'position');
  pos_w2=[0 100 pos_w1(3) pos_w1(4)];
  set(ParentProgress,'position',pos_w2,'doublebuffer','on')

  Progress = waitbar(0.0, 'BuildGrid X');
  pos_w1=get(ParentProgress,'position');
  pos_w2=[pos_w1(1) pos_w1(2)+pos_w1(4) pos_w1(3) pos_w1(4)];
  set(Progress,'position',pos_w2,'doublebuffer','on')


for simu=0:n

  % __________________________________________________
  % Configuration de la simulation

  [n, ratio_N_D, resolution, mirrors_nb, mirrors_hide_nb, mirrors_diameter, mirrors_gap, mirror_orientation, pupil_diameter, pupil_obstruction, arms_nb, arms_width, arms_origin, lyot_diameter, lyot_obstruction, lyot_arms_width, lyot_based_on_pupil, apply_pupil, apply_mask, apply_lyot] = config(simu);

  % __________________________________________________
  % Modification des paramétres

  pupil_diameter = ceil(pupil_diameter/resolution);
  arms_width = ceil(arms_width/resolution);

  lyot_arms_width = ceil(arms_width*lyot_arms_width);
  lyot_diameter = ceil(pupil_diameter * lyot_diameter);
  lyot_obstruction = pupil_obstruction * lyot_obstruction;

  N = 2^ceil(log2(pupil_diameter*ratio_N_D));

  mirrors_radius = mirrors_diameter/(2*resolution);
  mirrors_gap = mirrors_gap/resolution;

  yc = 0; % Position x centre
  xc = 0; % Position y centre
  m = N/2; % Bins number

  % __________________________________________________
  % Run simulations

  name = sprintf('Simulation %d / %d', simu+1, n+1);
  waitbar((simu+1)/(n+1), ParentProgress, name);

  fprintf('Simulation for: %s ...\n', name);
  process(N, yc, xc, m, simu, ratio_N_D, resolution, mirrors_nb, mirrors_hide_nb, mirrors_radius, mirrors_gap, mirror_orientation, pupil_diameter, pupil_obstruction, arms_nb, arms_width, arms_origin, lyot_diameter, lyot_obstruction, lyot_arms_width, lyot_based_on_pupil, apply_pupil, apply_mask, apply_lyot, Progress);

end

  % __________________________________________________
  % End
  close(Progress);
  close(ParentProgress);
  legend

endfunction
