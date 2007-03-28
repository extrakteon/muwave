function cOUT=addprop(cIN,varargin)
%ADDPROP    Add measmnt object properties.
%   addprop(M,'P',V) creates a new property, P, with value V
%   to the measmnt object M.

%   addprop(M,'P1',V1,'P2',V2,..) adds multiple properties in a single statement.

% $Header$
% $Author: $
% $Date: 2003-08-18 14:50:06 +0200 (Mon, 18 Aug 2003) $
% $Revision: 122 $ 
% $Log$
% Revision 1.2  2003/07/16 14:45:48  fager
% Ignore the property case
%
% Revision 1.1  2003/07/16 13:20:39  fager
% New method to add object properties
%
% Revision 1.4  2003/07/16 09:58:25  fager
% Check if the property is a string.
%
% Revision 1.3  2003/07/16 09:22:47  fager
% Matlab Help and CVS logging info added.
%
%

property_argin = varargin;
INclass=measmnt(cIN);

if nargin == 1 % display only, set(m)
    display(INclass);
    return;
elseif nargin>2 & mod(nargin,2)==1   %set(cIN,'Prop1',val,'Prop2',val2,...)
    while length(property_argin) >= 2
        prop = property_argin{1};
        prop_ix = find(strcmpi(INclass.props,prop));
        val = property_argin{2};
        property_argin = property_argin(3:end);
        if ~isstr(prop), error('Properties must be strings.'), end;
        if isempty(val), continue; end;
        if isempty(prop_ix) % New, unknown property
            INclass.props{end+1} = prop;
            INclass.values{end+1} = val;
        else % Property already defined; just modify the value.
            INclass.values{prop_ix} = val;
        end
    end
    cOUT=INclass;
else
    error('Inproper number of input arguments');
end
