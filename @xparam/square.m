%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
%

function n = square(a)
%
% Returns true if a.data is a square matrix
% 

x = size(a.data);
n = x(1) == x(2);