function Pupille=BuildApodizedPupil(r,r_b,N,reseau,SegmentTab,gap,ParentProgress)

min_y=min(reseau(:,2));
min_x=min(reseau(:,1));

%Pupille=zeros(ceil([4*N*r_b+2*N*gap+2*min_y,3*N*r+sqrt(3)*N*gap+2*min_x]));
Pupille=zeros(ceil([4*N*r_b+2*N*gap+2*min_y,3*N*r+sqrt(3)*N*gap+2*min_x]));


Progress = waitbar(0.0, 'BuildApodizedPupil');
pos_w1=get(ParentProgress,'position');
pos_w2=[pos_w1(1) pos_w1(2)+pos_w1(4) pos_w1(3) pos_w1(4)];
set(Progress,'position',pos_w2,'doublebuffer','on')
    
       
for i=1:length(reseau)
    waitbar(i/length(reseau), Progress, 'BuildApodizedPupil');
    
    L_x=floor(reseau(i,2)-ceil(r)-1:reseau(i,2)+ceil(r));
    L_y=floor(reseau(i,1)-ceil(r)-1:reseau(i,1)+ceil(r));
    
    
    Pupille(L_x,L_y)=Pupille(L_x,L_y)+SegmentTab(:,:,i);
    %imagesc(Pupille)

end
close(Progress);

%disp(['min(Pupille) = ' num2str(min(min(Pupille))) ' ; max(Pupille) = ' ...
 %   num2str(max(max(Pupille)))])

end
