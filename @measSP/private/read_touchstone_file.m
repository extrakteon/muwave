function Y=read_touchstone_file(input_filename,nports)
% Private function to extract information from a Touchstone file.

% $Header$
% $Author: kristoffer $
% $Date: 2003-06-17 14:17:51 +0200 (Tue, 17 Jun 2003) $
% $Revision: 2 $ 
% $Log$
% Revision 1.1  2003/06/17 12:17:52  kristoffer
% Initial revision
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

Y=struct('Operator','','Info','','Date','','freq_list',[],'data',[],...
    'Vgs',[],'Vds',[],'Igs',[],'Ids',[],'gate_length',[],'gate_width',[],...
    'Period',[],'PulseWidth',[],'Temp',[]);

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
   elseif strncmpi(line,'! Created: ',11) % Read creation date
     Y.Date = line(findstr(line,':')+1:length(line));
   elseif strncmpi(line,'! Operator: ',12) % Read operator
     Y.Operator = line(findstr(line,':')+1:length(line));
   elseif strncmpi(line,'! Info: ',8) % Read measurement info
     Y.Info = line(findstr(line,':')+1:length(line));
   elseif strncmpi(line,'! Gate Voltage',14) % Read Gate voltage
     Y.Vgs = str2double(line(findstr(line,':')+1:length(line)));
   elseif strncmpi(line,'! Gate Voltage',14) % Read Gate voltage
     Y.Vgs = str2double(line(findstr(line,':')+1:length(line)));
   elseif strncmpi(line,'! Gate current',14) % Read Gate current
     Y.Igs = str2double(line(findstr(line,':')+1:length(line)));
   elseif strncmpi(line,'! Drain Voltage',15) % etc...
     Y.Vds = str2double(line(findstr(line,':')+1:length(line)));
     % LabView Milou can sometimes create NaN instead of 0
     if ~isfinite(Y.Vds)
       Y.Vds = 0;
     end
   elseif strncmpi(line,'! Drain current',15)
     Y.Ids = str2double(line(findstr(line,':')+1:length(line)));
   elseif strncmpi(line,'! Gate Length',13)
     Y.gate_length = str2double(line(findstr(line,':')+1:length(line)));
   elseif strncmpi(line,'! Gate Width',12)
      Y.gate_width = str2double(line(findstr(line,':')+1:length(line)));
   elseif strncmpi(line,'! Temperature',13)
      Y.Temp = str2double(line(findstr(line,':')+1:length(line)));
   elseif strncmpi(line,'! Pulsewidth',12)
      Y.PulseWidth = str2double(line(findstr(line,':')+1:length(line)));
   elseif strncmpi(line,'! Period',8)
      Y.Period = str2double(line(findstr(line,':')+1:length(line)));
   elseif strncmpi(line,'!Date: ',7)
      Y.Date = line(findstr(line,':')+1:end);
   elseif strncmpi(line,'!Vgs = ',7)
      Y.Vgs = str2double(line(findstr(line,'=')+1:end));
   elseif strncmpi(line,'!Vds = ',7)
      Y.Vds = str2double(line(findstr(line,'=')+1:end));
      elseif strncmpi(line,'!Vg = ',6)
      Y.Vgs = str2double(line(findstr(line,'=')+1:end));
   elseif strncmpi(line,'!Vd = ',6)
      Y.Vds = str2double(line(findstr(line,'=')+1:end));
   elseif strncmpi(line,'!Id = ',6)
      Y.Ids = str2double(line(findstr(line,'=')+1:end));
   elseif strncmpi(line,'!Ig = ',6)
      Y.Igs = str2double(line(findstr(line,'=')+1:end));
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
Y.freq_list = temp_mtrx(1,:)*f_scale;

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
Y.Datatype = upper(datatype);
Y.Ref = reference;


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

