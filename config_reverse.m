function [n, fname] = config_reverse(i)
  
  n              = 0;            % Nombre de simulations � faire tourner
                                 % Le param�tre i va de 0 � n
  
  % __________________________________________________ 
  % Param�tres de base
  
  fname          = 'image.fits'; % Nom du fichier
  
  
  % __________________________________________________ 
  % Param�tres en fonction de la simulation
            
  if i != 0
     fname = 'Test2.fits';
  end
  
endfunction
