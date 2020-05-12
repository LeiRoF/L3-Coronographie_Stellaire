function main
  
  % __________________________________________________  
  % Installation des prérequis
  
  addpath('./utils');
  
  if !any(strcmp({ver.Name}, 'image'))
    pkg install -forge image
    pkg load image
  end
  
  figure;
 
  % __________________________________________________  
  % Récupération de la configuration
  
  [n, lambda, div, D, nb_arms, arms_width, nb_Mirrors, Diametre, Gap, Op, Ol, l, mask] = config(0);
  
  % __________________________________________________  
  % Barres de progression
  
  ParentProgress = waitbar(0.0, 'Simulation');
  pos_w1=get(ParentProgress,'position');
  pos_w2=[0 100 pos_w1(3) pos_w1(4)];
  set(ParentProgress,'position',pos_w2,'doublebuffer','on')
  
  Progress = waitbar(0.0, 'BuildGrid X');
  pos_w1=get(ParentProgress,'position');
  pos_w2=[pos_w1(1) pos_w1(2)+pos_w1(4) pos_w1(3) pos_w1(4)];
  set(Progress,'position',pos_w2,'doublebuffer','on')
  
  
for simu=0:n
  
  % __________________________________________________  
  % Configuration de la simulation
  
  [n, lambda, div, D, nb_arms, armos_width, nb_Mirrors, Diametre, Gap, Op, Ol, l, mask] = config(simu);
  
  % __________________________________________________  
  % Modification des paramètres
  
  arms_width = ceil(arms_width/div);
  D = D/div;
  N = ceil(D)*lambda;
  
  Radius = Diametre/(2*div);
  Gap = Gap/div;
  
  yc = 0; % Position x centre
  xc = 0; % Position y centre
  m = N/2; % Bins number
  
  if mask == 0
    name = sprintf('N=%d, D=%d, l=%.2f, Op=%.2f, Ol=%.2f, Without Mask', N, D, l, Op, Ol);
  else
    name = sprintf('N=%d, D=%d, l=%.2f, Op=%.2f, Ol=%.2f, With Mask', N, D, l, Op, Ol);
  end
  
  if n != 0
     waitbar(simu/n, ParentProgress, sprintf('Simulation %s', name));
  else
     waitbar(1, ParentProgress, sprintf('Simulation %s', name));
  end
  
  
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
  [N1,N2]=size(pup);
  
  if(N1 > N2 )
    diff = ceil((N1-N2)/2);
    
    pup=[pup zeros(N1,diff)]; % Ajout lignes
    pup=[zeros(N1,diff) pup];
  end
  writefits(fname,pup);
  
  [N1,N2]=size(pup);
  
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
  
  for(i=1:N-N1)     % Ajout colonnes
    waitbar(i/(N-N1), Progress, 'Resize matrix on Y');
    if(mod(i,2)==0)
      pup=[pup ; zeros(1,N)];
    else
      pup=[zeros(1,N) ; pup];
    end
  end
  [N1,N2]=size(pup);
  
  pup = pup .* mkspider(N, nb_arms, arms_width);
  
  
  % __________________________________________________ 
  % Run simulations 
    
  fprintf('Simulation for: %s ...\n', name);
  process(N, D, Op, Ol, yc, xc, m, lambda, l, name, simu, mask, pup, Progress);
  
end
  
  % __________________________________________________ 
  % End
  close(Progress);
  close(ParentProgress);
  legend
  
endfunction
