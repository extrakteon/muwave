function val=get(cIN,prop_name)
% Method to access the properties of a measmnt object.

% Version 2.0
% Created 02-01-03 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-03
% Created.
% v2.0 -- Date 02-01-04
% Updated according to standard.


INclass=measmnt(cIN);
switch prop_name
    case 'Operator',
        val=INclass.Operator;    
    case 'GateLength',
        val=INclass.GateLength;    
    case 'GateWidth',
        val=INclass.GateWidth;    
    case 'Date',
        val=INclass.Date;    
    case 'Info',
        val=INclass.Info;    
    case 'Origin',
        val=INclass.Origin;    
    otherwise
    error(['Unknown property "',prop_name,'".']);
end
