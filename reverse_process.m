function process(N, D, Op, Ol, yc, xc, m, res, l, name, i, mask, pup, ParentProgress)
  
  Progress = waitbar(0.1, 'Génération de la pupille');
  pos_w1=get(ParentProgress,'position');
  pos_w2=[pos_w1(1) pos_w1(2)+pos_w1(4) pos_w1(3) pos_w1(4)];
  set(Progress,'position',pos_w2,'doublebuffer','on')


  % TF -> PSF Coronographique
  waitbar(0.9, Progress, 'TF 3');
  A = fftshift(fft2(fftshift(A)));
  writefits(sprintf('8-TFLyot %s.fits', name),abs(A).^2);

  % Application du Lyot
  waitbar(0.8, Progress, 'Application du Lyot Stop');
  A = A .* L;
  writefits(sprintf('7-ApplicationLyot %s.fits', name),abs(A).^2);

  % Création du Lyot
  waitbar(0.7, Progress, 'Génération du Lyot Stop');
  L = mkpup(N, D*l, Ol);
  writefits(sprintf("6-Lyot %s.fits", name),L);

    % TF-1
  waitbar(0.6, Progress, 'TF 2');
  A = fftshift(ifft2(fftshift(A)));
  writefits(sprintf('5-TFMasque2 %s.fits', name), abs(A).^2);

  
    
  % Création du masque
  waitbar(0.3, Progress, 'Génération du masque');
  M = FQPM(N, N/2, N/2);
  writefits("2-Masque.fits", M);
  
  % Application du masque
  waitbar(0.5, Progress, 'Application du masque');
  if mask == 1;
  A = A .* M;
  writefits(sprintf('4-TFMasque %s.fits', name), A);
  end;



   % Pupille: TF -> PSF
  waitbar(0.4, Progress, 'TF 1');
  A = Shift_im2(p, N);
  writefits(sprintf('3-TFPupille %s.fits', name),abs(A).^2);
  a = A;
  % A: avec masque      a: sans masque

  
  

  

  


  

  
  

  
  
  close(Progress);
  
endfunction