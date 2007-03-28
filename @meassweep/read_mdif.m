function cOUT = read_mdif(cIN,FileName)
%READ_MDIF Read a generalized MDIF file into an meassweep object.
%   M = READ_MDIF(meassweep,'mdif_file.mdif')
%   MDIF-file structure (repeated):
%       !comments
%       VAR xx1 = yy2
%       VAR xx2 = yy2
%       BEGIN zzz
%       % array contents
%       END
%
%   See also: READ_MILOUSWEEP

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2004-10-20 19:01:34 +0200 (Wed, 20 Oct 2004) $
% $Revision: 218 $ 
% $Log$
% Revision 1.2  2004/10/20 16:58:19  fager
% Help comments added
%
% Revision 1.1  2004/08/19 13:23:43  fager
% Initial file - rewritten to allow reading of files created by Jörgen S's MDIF-files. Not completely verified...
%


fid = fopen(FileName);
if fid==-1, error(['Unable to open file:',FileName]);end
stop = false;
cOUT = cIN;
n_meas = 0;
fline = fgetl(fid);
while ~stop
    mstate = measstate;
    mmeasmnt = measmnt;
    % Any comments?
    infostr = '';
    while strncmp(fline,'!',1)|isempty(fline);
        infostr = strcat(infostr,' ',fline(2:end));
        fline = fgetl(fid);
    end
    if ~isempty(infostr), mmeasmnt = set(mmeasmnt,'Info',infostr,'Date',[]);end
    % Independent variables?
    while isempty(fline)|strncmpi(fline,'VAR',3);
        if ~isempty(fline)
            [varname,value] = FindVariable(fline(4:end));
            if ~isempty(varname), mstate = addprop(mstate,varname,value);end
        end
        fline = fgetl(fid);
    end
    type_ix = strfind(fline,'BEGIN');
    
    if ~isempty(type_ix)
        swtype = FindSweepType(fline(type_ix+6:end));
        fline = fgetl(fid);
        while strncmp(fline,'%',1) | strncmp(fline,'#',1) | strncmp(fline,'!',1)
            switch fline(1),
                case '%',
                    [datatypes,dataformatstr] = FindDataFormat(fline(2:end));
                case '#',
                    spformat = FindSPFormat(fline(2:end));
                otherwise;                    
            end
            fline = fgetl(fid);
        end
        
        switch swtype
            case 'DC',  % DC data
                % For the moment, only single point data is handled (as
                % complement to e.g. S-parameter simulation data)
                varnames = get(mstate);
                bias_ix = [];
                for k=1:length(varnames)
                    try 
                        if isempty(bias_ix), 
                            bias_ix = find(get(cOUT,varnames{k}) == get(mstate,varnames{k}));
                        else
                            bias_ix = intersect(find(get(cOUT,varnames{k}) == get(mstate,varnames{k})),bias_ix);
                        end
                    catch
                        bias_ix = [];
                        break;
                    end
                end
                M = strread(fline);
                new_state = mstate;
                for k=1:length(datatypes)
                    if ~strcmpi(datatypes{k},'freq')
                        new_state = addprop(new_state,datatypes{k},M(1,k));
                    end
                end
                if isempty(bias_ix)
                    n_meas = n_meas + 1;
                    msp = meassp;
                    msp = set(msp,'measstate',new_state,'measmnt',mmeasmnt,'data',xparam);
                    cOUT = add(cOUT,msp);
                else
                    msp = cOUT.data{bias_ix};
                    msp = set(msp,'measstate',new_state,'measmnt',mmeasmnt);
                    cOUT.data{bias_ix} = msp;
                end
                
            case {'SP','SWEEPSPARS'}  % S-parameter data
                spformat.f_scale = 1;
                spformat.datatype = 'S';
                spformat.fmt = 1;    % RI
                spformat.reftype = 'R';
                spformat.reference = 50;
                [flist,xp_obj,extras] = read_spdata(fid,fline,spformat,datatypes,dataformatstr);
                n_meas = n_meas + 1;
                msp = meassp;
                mstate = addprop(mstate,'freq',flist);
                msp = set(msp,'measstate',mstate,'measmnt',mmeasmnt,'data',xp_obj);
                cOUT = add(cOUT,msp);
                
                
            case 'ACDATA' % Touchstone formatted S-parameter data,
                [flist,xp_obj,extras] = read_spdata(fid,fline,spformat,datatypes,dataformatstr);                
                n_meas = n_meas + 1;
                msp = meassp;
                mstate = addprop(mstate,'freq',flist);
                msp = set(msp,'measstate',mstate,'measmnt',mmeasmnt,'data',xp_obj);
                cOUT = add(cOUT,msp);
        end
    end
    fline = fgetl(fid);
    if fline == -1, stop = true;end
