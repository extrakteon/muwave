function cOUT=measmnt(cIN)
%MEASMNT    Constructor for measmnt class.
%   The class is used to handle various general measurement information.
%   Default properties are: Date, Operator, GateWidth, GateLength, Info, 
%   and Origin. 

% $Header$
% $Author: $
% $Date: 2003-08-18 14:50:06 +0200 (Mon, 18 Aug 2003) $
% $Revision: 122 $ 
% $Log$
% Revision 1.6  2003/07/17 09:30:14  fager
% no message
%
% Revision 1.5  2003/07/16 14:46:10  fager
% no message
%
% Revision 1.4  2003/07/16 09:57:12  fager
% Matlab help updated.
%
% Revision 1.3  2003/07/16 09:22:51  fager
% Matlab Help and CVS logging info added.
%
%

switch nargin
case 0,
    % Default properties.
    meas.props={'Date','Origin','Operator','Info'};
    meas.values={datestr(now),'','',''};
    cOUT=class(meas,'measmnt');
case 1,
    if isa(cIN,'measmnt')
        cOUT=cIN;
    else
        error('Wrong input argument.');
    end       
end
