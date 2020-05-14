function [Zr, R] = process(N, D, div, Op, Ol, yc, xc, m, res, l, i, mask, nb_Mirrors, Radius, Gap, nb_arms, arms_width, arms_width_lyot, Progress)
  
  name = sprintf('Resolution = %um.px-1, Airy=%dpx, Op=%.2f, Aw=%.2fum, An=%d, l = %.2f, Ol=%.2f, Awl=%.2f, Mask=%d', div, res, Op/100, arms_width, nb_arms, l/100, Ol/100, arms_width_lyot, mask);
  path = sprintf('./simu/%s/', name);
  mkdir('simu');
  mkdir('simu', name);
  
  % __________________________________________________  
  % Génération ou récupération du mirroir segmenté
  
  fname = sprintf('./simu/Mirror Div = %.2f px.um-1, Segments = %d, Radius= %.2f um, Gap = %.2f um.fits', div, nb_Mirrors, Radius, Gap);
  if isfile(fname)
    waitbar(0.0, Progress, 'Recuperation of existing mirror');
    [pup,hdr] = readfits(fname);
  else
    waitbar(0.0, Progress, 'Generating mirror');
    Grid = BuildGrid(Radius, sqrt(3.)*Radius/2., Gap, nb_Mirrors, Progress);
    BasisSegmentsCube = BuildApodizedSegment(Grid, Radius, sqrt(3.)*Radius/2., nb_Mirrors,Progress); % segments
    pup = BuildApodizedPupil(Radius, sqrt(3.)*Radius/2., nb_Mirrors, Grid, BasisSegmentsCube, Gap,Progress); % pupil wo aberrations
    writefits(fname,pup);
  end
  
  % __________________________________________________ 
  % Rendre la matrice du miroir carrée
  
  N
  [sx, sy] = size(pup)
  if sx < N && sy < N
    pup_tmp = zeros(N);
    
    %pup_tmp(N/2+1-floor(sx/2) : N/2+floor(sx/2)+1 , N/2+1-floor(sy/2) : N/2+floor(sy/2)+1) = pup;
    ox = floor(N/2+1)-floor(sx/2)
    oy = floor(N/2+1)-floor(sy/2)
    
    pup_tmp(ox : ox+sx-1 , oy : oy+sy-1) = pup;
    
  end
  clear pup;
  pup = pup_tmp;
  
  % __________________________________________________ 
  % Création de la pupille
  
  waitbar(0.1, Progress, 'Génération de la pupille');
  p = mkpup(N ,D ,Op) .* mkspider(N, nb_arms, arms_width);
  
  % __________________________________________________ 
  % Application de la pupille au miroir
  
  p = pup .* p;
  waitbar(0.2, Progress, 'Application de la pupille');
  
  
  
  
  writefits(sprintf('%s1-Pupille.fits', path),p);
  
  % __________________________________________________ 
  % Création du masque
  
  waitbar(0.3, Progress, 'Génération du masque');
  M = FQPM(N, N/2, N/2);
  writefits(sprintf('%s2-Masque.fits', path), M);
  
  % __________________________________________________ 
  % Pupille: TF -> PSF
  
  waitbar(0.4, Progress, 'TF 1');
  A = Shift_im2(p, N);
  writefits(sprintf('%s3a-TFPupille.fits', path),A);
  writefits(sprintf('%s3b-TFPupille.fits', path),abs(A).^2);
  a = A;
  % A: avec masque      a: sans masque
  
  % __________________________________________________ 
  % Application du masque
  
  waitbar(0.5, Progress, 'Application du masque');
  if mask == 1;
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
  
  waitbar(0.7, Progress, 'Génération du Lyot Stop');
  L = mkpup(N, D*l, Ol);
  L = L .* mkspider(N, nb_arms, arms_width_lyot);
  writefits(sprintf("%s6-Lyot.fits", path),L);
  
  % __________________________________________________ 
  % Application du Lyot
  
  waitbar(0.8, Progress, 'Application du Lyot Stop');
  A = A .* L;
  writefits(sprintf('%s7a-ApplicationLyot.fits', path),A);
  writefits(sprintf('%s7b-ApplicationLyot.fits', path),abs(A).^2);

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
  
  if mod(i,3) == 0;
  figure(1);semilogy((R(1:res*12)*N/2)/res,Zr(1:res*12),'--','DisplayName',name);hold on;
  end;
  if mod(i,3) == 1;
  figure(1);semilogy((R(1:res*12)*N/2)/res,Zr(1:res*12),':','DisplayName',name);hold on;
  end;
  if mod(i,3) == 2;
  figure(1);semilogy((R(1:res*12)*N/2)/res,Zr(1:res*12),'-.','DisplayName',name);hold on;
  end;

  % __________________________________________________ 
  % Legend
  
  xlabel({'Position sur le détecteur','(en résolution angulaire)'});
  ylabel ({'Intensité normalisée'});
  set(gcf, 'name', 'Profil radial av masque');
  
endfunction