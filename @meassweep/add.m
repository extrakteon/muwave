function cOUT=add(cIN,item)
%ADD    Add an item (e.g. a meassp-object) to the meassweep.
%   M=ADD(M,item) 
%

% $Header$
% $Author: kristoffer $
% $Date: 2003-07-22 14:00:08 +0200 (Tue, 22 Jul 2003) $
% $Revision: 109 $ 
% $Log$
% Revision 1.1  2003/07/22 12:00:08  kristoffer
% Initial.
%

cOUT = cIN;
if isempty(cIN.data)
    cOUT.data{1} = item;
else
    cOUT.data{end+1} = item;
end
