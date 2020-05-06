function simulations
  
  lambda = 4;
  N = 2048; % Taille Matrice
  D = N/lambda; % Diamètre pupille
  Op   = [0.00 0.00 0.00 0.00 0.00]; % Obstruction centrale pupille
  Ol   = [0.00 0.00 0.00 0.00 0.00]; % Obstruction centrale Lyot
  l    = [1.00 0.95 0.90 0.85 0.80]; % Diamètre Lyot (pourcentage pupille)
  yc = 0; % Position x centre
  xc = 0; % Position y centre
  m = N/2; % Bins number
  res = N/D; % Résolution angulaire
  n = 1;
  figure;
  
  Progress = waitbar(0.0, 'Generating mirror');
  pos_w1=get(Progress,'position');
  pos_w2=[0 100 pos_w1(3) pos_w1(4)];
  set(Progress,'position',pos_w2,'doublebuffer','on')

  
  # Mirroir Segmenté
  div = 128; % micrometres par pixel
  D = 7.7*1000/div;
  if isfile('0-Mirror.fits')
    [pup,hdr] = readfits('0-Mirror.fits');
  else
    Nb_Mirrors = 7;
    Radius = 350/div;
    Gap = 4/div;
    Grid = BuildGrid(Radius, sqrt(3.)*Radius/2., Gap, Nb_Mirrors, Progress);
    BasisSegmentsCube = BuildApodizedSegment(Grid, Radius, sqrt(3.)*Radius/2., Nb_Mirrors,Progress); % segments
    pup = BuildApodizedPupil(Radius, sqrt(3.)*Radius/2., Nb_Mirrors, Grid, BasisSegmentsCube, Gap,Progress); % pupil wo aberrations
    writefits('0-Mirror.fits',pup);
  end
  
  [N,osef]=size(pup);
  disp(N);
  
  # Simulation without mask
  i=1;
  name = sprintf('N=%d, D=%d, l=%.2f, Op=%.2f, Ol=%.2f, Without Mask', N, D, l(i), Op(i), Ol(i));
  waitbar(0.0, Progress, sprintf('Simulation %s', name))
  fprintf('Simulations for: %s ...\n', name);
  main(N, D, Op(i), Ol(i), yc, xc, m, res, l(i), name, i, 0, pup, Progress);
  
  
  # Simulations with mask
  for i = 1:n
    waitbar(i/n, Progress, sprintf('Simulation %s', name));
    name = sprintf('N=%d, D=%d, l=%.2f, Op=%.2f, Ol=%.2f, With Mask', N, D, l(i), Op(i), Ol(i));
    fprintf('Simulation for: %s ...\n', name);
    main(N, D, Op(i), Ol(i), yc, xc, m, res, l(i), name, i, 1, pup, Progress);
  end
  close(Progress);
  
  legend
  
endfunction
