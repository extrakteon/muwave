function cOUT=set(cIN,varargin)
%SET    Set measstate object properties.
%   set(M) returns the non-empty properties of the measstate
%   object M.
%   M=set(M,'P1',V) assigns the property P1 of the measstate
%   object M the value V.  

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.5  2005/05/23 14:11:13  fager
% Assignment with empty-matrix value removes the property.
%
% Revision 1.4  2003/07/16 14:45:49  fager
% Ignore the property case
%
% Revision 1.3  2003/07/16 13:21:28  fager
% Method addprop replaces the possibility to add properties directly in set.
%
% Revision 1.2  2003/07/16 09:59:49  fager
% Matlab help added.
%
% Revision 1.1.1.1  2003/06/17 12:17:52  kristoffer
%
%
% Revision 1.3  2002/03/12 11:38:46  fager
% Changed to use arbitrary measurement state properties
%

property_argin = varargin;
INclass=measstate(cIN);

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
                if isempty(val) % Remove the property
                    INclass.props(prop_ix) = [];
                    INclass.values(prop_ix) = [];
                else
                    INclass.values{prop_ix} = val;
                end
            else
                error(['Undefined parameter: ',prop,'.']);
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