function [pos,obst,target,dist_matrix,lambda,sec_dist,mu,Cr,d,tr1,tr2,tr3,tr4] = formazione_rombo(pos,d,target,obst,c,toll)

syms x1
syms x2

tr1 = [];
tr2 = [];
tr3 = [];
tr4 = [];
N = 4;
G=create_graph(pos,sqrt(2)*d);
flag=true;
pos = pos';
while flag==true
    for i=1:N
        vicini=neighbors(G,i);
        varz=0;
        for j=1:length(vicini)
            varz=varz + pos(i,3)-pos(vicini(j),3);
        end 
        pos(i,3)=pos(i,3)-varz/length(vicini);
    end 
    gradientz=gradient(pos,G);
    if abs(gradientz) <=10^(-5) 
        flag = false;
    end
end
pos = pos';
lambda = 0.1;
sec_dist = 1;
mu = 0.1;
Cr = 1;
dist_matrix = [0,d,sqrt(2)*d,d;d,0,d,sqrt(2)*d;sqrt(2)*d,d,0,d;d,sqrt(2)*d,d,0];
count=0;
check1 = 100;
while check1>=toll && count<500
    disp(count)
    disp(check1)
    check1 = checkDist(pos,dist_matrix,G);
    pos = adjustement(pos,obst,[],x1,x2,dist_matrix,lambda,0.5,mu,Cr,G,c);
    G = create_graph(pos,sqrt(2)*d);
    check2 = checkDist(pos,dist_matrix,G);
    lambda = fix_lambda2(check1,check2);
    count = count +1;
    tr1 = [[tr1] [pos(:,1)]];
    tr2 = [[tr2] [pos(:,2)]];
    tr3 = [[tr3] [pos(:,3)]];
    tr4 = [[tr4] [pos(:,4)]];
end


% GENERAZIONE TARGET E OSTACOLI
if isempty(target)
    target = [pos(1,1)+20 pos(2,1)-3.5 pos(3,1)]';
end
if isempty(obst)
    obst = [];
    P = pos(1,1);
    b=1;
    for a = 1:0.001:8
        obst(:,b) = [pos(1,1)+1.5+a pos(2,1)-9+a pos(3,1)];
        b = b+1;
    end
    for a = 2:0.001:4
        obst(:,b) = [pos(1,1)+7.5+a pos(2,1)-1 pos(3,1)];
        b = b+1;
    end
    for a = 2:0.001:4
        obst(:,b) = [pos(1,1)+7.5+a pos(2,1)+1 pos(3,1)];
        b = b+1;
    end
    for a = 1:0.001:8
        obst(:,b) = [pos(1,1)+1.5+a pos(2,1)+9-a pos(3,1)];
        b = b+1;
    end
end
end