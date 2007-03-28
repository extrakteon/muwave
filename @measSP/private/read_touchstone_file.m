function Y=read_touchstone_file(input_filename,nports)
%READ_TOUCHSTONE_FILE Private function to extract information from a Touchstone file.
%   Support function for READ_TOUCHSTONE
%
%   See also: READ_TOUCHSTONE

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2005-02-22 08:29:20 +0100 (Tue, 22 Feb 2005) $
% $Revision: 238 $ 
% $Log$
% Revision 1.11  2005/02/22 07:29:20  fager
% Adapted to work with Matlab v7 (verified to be operational also in v6.5)
%
% Revision 1.10  2004/10/20 22:25:32  fager
% Help comments added
%
% Revision 1.9  2004/04/28 15:54:30  koffer
% Fixed a bug in the port-detection routine. Now it uses regularexpressions to detect the number of ports.
%
% Revision 1.8  2004/03/10 09:40:45  koffer
% Fixed support for N-ports. The file format used is that supported by Agilent ADS.
% Tested with a 14-port with 501 frequency points.
%
% Revision 1.7  2003/11/11 11:31:23  kristoffer
% Bug fix. S12 and S21 were interchanged in DB and MA formats.
%
% Revision 1.6  2003/10/03 13:11:58  fager
% Added compability with older Milou-touchstone files
%
% Revision 1.5  2003/07/18 09:50:58  fager
% ADS generated Touchstone files now also work.
%
% Revision 1.4  2003/07/18 07:59:29  fager
% Improved handling of Vgs/Vds/Ids/Igs expressions
%
% Revision 1.3  2003/07/18 07:53:33  fager
% Now returns the frequency vector properly.
%
% Revision 1.2  2003/07/17 13:48:17  fager
% New local functions added to parse the properties and assign their values.
%
% Revision 1.1.1.1  2003/06/17 12:17:52  kristoffer
%
%
% Revision 1.9  2003/05/21 15:17:38  kristoffer
% bugfix
%
% Revision 1.8  2003/01/03 13:32:13  kristoffer
% Bugfix for: Capable of reading files from Sonnet, i.e. handles comments within the data block
%
% Revision 1.7  2003/01/02 15:26:40  kristoffer
% Capable of reading files from Sonnet, i.e. handles comments within the data block
%
% Revision 1.6  2002/11/11 14:37:29  fager
% Errors fixed
%
% Revision 1.5  2002/04/17 09:05:35  fager
% Removed the necessity of having a blank line between # GHz....
% and measurement data.
%
% Revision 1.4  2002/04/15 12:00:45  kristoffer
% no message
%
% 
LMAX = 9; % MAXIMUM NUMBER OF ENTRIES PER LINE

Y=struct('props',{{}},'values',{{}});

f_ID=fopen(input_filename,'r');
if f_ID == -1, % if file not found
    error_msg=strcat('MILOU.READ_TOUCSHTONE: Error open file :',input_filename,'.');
    error(error_msg);
end

% detect number of ports
if isempty(nports)
    idx=regexp(upper(input_filename),'.S[0-9][0-9]P$');
    if isempty(idx)
        idx=regexp(upper(input_filename),'.S[0-9]P$');
    end
    if isempty(idx)
        numports=2;	% Default 2-port data, "*.S2P"
    else
        numports = str2num(input_filename((idx+2):(end-1))); % Assume format '*.SnP'
    end
else
    numports = nports;
end
%
% Parse header
%

stop = 0;
while ~stop & ~feof(f_ID)
    line = fgetl(f_ID);
    if isempty(line)
        % Do nothing;
        1==1;
    elseif line(1) == '#'
        stop=1;
    else
        % Use local functions to parse the header properties and their values.
        [prop,val]=getprop(line);
        if isempty(prop), continue; end
        Y=addprop(Y,prop,val);
    end
end


% Found the #-line defining the contents in the upcoming 
% data table.
% # GHZ S RI R 50
% According to Jörgen Stenarsson the following format should also be supported:
% #HZ S RI R 50

line = upper(line);

if line(1) == '#'
    % where at the header line!
    % now strip the '#'
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
end

% Skip blank-line
%fgetl(f_ID);

% Some software puts comments within in the data section (interleaved with
% data)
if nports==2 
    scanstr =['%e',repmat([' %e %e'],[1,numports^2])];
    temp_mtrx = [];
    while ~feof(f_ID)
        line = fgetl(f_ID);
        if ~isempty(line)
            if line(1) ~= '!' & line(1) ~= -1
                temp = sscanf(line,scanstr,[1+2*numports^2 Inf]);
                temp_mtrx = [temp_mtrx, temp];
            end
        end
    end
else
    temp_mtrx = [];
    f = [];
    row = 1;
    col = 0;
    while ~feof(f_ID)
        line = fgetl(f_ID);
        if ~isempty(line)
            if line(1) ~= '!' & line(1) ~= -1
                [temp,count] = sscanf(line,'%e',[LMAX 1]);
                if col>=(2*numports^2)
                    row = row + 1;
                    temp_mtrx(row,(1:count))=temp.';
                    col = count;
                else
                    temp_mtrx(row,col+(1:count))=temp.';
                    col = col + count;    
                end
            end
        end
    end
    temp_mtrx = temp_mtrx.';
end

% Close file
fclose(f_ID);

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
% Local functions
%

function A=convert_pol_complex(indata)

for k=1:size(indata,1)
    amp = real(indata(k,:));
    phase = imag(indata(k,:));
    A(k,:) = amp.*exp(i*phase*pi/180);
end

function B=convert_db_complex(indata)

for k=1:size(indata,1)
    amp = 10.^(real(indata(k,:))/20);
    phase = imag(indata(k,:));
    B(k,:) = amp.*exp(i*phase*pi/180);
end
    
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
function [prop,val]=getprop(S)
if S(1)~='!' 
    prop = [];
    val = [];
    return;
end

% Find index of delimiter (':' or '=')
delix=min(findstr(S,':'));
if isempty(delix)
    delix = findstr(S,'=');
end
if isempty(delix)
    prop = [];
    val = [];
    return;
end
prop1 = deblank(sscanf(S(2:(delix-1)),'%s'));

% Special handling of ADS-created files...
if strncmpi(S(3:end),'Created',7)
    prop1 = 'Date';
    delix = 10;
end

switch lower(prop1)
    case {'gatevoltage','gatevoltage[v]','vg','vgs'} % Known Vgs expressions
        prop = 'Vgs';
    case {'drainvoltage','drainvoltage[v]','vd','vds'} % Known Vds expressions
        prop = 'Vds';
    case {'gatecurrent','gatecurrent[a]','ig','igs'} % Known Igs expressions
        prop = 'Igs';
    case {'draincurrent','draincurrent[a]','id','ids'} % Known Ids expressions
        prop = 'Ids';
    case {'gatelength[m]'} % Known gate length expressions
        prop = 'Lg';
    case {'gatewidth[m]'} % Known gate width expressions
        prop = 'Wg';
    otherwise,
        prop = prop1;
end
val = sscanf(S((delix+1):end),'%s%c',inf);
nval = str2double(val);
if ~isnan(nval), 
    val = nval;
end