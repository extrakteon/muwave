function cOUT=renameprop(cIN,oldname,newname)
%RENAMEprop    Renames a measstate property.
%   M = renameprop(M,'OldName','NewName') changes the name of the measstate object M's property "OldName" to "NewName".  

% $Header: /milou/matlab_milou/@measstate/renameprop.m,v 1.1 2005/04/27 21:50:34 fager Exp $
% $Author: fager $
% $Date: 2005/04/27 21:50:34 $
% $Revision: 1.1 $ 
% $Log: renameprop.m,v $
% Revision 1.1  2005/04/27 21:50:34  fager
% * Initial version
% * Frequencies -> xparam
%

cOUT=measstate(cIN);

if nargin ~= 3, error('Wrong number of input arguments');end
if ~(ischar(oldname) & ischar(newname)), error('Both old and new names must be strings'); end

v = get(cIN,oldname);
p_ix = find(ismember(cIN.props,oldname));
cOUT.props(p_ix) = [];
cOUT.values(p_ix) = [];
cOUT = addprop(cOUT,newname,v);
