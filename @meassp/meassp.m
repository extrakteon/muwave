function cOUT=meassp(varargin)
%MEASSP Constructor for meassp class.
%   The class meassp is used to handle single-bias S-parameter measurements.
%   The class uses children classes, measstate and measmnt to store information
%   abould the bias conditions and information about the measurement.
%   The S-parameter data is stored as an XPARAM object within the meassp object.
%
%   M = meassp creates a default, empty meassp object.
%
%   See also: @MEASMNT (class), @MEASSTATE (class), @XPARAM (class), GET, SET, DISPLAY

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: koffer $
% $Date: 2006-08-18 06:47:51 +0200 (Fri, 18 Aug 2006) $
% $Revision: 306 $ 
% $Log$
% Revision 1.7  2005/05/11 10:10:31  fager
% Allows creation of a meassp object from xparam data alone.
%
% Revision 1.6  2005/04/27 21:39:43  fager
% no message
%
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
    cOUT=class(MSP,'meassp',meas,state); % Creates MSP as a meassp object with measmnt and measstate as parent.
case 1,
    if isa(inparam{1},'meassp')
        cOUT=inparam{1};
    elseif isa(inparam{1},'xparam')
        meas=set(measmnt,'Date',datestr(now)); % Create a parent object
        state=addprop(measstate,'MeasType','SP'); % Create a measstate object
        MSP.data=inparam{1};    % Inserts the xparam object
        cOUT=class(MSP,'meassp',meas,state); % Creates MSP as a meassp object with measmnt and measstate as parent.
    else
        error('Wrong input argument.');
    end    
otherwise,
    error('Inaccurate number of input arguments');
end
