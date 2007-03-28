function val=length(cIN)
% Method to find the length of a measSP object.

% Version 1.0
% Created 02-01-07 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-07
% Created.


INclass=measSP(cIN);
val=length(INclass.Data);
