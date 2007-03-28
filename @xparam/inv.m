%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
% CHANGES:
% 2002-01-03, Kristoffer Andersson
%             Major rewrite version
%

% Invert xparam
% Note: the parameter type of object Minv is the same as for M!
function Minv = inv(M)

Minv = xparam(M);
Minv.data = inv(M.data);

% for some types the inverse means a parameter change
type = Minv.type;
switch type
    case 'Z'
        Minv.type = 'Y';
    case 'Y'
        Minv.type = 'Z';
    otherwise
        Minv.type = type;
end


