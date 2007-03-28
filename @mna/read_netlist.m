
function x = read_netlist(x,filename)

f_ID=fopen(filename,'r');
% read netlist into memory in a structured form
row = 0;
stop = 0;
while ~stop & ~feof(f_ID)
    line = fgetl(f_ID);
    symbol = 0;
    while ~isempty(line)
        [Astr,count,err,nextindex]=sscanf(line,'%s',1);
        if ~isempty(Astr)
            M{row+1,symbol+1} = Astr;
            symbol = symbol + 1;
        end
        line = line(nextindex:end);
    end
    row = row + 1;
end
fclose(f_ID);

% parse the netlist-structure and stamp into Y-matrix
N = row;
x = mna(maxnode(M)); % reserve working space
for row = 1:N
    type = M{row,1};
    n = terminals(type); 
    if  n > 1
        element = M{row,2};
        conn = [];
        for node=1:n
            conn(node) = str2num(M{row,2+node});
        end
        x = stamp(x,type,element,conn);
        conn = [];element = [];type = [];
    else
        % we have a ground!
        n = length(M(row,:))-1;
        for node=1:n
            if ~isempty(M{row,1+node})
                conn(node) = str2num(M{row,1+node});
            end
        end
        x = gnd(x,conn);
        conn = [];element = [];type = [];
    end
end

function c = maxnode(M)
Y = size(M,1);
X = size(M,2);
c = 0;
for row = 1:Y
    for col = 3:X
        a = M{row,col};
        if isempty(a)
            c = c;
        else
            c = max(c,str2num(a));    
        end
    end
end
        
function n = terminals(type)
switch type
    case 'C'
        n = 2;  
    case 'R'
        n = 2;
    case 'G'
        n = 2;
    case 'L'
        n = 2;
    case 'VCCS'
        n = 4;
    case 'GY'
        n = 4;
    otherwise
        n = 1;
end
