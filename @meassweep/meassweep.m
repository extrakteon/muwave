function cOUT=meassweep(cIN)
%MEASSWEEP Constructor for the meassweep class.
%   The class is designed to handle a set of measurements, typically a sweep of 
%   S-parameter measurements in MEASSP objects. 
%
%   See also: READ_MDIF, READ_MILOUSWEEP, @MEASSP, @MEASMNT

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header: /milou/matlab_milou/@meassweep/meassweep.m,v 1.3 2004/10/20 16:58:53 fager Exp $
% $Author: fager $
% $Date: 2004/10/20 16:58:53 $
% $Revision: 1.3 $ 
% $Log: meassweep.m,v $
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
