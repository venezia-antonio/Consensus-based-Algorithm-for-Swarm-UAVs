clear all
close all 
clc
syms x1
syms x2 
grid on 
hold on 
axis equal

N = 4;
d = 1.5;
pos = 3*rand(2,N);
pos = [pos; rand(1,N)];
pos(1:2,1) = [5;0];
[pos,obst,target,dist_matrix,lambda,sec_dist,mu,Cr,d,tr1,tr2,tr3,tr4] = formazione_rombo(pos,d,[],[],1,0.02);
initial_pos = pos;
plot3(initial_pos(1,1),initial_pos(2,1),initial_pos(3,1),'s','MarkerSize',10, 'MarkerFaceColor','y','HandleVisibility','off');
plot3(initial_pos(1,2:4),initial_pos(2,2:4),initial_pos(3,2:4),'s','MarkerSize',10, 'MarkerFaceColor','g');
G = create_graph(pos,sqrt(2)*d);
while norm(pos(:,1)-target(:,1)) > 0.1
    pos(:,1) = adjustement(pos(:,1),obst,target,x1,x2,0,10*lambda,0.8,mu,Cr,G,1);
    pos = adjustement(pos,obst,[],x1,x2,dist_matrix,5*lambda,1,mu,Cr,G,2);
    G = create_graph(pos,sqrt(2)*d);
    check = checkDist(pos,dist_matrix,G)
    
    %ripristino la formazione se si sminchia troppo
    while check > 2
        pos = adjustement(pos,obst,[],x1,x2,dist_matrix,3*lambda,sec_dist,mu,Cr,G,1);
        G = create_graph(pos,sqrt(2)*d);
        check = checkDist(pos,dist_matrix,G)
    end
    
    tr1 = [[tr1] [pos(:,1)]];
    tr2 = [[tr2] [pos(:,2)]];
    tr3 = [[tr3] [pos(:,3)]];
    tr4 = [[tr4] [pos(:,4)]];
    disp(norm(pos(:,1)-target(:,1)));
end 
G = create_graph(pos,sqrt(2)*d);
check = checkDist(pos,dist_matrix,G);
if check >0.15
    [pos,~,~,~,~,~,~,~,~,tr11,tr22,tr33,tr44] = formazione_rombo(pos,d,[],obst,2,0.02);
else 
    tr11 = [];
    tr22 = [];
    tr33 = [];
    tr44 = [];
end 
tr1 = [tr1 tr11];
tr2 = [tr2 tr22];
tr3 = [tr3 tr33];
tr4 = [tr4 tr44];
plot3(tr1(1,:),tr1(2,:),tr1(3,:),'--');
plot3(pos(1,1),pos(2,1),pos(3,1),'s','MarkerSize',10, 'MarkerFaceColor','y');
plot3(pos(1,2:4),pos(2,2:4),pos(3,2:4),'s','MarkerSize',10, 'MarkerFaceColor','r');
plot3(obst(1,:),obst(2,:),obst(3,:),'*b')
plot3(target(1,1),target(2,1),target(3,1),'-o','MarkerSize',15);
plot3(tr2(1,:),tr2(2,:),tr2(3,:),'--');
plot3(tr3(1,:),tr3(2,:),tr3(3,:),'--');
plot3(tr4(1,:),tr4(2,:),tr4(3,:),'--');
legend('Initial Position','Trajectory','Leader','Final Position','Obstacle','Final Target','FontSize',14);