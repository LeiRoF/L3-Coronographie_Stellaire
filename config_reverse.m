function [n, fname] = config_reverse(i)
  
  n              = 0;            % Nombre de simulations à faire tourner
                                 % Le paramètre i va de 0 à n
  
  % __________________________________________________ 
  % Paramètres de base
  
  fname          = 'image.fits'; % Nom du fichier
  
  
  % __________________________________________________ 
  % Paramètres en fonction de la simulation
            
  if i != 0
     fname = 'Test2.fits';
  end
  
endfunction
