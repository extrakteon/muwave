%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
% CHANGES:
% 2002-01-07, Kristoffer Andersson
%             First version
%
function c_skip = skip(a, index)

a.data = skip(a.data,index);
c_skip=a;
