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

M = xparam(M);

Minv = xparam(M);
Minv.data = inv(M.data);

