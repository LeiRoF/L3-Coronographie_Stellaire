function Pupille=BuildApodizedPupil(r,r_b,N,reseau,SegmentTab,gap)

min_y=min(reseau(:,2));
min_x=min(reseau(:,1));

%Pupille=zeros(ceil([4*N*r_b+2*N*gap+2*min_y,3*N*r+sqrt(3)*N*gap+2*min_x]));
Pupille=zeros(ceil([4*N*r_b+2*N*gap+2*min_y,3*N*r+sqrt(3)*N*gap+2*min_x]));

for i=1:length(reseau)
    
    L_x=floor(reseau(i,2)-ceil(r)-1:reseau(i,2)+ceil(r));
    L_y=floor(reseau(i,1)-ceil(r)-1:reseau(i,1)+ceil(r));
    
    
    Pupille(L_x,L_y)=Pupille(L_x,L_y)+SegmentTab(:,:,i);
    %imagesc(Pupille)

end

%disp(['min(Pupille) = ' num2str(min(min(Pupille))) ' ; max(Pupille) = ' ...
 %   num2str(max(max(Pupille)))])

end
