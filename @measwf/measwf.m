function cOUT=measwf(varargin)
%MEASWF Constructor for measwf class.
%   The class measwf is used to handle single-bias wave form measurements.
%   The class uses children classes, measstate and measmnt to store information
%   abould the bias conditions and information about the measurement.
%   The wave from data is stored as an ARRAYMATRIX object within the measwf object.
%
%   M = measwf creates a default, empty measwf object.
%
%   See also: @MEASMNT (class), @MEASSTATE (class), @WAVEFORM (class), GET, SET, DISPLAY

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: e7koffe@CHALMERS.SE $
% $Date: 2009-09-01 11:15:27 +0200 (ti, 01 sep 2009) $
% $Revision: 113 $ 
% $Log$

inparam=varargin;

switch nargin
case 0, % Default constructor
    meas=set(measmnt,'Date',datestr(now)); % Create a parent object
    state=addprop(measstate,'MeasType','WAVEFORM'); % Create a measstate object
    
    % Create a default wave form object.
    MSP.data=arraymatrix;    % Invokes the default constructor of the xparam class.
    cOUT=class(MSP,'measwf',meas,state); % Creates MSP as a meassp object with measmnt and measstate as parent.
case 1,
    if isa(inparam{1},'measwf')
        cOUT=inparam{1};
    elseif isa(inparam{1},'waveform')
        meas=set(measmnt,'Date',datestr(now)); % Create a parent object
        state=addprop(measstate,'MeasType','WAVEFORM'); % Create a measstate object
        MSP.data=inparam{1};    % Inserts the waveform object
        cOUT=class(MSP,'measwf',meas,state); % Creates MSP as a measwf object with measmnt and measstate as parent.
    else
        error('Wrong input argument.');
    end    
otherwise,
    error('Inaccurate number of input arguments');
end
