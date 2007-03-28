%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
% CHANGES:
% 2002-01-07, Kristoffer Andersson
%             Moved getindex outside of get.m
%
function [n,m,err] = getindex(param_index, ports)

% initialize indeces to invalid results, to catch errors
n = 0;
m = 0;
if ports < 10
    n = floor(param_index/10);
    m = rem(param_index,10);
elseif ports > 9
    n = floor(param_index/100);
    m = rem(param_index,100);
end
% is param specifying a valid index?
if (n > 0) & (n <= ports) & (m > 0) & (m <= ports),
    err = 0;
else
    err = 1;
end