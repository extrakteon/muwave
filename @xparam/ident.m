%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
% CHANGES:
% 2002-01-04, Kristoffer Andersson
%             Major rewrite version
%


% Make identity matrix
function I = ident(M)

I = xparam(M);
I.data = ident(M.data);
