function cOUT=setInfo(cIN,info)
% Method to set the info of a measmnt class object.

% Version 1.0
% Created 02-01-06 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-03
% Created.

INclass=measmnt(cIN);

if nargin == 2
	cOUT=set(cIN,'Info',info);
else 
	error('Wrong number of input arguments.');
end