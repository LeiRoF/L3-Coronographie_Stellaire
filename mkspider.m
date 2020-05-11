function res = mkspider(dim, nb_arms, width)

% Angle entre les bras
angle = 360/nb_arms;

% Création de la matrice
res = zeros(dim);
res(:,:) = 1;

% Création des branches
for i=1:nb_arms
  % Création d'une matrice de 1
  mat = zeros(dim);
  mat(:,:) = 1;

  % Tracage du bras du centre de la matrice jusqu'au coté droit avec une épaisseur width
  mat(ceil(dim/2-width/2):ceil(dim/2+width/2),ceil(dim/2):dim) = 0;
  
  % Rotation de la matrice
  mat = imrotate(mat, angle * (i-1) - 90, 'bilinear', 'crop');

  % Ajout du bras dans la matrice principale
  res = res .* mat;
  
  % Debug
  writefits(sprintf('Test %d.fits', i), res);
end

% Debug
writefits('Test final.fits', res);
end