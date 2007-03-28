%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
% CHANGES:
% 2002-01-04, Kristoffer Andersson
%             Major rewrite version
%

% Make empty matrix
function Z = empty(M)

Z = xparam(M);
Z.data = empty(M.data);
