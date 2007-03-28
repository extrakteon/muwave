%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
% CHANGES:
% 2002-01-15, Kristoffer Andersson
%             First version
%

% Returns the conjugate of M
function cM = conj(M)

cM = xparam(M);
cM.data = conj(M.data);

