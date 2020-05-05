function simulations
  
  div = 4;
  N = 2048/div; % Taille Matrice
  D = 512/(4*div); % Diamètre pupille
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
  fprintf('Simulation for: %s ...\n', name);
  main(div, N, D, Op(i), Ol(i), yc, xc, m, res, l(i), name, i, 0);
  
  for i = 1:n
    name = sprintf('N=%d, D=%d, l=%.2f, Op=%.2f, Ol=%.2f, With Mask', N, D, l(i), Op(i), Ol(i));
    fprintf('Simulation for: %s ...\n', name);
    main(div, N, D, Op(i), Ol(i), yc, xc, m, res, l(i), name, i, 1);
  end
  legend
  
endfunction
