function val=get(cIN,prop)
% Method to access the properties of a meassweep object.

% $Header$
% $Author: fager $
% $Date: 2003-07-21 10:32:28 +0200 (Mon, 21 Jul 2003) $
% $Revision: 105 $ 
% $Log$
% Revision 1.2  2003/07/21 08:32:11  fager
% Initial. Matlab help and CVS logging added.
%

val=[];
INclass=meassweep(cIN);
if nargin~=2, error('Wrong number of input arguments');end
if ismember(prop,get(cIN.measmnt))
    val = get(cIN.measmnt,prop);
    return;
end
if strcmpi(prop,'data'), val=INclass.data; end
for k=1:length(cIN.data)
    val=cat(2,val,get(INclass.data{k},prop));
end