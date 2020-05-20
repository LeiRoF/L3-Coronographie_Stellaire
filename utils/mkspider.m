function res = mkspider(dim, nb_arms, width, spider_origin)


% Cr�ation de la matrice
res = zeros(dim);
res(:,:) = 1;

if nb_arms > 0;
  
  % Angle entre les bras
  angle = 360/nb_arms;

    width
    dim


  % Cr�ation des branches
  for i=1:nb_arms
    % Cr�ation d'une matrice de 1
    mat = zeros(dim);
    mat(:,:) = 1;

    
    if(mod(width,2)==1)
      mat(dim/2+1-ceil(width/2):dim/2+ceil(width/2),floor(dim/2):dim) = 0.5;
    end
    % Tracage du bras du centre de la matrice jusqu'au cot� droit avec une �paisseur width
    mat(dim/2+1-floor(width/2):dim/2+floor(width/2),floor(dim/2):dim) = 0;
    
    % Rotation de la matrice
    mat = imrotate(mat, angle * (i-1) - 90 + spider_origin, 'bilinear', 'crop');

    % Ajout du bras dans la matrice principale
    res = res .* mat;
    
  end
end

end