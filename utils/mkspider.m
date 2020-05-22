function res = mkspider(N, arms_nb, arms_width, arms_origin)


% Cr�ation de la matrice
res = zeros(N);
res(:,:) = 1;

if arms_nb > 0;
  
  % Angle entre les bras
  angle = 360/arms_nb;


  % Cr�ation des branches
  for i=1:arms_nb
    % Cr�ation d'une matrice de 1
    mat = zeros(N);
    mat(:,:) = 1;

    
    if(mod(arms_width,2)==1)
      mat(N/2+1-ceil(arms_width/2):N/2+ceil(arms_width/2),floor(N/2):N) = 0.5;
    end
    % Tracage du bras du centre de la matrice jusqu'au cot� droit avec une �paisseur arms_width
    mat(N/2+1-floor(arms_width/2):N/2+floor(arms_width/2),floor(N/2):N) = 0;
    
    % Rotation de la matrice
    mat = imrotate(mat, angle * (i-1) - 90 + arms_origin, 'bilinear', 'crop');

    % Ajout du bras dans la matrice principale
    res = res .* mat;
    
  end
  
  res(1:N-2,1:N-2) = res(2:N-1,2:N-1);
end

end