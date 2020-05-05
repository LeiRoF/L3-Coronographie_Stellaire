function[FQPM]=FQPM(N, xc, yc)

FQPM=zeros(N);
FQPM(1:xc,1:yc)=-1;
FQPM(xc+1:end,1:yc)=1;
FQPM(1:xc,yc+1:end)=1;
FQPM(xc+1:end,yc+1:end)=-1;