function val=get(cIN,prop_name)
%GET    Get measstate object properties.
%   V = get(M,'P1') returns the value of the measstate object M property P1.
%
%   V = get(M) returns a cell vector of the defined M property names.

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.4  2003/07/17 09:20:06  fager
% Possibility to get a list of the defined property names added.
%
% Revision 1.3  2003/07/16 14:45:49  fager
% Ignore the property case
%
% Revision 1.2  2003/07/16 09:59:59  fager
% Matlab help added.
%
% Revision 1.1.1.1  2003/06/17 12:17:52  kristoffer
%
%
% Revision 1.3  2002/03/12 11:41:58  fager
% Changed to use arbitrary measurement state properties
%

INclass=measstate(cIN);
% Does the property exist?

switch nargin
    case 1,
        val = cIN.props;
    case 2,
        prop_ix=find(strcmpi(INclass.props,prop_name));
        if ~isempty(prop_ix)
            val = INclass.values{prop_ix};
        else
            error(['Unknown property "',prop_name,'".']);
        end
end
