function cOUT=add(cIN,varargin)
%ADD    Add an item MEASSWP- or MEASSP-object to the meassweep.
%   M=ADD(M,item) 
%
% $Header$
% $Author: e7koffe@CHALMERS.SE $
% $Date: 2009-09-01 11:16:10 +0200 (ti, 01 sep 2009) $
% $Revision: 114 $ 
% $Log$
% Revision 1.3  2005/05/12 12:27:37  fager
% Allows multiple objects to be added in one statement.
%
% Revision 1.2  2004/09/28 13:40:58  koffer
% Now accepts both MEASSP- and MEASSWEEP-objects as input arguments.
%
% Revision 1.1  2003/07/22 12:00:08  kristoffer
% Initial.
%

cOUT = cIN;
stop = nargin<2;
i = 1;
while ~stop
    item = varargin{i};
    if isempty(cOUT.data)
        switch upper(class(item))
            case 'MEASSWEEP'
                cOUT = item;
            case {'MEASSP','MEASWF'}
                cOUT.data{1} = item;
            otherwise
                error('MEASSWEEP/ADD Input data must be of type MEASSWEEP, MEASSP or MEASWF');
        end
    else
        switch upper(class(item))
            case 'MEASSWEEP'
                cOUT.data = [cOUT.data,item.data];
            case {'MEASSP','MEASWF'}
                cOUT.data{end+1} = item;
            otherwise
                error('MEASSWEEP/ADD Input data must be of type MEASSWEEP, MEASSP or MEASWF');
        end
    end
    i = i+1;
    stop = i>length(varargin);
end
