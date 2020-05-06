function main(N, D, Op, Ol, yc, xc, m, res, l, name, i, mask, pup, ParentProgress)
  
  Progress = waitbar(0.1, 'Génération de la pupille');
  pos_w1=get(ParentProgress,'position');
  pos_w2=[pos_w1(1) pos_w1(2)+pos_w1(4) pos_w1(3) pos_w1(4)];
  set(Progress,'position',pos_w2,'doublebuffer','on')

  % Création de la pupille
  p = mkpup(N ,D ,Op);
  
  % Application de la pupille au miroir
  p = pup .* p;
  waitbar(0.2, Progress, 'Application de la pupille');
  writefits(sprintf('1-Pupille %s.fits', name),p);
  
  % Création du masque
  waitbar(0.3, Progress, 'Génération du masque');
  M = FQPM(N, N/2, N/2);
  writefits("2-Masque.fits", M);
  
  % Pupille: TF -> PSF
  waitbar(0.4, Progress, 'TF 1');
  A = Shift_im2(p, N);
  writefits(sprintf('3-TFPupille %s.fits', name),abs(A).^2);
  a = A;
  % A: avec masque      a: sans masque
  
  % Application du masque
  waitbar(0.5, Progress, 'Application du masque');
  if mask == 1;
  A = A .* M;
  writefits(sprintf('4-TFMasque %s.fits', name), A);
  end;
  
  % TF-1
  waitbar(0.6, Progress, 'TF 2');
  A = fftshift(ifft2(fftshift(A)));
  writefits(sprintf('5-TFMasque2 %s.fits', name), abs(A).^2);
  
  % Création du Lyot
  waitbar(0.7, Progress, 'Génération du Lyot Stop');
  L = mkpup(N, D*l, Ol);
  writefits(sprintf("6-Lyot %s.fits", name),L);
  
  % Application du Lyot
  waitbar(0.8, Progress, 'Application du Lyot Stop');
  A = A .* L;
  writefits(sprintf('7-ApplicationLyot %s.fits', name),abs(A).^2);

  % TF -> PSF Coronographique
  waitbar(0.9, Progress, 'TF 3');
  A = fftshift(fft2(fftshift(A)));
  writefits(sprintf('8-TFLyot %s.fits', name),abs(A).^2);
  
  
  % Profil radial PSF
  waitbar(1.0, Progress, 'Génération du profile radial');
  Max = max(max(abs(a)^2)); % Max 2D
  B = (abs(A)^2)/Max;
  [Zr, R] = radialavg(B,m,0,0,Progress);
  
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
  
  % Legend
  xlabel({'Position sur le détecteur','(en résolution angulaire)'});
  ylabel ({'Intensité normalisée'});
  set(gcf, 'name', 'Profil radial av masque');

  close(Progress);
  
endfunction