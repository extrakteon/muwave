function cOUT=measNoise(varargin)
% Constructor for measNoise class.
% The class is used to handle a Noise measurement.
% cOUT=measNoise creates a default object.

% Version 1.0
% Created 02-01-10 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-10
% Created.

inparam=varargin;

switch nargin
case 0,
    Meas=measmnt;
    Meas=set(Meas,'Date','today');
    
    MN.State=measstate;
    MN.State=set(MN.State,'MeasType','Noise','Vgsq',[],'Vdsq',[],'Igsq',[],'Idsq',[]);
    MN.Fmin=[];
    MN.GammaOpt=[];
    MN.Rn=[];
    MN.NF=[];
    
    cOUT=class(MN,'measNoise',Meas); % Creates MDC as a measDC object with measmnt as parent.
case 1,
    if isa(inparam{1},'measNoise')
        cOUT=inparam{1};
    else
        error('Wrong input argument.');
    end    
otherwise,
    error('Inaccurate number of input arguments');
end
