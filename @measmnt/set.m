function cOUT=set(cIN,varargin)
% Method to set the properties of a measmnt class object.

% Version 2.0
% Created 02-01-03 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-03
% Created.
% v2.0 -- Date 02-01-04
% Modified in accordance with standard


property_argin = varargin;
INclass=measmnt(cIN);

if nargin == 1 % display only, set(m)
    display(INclass);
    return;
elseif nargin>2 & mod(nargin,2)==1   %set(cIN,'Prop1',val,'Prop2',val2,...)
    while length(property_argin) >= 2
        prop = property_argin{1};
        val = property_argin{2};
        property_argin = property_argin(3:end);
        switch prop
        case 'Operator',
            if isstr(val) | isnumeric(val)
                INclass.Operator=val;      
            else
                error('Operator must be a string or number.');
            end
        case 'Date',
            if isstr(val)
                if strcmp(val,'today')
                    INclass.Date=datestr(now);
                else
                    INclass.Date=val;
                end
            else
                error('Date must be a string.');
            end
        case 'Info',
            if isstr(val)
                INclass.Info=val;
            else
                error('Info must be a string.');
            end
        case 'GateLength',
            if isnumeric(val)
                INclass.GateLength=val;
            else
                error('GateLength must be numeric.');
            end
        case 'GateWidth',
            if isnumeric(val)
                INclass.GateWidth=val;
            else
                error('GateWidth must be numeric.');
            end
        case 'Origin',
            if isstr(val)
                INclass.Origin=val;
            else
                error('Origin must be a string.');
            end
        otherwise,
            error('Undefined parameter');
        end
    end
    cOUT=INclass;
else
    error('Inproper number of input arguments');
end
