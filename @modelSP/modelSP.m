function cOUT=modelSP(varargin)
% Constructor for modelSP class.
% The class is used to handle a models for S-parameter measurements.
% The class is derived from measSP.
%
% cOUT=modelSP creates a default object.

% $Header$
% $Author: kristoffer $
% $Date: 2003-06-17 14:17:51 +0200 (Tue, 17 Jun 2003) $
% $Revision: 2 $ 
% $Log$
% Revision 1.1  2003/06/17 12:17:53  kristoffer
% Initial revision
%
% Revision 1.2  2002/01/17 15:19:45  fager
% Initial
%
% Revision 1.1  2002/01/17 13:06:49  fager
% no message
%
%

inparam=varargin;

switch nargin
case 0, % Default constructor
    MeasSPobj = meassp;         % Contains the simulated S-parameters
    MSP.ModelType   = '';       % Ex. 'HEMT' (must be of registered type)
    MSP.Params      = [];       % Ex. [1.2 2.4 5.6 ]    % Must be all parameters
    MSP.ExtrType    = '';       % Ex. 'Niekerk'
    MSP.OptParams   = [];       % Ex. [1 3 5 7], corresponding to some model parameters
    MSP.ParamStart  = [];       % Starting values for optimized parameters
    MSP.ParamMin    = [];       % Min. parameter range for optimized parameters
    MSP.ParamMax    = [];       % Max. parameter range for optimized parameters
    MSP.Error       = [];       % Error obtained during i.e. optimization
    MSP.Iterations  = [];       % Ex. 10
    MSP.MeasData    = [];       % Refers to an xparam object from which the model was extracted.
    MSP.CustomInfo  = [];       % Refers to struct with additional extraction specific information
    cOUT=class(MSP,'modelSP',MeasSPobj); % Creates MSP as a modelSP object with measSP as parent.
otherwise,
    error('Illegal number of input arguments');
end
