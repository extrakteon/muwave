function val=get(cIN,prop_name)
% Method to access the properties of a measDC object.

% Version 1.0
% Created 02-01-03 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-04
% Created.


INclass=measDC(cIN);
switch prop_name
    % Measmnt properties    
case 'Operator',
    val=get(INclass.measmnt,'Operator');    
case 'Date',
    val=get(INclass.measmnt,'Date');    
case 'Info',
    val=get(INclass.measmnt,'Info');    
case 'Origin',
    val=get(INclass.measmnt,'Origin');    
    % State properties    
case 'Vgsq',
    val=get(INclass.State,'Vgsq');    
case 'Igsq',
    val=get(INclass.State,'Igsq');    
case 'Vdsq',
    val=get(INclass.State,'Vdsq');    
case 'Idsq',
    val=get(INclass.State,'Idsq');    
otherwise
    error(['Unknown property "',prop_name,'".']);
end
