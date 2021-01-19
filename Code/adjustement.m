function pos = adjustement(pos,obst,dest,x1,x2,dist_matrix,lambda,sec_dist,mu,Cr,G,c)
%c indica da che drone iniziare il primo ciclo for. Se c == 2 vuol dire che
%il leader sta andando verso il target fregandosene degli altri
for i=c:size(pos,2)
    c1 = 0;
    c2 = 0;
    dXr = 0;
    dXro = 0;
    for j=1:size(pos,2)
        if ismember(j,neighbors(G,i)) 
            dist = dist_matrix(i,j);
            target = pos(1:2,j)+dist/(norm(pos(1:2,i)-pos(1:2,j)))*(pos(1:2,i)-pos(1:2,j));
            P1a = x1*target(2)-(x1-target(1));
            P2a = target(2);
            Ft = [x1*x2-P1a;x2-P2a];
            Ja=jacobian(Ft);
            A = -inv(Ja)*Ft;
            N = norm(A);
            dXa(j,:)=A/N;
            if norm([pos(1:2,i)-pos(1:2,j)])<=sec_dist
                P1o = x1*pos(2,j)-(x1-pos(1,j));
                P2o = pos(2,j);
                Fo = [x1*x2-P1o;x2-P2o];
                Jo = jacobian(Fo);
                R = inv(Jo)*Fo;
                dXr=dXr+R/(1+(norm(R)/Cr)^mu*norm(R)^3)-sec_dist/(sec_dist^3*(1+(sec_dist/Cr)^mu));
                disp("PERICOLO");
            end    
        end
    end
    for s = 1:size(obst,2)
        if(norm(pos(:,i)-obst(:,s))<=sec_dist)
            if pos(2,i)<=obst(2,s)
                c1 = c1+1;
            else
                c2 = c2+1;
            end
            P1o = x1*obst(2,s)-(x1-obst(1,s));
            P2o = obst(2,s);
            Fo = [x1*x2-P1o;x2-P2o];
            Jo = jacobian(Fo);
            R = inv(Jo)*Fo;
            dXr=dXr+0.005*((R/(1+(norm(R)/Cr)^mu*norm(R)^3))-sec_dist/(sec_dist^3*(1+(sec_dist/Cr)^mu)));
%             disp("PERICOLO Ostacolo ");
        end
    end
    if i==1 && not(isempty(dest))
        target = dest(1:2);
        vers = (target-pos(1:2,i))/norm(pos(1:2,i)-target);
        Dxr = double(sum(subs(dXr,[x1,x2],[pos(1,i),pos(2,i)])));
        if c2>c1
            Dxr = Dxr*sign(Dxr);
        end
        if Dxr ~= 0
            pos(1:2,i) = pos(1:2,i)+lambda*(Dxr)';
        else
            pos(1:2,i) = pos(1:2,i)+lambda*(vers);
        end
    else
        Dxa = double(sum(subs(dXa,[x1,x2],[pos(1,i),pos(2,i)])));
        Dxr = double(sum(subs(dXr,[x1,x2],[pos(1,i),pos(2,i)])));
        if c2>c1
            Dxr = Dxr*sign(Dxr);
        end
        Dx = (Dxa+Dxr)';
        pos(1:2,i) = pos(1:2,i)+lambda*(Dx);
    end
end
end
