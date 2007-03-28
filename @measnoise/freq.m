function val=freq(cIN)
% Method to access the frequency of a measNoise object.

% Version 1.0
% Created 02-01-10 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-10
% Created.


INclass=measNoise(cIN);
val=get(INclass.State,'Freq');    
