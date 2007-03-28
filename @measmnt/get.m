function val=get(cIN,prop_name)
%GET    Get measmnt object properties.
%   V = get(M,'P1') returns the value of the measmnt object M property P1.
%
%   V = get(M) returns a cell vector of the defined M property names.

% $Header$
% $Author: $
% $Date: 2003-08-18 14:50:06 +0200 (Mon, 18 Aug 2003) $
% $Revision: 122 $ 
% $Log$
% Revision 1.5  2003/07/17 09:20:01  fager
% Possibility to get a list of the defined property names added.
%
% Revision 1.4  2003/07/16 14:45:48  fager
% Ignore the property case
%
% Revision 1.3  2003/07/16 09:22:56  fager
% Matlab Help and CVS logging info added.
%
%


INclass=measmnt(cIN);

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