function x = stamp(x,type,element,conn)

Y = x.Y;
switch type
    case 'C'
        Y = mna_cap(element,conn,Y);        
    case 'R'
        Y = mna_res(element,conn,Y);
    case 'G'
        Y = mna_cond(element,conn,Y);
    case 'L'
        Y = mna_ind(element,conn,Y);
    case 'VCCS'
        Y = mna_vccs(element,conn,Y);
    case 'GY'
        Y = mna_gyrator(element,conn,Y);
    otherwise
        Y = Y;
end
x.Y = Y;
% also add the variable name to the variable list (if it's not already
% there
params = x.params;
if isempty(params)
    params{1} = element;    
else
    N = length(params);
    i = 1;found = false;
    while ~found & i <= N
        if strmatch(element,params{i})
            found = true;
        end
        i = i + 1;
    end
    if ~found
        params{N+1} = element;
    end
end
x.params = params;

function Y = mna_cap(element,conn,Y)
    Y{conn(1),conn(1)}=strcat(Y{conn(1),conn(1)},'+s.*',element);
    Y{conn(1),conn(2)}=strcat(Y{conn(1),conn(2)},'-s.*',element);
    Y{conn(2),conn(1)}=strcat(Y{conn(2),conn(1)},'-s.*',element);
    Y{conn(2),conn(2)}=strcat(Y{conn(2),conn(2)},'+s.*',element);
    
function Y = mna_res(element,conn,Y)
    Y{conn(1),conn(1)}=strcat(Y{conn(1),conn(1)},'+1./',element);
    Y{conn(1),conn(2)}=strcat(Y{conn(1),conn(2)},'-1./',element);
    Y{conn(2),conn(1)}=strcat(Y{conn(2),conn(1)},'-1./',element);
    Y{conn(2),conn(2)}=strcat(Y{conn(2),conn(2)},'+1./',element);
    
function Y = mna_cond(element,conn,Y)
    Y{conn(1),conn(1)}=strcat(Y{conn(1),conn(1)},'+',element);
    Y{conn(1),conn(2)}=strcat(Y{conn(1),conn(2)},'-',element);
    Y{conn(2),conn(1)}=strcat(Y{conn(2),conn(1)},'-',element);
    Y{conn(2),conn(2)}=strcat(Y{conn(2),conn(2)},'+',element);
    
function Y = mna_ind(element,conn,Y)
    Y{conn(1),conn(1)}=strcat(Y{conn(1),conn(1)},'+1./(s*',element,')');
    Y{conn(1),conn(2)}=strcat(Y{conn(1),conn(2)},'-1./(s*',element,')');
    Y{conn(2),conn(1)}=strcat(Y{conn(2),conn(1)},'-1./(s*',element,')');
    Y{conn(2),conn(2)}=strcat(Y{conn(2),conn(2)},'+1./(s*',element,')');

function Y = mna_vccs(element,conn,Y)
    Y{conn(2),conn(1)}=strcat(Y{conn(2),conn(1)},'+',element);
    Y{conn(2),conn(3)}=strcat(Y{conn(2),conn(3)},'-',element);
    Y{conn(4),conn(1)}=strcat(Y{conn(4),conn(1)},'-',element);
    Y{conn(4),conn(3)}=strcat(Y{conn(4),conn(3)},'+',element);

function Y = mna_gyrator(element,conn,Y)
    Y{conn(1),conn(2)}=strcat(Y{conn(1),conn(2)},'+',element);
    Y{conn(1),conn(4)}=strcat(Y{conn(1),conn(4)},'-',element);
    Y{conn(2),conn(1)}=strcat(Y{conn(2),conn(1)},'-',element);
    Y{conn(2),conn(3)}=strcat(Y{conn(2),conn(3)},'+',element);
    Y{conn(3),conn(2)}=strcat(Y{conn(3),conn(2)},'-',element);
    Y{conn(3),conn(4)}=strcat(Y{conn(3),conn(4)},'+',element);
    Y{conn(4),conn(1)}=strcat(Y{conn(4),conn(1)},'+',element);
    Y{conn(4),conn(3)}=strcat(Y{conn(4),conn(3)},'-',element);
    
    
    