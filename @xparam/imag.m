%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
% CHANGES:
% 2002-01-03, Kristoffer Andersson
%             Major rewrite version
%

% Returns the imaginary part of M
function iM = imag(M)

iM = xparam(M);
iM.data = imag(M.data);

