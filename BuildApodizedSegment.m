function [SegmentTab]=BuildApodizedSegment(GridVector,r,rb,N)

SegmentTab=zeros(2*ceil(r)+2,2*ceil(r)+2,3*N*(N+1)+1);
SegmentStart=zeros(length(GridVector),1);

DeltaXLim=(3+sqrt(3))/6;
DeltaxLim=(3-sqrt(3))/6;

XLim=rb/sqrt(3);

for s=1:length(GridVector)
    
    CenterX=GridVector(s,1);
    CenterY=GridVector(s,2);
    
    LocalStartX=CenterX-floor(CenterX);
    LocalStartY=CenterY-floor(CenterY);
    
    %     LocalStartY=0;
    %     LocalStartX=0;
    SegmentStart(s)=floor(CenterY)-(r+1);
    
    for i=1:2*ceil(r)+2
        for j=1:2*ceil(r)+2
            
            LocalY=-(i-(r+1)-LocalStartY-1/2);
            LocalX=j-(r+1)-LocalStartX-1/2;
            
            %POINT SITUÉ ENTIÈREMENT DANS L'HEXAGONE
            if (LocalY<=rb ...
                    && LocalY>=-rb ...
                    && (LocalY-sqrt(3)*LocalX)>=-2*rb ...
                    && (LocalY+sqrt(3)*LocalX)<=2*rb ...
                    && (LocalY-sqrt(3)*LocalX)<=2*rb ...
                    && (LocalY+sqrt(3)*LocalX)>=-2*rb)
                SegmentTab(i,j,s)=1;
            end
            
            
            
            
            DeltaX1=((LocalY+2*rb)/sqrt(3))-LocalX;
            DeltaX2=((LocalY-2*rb)/(-sqrt(3)))-LocalX;
            DeltaX3=((LocalY-2*rb)/sqrt(3))-LocalX;
            DeltaX4=((LocalY+2*rb)/(-sqrt(3)))-LocalX;
            
            
            %POINT SITUÉ À LA LIMITE HAUTE SELON Y
            if (LocalY>0 && abs(LocalY-rb)<=.5 ...
                    && (LocalY-sqrt(3)*LocalX)>=-2*rb ...
                    && (LocalY+sqrt(3)*LocalX)<=2*rb ...
                    && (LocalY-sqrt(3)*LocalX)<=2*rb ...
                    && (LocalY+sqrt(3)*LocalX)>=-2*rb)
                if rb-LocalY>0
                    SegmentTab(i,j,s)=.5+(rb-LocalY);
                else
                    SegmentTab(i,j,s)=.5+(rb-LocalY);
                end
                
            else
                
                %2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % j = -sqrt(3)*i +2rb
                
                if DeltaX2<=DeltaXLim && DeltaX2>=DeltaxLim && LocalY<=rb ...
                        && LocalY>=-rb && LocalY>0
                    
                    
                    SegmentTab(i,j,s)=1-(sqrt(3)/2)*(DeltaX2-DeltaXLim)^2;
                    
                end
                
                if DeltaX2>=-DeltaXLim && DeltaX2<=-DeltaxLim && LocalY<=rb ...
                        && LocalY>=-rb && LocalY>0
                    
                    SegmentTab(i,j,s)=(sqrt(3)/2)*(DeltaX2+DeltaXLim)^2;
                    
                end
                
                if DeltaX2<=DeltaxLim && DeltaX2>=0 && LocalY<=rb ...
                        && LocalY>=-rb && LocalY>0
                    
                    SegmentTab(i,j,s)=1-((sqrt(3)/6)+(DeltaxLim-DeltaX2));
                    
                end
                if DeltaX2>=-DeltaxLim && DeltaX2<=0 && LocalY<=rb ...
                        && LocalY>=-rb && LocalY>0
                    
                    SegmentTab(i,j,s)=1-((sqrt(3)/6)+(DeltaxLim-DeltaX2));
                    
                end
                
                %3%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % j = sqrt(3)*i +2rb
                
                if DeltaX3<DeltaXLim && DeltaX3>=DeltaxLim && LocalY<=rb ...
                        && LocalY>=-rb && LocalY>0
                    
                    SegmentTab(i,j,s)=(sqrt(3)/2)*(DeltaX3-DeltaXLim)^2;
                    
                end
                
                if DeltaX3>-DeltaXLim && DeltaX3<-DeltaxLim && LocalY<=rb ...
                        && LocalY>=-rb && LocalY>0
                    
                    SegmentTab(i,j,s)=1-(sqrt(3)/2)*(DeltaX3+DeltaXLim)^2;
                    
                end
                
                if DeltaX3<DeltaxLim && DeltaX3>=0 && LocalY<=rb ...
                        && LocalY>=-rb && LocalY>0
                    
                    SegmentTab(i,j,s)=1-((sqrt(3)/6)+(DeltaxLim+DeltaX3));
                    
                end
                if DeltaX3>=-DeltaxLim && DeltaX3<0 && LocalY<=rb ...
                        && LocalY>=-rb && LocalY>0
                    
                    SegmentTab(i,j,s)=1-((sqrt(3)/6)+(DeltaxLim+DeltaX3));
                    
                end
                
                
            end
            
            
            
            
            
            
            %POINT SITUÉ À LA LIMITE BASSE SELON Y
            if (LocalY<0 && abs(-LocalY-rb)<=.5 ...
                    && (LocalY-sqrt(3)*LocalX)>=-2*rb ...
                    && (LocalY+sqrt(3)*LocalX)<=2*rb ...
                    && (LocalY-sqrt(3)*LocalX)<=2*rb ...
                    && (LocalY+sqrt(3)*LocalX)>=-2*rb)
                if -rb-LocalY>0
                    SegmentTab(i,j,s)=.5-(-rb-LocalY);
                else
                    SegmentTab(i,j,s)=.5-(-rb-LocalY);
                end
                
            else
                
                %1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % j = sqrt(3)*i -2rb
                
                if DeltaX1<=DeltaXLim && DeltaX1>=DeltaxLim && LocalY<=rb ...
                        && LocalY>=-rb && LocalY<0
                    
                    SegmentTab(i,j,s)=1-(sqrt(3)/2)*(DeltaX1-DeltaXLim)^2;
                    
                end
                
                if DeltaX1>=-DeltaXLim && DeltaX1<=-DeltaxLim && LocalY<=rb ...
                        && LocalY>=-rb && LocalY<0
                    
                    SegmentTab(i,j,s)=(sqrt(3)/2)*(DeltaX1+DeltaXLim)^2;
                    
                end
                
                if DeltaX1<DeltaxLim && DeltaX1>=0 && LocalY<=rb ...
                        && LocalY>=-rb && LocalY<0
                    
                    SegmentTab(i,j,s)=1-((sqrt(3)/6)+(DeltaxLim-DeltaX1));
                    
                end
                if DeltaX1>=-DeltaxLim && DeltaX1<=0 && LocalY<=rb ...
                        && LocalY>=-rb && LocalY<0
                    
                    SegmentTab(i,j,s)=1-((sqrt(3)/6)+(DeltaxLim-DeltaX1));
                    
                end
                
                %4%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % j = -sqrt(3)*i -2rb
                
                if DeltaX4<DeltaXLim && DeltaX4>=DeltaxLim && LocalY<=rb ...
                        && LocalY>=-rb && LocalY<0
                    
                    SegmentTab(i,j,s)=(sqrt(3)/2)*(DeltaX4-DeltaXLim)^2;
                    
                end
                
                if DeltaX4>-DeltaXLim && DeltaX4<-DeltaxLim && LocalY<=rb ...
                        && LocalY>=-rb && LocalY<0
                    
                    SegmentTab(i,j,s)=1-(sqrt(3)/2)*(DeltaX4+DeltaXLim)^2;
                    
                end
                
                if DeltaX4<DeltaxLim && DeltaX4>=0 && LocalY<=rb ...
                        && LocalY>=-rb && LocalY<0
                    
                    SegmentTab(i,j,s)=1-((sqrt(3)/6)+(DeltaxLim+DeltaX4));
                    
                end
                if DeltaX4>=-DeltaxLim && DeltaX4<0 && LocalY<=rb ...
                        && LocalY>=-rb && LocalY<0
                    
                    SegmentTab(i,j,s)=1-((sqrt(3)/6)+(DeltaxLim+DeltaX4));
                    
                end
                
                
            end
            
            
            
            
            
            
            
            
            
            %RIGHT CORNER
            X1=(LocalY+.5-2*rb)/(-sqrt(3));
            X2=2*rb/sqrt(3);
            X3=(LocalY-.5+2*rb)/(sqrt(3));
            X4=LocalX-.5;
            X5=LocalX-.5;
            
            Y1=LocalY+.5;
            Y3=LocalY-.5;
            Y4=-sqrt(3)*(LocalX-.5)+2*rb;
            Y5=sqrt(3)*(LocalX-.5)-2*rb;
            
            if X2<=LocalX+.5 && X2>=LocalX-.5 && 0<=LocalY+.5 && 0>=LocalY-.5
                
                if  X1>=LocalX-.5 && X3>=LocalX-.5
                    S1=(2*LocalX+1-X1-X2)*(Y1)/2;
                    S2=(2*LocalX+1-X2-X3)*(-Y3)/2;
                    SegmentTab(i,j,s)=1-(S1+S2);
                    
                else if X1<LocalX-.5 && X3>=LocalX-.5
                        S1=(Y1-Y4)+(2*LocalX+1-X4-X2)*Y4/2;
                        S2=(2*LocalX+1-X2-X3)*(-Y3)/2;
                        SegmentTab(i,j,s)=1-(S1+S2);
                        
                    else if X1>=LocalX-.5 && X3<LocalX-.5
                            S1=(2*LocalX+1-X1-X2)*Y1/2;
                            S2=(Y5-Y3)+(2*LocalX+1-X2-X5)*(-Y5)/2;
                            SegmentTab(i,j,s)=1-(S1+S2);
                            
                        else if X1<LocalX-.5 && X3<LocalX-.5
                                SegmentTab(i,j,s)=(X2-X4)*Y4/2+(X2-X5)*(-Y5)/2;
                            end
                            
                        end
                    end
                end
            end
            
            %LEFT CORNER
            X1=(LocalY+.5-2*rb)/(sqrt(3));
            X2=-2*rb/sqrt(3);
            X3=(LocalY-.5+2*rb)/(-sqrt(3));
            X4=LocalX+.5;
            X5=LocalX+.5;
            
            Y1=LocalY+.5;
            Y3=LocalY-.5;
            Y4=sqrt(3)*(LocalX+.5)+2*rb;
            Y5=-sqrt(3)*(LocalX+.5)-2*rb;
            
            if X2<=LocalX+.5 && X2>=LocalX-.5 && 0<=LocalY+.5 && 0>=LocalY-.5
                
                if  X1<=LocalX+.5 && X3<=LocalX+.5
                    S1=(X1+X2-2*LocalX+1)*(LocalY+.5)/2;
                    S2=(X2+X3-2*LocalX+1)*(.5-LocalY)/2;
                    SegmentTab(i,j,s)=1-(S1+S2);
                    
                else if X1>LocalX+.5 && X3<=LocalX+.5
                        S1=(Y1-Y4)+(1+.5+X2-LocalX)*Y4/2;
                        S2=(1+X2+X3-2*LocalX)*(-Y3)/2;
                        SegmentTab(i,j,s)=1-(S1+S2);
                        
                    else if X1<=LocalX+.5 && X3>LocalX+.5
                            S1=(X1+X2+1-2*LocalX)*Y1/2;
                            S2=(Y5-Y3)+(X2+X5+1-2*LocalX)*(-Y5)/2;
                            SegmentTab(i,j,s)=1-(S1+S2);
                            
                        else if X1>LocalX+.5 && X3>LocalX+.5
                                SegmentTab(i,j,s)=(X4-X2)*Y4/2+(X5-X2)*(-Y5)/2;
                            end
                            
                        end
                    end
                end
            end
            
            
            
            
            
            
            
            
            
            
            %UPPER LEFT - CAS 1
            X1=(LocalY+.5-2*rb)/sqrt(3);
            X2=-rb/sqrt(3);
            X3=LocalX-.5;
            
            Y1=LocalY+.5;
            Y2=rb;
            Y3=sqrt(3)*(LocalX-.5)+2*rb;
            
            DeltaX=((LocalY-2*rb)/(sqrt(3)))-LocalX;
            DeltaY=LocalY+.5-rb;
            
            if DeltaX>-DeltaXLim && DeltaX<=-DeltaxLim && LocalY<rb+.5 && LocalY>rb-.5 && X2>LocalX-.5
                
                S1=(X1-LocalX+.5)*(LocalY+.5-Y3)/2;
                S2=DeltaY*((sqrt(3)/6)*DeltaY+(LocalX+.5-X1));
                SegmentTab(i,j,s)=1-(S1+S2);
                %disp(num2str(1-(S1+S2)))
            end
            %UPPER LEFT - CAS 2
            X1=(LocalY+.5-2*rb)/sqrt(3);
            X2=-rb/sqrt(3);
            X3=(LocalY-.5-2*rb)/sqrt(3);
            
            Y1=LocalY+.5;
            Y2=rb;
            Y3=LocalY-.5;
            
            
            DeltaX=((LocalY-2*rb)/(sqrt(3)))-LocalX;
            DeltaY=LocalY+.5-rb;
            
            if DeltaX<DeltaxLim && DeltaX>-DeltaxLim && LocalY<rb+.5 && LocalY>rb-.5 && X2<LocalX+.5
                
                S1=(X1-X3)*(Y1-Y3)/2+(X3-LocalX+.5);
                S2=DeltaY*((sqrt(3)/6)*DeltaY+(LocalX+.5-X1));
                SegmentTab(i,j,s)=1-(S1+S2);
                %disp(num2str(1-(S1+S2)))
            end
            %UPPER LEFT - CAS 3
            X1=LocalX+.5;
            X2=-rb/sqrt(3);
            X3=(LocalY-.5-2*rb)/sqrt(3);
            
            Y1=sqrt(3)*(LocalX+.5)+2*rb;
            Y2=rb;
            Y3=LocalY-.5;
            
            DeltaX=((LocalY-2*rb)/(sqrt(3)))-LocalX;
            DeltaY=LocalY+.5-rb;
            
            if DeltaX<DeltaXLim && DeltaX>DeltaxLim && LocalY<rb+.5 && LocalY>rb-.5 && X2<LocalX+.5
                
                S1=(X1-X2)*(Y1-Y2)/2;
                S2=(X1-X3)*(Y1-Y3)/2;
                SegmentTab(i,j,s)=(S2-S1);
                %disp(num2str(S1-S2))
            end
            
            
            
            
            
            
            
            
            
            %UPPER RIGHT - CAS 1
            X1=(LocalY+.5-2*rb)/(-sqrt(3));
            X2=rb/sqrt(3);
            X3=LocalX+.5;
            
            Y1=LocalY+.5;
            Y2=rb;
            Y3=-sqrt(3)*(LocalX+.5)+2*rb;
            
            DeltaX=((LocalY-2*rb)/(-sqrt(3)))-LocalX;
            DeltaY=LocalY+.5-rb;
            
            if DeltaX<DeltaXLim && DeltaX>DeltaxLim && LocalY<rb+.5 && LocalY>rb-.5 && X2<LocalX+.5
                
                S1=(LocalX+.5-X1)*(LocalY+.5-Y3)/2;
                S2=DeltaY*((sqrt(3)/6)*DeltaY+(X1+.5-LocalX));
                SegmentTab(i,j,s)=1-(S1+S2);
                %disp(num2str(1-(S1+S2)))
            end
            %UPPER RIGHT - CAS 2
            X1=(LocalY+.5-2*rb)/(-sqrt(3));
            X2=rb/sqrt(3);
            Y1=LocalY+.5;
            
            DeltaX=((LocalY-2*rb)/(-sqrt(3)))-LocalX;
            DeltaY=Y1-rb;
            
            if DeltaX<DeltaxLim && DeltaX>-DeltaxLim && LocalY<rb+.5 && LocalY>rb-.5 && X2>LocalX-.5
                
                S1=sqrt(3)/6+DeltaxLim-DeltaX;
                S2=DeltaY*((sqrt(3)/6)*DeltaY+X1+.5-LocalX);
                SegmentTab(i,j,s)=1-(S1+S2);
                %disp(num2str(1-(S1+S2)))
            end
            %UPPER RIGHT - CAS 3
            X2=rb/sqrt(3);
            X3=(LocalY-.5-2*rb)/(-sqrt(3));
            Y1=-sqrt(3)*(LocalX-.5)+2*rb;
            
            DeltaX=((LocalY-2*rb)/(-sqrt(3)))-LocalX;
            DeltaY=Y1-rb;
            
            if DeltaX>-DeltaXLim && DeltaX<-DeltaxLim && LocalY<rb+.5 && LocalY>rb-.5 && X2>LocalX-.5
                
                S1=(X3+.5-LocalX)*(Y1-LocalY+.5)/2;
                S2=(X2-LocalX+.5)*(Y1-rb)/2;
                SegmentTab(i,j,s)=(S1-S2);
                %disp(num2str(S1-S2))
            end
            
            
            
            
            
            
            
            %LOWER RIGHT - CAS 1
            X1=(LocalY+.5+2*rb)/(sqrt(3));
            X2=rb/sqrt(3);
            X3=LocalX-.5;
            
            Y1=LocalY+.5;
            Y2=-rb;
            Y3=(sqrt(3)*(LocalX-.5))-2*rb;
            
            DeltaX=((LocalY+2*rb)/(sqrt(3)))-LocalX;
            DeltaY=-rb-LocalY+.5;
            
            if DeltaX>-DeltaXLim && DeltaX<-DeltaxLim && LocalY<-rb+.5 && LocalY>-rb-.5 && X2>LocalX-.5
                
                S1=(X1-X3)*(Y1-Y3)/2;
                S2=(X2-X3)*(Y2-Y3)/2;
                SegmentTab(i,j,s)=S1-S2;
                %disp(num2str(1-(S1+S2)))
            end
            %LOWER RIGHT - CAS 2
            
            X1=(LocalY+.5+2*rb)/(sqrt(3));
            X2=rb/sqrt(3);
            X3=(LocalY-.5+2*rb)/sqrt(3);
            
            Y1=LocalY+.5;
            Y2=-rb;
            Y3=LocalY-.5;
            
            DeltaX=((LocalY+2*rb)/(sqrt(3)))-LocalX;
            DeltaY=-rb-LocalY+.5;
            
            if DeltaX<DeltaxLim && DeltaX>-DeltaxLim && LocalY<-rb+.5 && LocalY>-rb-.5 && X2>LocalX-.5
                
                S1=(LocalX+.5-X1+(X1-X3)*(Y1-Y3)/2);
                S2=DeltaY*((sqrt(3)/6)*DeltaY+(X3+.5-LocalX));
                SegmentTab(i,j,s)=1-(S1+S2);
                %disp(num2str(1-(S1+S2)))
            end
            %LOWER RIGHT - CAS 3
            X1=LocalX+.5;
            X2=rb/sqrt(3);
            X3=(LocalY-.5+2*rb)/sqrt(3);
            
            Y1=sqrt(3)*(LocalX+.5)-2*rb;
            Y2=-rb;
            Y3=LocalY-.5;
            
            DeltaX=((LocalY+2*rb)/(sqrt(3)))-LocalX;
            DeltaY=-rb-LocalY+.5;
            
            if DeltaX<DeltaXLim && DeltaX>DeltaxLim && LocalY<-rb+.5 && LocalY>-rb-.5 && X2<LocalX+.5
                
                S1=(X1-X3)*(Y1-Y3)/2;
                S2=DeltaY*((sqrt(3)/6)*DeltaY+(X3+.5-LocalX));
                SegmentTab(i,j,s)=1-(S1+S2);
                %disp(num2str(S1-S2))
            end
            
            
            
            
            %LOWER LEFT - CAS 1
            X2=-rb/sqrt(3);
            X3=(LocalY-.5+2*rb)/(-sqrt(3));
            Y3=LocalY-.5;
            
            DeltaX=((LocalY+2*rb)/(-sqrt(3)))-LocalX;
            DeltaY=-rb-Y3;
            
            if DeltaX>-DeltaXLim && DeltaX<-DeltaxLim && LocalY<-rb+.5 && LocalY>-rb-.5 && X2>LocalX-.5
                
                S1=(sqrt(3)/2)*(DeltaX+DeltaXLim)^2;
                S2=DeltaY*((sqrt(3)/6)*DeltaY+LocalX+.5-X3);
                SegmentTab(i,j,s)=1-(S1+S2);
                %disp(num2str(1-(S1+S2)))
            end
            %LOWER LEFT - CAS 2
            X2=-rb/sqrt(3);
            X3=(LocalY-.5+2*rb)/(-sqrt(3));
            Y3=LocalY-.5;
            
            DeltaX=((LocalY+2*rb)/(-sqrt(3)))-LocalX;
            DeltaY=-Y3-rb;
            
            if DeltaX<DeltaxLim && DeltaX>-DeltaxLim && LocalY<-rb+.5 && LocalY>-rb-.5 && X2>LocalX-.5
                
                S1=(sqrt(3)/6)+(DeltaxLim+DeltaX);
                S2=DeltaY*((sqrt(3)/6)*DeltaY+LocalX+.5-X3);
                SegmentTab(i,j,s)=1-(S1+S2);
                %disp(num2str(1-(S1+S2)))
            end
            %LOWER LEFT - CAS 3
            X1=(LocalY+.5+2*rb)/(-sqrt(3));
            X2=-rb/sqrt(3);
            Y3=-sqrt(3)*(LocalX+.5)-2*rb;
            
            DeltaX=((LocalY+2*rb)/(-sqrt(3)))-LocalX;
            DeltaY=-Y3-rb;
            
            if DeltaX>DeltaxLim && DeltaX<DeltaXLim && LocalY<-rb+.5 && LocalY>-rb-.5 && X2<LocalX+.5
                
                S1=(LocalX+.5-X1)*(LocalY+.5-Y3)/2;
                S2=(LocalX+.5-X2)*(-Y3-rb)/2;
                SegmentTab(i,j,s)=(S1-S2);
                %disp(num2str(S1-S2))
            end
            
            
            
            

            
            
            
            
            
        end
    end
    
    %end
    
end
