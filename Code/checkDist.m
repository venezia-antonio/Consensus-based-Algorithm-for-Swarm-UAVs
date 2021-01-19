function check = checkDist(pos,dist_matrix,G)
N = size(pos,2);
check = 0;
for i = 1:N
    vicini = neighbors(G,i);
    for j=1:N
        if ismember(j,vicini)
            dist=norm([pos(:,i)-pos(:,j)]);
            check = check+abs(dist_matrix(i,j)-dist);
        end
    end
end
check = check/N;
end