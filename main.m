function main(N, D, Op, Ol, yc, xc, m, res, l, name, i, mask)
   
  disp("   > Génération de la pupille");
  R = D;
  Gap = 1;
  Grid = BuildGrid(R, sqrt(3.)*R/2., Gap, N);
  BasisSegmentsCube = BuildApodizedSegment(Grid, R, sqrt(3.)*R/2., N); % segments
  pup = BuildApodizedPupil(R, sqrt(3.)*R/2., N, Grid, BasisSegmentsCube, Gap); % pupil wo aberrations
  writefits(sprintf('0-test %s.fits', name),pup);
    
  % Création de la pupille
  p = mkpup(N ,D ,Op);
  writefits(sprintf('1-Pupille %s.fits', name),p);
  
  % Création du masque
  disp("   > Génération du masque");
  M = FQPM(N, N/2, N/2);
  writefits("2-Masque.fits", M);
  
  % Pupille: TF -> PSF
  disp("   > TF 1");
  A = Shift_im2(p, N);
  writefits(sprintf('3-TFPupille %s.fits', name),abs(A).^2);
  a = A;

  % A: avec masque      a: sans masque
  
  % Application du masque
  disp("   > Application du Masque");
  if mask == 1;
  A = A .* M;
  writefits(sprintf('4-TFMasque %s.fits', name), A);
  end;
  
  % TF-1
  disp("   > TF 2");
  A = fftshift(ifft2(fftshift(A)));
  writefits(sprintf('5-TFMasque2 %s.fits', name), abs(A).^2);
  
  % Création du Lyot
  disp("   > Génération du Lyot Stop"); 
  L = mkpup(N, D*l, Ol);
  writefits(sprintf("6-Lyot %s.fits", name),L);
  
  % Application du Lyot
  disp("   > Application du Lyot Stop");
  A = A .* L;
  writefits(sprintf('7-ApplicationLyot %s.fits', name),abs(A).^2);

  % TF -> PSF Coronographique
  disp("   > TF 3");
  A = fftshift(fft2(fftshift(A)));
  writefits(sprintf('8-TFLyot %s.fits', name),abs(A).^2);
  
  
  % Profil radial PSF
  disp("   > Génération du profile radial");
  Max = max(max(abs(a)^2)); % Max 2D
  B = (abs(A)^2)/Max;
  [Zr, R] = radialavg(B,m,0,0);
  
  % Plots
  disp("   > Génération des plots");
  if mod(i,3) == 0;
  semilogy((R(1:res*12)*N/2)/res,Zr(1:res*12),'--','DisplayName',name);hold on;
  end;
  if mod(i,3) == 1;
  semilogy((R(1:res*12)*N/2)/res,Zr(1:res*12),':','DisplayName',name);hold on;
  end;
  if mod(i,3) == 2;
  semilogy((R(1:res*12)*N/2)/res,Zr(1:res*12),'-.','DisplayName',name);hold on;
  end;
  
  % Legend
  xlabel({'Position sur le détecteur','(en résolution angulaire)'});
  ylabel ({'Intensité normalisée'});
  set(gcf, 'name', 'Profil radial av masque');


endfunction