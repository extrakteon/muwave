function varargout = dtd(varargin)
%TD Return derivative time-domain data for a waveform
%
%   
% $Header$
% $Author: $
% $Date: $
% $Revision: $ 
% $Log$
%
wf = varargin{1};
if nargin == 2
    temp = varargin{2};
else
    temp = 201; % default number of time steps
end

if length(temp) > 1
    t = temp;
else
    t = linspace(0,2*period(wf),temp);
end

[xomega,xt] = meshgrid(2*pi*wf.freq,t);
H = j*xomega.*exp(j*xomega.*xt); % time derivative

data_dtd = wf.data*H.';
data_dtd = 0.5*(data_dtd + conj(data_dtd));

varargout{1} = data_dtd;
if nargout == 2
    varargout{2} = t;
end