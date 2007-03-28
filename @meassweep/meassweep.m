function cOUT=meassweep(cIN)
%MEASSWEEP  Constructor for the meassweep class.
%   The class is used to handle a range of measurements.

% $Header$
% $Author: fager $
% $Date: 2003-07-21 10:32:28 +0200 (Mon, 21 Jul 2003) $
% $Revision: 105 $ 
% $Log$
% Revision 1.2  2003/07/21 08:32:17  fager
% Initial. Matlab help and CVS logging added.
%


switch nargin
case 0,
    info=addprop(measmnt,'Date',datestr(now));   % Holds information about the origin, operator etc.
    Swp.data=[];        % A vector of measmnt objects.
    
    cOUT=class(Swp,'meassweep',info);
case 1,
    if isa(cIN,'meassweep')
        cOUT=cIN;
    else
        error('Wrong input argument.');
    end       
end
