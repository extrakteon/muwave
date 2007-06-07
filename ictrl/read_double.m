function data = read_form5(obj)

% read header
header = fread(obj, 8, 'char');
header = char(reshape(header(3:end), [1 6]));
numbytes = str2num(header);

% read double-data
data = fread(obj, numbytes/8, 'double');

% read EOI-terminator
eoi = fread(obj, 1, 'char');

if eoi ~= 10
    error('Did not receive EOI.');
end


