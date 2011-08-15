function a = subsasgn(a,S,b)
% SUBASGN   Overloads the subs-assignment operator
%
%   F = XP.FREQ equals the expression F = GET(XP,'FREQ');
%
%   See also: @XPARAM (class), GET, SET

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2005-04-27 23:46:37 +0200 (Wed, 27 Apr 2005) $
% $Revision: 263 $
% $Log$
% Revision 1.2  2005/04/27 21:46:28  fager
% * Version logging added.
% * Frequencies -> xparam.
% * Possibility of including measurement covariances added
%
% Revision 1.5  2004/10/20 22:24:09  fager
% Help comments added
%

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
        if ismember(lower(S.subs),{'freq','data','datacov','reference','type    '})
            a = set(a,S.subs,b);
        else
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
                    try
                        a = set(a,param,b);
                    catch
                        error('Illegal assignment.');
                    end
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
        end
    otherwise
        error('XPARAM.SUBSASGN: Unsupported indexing.');
end


% internal functions
