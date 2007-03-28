function cOUT=measSP(varargin)
% Constructor for measSP class.
% The class is used to handle a S-parameter measurement.
% cOUT=measSP creates a default object.

% Version 1.0
% Created 02-01-03 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-04
% Created.

inparam=varargin;

switch nargin
case 0, % Default constructor
    Meas=measmnt;   % Create a parent object
    Meas=set(Meas,'Date','today');
    
    % Create a measstate object
    MSP.State=measstate;
    MSP.State=set(MSP.State,'MeasType','SP','Vgsq',0,'Vdsq',0,'Igsq',0,'Idsq',0);
    
    % Create a default xparam object.
    MSP.Data=xparam;    % Invokes the default constructor of the xparam class.
    
    cOUT=class(MSP,'measSP',Meas); % Creates MSP as a measSP object with measmnt as parent.
case 1,
    if isa(inparam{1},'measSP')
        cOUT=inparam{1};
    else
        error('Wrong input argument.');
    end    
otherwise,
    error('Inaccurate number of input arguments');
end
