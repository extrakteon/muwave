function cOUT=modelSP(varargin)
% Constructor for modelSP class.
% The class is used to handle a models for S-parameter measurements.
% The class is derived from meassp.
%
% cOUT=modelSP creates a default object.

% $Header$
% $Author: koffer $
% $Date: 2006-08-18 06:47:51 +0200 (Fri, 18 Aug 2006) $
% $Revision: 306 $ 
% $Log$
% Revision 1.2  2005/04/27 21:44:52  fager
% * Changed from measSP to meassp.
%
% Revision 1.1.1.1  2003/06/17 12:17:53  kristoffer
%
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
    cOUT=class(MSP,'modelSP',MeasSPobj); % Creates MSP as a modelSP object with meassp as parent.
otherwise,
    error('Illegal number of input arguments');
end