end

%%%%%%%%%%%%%%%%%%%%%%5
% Local functions
function [varname,value] = FindVariable(str)
eqix = strfind(str,'=');
if isempty(eqix)
    varname='';
    return;
end
name0 = str(1:eqix-1);
varname = strrep(strrep(name0,'(real)',''),' ',''); % Remove possible 'real' and spaces
value = str2num(str(eqix+1:end));
%%%%%%%%%%%%%%%%%%%%%%%
function swtype = FindSweepType(str)
ptix = max(strfind(str,'.'));
if isempty(ptix)
    swtype = upper(strrep(str,' ',''));
else
    swtype = upper(strrep(str(ptix+1:end),' ',''));
end
%%%%%%%%%%%%%%%%%%%%%%%%
function [datatypes,dataformatstr] = FindDataFormat(str)
T=strread(str,'%s');
dataformatstr = '';
datatypes = {};
columns = 0;
for k=1:length(T)
    substr = T{k};
    if strfind(substr,'(complex)')
        dataformatstr = strcat(dataformatstr,'%f%f');
        columns = columns + 2;    
        substr = strrep(substr,'(complex)','');
        S_ix = str2num(sscanf(substr,'S%s[%n,%n]'));
        if length(S_ix)>1,  % Valid S-parameter
            datatypes{columns-1} = S_ix;
            datatypes{columns} = S_ix;
            
        else
            datatypes{columns-1} = substr;
            datatypes{columns} = substr;
        end
    else
        dataformatstr = strcat(dataformatstr,'%f');
        columns = columns + 1;
        substr = strrep(substr,'(real)','');
        if strcmp(substr,'freq')|strcmp(substr,'F')
            datatypes{columns} = 'freq'; 
        elseif length(substr)==4 & strncmpi(substr,'n',1) & (strcmpi(substr(end),'x') | strcmpi(substr(end),'y'))
            datatypes{columns} = str2num(substr(~isletter(substr))')';
        else
            datatypes{columns} = substr;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%
function spformat = FindSPFormat(str);
n=1;
nextindex = 1;
while (length(str)>1)
    [Astr,count,err,nextindex]=sscanf(str,'%s',1);
    str=str(nextindex:length(str));
    switch n
        case 1,
            % Frequency scaling
            switch upper(Astr)
                case 'GHZ',
                    spformat.f_scale = 1e9;
                case 'MHZ',
                    spformat.f_scale = 1e6;
                case 'KHZ',
                    spformat.f_scale = 1e3;
                case 'HZ',
                    spformat.f_scale = 1;
            end
        case 2,
            % File contains this type of parameters (maybe S?)
            spformat.datatype = Astr;
        case 3,
            switch upper(Astr)
                case 'RI',% Data in Real-Imag format
                    spformat.fmt=1;
                case {'MAG','MA'},% Data in magnitude-angle format
                    spformat.fmt=2;
                case 'DB',% Data in dB - angle format
                    spformat.fmt=3;
            end
        case 4,
            spformat.reftype = Astr;
        case 5,
            spformat.reference = str2double(Astr);
    end
    n=n+1;
end
%%%%%%%%%%%%%%%%%%%%%
function [flist,xp_obj,extras] = read_spdata(fid,fline,spformat,datatypes,dataformatstr)
row = 0;
M = zeros(1000,length(datatypes));
while ~strncmpi(fline,'END',3)
    row = row + 1;
    M(row,:) = strread(fline);
    fline = fgetl(fid);
end
flist = M(1:row,find(strcmp(datatypes,'freq')))*spformat.f_scale;
dataorder = [];
start_ix = [];
for k=1:length(datatypes)
    if isnumeric(datatypes{k}), 
        dataorder = cat(1,dataorder,datatypes{k}); 
        if isempty(start_ix), start_ix = k; end
    end
end
[Y,I] = sortrows(unique(dataorder,'rows'),[1,2]); %Find the proper order of parameters (S11 S21 S12 S22)
index_order = reshape([2*(I-1) 2*(I-1)+1]',1,[]);
switch spformat.fmt
    case 1, %R/I
        Mc = M(1:row,start_ix + index_order(1:2:end)) + j*M(1:row,start_ix + index_order(2:2:end));
    case 2, %M/A
        Mc = M(1:row,start_ix + index_order(1:2:end)).*exp(j*M(1:row,start_ix + index_order(2:2:end)));
    case 3, %dB/A
        Mc = 10.^(M(1:row,start_ix + index_order(1:2:end))/20).*exp(j*M(1:row,start_ix + index_order(2:2:end)));
end
xp_obj = buildxp(xparam,Mc,spformat.datatype,spformat.reference);
extras = [];