function cOUT=measSP(varargin)
%MEASSP Constructor for measSP class.
%   The class is used to handle single-bias S-parameter measurements.
%   M = measSP creates a default, empty measSP object.

% $Header$
% $Author: fager $
% $Date: 2003-07-16 16:49:35 +0200 (Wed, 16 Jul 2003) $
% $Revision: 58 $ 
% $Log$
% Revision 1.4  2003/07/16 14:49:35  fager
% no message
%
% Revision 1.3  2003/07/16 13:25:42  fager
% Uses new measstate and measmnt classes
%
% Revision 1.2  2003/07/16 10:42:38  fager
% Matlab help and CVS logging included. Modified for new measmnt and measstate
% classes.
%

inparam=varargin;

switch nargin
case 0, % Default constructor
    meas=set(measmnt,'Date',datestr(now)); % Create a parent object
    state=addprop(measstate,'MeasType','SP'); % Create a measstate object
    
    % Create a default xparam object.
    MSP.data=xparam;    % Invokes the default constructor of the xparam class.
    cOUT=class(MSP,'measSP',meas,state); % Creates MSP as a measSP object with measmnt and measstate as parent.
case 1,
    if isa(inparam{1},'measSP')
        cOUT=inparam{1};
    else
        error('Wrong input argument.');
    end    
otherwise,
    error('Inaccurate number of input arguments');
end
