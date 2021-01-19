function [G] = create_graph(pos,d)
N = size(pos,2);
A=zeros(N,N);
dist = zeros(N,N);
for i=1:N
    for j=i+1:N
        dist(i,j) = norm(pos(:,i)-pos(:,j));
    end
end
M = max(dist);
M = max(M);
if M <= d
    eps = 0;
end
for i = 1:N    %creo la matrice delle distanze
    for j = 1:N
        if dist(i,j)<= M && i~=j
            A(i,j)=1;    %creo la matrice di adiacenza
        end 
    end
end


G = graph(A,'upper');
end