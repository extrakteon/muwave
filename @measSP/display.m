function display(cIN)
% Method to display the properties of a measSP object.

% Version 1.0
% Created 02-01-03 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-04
% Created.

INclass=measSP(cIN);
disp('Measurement info')
display(cIN.measmnt);
disp('Measurement state')
display(cIN.State);
disp('Measurement Data')
display(cIN.Data);