function cOUT=set(cIN,varargin)
% Method to set the properties of a meassweep object.

% Created 02-01-08 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-08
% Created.

property_argin = varargin;
INclass=meassweep(cIN);

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
                INclass.Info=setOperator(INclass.Info,val);      
            else
                error('Operator must be a string or number.');
            end
        case 'Date',
            if isstr(val)
                INclass.Info=setDate(INclass.Info,val);      
            else
                error('Date must be a string.');
            end
        case 'Info',
            if isstr(val)
                INclass.Info=setInfo(INclass.Info,val);      
            else
                error('Info must be a string.');
            end
        case 'Origin',
            if isstr(val)
                INclass.Info=setOrigin(INclass.Info,val);      
            else
                error('Origin must be a string.');
            end
        case 'GateWidth',
            if isnumeric(val)
                INclass.Info=setGateWidth(INclass.Info,val);      
            else
                error('Gate width must be numeric.');
            end
        case 'GateLength',
            if isnumeric(val)
                INclass.Info=setGateLength(INclass.Info,val);      
            else
                error('Gate length must be numeric.');
            end
        case 'DataType',
            if ismember(val,{'SP','DC','DCPulse'})
                INclass.DataType=val;      
            else
                error('Datatype must be a any of "SP","DC", or "DCPulse".');
            end
        case 'Data',
            if isa(val,'cell') 
                INclass.Data=val;      
            elseif isa(val,'measmnt')
                INclass.Data={val};
            elseif isempty(val)
                INclass.Data={};
            else
                error('Data must be a measmnt cell object.');
            end
        otherwise,
            warning(['Unknown property: "',prop,'".']);
        end
    end
    cOUT=INclass;
else
    error('Inproper number of input arguments');
end
