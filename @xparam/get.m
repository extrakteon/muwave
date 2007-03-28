%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
% CHANGES:
% 2002-01-04, Kristoffer Andersson
%             Major rewrite version
%

function val = get(a,param)

a = xparam(a);
if square(a)
    ports = get(a.data,'nx');
else
    ports = [get(a.data,'nx'),get(a.data,'ny')];
end

if isa(param,'char')
switch param
case 'reference',
    val = a.reference;
case 'type',
    val = a.type;
case 'ports',
    val = ports;
case 'elements',
    val = length(a.data);
case 'arraymatrix',
    val = a.data;
case 'mtrx',
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
                val = a.data(x, y);
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