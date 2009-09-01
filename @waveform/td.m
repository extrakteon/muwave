function varargout = td(varargin)
%TD Return time-domain data for a waveform
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
H = exp(j*xomega.*xt);

data_td = wf.data*H.';
data_td = 0.5*(data_td + conj(data_td));

varargout{1} = data_td;
if nargout == 2
    varargout{2} = t;
end