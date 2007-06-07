function data = read_form5(obj, HP8510)
% READ_FORM5 reads Agilent/HP binary FORM5 data from obj

if (nargin == 2) & HP8510
    % the 8510 uses a different header
    header = fread(obj, 4, 'char');
    bytea = header(3);
    byteb = header(4);
    numbytes = bytea + 256*byteb;

    % read single-data
    data = fread(obj, numbytes/4, 'single');

else
    % read header
    header = fread(obj, 8, 'char');
    header = char(reshape(header(3:end), [1 6]));
    numbytes = str2num(header);
   
    % read single-data
    data = fread(obj, numbytes/4, 'single');

    % read EOI-terminator
    eoi = fread(obj, 1, 'char'); 

    if eoi ~= 10
        error('Did not receive EOI.');
    end
end


