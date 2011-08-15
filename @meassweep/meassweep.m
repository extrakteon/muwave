function cOUT=meassweep(cIN)
%MEASSWEEP Constructor for the meassweep class.
%   The class is designed to handle a set of measurements, typically a sweep of 
%   S-parameter measurements in MEASSP objects. 
%
%   See also: READ_MDIF, READ_MILOUSWEEP, @MEASSP, @MEASMNT

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2004-10-20 19:01:34 +0200 (Wed, 20 Oct 2004) $
% $Revision: 218 $ 
% $Log$
% Revision 1.3  2004/10/20 16:58:53  fager
% Help comments added
%
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
