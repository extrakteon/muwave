function x = gnd(x,nodes)

nodes=flipud(fliplr(sort(nodes)));
for i=1:length(nodes)
    x.Y(nodes(i),:)=[];
    x.Y(:,nodes(i))=[];
    x.nodes = x.nodes - 1;
end
