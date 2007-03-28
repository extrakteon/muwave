function cOUT=measDC(varargin)
% Constructor for measDC class.
% The class is used to handle a DC measurement.
% cOUT=measDC creates a default object.
% cOUT=measDC(Vgs,Igs,Vds,Ids) creates a default DC measurement.

% Version 2.0
% Created 02-01-03 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-03
% Created.
% v2.0 -- Date 02-01-04
% Modified using measmnt class as parent.

inparam=varargin;

switch nargin
case 0,
    Meas=measmnt;
    Meas=set(Meas,'Date','today');
    
    MDC.State=measstate;
    MDC.State=set(MDC.State,'MeasType','DC','Vgsq',0,'Vdsq',0,'Igsq',0,'Idsq',0);
    
    cOUT=class(MDC,'measDC',Meas); % Creates MDC as a measDC object with measmnt as parent.
case 1,
    if isa(inparam{1},'measDC')
        cOUT=inparam{1};
    else
        error('Wrong input argument.');
    end    
case 4,
    Meas=measmnt;
    Meas=set(Meas,'Date','today');
    
    MDC.State=measstate;
    MDC.State=set(MDC.State,'MeasType','DC','Vgsq',inparam{1},'Igsq',inparam{2},'Vdsq',inparam{3},'Idsq',inparam{4});
    cOUT=class(MDC,'measDC',Meas); % Creates MDC as a measDC object with measmnt as parent.
otherwise,
    error('Inaccurate number of input arguments');
end
