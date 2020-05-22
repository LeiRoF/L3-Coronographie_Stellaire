function [Zr, R] = process(N, yc, xc, m, simu, ratio_N_D, resolution, mirrors_nb, mirrors_hide_nb, mirrors_radius, mirrors_gap, mirror_orientation, pupil_diameter, pupil_obstruction, arms_nb, arms_width, arms_origin, lyot_diameter, lyot_obstruction, lyot_arms_width, lyot_based_on_pupil, apply_pupil, apply_mask, apply_lyot, Progress)

  name = sprintf('Resolution = %um.px-1, Airy=%dpx, pupil_obstruction=%.2f, Aw=%.2fum, An=%d,lyot= %.2f, lyot_obstruction=%.2f, Awl=%.2f, Mask=%d', resolution, ratio_N_D, pupil_obstruction/100, arms_width, arms_nb, lyot_diameter, lyot_obstruction/100, lyot_arms_width, apply_mask);
  mirror_name = sprintf('Mirror Div = %.2f px.um-1, Segments = %d, mirrors_radius= %.2f um, mirrors_gap = %.2f um.fits', resolution, mirrors_nb, mirrors_radius, mirrors_gap);

  if 1
    simu_folder = "simu";
    mkdir(simu_folder);
    mkdir(simu_folder, name);

    path = sprintf('./%s/%s/', simu_folder, name);
    mirror_path = sprintf('./%s/%s', simu_folder, mirror_name);
  else
    path = '';
    mirror_path = '0-Mirror.fits';
  endif



  % __________________________________________________
  % Génération ou récupération du mirroir segmenté

  fname = sprintf('./simu/Mirror Div = %.2f px.um-1, Segments = %d, mirrors_radius= %.2f um, mirrors_gap = %.2f um.fits', resolution, mirrors_nb, mirrors_radius, mirrors_gap);
  if isfile(mirror_path)
    waitbar(0.0, Progress, 'Recuperation of existing mirror');
    [pup,hdr] = readfits(mirror_path);
  else
    waitbar(0.0, Progress, 'Generating mirror');
    Grid = BuildGrid(mirrors_radius, sqrt(3.)*mirrors_radius/2., mirrors_gap, mirrors_nb, Progress);
    BasisSegmentsCube = BuildApodizedSegment(Grid, mirrors_radius, sqrt(3.)*mirrors_radius/2., mirrors_nb,Progress); % segments
    pup = BuildApodizedPupil(mirrors_radius, sqrt(3.)*mirrors_radius/2., mirrors_nb, Grid, BasisSegmentsCube, mirrors_gap,Progress); % pupil wo aberrations
    writefits(mirror_path,pup);
  end

  % __________________________________________________
  % Rendre la matrice du miroir carrée

  [sx, sy] = size(pup);
  if sx < N && sy < N
    pup_tmp = zeros(N);

    %pup_tmp(N/2+1-floor(sx/2) : N/2+floor(sx/2)+1 , N/2+1-floor(sy/2) : N/2+floor(sy/2)+1) = pup;
    ox = floor(N/2+1)-floor(sx/2)
    oy = floor(N/2+1)-floor(sy/2)

    pup_tmp(ox : ox+sx-1 , oy : oy+sy-1) = pup;

  end
  clear pup;
  p = pup_tmp;
  p = imrotate(p, mirror_orientation, 'bilinear', 'crop');


