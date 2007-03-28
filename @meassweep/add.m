function cOUT=add(cIN,item)
%ADD    Add an item MEASSWP- or MEASSP-object to the meassweep.
%   M=ADD(M,item) 
%
% $Header$
% $Author: koffer $
% $Date: 2004-09-28 15:40:58 +0200 (Tue, 28 Sep 2004) $
% $Revision: 212 $ 
% $Log$
% Revision 1.2  2004/09/28 13:40:58  koffer
% Now accepts both MEASSP- and MEASSWEEP-objects as input arguments.
%
% Revision 1.1  2003/07/22 12:00:08  kristoffer
% Initial.
%

cOUT = cIN;
if isempty(cIN.data)
    switch upper(class(item))
        case 'MEASSWEEP'
            cOUT = item;    
        case 'MEASSP'
            cOUT.data{1} = item;
        otherwise
            error('MEASSWEEP/ADD Input data must be of type MEASSWEEP or MEASSP');
    end
else
    switch upper(class(item))
        case 'MEASSWEEP'
            cOUT.data = [cOUT.data,item.data];
        case 'MEASSP'
            cOUT.data{end+1} = item;
        otherwise
            error('MEASSWEEP/ADD Input data must be of type MEASSWEEP or MEASSP');
    end
end
