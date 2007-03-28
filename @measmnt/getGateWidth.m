function val=getGateWidth(cIN)
% Method to access the GateWidth of a measmnt object.

% Version 1.0
% Created 02-01-06 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-06


INclass=measmnt(cIN);
val=INclass.GateWidth;
