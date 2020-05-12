function [Zr, R] = process(N, D, div, Op, Ol, yc, xc, m, res, l, name, i, mask, nb_Mirrors, Radius, Gap, nb_arms, arms_width, Progress)
  
  % __________________________________________________  
  % Génération ou récupération du mirroir segmenté
  
  fname = sprintf('0-Mirror div=%d.fits', div);
  if isfile(fname)
    waitbar(0.0, Progress, 'Recuperation of existing mirror');
    [pup,hdr] = readfits(fname);
  else
    waitbar(0.0, Progress, 'Generating mirror');
    Grid = BuildGrid(Radius, sqrt(3.)*Radius/2., Gap, nb_Mirrors, Progress);
    BasisSegmentsCube = BuildApodizedSegment(Grid, Radius, sqrt(3.)*Radius/2., nb_Mirrors,Progress); % segments
    pup = BuildApodizedPupil(Radius, sqrt(3.)*Radius/2., nb_Mirrors, Grid, BasisSegmentsCube, Gap,Progress); % pupil wo aberrations
    
  end
  
  % __________________________________________________ 
  % Rendre la matrice du miroir carrée
  disp('1');
  [N1,N2]=size(pup)
  
  
  if(N1 > N2 )
    diff = ceil((N1-N2)/2);
    
    pup=[pup zeros(N1,diff)]; % Ajout lignes
    if(mod(N1-N2,2)==0)
      pup=[zeros(N1,diff) pup];
    else
      pup=[zeros(N1,diff-1) pup];
    end
  end
  
  disp('2');
  [N1,N2]=size(pup)
  
  if(N2 > N1)
    diff = ceil((N2-N1)/2);
    
    pup=[pup ; zeros(diff, N2)]; % Ajout colonnes
    if(mod(N1-N2,2)==0)
      pup=[zeros(diff, N2) ; pup];
    else 
      pup=[zeros(diff-1, N2) ; pup];
    end
  end
  
  writefits(fname,pup);
  
  disp('3');
  [N1,N2]=size(pup)
  
  % __________________________________________________ 
  % Aggrandir la matrice pour avoir le bon lambda
  
  for(i=1:N-N1)     % Ajout lignes
    waitbar(i/(N-N1), Progress, 'Resize matrix on X');
    if(mod(i,2)==0)
      pup=[pup zeros(N1,1)];
    else
      pup=[zeros(N1,1) pup];
    end
  end
 
  [N1,N2]=size(pup);
  for(i=1:N-N1)     % Ajout colonnes
    waitbar(i/(N-N1), Progress, 'Resize matrix on Y');
    if(mod(i,2)==0)
      pup=[pup ; zeros(1,N2)];
    else
      pup=[zeros(1,N2) ; pup];
    end
  end
  [N1,N2]=size(pup);
  
  pup = pup .* mkspider(N, nb_arms, arms_width);
  
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
  L = L .* mkspider(N, nb_arms, arms_width);
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