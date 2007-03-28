function cOUT=meassweep(cIN)
% Constructor for meassweep class.
% The class is used to handle a bunch of measurements.
% Various child classes are used for different types of sweeps

% Version 1.0
% Created 02-01-07 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-07
% Created.


switch nargin
case 0,
    Swp.Info=measmnt;   % Holds information about the origin, operator etc.
    Swp.DataType=[];  % Ex. {'SP'} or {'DC'}
    Swp.Data=[];        % A vector of measmnt objects.
    
    cOUT=class(Swp,'meassweep');
case 1,
    if isa(cIN,'meassweep')
        cOUT=cIN;
    else
        error('Wrong input argument.');
    end       
end
