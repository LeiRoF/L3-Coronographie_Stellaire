function simulations
  Progress = waitbar(0.0, 'Generating mirror');
  pos_w1=get(Progress,'position');
  pos_w2=[0 100 pos_w1(3) pos_w1(4)];
  set(Progress,'position',pos_w2,'doublebuffer','on')
  
  
  lambda = 4;
  div = 16; % micrometres par pixel
  D = 7.7*1000/div;
  N = ceil(D)*lambda;
  
  Nb_Mirrors = 7;
  Radius = 350/div;
  Gap = 4/div;
  
  Op   = [0.30 0.30 0.30 0.30 0.30]; % Obstruction centrale pupille
  Ol   = [0.30 0.30 0.30 0.30 0.30]; % Obstruction centrale Lyot
  l    = [1.00 0.95 0.90 0.85 0.80]; % Diamètre Lyot (pourcentage pupille)
  
  yc = 0; % Position x centre
  xc = 0; % Position y centre
  m = N/2; % Bins number
  res = N/D; % Résolution angulaire
  n = 5;
  figure;
  
  

  
  # Mirroir Segmenté
  
  fname = sprintf('0-Mirror div=%d.fits', div);
  if isfile(fname)
    [pup,hdr] = readfits(fname);
  else
    Grid = BuildGrid(Radius, sqrt(3.)*Radius/2., Gap, Nb_Mirrors, Progress);
    BasisSegmentsCube = BuildApodizedSegment(Grid, Radius, sqrt(3.)*Radius/2., Nb_Mirrors,Progress); % segments
    pup = BuildApodizedPupil(Radius, sqrt(3.)*Radius/2., Nb_Mirrors, Grid, BasisSegmentsCube, Gap,Progress); % pupil wo aberrations
    
  end
  
  % Rendre la matrice carré
  [N1,N2]=size(pup);
  disp('Avant');
  disp(N);
  disp(N1);
  disp(N2);
  
  if(N1 > N2 )
    diff = ceil((N1-N2)/2);
    %Ajout lignes
    pup=[pup zeros(N1,diff)];
    pup=[zeros(N1,diff) pup];
  end
  writefits(fname,pup);
  
  [N1,N2]=size(pup);
  disp('Pendant');
  disp(N1);
  disp(N2);
  % Aggrandir la matrice pour avoir le bon lambda
  
  %Ajout lignes
  for(i=1:N-N1)
    if(mod(i,2)==0)
      pup=[pup zeros(N1,1)];
    else
      pup=[zeros(N1,1) pup];
    end
  end
  %Ajout colonnes
  for(i=1:N-N1)
    if(mod(i,2)==0)
      pup=[pup ; zeros(1,N)];
    else
      pup=[zeros(1,N) ; pup];
    end
  end
  [N1,N2]=size(pup);
  disp('Final');
  disp(N1);
  disp(N2);
  
  
  if(mod(N1,2)==1)
    %Recentrer de +0,5 pixel
  end
  
  
  
  # Simulation without mask
  i=1;
  name = sprintf('N=%d, D=%d, l=%.2f, Op=%.2f, Ol=%.2f, Without Mask', N, D, l(i), Op(i), Ol(i));
  waitbar(0.0, Progress, sprintf('Simulation %s', name))
  fprintf('Simulations for: %s ...\n', name);
  main(N, D, Op(i), Ol(i), yc, xc, m, lambda, l(i), name, i, 0, pup, Progress);
  
  
  # Simulations with mask
  for i = 1:n
    waitbar(i/n, Progress, sprintf('Simulation %s', name));
    name = sprintf('N=%d, D=%d, l=%.2f, Op=%.2f, Ol=%.2f, With Mask', N, D, l(i), Op(i), Ol(i));
    fprintf('Simulation for: %s ...\n', name);
    main(N, D, Op(i), Ol(i), yc, xc, m, lambda, l(i), name, i, 1, pup, Progress);
  end
  close(Progress);
  
  legend
  
endfunction
