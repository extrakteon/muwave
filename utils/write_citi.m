function write_citi(cIN, write_filename)

% Write S-PARAMETERS/WAVEFORM data to CITIFILE
% S-PARAMETERS is currently unsupported

extix=findstr('.',write_filename);
if isempty(extix)	% No extension specified, use CITI extension
    write_filename=[write_filename, '.citi'];
end

fid=fopen(write_filename,'wt');
if fid==-1, error('Error in opening file for writing'); end;

if isempty(cIN)
    error('UTILS/WRITE_CITI: Empty object. No data written.');
end

% determine data type
if strcmpi(class(cIN),'meassweep')
    data_type = class(cIN(1).data);
else
    data_type = class(cIN);
end

switch data_type
    case {'waveform','measwf'}
        waveform2citi(cIN, fid);
    case {'xparam','meassp'}
        sparam2citi(cIN, fid);
    otherwise
        error('UTILS/WRITE_CITI: Unknown data format.');
end

fclose(fid);

end

% internal functions
%

function sparam2citi(cIN, fid)
end

function waveform2citi(cIN, fid)

INDEX = (1:length(cIN)).';
FREQ = cIN(1).freq.';

NOUTER = length(INDEX);
NINNER = length(FREQ);
NELEM = NOUTER*NINNER;

% Här behöver ändras så vektorerna blir rätt utifrån measwf klassen
V1=reshape(cIN.V1.',NELEM,1);
I1=reshape(cIN.I1.',NELEM,1);
V2=reshape(cIN.V2.',NELEM,1);
I2=reshape(cIN.I2.',NELEM,1);

fprintf(fid,'CITIFILE A.01.01\n');
fprintf(fid,'COMMENT Chalmers LSNA data\n');
fprintf(fid,'COMMENT Date: %s\n',datestr(now));
fprintf(fid,'NAME NoName\n');
fprintf(fid,'VAR INDEX MAG %d\n',NOUTER);
fprintf(fid,'VAR FREQ MAG %d\n',NINNER);
fprintf(fid,'DATA V1 RI\n');
fprintf(fid,'DATA I1 RI\n');
fprintf(fid,'DATA V2 RI\n');
fprintf(fid,'DATA I2 RI\n');
fprintf(fid,'VAR_LIST_BEGIN\n');
fprintf(fid,'%d\n',INDEX);
fprintf(fid,'VAR_LIST_END\n');
fprintf(fid,'VAR_LIST_BEGIN\n');
fprintf(fid,'%e\n',FREQ);
fprintf(fid,'VAR_LIST_END\n');

% V1
fprintf(fid,'BEGIN\n');
fprintf(fid,'%e,%e\n',[real(V1),imag(V1)].');
fprintf(fid,'END\n');

% I1
fprintf(fid,'BEGIN\n');
fprintf(fid,'%e,%e\n',[real(I1),imag(I1)].');
fprintf(fid,'END\n');

% V2
fprintf(fid,'BEGIN\n');
fprintf(fid,'%e,%e\n',[real(V2),imag(V2)].');
fprintf(fid,'END\n');

% I2
fprintf(fid,'BEGIN\n');
fprintf(fid,'%e,%e\n',[real(I2),imag(I2)].');
fprintf(fid,'END\n');

end