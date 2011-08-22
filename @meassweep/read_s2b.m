function cOUT=read_milousweep(cIN,input_filename)
%READ_S2B    Read Maury ATS swept bias S-parameters.
%   M = read_s2b(meassweep,'filename')

% $Header$
% $Author: e7koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
% $Log$
% Revision 1.1  2004/05/28 07:00:55  koffer
% *** empty log message ***
%
%

f_ID=fopen(input_filename,'r');
if f_ID == -1, % if file not found
    error_msg=strcat('MILOU.READ_S2B: Error open file :',input_filename,'.');
    error(error_msg);
end

cOUT = cIN;

Y=struct('props',{{}},'values',{{}});

blocklist = {};
whithin_block = 0;

stop = 0;
while ~stop & ~feof(f_ID)
    line = fgetl(f_ID);
    if isempty(line)
        % Do nothing;
        1==1;
    elseif line(1) == '!'
        % Do nothing;
        1==1;
    elseif strmatch('VAR',line)
        % we have a variable definition
        [prop,val]=getprop(line);
        if isempty(prop), continue; end   
        Y=addprop(Y,prop,val);
    elseif strmatch('BEGIN',line)
        whithin_block = 1;
        [blockname] = sscanf(line,'BEGIN %s');
        if blockname == 'ACDATA'
            format = fgetl(f_ID);
            line_idx = 0;
            while whithin_block        
                line = fgetl(f_ID);
                if line(1:3) == 'END'
                    whithin_block = 0;
                elseif strfind('!%',line(1))
                    % do nothing
                else
                    line_idx = line_idx + 1;
                    data(:,line_idx) = sscanf(line,'%g');
                end
            end
            % use touchstone stuff here
            Y = touchstone(Y,data,format,2);
        end
        whithin_block = 0;
        cOUT = add(cOUT,struct2meassp(meassp,Y,input_filename));
        Y=struct('props',{{}},'values',{{}});
    end
end

% cOUT=set(cOUT,'Date',datestr(now),'Origin',origin);

%
function [f_scale,datatype,fmt,reftype,reference]=parseformat(line)
% where at the header line!
% now strip the '#'
line = upper(line);
line = line(2:end);
% Continue as before
n=1;
nextindex = 1;
while (length(line)>1)
    [Astr,count,err,nextindex]=sscanf(line,'%s',1);
    line=line(nextindex:length(line));
    switch n
        case 1,
            % Frequency scaling
            switch Astr
                case 'GHZ',
                    f_scale = 1e9;
                case 'MHZ',
                    f_scale = 1e6;
                case 'KHZ',
                    f_scale = 1e3;
                case 'HZ',
                    f_scale = 1;
            end
        case 2,
            % File contains this type of parameters (maybe S?)
            datatype = Astr;
        case 3,
            switch upper(Astr(1:2))
                case 'RI',% Data in Real-Imag format
                    fmt=1;
                case 'MA',% Data in magnitude-angle format
                    fmt=2;    
                case 'DB',% Data in dB - angle format
                    fmt=3;
            end
        case 4,
            reftype = Astr;
        case 5,
            reference = str2double(Astr);
    end
    n=n+1;
end

%
function Y=touchstone(Y,temp_mtrx,format,numports);
[f_scale,datatype,fmt,reftype,reference]=parseformat(format);
% Store the data read in temporary matrix.
Y.freq_list = temp_mtrx(1,:)'*f_scale;
% Form a complex matrix
temp_mtrx2=temp_mtrx(2:2:end,:)+j*temp_mtrx(3:2:end,:);
% for multiports the row-column order is different
if numports > 2
    row=repmat(1:numports,[1 numports]);
    col=repmat(1:numports,numports);
    col=col(1:(numports*numports));
    col_order = (row-1)*numports+col;
    temp_mtrx2 = temp_mtrx2(col_order,:);
end
switch fmt
    case 1, % reim_reim
        temp_mtrx = convert_reim_reim(temp_mtrx2);
    case 2, % pol_complex
        temp_mtrx = convert_pol_complex(temp_mtrx2);
    case 3, % db_complex
        temp_mtrx = convert_db_complex(temp_mtrx2);      
end
Y.data = temp_mtrx.';
Y.datatype = upper(datatype);
Y.ref = reference;

%
function A=convert_pol_complex(indata)

for k=1:size(indata,1)
    amp = real(indata(k,:));
    phase = imag(indata(k,:));
    A(k,:) = amp.*exp(i*phase*pi/180);
end

%
function B=convert_db_complex(indata)

for k=1:size(indata,1)
    amp = 10.^(real(indata(k,:))/20);
    phase = imag(indata(k,:));
    B(k,:) = amp.*exp(i*phase*pi/180);
end

%   
function C=convert_reim_reim(indata)
C = indata;

%%%%%%%%
function Y=addprop(Y,prop,val)
prop_ix = find(strcmpi(Y.props,prop));
if isempty(prop_ix) % New, unknown property
    Y.props{end+1} = prop;
    Y.values{end+1} = val;
else % Property already defined; just modify the value.
    Y.values{prop_ix} = val;
end

%%%%%%%%%%
function [prop,val]=getprop(line)
[propx,void,void,rindex] = sscanf(line,'VAR %s=');
propx = propx(1:end-1);
switch lower(propx)
    case {'v_in'} % Known Vgs expressions
        prop = 'Vgs';
    case {'v_out'} % Known Vds expressions
        prop = 'Vds';
    case {'i_in'} % Known Igs expressions
        prop = 'Igs';
    case {'i_out'} % Known Ids expressions
        prop = 'Ids';
    otherwise,
        prop = [];
end
val = str2double(line(rindex:end));

