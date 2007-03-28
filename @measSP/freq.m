function val=freq(cIN)
% Method to access the frequency of a measSP object.

% Version 1.0
% Created 02-01-04 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-06
% Created.


INclass=measSP(cIN);
val=get(INclass.State,'Freq');    
