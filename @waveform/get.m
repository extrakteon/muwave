function val = get(a,param)
% GET   Returns properties from an waveform object.
%
%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: $
% $Date: $
% $Revision: $ 
% $Log$
%

if nargin == 1, % Just return the available properties
    disp('Valid waveform properties');
    disp(sprintf('\treference :\t%d',get(a,'reference')));
    disp(sprintf('\ttype :\t%s',get(a,'type')));
    disp(sprintf('\tfundamental :\t[%d]',length(get(a,'fundamental'))));
    disp(sprintf('\telements :\t%d',get(a,'elements')));          
else
    
end
    
if isa(param,'char')
switch lower(param)
    case 'reference',
        val = a.reference;
    case 'type',
        val = a.type;
    case 'freq',
        val = a.freq;  
    case 'omega',
        val = 2*pi*freq;
    case 'ports',
        val = size(a.data,2);
    case 'elements',
        val = length(a.data);
    case 'arraymatrix',
        val = a.data;
    case {'mtrx','data'}
        val = get(a.data,'mtrx');
    case 'fundamental'
        val = a.fundamental;
    case 'a'
        val = a.data(1,:).';
    case 'b'
        val = a.data(2,:).';
    case 'v'
        val = (a.data(1,:) + a.data(2,:)).';
    case 'i'
        val = ((a.data(1,:) - a.data(2,:))/a.reference).';
    otherwise
        if ischar(param(1))
            if (length(param) == 1)
                % no indexing, perform conversion
                val = convert(a, param(1));
            else
                if (length(param) == 2) & (ports == 1)
                    % x1 type of indexing
                    if str2double(param(2)) == 1
                        param_index = 11;
                    else
                        error('WAVEFORM.GET: Index out of range.');
                    end
                elseif (length(param) == 3) & (ports < 10)
                    % x11 type of indexing
                    param_index = str2double(param(2:3));
                elseif (length(param) == 5) & (ports > 9)
                    % x0101 type of indexing
                    param_index = str2double(param(2:5));
                else
                    error('WAVEFORM.GET: Invalid index parameter.');
                end
                [x,y,err] = getindex(param_index, ports);
                if ~err
                    % Get correct parameter
                    a = convert(a, param(1));
                    val = a.data(x, y);
                else
                    error('WAVEFORM.GET: Index out of range.');
                end
            end
        end
end
elseif isa(param,'double') & (length(param) == 2)
    if (max(param) <= ports) & (min(param) > 0)
        val = get(a.data,param);
    else
        error('WAVEFORM.GET: Index out of range.');
    end
else
    error('WAVEFORM.GET: Unknown error.');
end

%
% Internal functions
%