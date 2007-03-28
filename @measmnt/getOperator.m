function val=getOperator(cIN)
% Method to access the operator of a measmnt object.

% Version 1.0
% Created 02-01-06 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-06


INclass=measmnt(cIN);
val=INclass.Operator;
