function [Zr, R] = process(N, D, Op, Ol, yc, xc, m, res, l, name, i, mask, pup, Progress)
  
  % __________________________________________________ 
  % Création de la pupille
  
  waitbar(0.1, Progress, 'Génération de la pupille');
  p = mkpup(N ,D ,Op);
  
  % __________________________________________________ 
  % Application de la pupille au miroir
  
  p = pup .* p;
  waitbar(0.2, Progress, 'Application de la pupille');
  writefits(sprintf('1-Pupille %s.fits', name),p);
  
  % __________________________________________________ 
  % Création du masque
  
  waitbar(0.3, Progress, 'Génération du masque');
  M = FQPM(N, N/2, N/2);
  writefits("2-Masque.fits", M);
  
  % __________________________________________________ 
  % Pupille: TF -> PSF
  
  waitbar(0.4, Progress, 'TF 1');
  A = Shift_im2(p, N);
  writefits(sprintf('3a-TFPupille %s.fits', name),A);
  writefits(sprintf('3b-TFPupille %s.fits', name),abs(A).^2);
  a = A;
  % A: avec masque      a: sans masque
  
  % __________________________________________________ 
  % Application du masque
  
  waitbar(0.5, Progress, 'Application du masque');
  if mask == 1;
  A = A .* M;
  writefits(sprintf('4a-TFMasque %s.fits', name), A);
  writefits(sprintf('4b-TFMasque %s.fits', name), abs(A).^2);
  end;

  % __________________________________________________ 
  % TF-1
  
  waitbar(0.6, Progress, 'TF 2');
  A = fftshift(ifft2(fftshift(A)));
  writefits(sprintf('5a-TFMasque2 %s.fits', name), A);
  writefits(sprintf('5b-TFMasque2 %s.fits', name), abs(A).^2);
  
  % __________________________________________________ 
  % Création du Lyot
  
  waitbar(0.7, Progress, 'Génération du Lyot Stop');
  L = mkpup(N, D*l, Ol);
  writefits(sprintf("6-Lyot %s.fits", name),L);
  
  % __________________________________________________ 
  % Application du Lyot
  
  waitbar(0.8, Progress, 'Application du Lyot Stop');
  A = A .* L;
  writefits(sprintf('7a-ApplicationLyot %s.fits', name),A);
  writefits(sprintf('7b-ApplicationLyot %s.fits', name),abs(A).^2);

  % __________________________________________________ 
  % TF -> PSF Coronographique
  
  waitbar(0.9, Progress, 'TF 3');
  A = fftshift(fft2(fftshift(A)));
  writefits(sprintf('8a-TFLyot %s.fits', name),A);
  writefits(sprintf('8b-TFLyot %s.fits', name),abs(A).^2);
  
  % __________________________________________________ 
  % Profil radial PSF
  
  waitbar(1.0, Progress, 'Génération du profile radial');
  Max = max(max(abs(a)^2)); % Max 2D
  B = (abs(A)^2)/Max;
  [Zr, R] = radialavg(B,m,0,0,Progress);
  
  % __________________________________________________ 
  % Plots
  
  if mod(i,3) == 0;
  semilogy((R(1:res*12)*N/2)/res,Zr(1:res*12),'--','DisplayName',name);hold on;
  end;
  if mod(i,3) == 1;
  semilogy((R(1:res*12)*N/2)/res,Zr(1:res*12),':','DisplayName',name);hold on;
  end;
  if mod(i,3) == 2;
  semilogy((R(1:res*12)*N/2)/res,Zr(1:res*12),'-.','DisplayName',name);hold on;
  end;

  % __________________________________________________ 
  % Legend
  
  xlabel({'Position sur le détecteur','(en résolution angulaire)'});
  ylabel ({'Intensité normalisée'});
  set(gcf, 'name', 'Profil radial av masque');
  
endfunction