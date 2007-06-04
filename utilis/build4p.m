function sp_out = build4p(port1, port2)
% BUILD4P - builds a 4-port S-parameter object suitable for embedding/deembedding
% 

% *FIXME* don't assume that sp_port1, sp_port2 uses same frequency indexing
try
    freq = port1.freq;
catch
    freq = port2.freq;
end

% Convert input argumnets to xparam-objects
port{1} = port1;
port{2} = port2;
for k = 1:2
switch class(port{k})
    case 'double'
        tmp{k} = xparam(port{k});
    case 'xparam'
        tmp{k} = port{k};
    otherwise
        tmp{k} = get(port{k},'data');
end

end
xp1 = tmp{1};
xp1 = xp1.S; % make sure we have S-parameters

xp2 = tmp{2};
xp2 = xp2.S; % make sure we have S-parameters

% create an  arraymatrix for the 4-port
data = arraymatrix(zeros(4,4,length(freq)));

% insert 2-port S-paramters into 4-port
row_2p = [1 2 1 2];
col_2p = [1 1 2 2];
% translation-table for port 1
row_4p = [1 3 1 3];
col_4p = [1 1 3 3];
data(row_4p,col_4p) = xp1(row_2p,col_2p);

% translation-table for port 2
row_4p = [2 4 2 4];
col_4p = [2 2 4 4];
data(row_4p,col_4p) = xp2(row_2p,col_2p);

% return 4-port object
sp_out = xparam(data,'S',50,freq);

