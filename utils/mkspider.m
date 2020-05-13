function res = mkspider(dim, nb_arms, width)

% Angle entre les bras
angle = 360/nb_arms;

% Création de la matrice
res = zeros(dim);
res(:,:) = 1;


  width
  dim


% Création des branches
for i=1:nb_arms
  % Création d'une matrice de 1
  mat = zeros(dim);
  mat(:,:) = 1;

  
  if(mod(width,2)==1)
    mat(dim/2+1-ceil(width/2):dim/2+ceil(width/2),floor(dim/2):dim) = 0.5;
  
  % Tracage du bras du centre de la matrice jusqu'au coté droit avec une épaisseur width
  mat(dim/2+1-floor(width/2):dim/2+floor(width/2),floor(dim/2):dim) = 0;
  
  % Rotation de la matrice
  mat = imrotate(mat, angle * (i-1) - 90, 'bilinear', 'crop');

  % Ajout du bras dans la matrice principale
  res = res .* mat;
  
end

end