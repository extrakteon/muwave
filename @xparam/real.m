%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
% CHANGES:
% 2002-01-03, Kristoffer Andersson
%             Major rewrite version
%

% Returns the realpart of M
function rM = real(M)

rM = xparam(M);
rM.data = real(M.data);

