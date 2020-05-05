function pup = mkpup(dim,pupdim,obsc)  

[x,y] = meshgrid(1:dim);
x = x- dim/2 + 0.5; 
y = y- dim/2 + 0.5; 
ratio = sqrt(x.^2+y.^2) / (pupdim/2);
pup = (ratio <= 1) & (ratio >= obsc);

end