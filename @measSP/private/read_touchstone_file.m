function Y=read_touchstone_file(input_filename,nports)
% Private function to extract information from a Touchstone file.

% $Header$
% $Author: $
% $Date: 2003-08-18 14:50:06 +0200 (Mon, 18 Aug 2003) $
% $Revision: 122 $ 
% $Log$
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

Y=struct('props',{{}},'values',{{}});

f_ID=fopen(input_filename,'r');
if f_ID == -1, % if file not found
    error_msg=strcat('MILOU.READ_TOUCSHTONE: Error open file :',input_filename,'.');
    error(error_msg);
end

if isempty(nports)
    d_ix=findstr(upper(input_filename),'.');	% Find the comma in the file extension, eg. TEST.S2P
    if isempty(d_ix)
        numports=2;	% Default 2-port data, "*.S2P"
    else
        ext	= upper(input_filename(d_ix+1:end));	% Assume format '*.SnP'
        numports = str2num(ext(2));
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
% According to Jörgen Stenarsson the follwoing format should also be supported:
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
                switch Astr
                    case 'RI',% Data in Real-Imag format
                        fmt=1;
                    case 'MAG',% Data in magnitude-angle format
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

% Close file
fclose(f_ID);

% Store the data read in temporary matrix.
Y.freq_list = temp_mtrx(1,:)'*f_scale;

% Form a complex matrix
temp_mtrx2=temp_mtrx(2:2:end,:)+j*temp_mtrx(3:2:end,:);

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
%Local functions
%

function A=convert_pol_complex(indata)
temp1 = real(indata(1,:));
temp2 = imag(indata(1,:));
A(1,:) = temp1.*exp(i*temp2*pi/180);

temp1 = real(indata(2,:));
temp2 = imag(indata(2,:));
temp3 = real(indata(3,:));
temp4 = imag(indata(3,:));
A(2,:) = temp3.*exp(i*temp4*pi/180);
A(3,:) = temp1.*exp(i*temp2*pi/180);

temp1 = real(indata(4,:));
temp2 = imag(indata(4,:));
A(4,:) = temp1.*exp(i*temp2*pi/180);


function B=convert_db_complex(indata)
temp1 = 10.^(real(indata(1,:))/20);
temp2 = imag(indata(1,:));
B(1,:) = temp1.*exp(i*temp2*pi/180);

temp1 = 10.^(real(indata(2,:))/20);
temp2 = imag(indata(2,:));
temp3 = 10.^(real(indata(3,:))/20);
temp4 = imag(indata(3,:));
B(2,:) = temp3.*exp(i*temp4*pi/180);
B(3,:) = temp1.*exp(i*temp2*pi/180);

temp1 = 10.^(real(indata(4,:))/20);
temp2 = imag(indata(4,:));
B(4,:) = temp1.*exp(i*temp2*pi/180);

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
    case {'gatevoltage','vg','vgs'} % Known Vgs expressions
        prop = 'Vgs';
    case {'drainvoltage','vd','vds'} % Known Vds expressions
        prop = 'Vds';
    case {'gatecurrent','ig','igs'} % Known Igs expressions
        prop = 'Igs';
    case {'draincurrent','id','ids'} % Known Ids expressions
        prop = 'Ids';
    otherwise,
        prop = prop1;
end
val = sscanf(S((delix+1):end),'%s%c',inf);
nval = str2double(val);
if ~isnan(nval), 
    val = nval;
end