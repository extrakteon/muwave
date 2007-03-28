function cOUT=set(cIN,varargin)
%SET    Set measmnt object properties.
%   set(M) returns the non-empty properties of the measmnt
%   object M.
%   M=set(M,'P1',V) assigns the property P1 of the measmnt
%   object M the value V. 

% $Header$
% $Author: $
% $Date: 2003-08-18 14:50:06 +0200 (Mon, 18 Aug 2003) $
% $Revision: 122 $ 
% $Log$
% Revision 1.6  2003/07/16 14:45:48  fager
% Ignore the property case
%
% Revision 1.5  2003/07/16 13:21:42  fager
% Method addprop replaces the possibility to add properties directly in set.
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
        val = property_argin{2};
        property_argin = property_argin(3:end);
        prop_ix = find(strcmpi(INclass.props,prop));
        if isstr(prop)
            if ~isempty(prop_ix)
                INclass.values{prop_ix} = val;
            else
                error(['Undefined property: ',prop,'.']);
                % INclass.props{end+1} = prop;
                % INclass.values{end+1} = val;
            end
        else
            error('Properties must be strings');
        end
    end
    cOUT=INclass;
else
    error('Inproper number of input arguments');
end
