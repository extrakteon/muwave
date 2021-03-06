function x = read_netlist(x,filename)
% READ_NETLIST  Reads a netlist file into mna object
%
% Usage : mna_obj = read_netlist(mna,'Filename.nl');


% $Header$
% $Author: fager $
% $Date: 2005-04-27 23:44:52 +0200 (Wed, 27 Apr 2005) $
% $Revision: 261 $ 
% $Log$
% Revision 1.5  2005/04/27 21:44:52  fager
% * Changed from measSP to meassp.
%
% Revision 1.4  2003/11/17 18:55:54  kristoffer
% no message
%
% Revision 1.3  2003/11/17 07:46:35  kristoffer
% *** empty log message ***
%
% Revision 1.2  2003/10/03 13:10:02  fager
% Allow comment- and empty lines.
%
% Revision 1.6  2003/08/18 07:48:44  kristoffer
% no message
%
% Revision 1.5  2003/07/23 09:18:43  kristoffer
% Returns a meassp-object containing the model
%
% Revision 1.4  2003/07/22 14:59:09  kristoffer
% no message
%

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
    if isempty(type) | strcmp(type,'%'), continue; end
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
    if strcmp(M{row,1},'%'),continue;end % Skip - we have a comment line!
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
    case {'C','R','G','L','X','P'}
        n = 2;  
    case {'VCCS','VCCSD','GY','X2'}
        n = 4;
    otherwise
        n = 1;
end
