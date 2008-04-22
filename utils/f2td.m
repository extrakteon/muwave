function varargout = f2td(varargin)
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
    temp = 101; % default number of time steps
end

freq = wf.freq(1,:);

if length(temp) > 1
    t = temp;
else
    T = 1./freq(2); % determine period
    t = linspace(0,T,temp);
end


[xomega,xt] = meshgrid(2*pi*freq,t);
H = exp(j*xomega.*xt);

NP = size(wf.freq,1);
x = [wf.a1.' wf.b1.' wf.a2.' wf.b2.'];
x = H*x;
x = 0.5*(x + conj(x));

idx = 1:NP;
td.a1 = x(:,idx);
td.b1 = x(:,NP+idx);
td.a2 = x(:,2*NP+idx);
td.b2 = x(:,3*NP+idx);
% calculate voltage/current
td.v1 = td.a1+td.b1;
td.i1 = (td.a1-td.b1)/50;
td.v2 = td.a2+td.b2;
td.i2 = (td.a2-td.b2)/50;

varargout{1} = td;
if nargout == 2
    varargout{2} = t;
end

