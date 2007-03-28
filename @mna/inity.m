function x = inity(x)

nodes = x.nodes;
for row=1:nodes
    for col=1:nodes
        Y{row,col}='';    
    end
end
x.Y = Y;