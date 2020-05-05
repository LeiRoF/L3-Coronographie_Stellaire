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
  
  i=1;
  
  
  name = sprintf('N=%d, D=%d, l=%.2f, Op=%.2f, Ol=%.2f, Without Mask', N, D, l(i), Op(i), Ol(i));
  
  Progress = waitbar(0.0, sprintf('Simulation %s', name));
  pos_w1=get(Progress,'position');
  pos_w2=[0 100 pos_w1(3) pos_w1(4)];
  set(Progress,'position',pos_w2,'doublebuffer','on')
  
  fprintf('Simulations for: %s ...\n', name);
  main(N, D, Op(i), Ol(i), yc, xc, m, res, l(i), name, i, 0, Progress);
  
  
  
  for i = 1:n
    waitbar(i/n, Progress, sprintf('Simulation %s', name));
    name = sprintf('N=%d, D=%d, l=%.2f, Op=%.2f, Ol=%.2f, With Mask', N, D, l(i), Op(i), Ol(i));
    fprintf('Simulation for: %s ...\n', name);
    main(N, D, Op(i), Ol(i), yc, xc, m, res, l(i), name, i, 1, Progress);
  end
  close(Progress);
  
  legend
  
endfunction
