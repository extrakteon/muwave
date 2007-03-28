function cOUT=set(cIN,varargin)
% Method to set the properties of a measSP class object.

% Version 2.0
% Created 02-01-03 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-03
% Created.
% v2.0 -- Date 02-01-04
% Modified in accordance with standard

property_argin = varargin;
INclass=measSP(cIN);

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
                INclass.measmnt=set(INclass.measmnt,'Operator',val);      
            else
                error('Operator must be a string or number.');
            end
        case 'Date',
            if isstr(val)
                INclass.measmnt=set(INclass.measmnt,'Date',val);      
            else
                error('Date must be a string.');
            end
        case 'Info',
            if isstr(val)
                INclass.measmnt=set(INclass.measmnt,'Info',val);      
            else
                error('Info must be a string.');
            end
        case 'Origin',
            if isstr(val)
                INclass.measmnt=set(INclass.measmnt,'Origin',val);      
            else
                error('Origin must be a string.');
            end
        case 'GateWidth',
            if isnumeric(val)
                INclass.measmnt=set(INclass.measmnt,'GateWidth',val);      
            else
                error('Gate width must be numeric.');
            end
        case 'GateLength',
            if isnumeric(val)
                INclass.measmnt=set(INclass.measmnt,'GateLength',val);      
            else
                error('Gate length must be numeric.');
            end
       case 'Vgsq',
            if isnumeric(val)
                INclass.State=set(INclass.State,'Vgsq',val);      
            else
                error('Vgsq must be numeric.');
            end
        case 'Igsq',
            if isnumeric(val)
                INclass.State=set(INclass.State,'Igsq',val);      
            else
                error('Igsq must be numeric.');
            end
        case 'Vdsq',
            if isnumeric(val)
                INclass.State=set(INclass.State,'Vdsq',val);      
            else
                error('Vdsq must be numeric.');
            end
        case 'Idsq',
            if isnumeric(val)
                INclass.State=set(INclass.State,'Idsq',val);      
            else
                error('Idsq must be numeric.');
            end
        case 'Data',
            if isa(val,'xparam')
                INclass.Data=val;      
            else
                error('Data must be of xparam type.');
            end
        case 'Freq',
            if isnumeric(val)
                INclass.State=set(INclass.State,'Freq',val);      
            else
                error('Frequencies must be numeric.');
            end
        case 'Temp',
            if isnumeric(val)
                INclass.State=set(INclass.State,'Temp',val);      
            else
                error('Temperature must be numeric.');
            end
        case 'Period',
            if isnumeric(val)
                INclass.State=set(INclass.State,'Period',val);      
            else
                error('Pulse period must be numeric.');
            end
        case 'PulseWidth',
            if isnumeric(val)
                INclass.State=set(INclass.State,'PulseWidth',val);      
            else
                error('Pulse width must be numeric.');
            end
        case 'Data',
            if isa(val,'meassp')
                INclass.Data=val;      
            else
                error('Pulse width must be numeric.');
            end
        otherwise,
            warning(['Unknown property: "',prop,'".']);
        end
    end
    cOUT=INclass;
else
    error('Inproper number of input arguments');
end
