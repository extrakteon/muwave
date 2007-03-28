%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
% CHANGES:
% 2002-01-04, Kristoffer Andersson
%             First version
% 2002-01-07, Kristoffer Andersson
%             Added support for xparam.S11 = some_vector assignments
%             Added support for xparam(n,m) = some_vector assignments
% Overloads method subsasgn, eg A(S) = B
function a = subsasgn(a,S,b)

switch S.type
case '()'
    if length(S.subs) == 1
        a = xparam(a);
        b = xparam(b);
        a.data(S.subs) = b.data;
    elseif length(S.subs) == 2
        if isa(b,'double')
            n = S.subs{1};
            m = S.subs{2};
            a = xparam(a);
            a.data(n,m) = b;
        else
            error('XPARAM.SUBSASGN: Argument B must be a vector.');
        end
    end
case '.'    
    if isa(b,'double')
        ports=get(a,'ports');
        param=S.subs;
        if (length(param) == 2) & (ports == 1)
                % x1 type of indexing
                if str2double(param(2)) == 1
                    param_index = 11;
                else
                    error('XPARAM.SUBSASGN: Index out of range.');
                end
            elseif (length(param) == 3) & (ports < 10)
                % x11 type of indexing
                param_index = str2double(param(2:3));
            elseif (length(param) == 5) & (ports > 9)
                % x0101 type of indexing
                param_index = str2double(param(2:5));
            else
                error('XPARAM.SUBSASGN: Invalid index parameter.');
            end
            [n,m,err] = getindex(param_index, ports);
            if ~err
                % Assign the vector b to the correct index
                a = convert(a, param(1));
                a.data(n,m) = b;
            else
                error('XPARAM.SUBSASGN: Index out of range.');
            end
    else
        error('XPARAM.SUBSASGN: Argument B must be of type double.');
    end
    
otherwise
    error('XPARAM.SUBSASGN: Unsupported indexing.');
end


% internal functions
