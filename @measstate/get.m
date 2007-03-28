function val=get(cIN,prop_name)
% Method to get the properties of a measstate class object.

% $Header$
% $Author: kristoffer $
% $Date: 2003-06-17 14:17:51 +0200 (Tue, 17 Jun 2003) $
% $Revision: 2 $ 
% $Log$
% Revision 1.1  2003/06/17 12:17:52  kristoffer
% Initial revision
%
% Revision 1.3  2002/03/12 11:41:58  fager
% Changed to use arbitrary measurement state properties
%

INclass=measstate(cIN);
if isstr(prop_name) & ismember(prop_name,INclass.Props)
    val = INclass.Values{find(strcmp(prop_name,INclass.Props))};
else
    error(['Unknown property "',prop_name,'".']);
end
