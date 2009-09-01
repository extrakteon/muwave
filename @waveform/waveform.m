function out = waveform(varargin)
%WAVEFORM Constructor for the waveform class.
%   The class waveform is used to handle single-bias wave form measurements.
%
%   WF = WAVEFORM creates a default, empty waveform object.
%
%   
% $Header$
% $Author: $
% $Date: $
% $Revision: $ 
% $Log$
%

% Default waveform
p.type = 'AB'; % 'AB' pseudo-waves, 'IV' voltage-current
p.reference = 50; % reference impedance
p.data = []; % array of pair of complex phasors
p.freq = []; % frequency list

if nargin==0
    out = class(p, 'waveform');
elseif nargin == 2
    p.data = varargin{1};
    p.freq = varargin{2};
    out = class(p, 'waveform');
elseif nargin == 3
    p.data = varargin{1};
    p.freq = varargin{2};
    if ismember(varargin{3},{'AB','VI'})
        p.type = varargin{3};
    else
       error('WAVEFORM.WAVEFORM: Invalid waveform type.') 
    end
    out = class(p, 'waveform');
else
    error('WAVEFORM.WAVEFORM: Invalid input argument(s).')   
end

%
% Internal functions
%

