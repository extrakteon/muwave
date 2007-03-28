function Y=read_touchstone_noise_file(input_filename)
% Converts a Touchstone formatted file from ATN5 noise measurement system into 
% the matrix format used by Milou.

% Version 1.0
% Created 02-01-10 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-10
% Created.

Y=struct('Operator','','Info','','Date','','freq_list',[],'Data',[],...
    'Vgsq',[],'Vdsq',[],'Igsq',[],'Idsq',[],'gate_length',[],'gate_width',[],...
    'Period',[],'PulseWidth',[],'Temp',[],'freq_list_noise',[],'Fmin',[],'Sopt',[],'Rn',[],'NF',[]);
%noise=struct('freq_list',[],'Fmin',[],'Yopt',[],'Rn',[],'NF',[]);

f_ID=fopen(input_filename,'r');
if f_ID == -1, % if file not found
    error_msg=strcat('MILOU.READ_TOUCSHTONE: Error open file :',input_filename,'.');
    error(error_msg);
end

d_ix=findstr(upper(input_filename),'.');	% Find the comma in the file extension, eg. TEST.S2P
if isempty(d_ix)
    numports=2;	% Default 2-port data, "*.S2P"
else
    ext	= upper(input_filename(d_ix+1:end));	% Assume format '*.SnP'
    numports = str2num(ext(2));
end
type='S';

%
% Parse header
%

stop = 0;
n = 1;
while ~stop & ~feof(f_ID)
    line = fgetl(f_ID);
    if isempty(line)
        % Do nothing;
        1==1;
    elseif line(1) == '#'
        % Found the #-line defining what is into the upcoming 
        % data table.
        % # GHZ S RI R 50
        line = upper(line);
        m=1;
        nextindex = 1;
        while (length(line)>1)
            [Astr,count,err,nextindex]=sscanf(line,'%s',1);
            line=line(nextindex:length(line));
            switch m
            case 2,
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
            case 2,%3
                % File contains this type of parameters (maybee S?)
                type = Astr;
            case 3,%4
                switch Astr
                case 'RI',% Data in Real-Imag format
                    fmt=1;
                case 'MAG',% Data in magnitude-angle format
                    fmt=2;
                case 'MA',% Data in magnitude-angle format (MA from ATN5)
                    fmt=2;
                case 'DB',% Data in dB - angle format
                    fmt=3;
                end
            case 4,%5
                reftype = Astr;
            case 5,%6
                reference = str2double(Astr);
            end
            m=m+1;
        end
        if n > 1 
            stop=1;    
        end
    elseif strncmpi(line,'! Created: ',11) % Read creation date
        Y.Date = line(findstr(line,':')+1:length(line));
    elseif strncmpi(line,'! Measurement Date',18) % Read creation date
        Y.Date = line(findstr(line,':')+1:length(line));
    elseif strncmpi(line,'! Info: ',8) % Read measurement info
        Y.Info = line(findstr(line,':')+1:length(line));
    elseif strncmpi(line,'! Gate Voltage',14) % Read Gate voltage
        Y.Vgs = str2double(line(findstr(line,':')+1:length(line)));
    elseif strncmpi(line,'! Vg   =',8) % Read Gate voltage and current from ATN5.s2p
        Y.Vgs = str2double(line(findstr(line,'Vg   =')+6:findstr(line,'V ')-2));
        Y.Igs = str2double(line(findstr(line,'Ig   =')+6:findstr(line,'mA')-2)); 
    elseif strncmpi(line,'! Gate current',14) % Read Gate current
        Y.Igs = str2double(line(findstr(line,':')+1:length(line)));
    elseif strncmpi(line,'! Drain Voltage',15) % etc...
        Y.Vds = str2double(line(findstr(line,':')+1:length(line)));
        % LabView Milou can sometimes create NaN instead of 0
        if ~isfinite(Y.Vds)
            Y.Vds = 0;
        end
    elseif strncmpi(line,'! Vd   =',8) % Read Drain voltage and current from ATN5.s2p
        Y.Vds = str2double(line(findstr(line,'Vd   =')+6:findstr(line,'V ')-2));
        Y.Ids = str2double(line(findstr(line,'Id   =')+6:findstr(line,'mA')-2)); 
    elseif strncmpi(line,'! Drain current',15)
        Y.Ids = str2double(line(findstr(line,':')+1:length(line)));
    elseif strncmpi(line,'! Gate Length',13)
        Y.gate_length = str2double(line(findstr(line,':')+1:length(line)));
    elseif strncmpi(line,'! Gate Width',12)
        Y.gate_width = str2double(line(findstr(line,':')+1:length(line)));
    elseif strncmpi(line,'!  RAW S-PAR DATA ',18)  % Find RAW S-PAR DATA and skip lines
        fgetl(f_ID);
        fgetl(f_ID);
        stop=1;     
    end
    n=n+1;
end

fgetl(f_ID);  %Skip empty line

% Read the data-table using the fscanf-function.
scanstr=['%e',repmat([' %e %e'],[1,numports^2])];
temp_mtrx=fscanf(f_ID,scanstr,[1+2*numports^2 Inf]);

for k=1:5;
    fgetl(f_ID);
end
temp_noise=fscanf(f_ID,'%e %e %e %e %e %c %e',[7 Inf]);

% Close file
fclose(f_ID);

% Store the S-data read in temporary matrix.
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
Y.Datatype = upper(type);
Y.Ref = reference;

Y.freq_list_noise = temp_noise(1,:)*f_scale;
Y.Fmin=temp_noise(2,:);
Y.Sopt=temp_noise(3,:).*cos(temp_noise(4,:)*pi/180)+j.*temp_noise(3,:).*sin(temp_noise(4,:)*pi/180);
Y.Rn=temp_noise(5,:);
Y.NF=temp_noise(7,:);
% Default temp is roomtemp.
%temp=300;
%Y.CA=noiseToC(Y.freq_list_noise, Y.Fmin, Y.Sopt, Y.Rn,temp) 
%Yopt=(1-Sopt)./(1+Sopt);
%Read into a noise matrix;


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
A(2,:) = temp1.*exp(i*temp2*pi/180);
A(3,:) = temp3.*exp(i*temp4*pi/180);

temp1 = real(indata(4,:));
temp2 = imag(indata(4,:));
A(4,:) = temp1.*exp(i*temp2*pi/180);


function B=convert_db_complex(indata)
temp1 = 10.^(real(indata(1))/20);
temp2 = imag(indata(1));
B(1) = temp1.*exp(i*temp2*pi/180);

temp1 = 10.^(real(indata(2))/20);
temp2 = imag(indata(2));
temp3 = 10.^(real(indata(3))/20);
temp4 = imag(indata(3));
B(2) = temp3.*exp(i*temp4*pi/180);
B(3) = temp1.*exp(i*temp2*pi/180);

temp1 = 10.^(real(indata(4))/20);
temp2 = imag(indata(4));
B(4) = temp1.*exp(i*temp2*pi/180);

function C=convert_reim_reim(indata)
C = indata;
