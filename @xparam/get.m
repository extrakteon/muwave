function val = get(a,param)
% GET   Returns properties from an xparam object.
%
%   F = GET(XP,'freq'); returns the frequencies contained in the XP object
%   into the variable F.

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.4  2005/04/27 21:39:13  fager
% * Version logging added.
% * Frequencies -> xparam.
% * Possibility of including measurement covariances added
%
% Revision 1.5  2004/10/20 22:24:09  fager
% Help comments added
%

if square(a)
    ports = get(a.data,'nx');
else
    ports = [get(a.data,'nx'),get(a.data,'ny')];
end

if nargin == 1, % Just return the available properties
    disp('Valid xparam properties');
    disp(sprintf('\treference :\t%d',get(a,'reference')));
    disp(sprintf('\ttype :\t%s',get(a,'type')));
    disp(sprintf('\tfreq :\t[%d]',length(get(a,'freq'))));
    disp(sprintf('\tports :\t%d',get(a,'ports')));
    disp(sprintf('\telements :\t%d',get(a,'elements')));
    disp(sprintf('\tdatacov'));
    disp(sprintf('\tmtrx'));
    disp(sprintf('\tarraymatrix'));        
    disp(sprintf('\tomega'));            
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
    case 'datacov',
        val = a.datacov;
    case 'ports',
        val = ports;
    case 'elements',
        val = length(a.data);
    case 'arraymatrix',
        val = a.data;
    case {'mtrx','data'}
        val = get(a.data,'mtrx');
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
                        error('XPARAM.GET: Index out of range.');
                    end
                elseif (length(param) == 3) & (ports < 10)
                    % x11 type of indexing
                    param_index = str2double(param(2:3));
                elseif (length(param) == 5) & (ports > 9)
                    % x0101 type of indexing
                    param_index = str2double(param(2:5));
                else
                    error('XPARAM.GET: Invalid index parameter.');
                end
                [x,y,err] = getindex(param_index, ports);
                if ~err
                    % Get correct parameter
                    a = convert(a, param(1));
                    temp = get(a.data,'mtrx');
                    val = squeeze(temp(x, y, :));
                    
                else
                    error('XPARAM.GET: Index out of range.');
                end
            end
        end
end
elseif isa(param,'double') & (length(param) == 2)
    if (max(param) <= ports) & (min(param) > 0)
        val = get(a.data,param);
    else
        error('XPARAM.GET: Index out of range.');
    end
else
    error('XPARAM.GET: Unknown error.');
end

%
% Internal functions
%