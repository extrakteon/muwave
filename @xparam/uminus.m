%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
% CHANGES:
% 2002-11-11, Christian Fager
%             Major rewrite version
%

% Negates M
function rM = uminus(M)

rM = xparam(M);
rM.data = -M.data;

