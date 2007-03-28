%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
% CHANGES:
% 2002-01-16, Kristoffer Andersson
%             Christian Fager
%

% Calculate determinant of xparam

function dx = det(M)

dx = det(M.data);

