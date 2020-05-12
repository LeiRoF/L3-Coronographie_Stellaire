function process_reverse(fname, Progress)
  
  [A,hdr] = readfits(fname);
  
  
  waitbar(0.1, Progress, 'Récupération de l amplitude complexe');


  % TF -> PSF Coronographique
  waitbar(0.2, Progress, 'TF 1');
  A = fftshift(fft2(fftshift(A)));
  writefits(sprintf('Reverse-1a-TFLyot %s.fits',fname),A);
  writefits(sprintf('Reverse-1b-TFLyot %s.fits',fname),abs(A).^2);


    % TF-1
  waitbar(0.4, Progress, 'TF 2');
  A = fftshift(ifft2(fftshift(A)));
  writefits(sprintf('Reverse-2b-TFMasque2 %s.fits',fname), A);
  writefits(sprintf('Reverse-2b-TFMasque2 %s.fits',fname), abs(A).^2);
    
  % Création du masque
  [N,N2]=size(A);
  waitbar(0.6, Progress, 'Génération du masque');
  M = FQPM(N, N/2, N/2);
  writefits(sprintf("Reverse-3-Masque %s.fits",fname), M);
  
  % Application du masque
  waitbar(0.8, Progress, 'Application du masque');
  A = A .* M;
  writefits(sprintf('Reverse-4a-TFMasque %s.fits',fname), A);
  writefits(sprintf('Reverse-4a-TFMasque %s.fits',fname), abs(A).^2);

   % Pupille: TF -> PSF
  waitbar(1.0, Progress, 'TF 1');
  A = fftshift(fft2(fftshift(A)));
  writefits(sprintf('Reverse-5a-TFPupille %s.fits',fname), A);
  writefits(sprintf('Reverse-5b-TFPupille %s.fits',fname),abs(A).^2);
  
  
  close(Progress);
  
endfunction