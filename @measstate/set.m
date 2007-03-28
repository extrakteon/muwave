function cOUT=set(cIN,varargin)
% Method to set the properties of a measstate class object.

% $Header$
% $Author: kristoffer $
% $Date: 2003-06-17 14:17:51 +0200 (Tue, 17 Jun 2003) $
% $Revision: 2 $ 
% $Log$
% Revision 1.1  2003/06/17 12:17:52  kristoffer
% Initial revision
%
% Revision 1.3  2002/03/12 11:38:46  fager
% Changed to use arbitrary measurement state properties
%

property_argin = varargin;
INclass=measstate(cIN);

if nargin == 1 % display only, set(m)
    display(INclass);
    return;
elseif nargin>2 & mod(nargin,2)==1   % set(cIN,'Prop1',val,'Prop2',val2,...)
    while length(property_argin) >= 2
        prop = property_argin{1};
        val = property_argin{2};
        property_argin = property_argin(3:end);
        if ismember(prop,INclass.Props) 
            % The specified property exists.
            INclass.Values{find(strcmp(prop,INclass.Props))}=val;
        elseif isstr(prop)
            % Create the specified property
            INclass.Props={INclass.Props{:},prop};
            INclass.Values={INclass.Values{:},val};
        else
            error(['Illegal property. A property must be a string.']);
        end
        cOUT=INclass;
    end
else
    error('Inproper number of input arguments');
end