function cOUT=measSP(varargin)
%MEASSP Constructor for measSP class.
%   The class meassp is used to handle single-bias S-parameter measurements.
%   The class uses children classes, measstate and measmnt to store information
%   abould the bias conditions and information about the measurement.
%   The S-parameter data is stored as an XPARAM object within the measSP object.
%
%   M = measSP creates a default, empty measSP object.
%
%   See also: @MEASMNT (class), @MEASSTATE (class), @XPARAM (class), GET, SET, DISPLAY

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2004-10-21 00:25:32 +0200 (Thu, 21 Oct 2004) $
% $Revision: 220 $ 
% $Log$
% Revision 1.5  2004/10/20 22:24:09  fager
% Help comments added
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
