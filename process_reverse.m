function process_reverse(fname, Progress)
  
  name = fname(1:end-5);
  
  path = sprintf('./simu_reverse/%s/', name);
  mkdir('simu_reverse');
  mkdir('simu_reverse', name);
  
  
  [A,hdr] = readfits(fname);
  
  
  waitbar(0.1, Progress, 'R�cup�ration delyotamplitude complexe');


  % TF -> PSF Coronographique
  waitbar(0.2, Progress, 'TF 1');
  A = fftshift(fft2(fftshift(A)));
  writefits(sprintf('%sReverse-1a-TFLyot.fits',path),A);
  writefits(sprintf('%sReverse-1b-TFLyot.fits',path),abs(A).^2);


    % TF-1
  waitbar(0.4, Progress, 'TF 2');
  A = fftshift(ifft2(fftshift(A)));
  writefits(sprintf('%sReverse-2b-TFMasque2.fits',path), A);
  writefits(sprintf('%sReverse-2b-TFMasque2.fits',path), abs(A).^2);
    
  % Cr�ation du masque
  [N,N2]=size(A);
  waitbar(0.6, Progress, 'G�n�ration du masque');
  M = FQPM(N, N/2, N/2);
  writefits(sprintf("%sReverse-3-Masque.fits",path), M);
  
  % Application du masque
  waitbar(0.8, Progress, 'Application du masque');
  A = A .* M;
  writefits(sprintf('%sReverse-4a-TFMasque.fits',path), A);
  writefits(sprintf('%sReverse-4a-TFMasque.fits',path), abs(A).^2);

   % Pupille: TF -> PSF
  waitbar(1.0, Progress, 'TF 1');
  A = fftshift(fft2(fftshift(A)));
  writefits(sprintf('%sReverse-5a-TFPupille.fits',path), A);
  writefits(sprintf('%sReverse-5b-TFPupille.fits',path),abs(A).^2);
  
endfunction