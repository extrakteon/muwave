function cOUT=set(cIN,varargin)
% Method to set the properties of a measNoise class object.

% Version 2.0
% Created 02-01-03 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-03
% Created.
% v2.0 -- Date 02-01-04
% Modified in accordance with standard

property_argin = varargin;
INclass=measNoise(cIN);

if nargin == 1 % display only, set(m)
    display(INclass);
    return;
elseif nargin>2 & mod(nargin,2)==1   %set(cIN,'Prop1',val,'Prop2',val2,...)
    while length(property_argin) >= 2
        prop = property_argin{1};
        val = property_argin{2};
        property_argin = property_argin(3:end);
        switch prop
        case 'State',
            if isa(val,'measstate')
                INclass.State=val;      
            else
                error('State must be of measstate type.');
            end
        case 'Fmin',
            if isnumeric(val)
                INclass.Fmin=val;      
            else
                error('Fmin must be numeric.');
            end
        case 'Rn',
            if isnumeric(val)
                INclass.Rn=val;      
            else
                error('Rn must be numeric.');
            end
        case 'GammaOpt',
            if isnumeric(val)
                INclass.GammaOpt=val;      
            else
                error('Gamma opt must be numeric.');
            end
        case 'NF',
            if isnumeric(val)
                INclass.NF=val;      
            else
                error('NF must be numeric.');
            end
        otherwise,
            try
                INclass.measmnt=set(INclass.measmnt,prop,val);
            catch
                try
                    INclass.State=set(INclass.State,prop,val);
                catch
                    error(['Unknown property "',prop,'".']);
                end
            end
        end
    end
    cOUT=INclass;
else
    error('Inproper number of input arguments');
end
