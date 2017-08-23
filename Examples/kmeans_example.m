X = 1+randn(100,2);
Y = 5+randn(100,2);
D = [X;Y];
scatter(D(:,1),D(:,2));
[idx,C]=kmeans(D,2);
for i = 1:200
    if idx(i)==1
        color = 'r';
    else
       color = 'k'; 
    end
   scatter(D(i,1),D(i,2),color); 
   hold on
end
