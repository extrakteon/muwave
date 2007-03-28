function display(cIN)
% Method to display the properties of a measmnt class object.

% Version 1.0
% Created 02-01-03 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-03
% Created.

INclass=measmnt(cIN);
if ~isempty(INclass.Date), disp(sprintf('\tDate: %s',INclass.Date)); end
if ~isempty(INclass.Origin), disp(sprintf('\tOrigin: %s',INclass.Origin)); end
if ~isempty(INclass.Operator), disp(sprintf('\tOperator: %s',INclass.Operator)); end
if ~isempty(INclass.Info), disp(sprintf('\tInfo: %s',INclass.Info)); end
if ~isempty(INclass.GateWidth), disp(sprintf('\tGateWidth: %f',INclass.GateWidth)); end
if ~isempty(INclass.GateLength), disp(sprintf('\tGateLength: %s',INclass.GateLength)); end
