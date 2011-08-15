function cOUT=set(INclass,varargin)
% Method to set the properties of a modelsp class object.

% $Header$
% $Author: kristoffer $
% $Date: 2003-06-17 14:17:51 +0200 (Tue, 17 Jun 2003) $
% $Revision: 2 $ 
% $Log$
% Revision 1.1  2003/06/17 12:17:53  kristoffer
% Initial revision
%
% Revision 1.1  2002/01/17 15:19:38  fager
% Initial
%
%

property_argin = varargin;

if nargin == 1 % display only, set(m)
    display(INclass);
    return;
elseif nargin>2 & mod(nargin,2)==1   %set(cIN,'Prop1',val,'Prop2',val2,...)
    while length(property_argin) >= 2
        prop = property_argin{1};
        val = property_argin{2};
        property_argin = property_argin(3:end);
        switch prop
        case 'meassp',
            if isa(val,'meassp') 
                INclass.meassp=val;      
            else
                error('meassp must be a meassp class object.');
            end
        case 'ModelType',
            if ismember(val,{'HEMT','LDMOS'})   % Inte bra ... 
                INclass.ModelType=val;      
            else
                error('Modeltype not recognized.');
            end
        case 'Params',
            if isnumeric(val) 
                INclass.Params=val;      
            else
                error('Model parameters must be numeric.');
            end
        case 'ExtrType',
            if ismember(val,{'Niekerk','Dambrine'}) 
                INclass.ExtrType=val;      
            else
                error('Extraction type not recognized.');
            end
        case 'OptParams',
            if isnumeric(val)
                INclass.OptParams=val;      
            else
                error('Optimization parameters must be numeric.');
            end
        case 'ParamMin',
            if isnumeric(val)
                INclass.ParamMin=val;      
            else
                error('ParamMin must be numeric.');
            end
        case 'ParamMax',
            if isnumeric(val)
                INclass.ParamMax=val;      
            else
                error('ParamMax must be numeric.');
            end
        case 'ParamStart',
            if isnumeric(val)
                INclass.ParamStart=val;      
            else
                error('ParamStart must be numeric.');
            end
        case 'Error',
            if isnumeric(val)
                INclass.Error=val;      
            else
                error('Extraction error must be numeric.');
            end
        case 'Iterations',
            if isnumeric(val)
                INclass.Iterations=val;      
            else
                error('Iterations must be numeric.');
            end
        case 'MeasData',
            if isa(val,'xparam')
                INclass.MeasData=val;
            else
                error('Measurement data must be numeric.');
            end
        case 'CustomInfo',
            if isa(val,'struct')
                INclass.CustomInfo=val;
            else
                error('Custom info must be a struct.');
            end        
        otherwise,
            try
                cOUT.meassp = set(INclass.meassp,prop,val);
            catch
                warning(['Unknown property: "',prop,'".']);
            end
        end
    end
    cOUT=INclass;
else
    error('Inproper number of input arguments');
end
