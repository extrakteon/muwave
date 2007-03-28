function cOUT=measmnt(cIN)
% Constructor for measmnt class.
% The class is used to handle a measurement.
% Various child-classes are used to define e.g. S-parameter 
% and DC measurements.

% Version 2.0
% Created 02-01-03 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-03
% Created.
% v2.0 -- Date 02-01-04
% Implemented in accordance with standard.

switch nargin
case 0,
    Meas.Date=datestr(now);
    Meas.Operator='';
    Meas.GateWidth=[];
    Meas.GateLength=[];
    Meas.Info='';
    Meas.Origin='';
    cOUT=class(Meas,'measmnt');
case 1,
    if isa(cIN,'measmnt')
        cOUT=cIN;
    else
        error('Wrong input argument.');
    end       
end