% __________________________________________________
% Génération de l obstructions des miroirs centraux

  if mirrors_hide_nb >= 0
    Grid = BuildGrid(mirrors_radius, sqrt(3.)*mirrors_radius/2., mirrors_gap, mirrors_hide_nb, Progress);
    BasisSegmentsCube = BuildApodizedSegment(Grid, mirrors_radius, sqrt(3.)*mirrors_radius/2., mirrors_hide_nb, Progress); % segments
    obst = BuildApodizedPupil(mirrors_radius, sqrt(3.)*mirrors_radius/2., mirrors_hide_nb, Grid, BasisSegmentsCube, mirrors_gap, Progress); % pupil wo aberrations

    [sx, sy] = size(obst);
    if sx < N && sy < N
      obst_tmp = zeros(N);

      ox = floor(N/2+1)-floor(sx/2);
      oy = floor(N/2+1)-floor(sy/2);

      obst_tmp(ox : ox+sx-1 , oy : oy+sy-1) = obst;
    end
    clear obst;
    obst = obst_tmp;
    obst = obst .* -1;
    obst = obst .+ 1;
    obst = imrotate(obst, mirror_orientation, 'bilinear', 'crop');

    p = p .* obst;
  endif

  % __________________________________________________
  % Création de la pupille

  if apply_pupil != 0;
    waitbar(0.1, Progress, 'Génération de la pupille');
    p = p .* mkpup(N ,pupil_diameter ,pupil_obstruction);
  end
  p = p .* mkspider(N, arms_nb, arms_width, arms_origin);

  writefits(sprintf('%s1-Pupille.fits', path),p);

  % __________________________________________________
  % Pupille: TF -> PSF

  waitbar(0.4, Progress, 'TF 1');
  A = Shift_im2(p, N);
  writefits(sprintf('%s3a-TFPupille.fits', path),A);
  writefits(sprintf('%s3b-TFPupille.fits', path),abs(A).^2);
  a = A;
  % A: avec masque      a: sans masque

  % __________________________________________________
  % Création du masque

  if apply_mask == 1;
    waitbar(0.3, Progress, 'Génération du masque');
    M = FQPM(N, N/2, N/2);
    writefits(sprintf('%s2-Masque.fits', path), M);

  % __________________________________________________
  % Application du masque

    waitbar(0.5, Progress, 'Application du masque');
    A = A .* M;
    writefits(sprintf('%s4a-TFMasque.fits', path), A);
    writefits(sprintf('%s4b-TFMasque.fits', path), abs(A).^2);
  end;

  % __________________________________________________
  % TF-1

  waitbar(0.6, Progress, 'TF 2');
  A = fftshift(ifft2(fftshift(A)));
  writefits(sprintf('%s5a-TFMasque2.fits', path), A);
  writefits(sprintf('%s5b-TFMasque2.fits', path), abs(A).^2);

  % __________________________________________________
  % Création du Lyot

  if apply_lyot == 1;
    waitbar(0.7, Progress, 'Génération du Lyot Stop');
    if lyot_based_on_pupil;
       L = p;
       disp('oui');
       writefits(sprintf("%s6-Lyot aaaaaa.fits", path),L);
    else
       L = zeros(N);
       L(:,:) = 1;
       disp('non');
    endif
    if apply_pupil;
      lyot_diameter
      lyot_obstruction
      writefits(sprintf("%s6-Lyot ccccccc.fits", path),mkpup(N, lyot_diameter, lyot_obstruction));
      L = L .* mkpup(N, lyot_diameter, lyot_obstruction);
      writefits(sprintf("%s6-Lyot bbbbbb.fits", path),L);
    endif
    L = L .* mkspider(N, arms_nb, lyot_arms_width, arms_origin);
    writefits(sprintf("%s6-Lyot.fits", path),L);

  % __________________________________________________
  % Application du Lyot

    waitbar(0.8, Progress, 'Application du Lyot Stop');
    A = A .* L;
    writefits(sprintf('%s7a-ApplicationLyot.fits', path),A);
    writefits(sprintf('%s7b-ApplicationLyot.fits', path),abs(A).^2);
  end

  % __________________________________________________
  % TF -> PSF Coronographique

  waitbar(0.9, Progress, 'TF 3');
  A = fftshift(fft2(fftshift(A)));
  writefits(sprintf('%s8a-TFLyot.fits', path),A);
  writefits(sprintf('%s8b-TFLyot.fits', path),abs(A).^2);

  % __________________________________________________
  % Profil radial PSF

  waitbar(1.0, Progress, 'Génération du profile radial');
  Max = max(max(abs(a)^2)); % Max 2D
  B = (abs(A)^2)/Max;
  [Zr, R] = radialavg(B,m,0,0,Progress);

  % __________________________________________________
  % Plots

  if mod(simu,3) == 0;
  figure(1);semilogy((R(1:ratio_N_D*12)*N/2)/ratio_N_D,Zr(1:ratio_N_D*12),'--','DisplayName',sprintf('Simulation n°%d', simu));hold on;
  end;
  if mod(simu,3) == 1;
  figure(1);semilogy((R(1:ratio_N_D*12)*N/2)/ratio_N_D,Zr(1:ratio_N_D*12),':','DisplayName',sprintf('Simulation n°%d', simu));hold on;
  end;
  if mod(simu,3) == 2;
  figure(1);semilogy((R(1:ratio_N_D*12)*N/2)/ratio_N_D,Zr(1:ratio_N_D*12),'-.','DisplayName',sprintf('Simulation n°%d', simu));hold on;
  end;

  % __________________________________________________
  % Legend

  xlabel({'Position sur le détecteur','(en résolution angulaire)'});
  ylabel ({'Intensité normalisée'});
  set(gcf, 'name', 'Profil radial av masque');

endfunction
