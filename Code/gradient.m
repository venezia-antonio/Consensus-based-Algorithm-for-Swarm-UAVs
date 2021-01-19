function  [gradientz,gradienty] = gradient(pos,G)
gradienty = 0;
gradientz = 0;
for i=1:size(pos,1)
    vicini = neighbors(G,i);
    for j=i:size(pos,1)
        if ismember(j,vicini)
            gradienty = gradienty+abs(pos(i,2)-pos(j,2));
            gradientz = gradientz+abs(pos(i,3)-pos(j,3));
        end
    end
end
end

