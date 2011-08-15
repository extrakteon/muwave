function cOUT=renameprop(cIN,oldname,newname)
%RENAMEprop    Renames a measmnt property.
%   M = renameprop(M,'OldName','NewName') changes the name of the measmnt object M's property "OldName" to "NewName".  

% $Header$
% $Author: fager $
% $Date: 2005-04-27 23:50:34 +0200 (Wed, 27 Apr 2005) $
% $Revision: 264 $ 
% $Log$
% Revision 1.1  2005/04/27 21:50:34  fager
% * Initial version
% * Frequencies -> xparam
%

INclass=measmnt(cIN);

if nargin ~= 3, error('Wrong number of input arguments');end
if ~(ischar(oldname) & ischar(newname)), error('Both old and new names must be strings'); end

v = get(cIN,oldname);
cOUT = addprop(cIN,newname,v);
p_ix = find(ismember(cIN.props,oldname));
cOUT.props(p_ix) = [];
cOUT.values(p_ix) = [];