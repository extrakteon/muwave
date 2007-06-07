function data = read_pna(obj)

% read header
header = fread(obj, 2, 'char');
numbytes = str2num(char(header(2)));

header = fread(obj, numbytes, 'char');
header = char(reshape(header, [1 numbytes]));
numbytes = str2num(header);

% read single-data (32-bit)
data = fread(obj, numbytes/4, 'single');

% read EOI-terminator
eoi = fread(obj, 1, 'char');

if eoi ~= 10
    error('Did not receive EOI.');
end


