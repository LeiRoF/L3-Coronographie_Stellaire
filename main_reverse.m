function main_reverse
  
  % __________________________________________________  
  % Installation des prérequis
  
  addpath('./utils');
 
  % __________________________________________________  
  % Récupération de la configuration
  
  [n, fname] = config_reverse(0);
  
  % __________________________________________________  
  % Barres de progression
  
  ParentProgress = waitbar(0.0, 'Reverse simulation');
  pos_w1=get(ParentProgress,'position');
  pos_w2=[0 100 pos_w1(3) pos_w1(4)];
  set(ParentProgress,'position',pos_w2,'doublebuffer','on')
  
  Progress = waitbar(0.0, 'Progression');
  pos_w1=get(ParentProgress,'position');
  pos_w2=[pos_w1(1) pos_w1(2)+pos_w1(4) pos_w1(3) pos_w1(4)];
  set(Progress,'position',pos_w2,'doublebuffer','on')
  
  
for simu=0:n
  
  % __________________________________________________  
  % Configuration de la simulation
  
  [n, fname] = config_reverse(simu);
  
  if n != 0
    waitbar(simu/n, ParentProgress, sprintf('Reverse %s', fname));
  else
    waitbar(1, ParentProgress, sprintf('Reverse %s', fname));
  end
  
  % __________________________________________________ 
  % Run simulations 
    
  fprintf('Reverse simulation for: %s ...\n', fname);
  process_reverse(fname, Progress);
  
end
  
  % __________________________________________________ 
  % End
  close(Progress);
  close(ParentProgress);
  
endfunction
