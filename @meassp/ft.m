function ft = ft(varargin)
%FT The ft parameter for two-port devices.
%   F = FT(MSP) returns the ft-parameter for the two-port measurements in the meassp-object MSP. 
%   The results are obtained by extrapolating to the frequency where the short-circuit current 
%   gain equals unity.
%
%   See also: FMAX

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.6  2005/04/27 21:37:11  fager
% * Changed from measSP to meassp.
%
% Revision 1.5  2004/10/20 22:18:42  fager
% Help comments added
%
%

a=varargin{1};
if nargin>1
    spline = varargin{2};
else
    spline = 1;
end

x = freq(a);
H21 = 20*log10(abs(h21(a)));

% see if we have measured the zero-dB crossing
if all(H21<=0)
    ft = 0;
elseif (any(H21<=0) && any(H21>0)) && spline
    % then use interpolation
    p = interp1(H21,log10(x),0,'spline');
    ft = 10^(p);
    if ft > max(x) % impossible if we measured the transition
        p = interp1(H21,log10(x),0,'linear');
    end
    ft = 10^(p);
else
    % otherwise use extrapolation
    % first remove low frequencies
    idx = find(x < 0.4*max(x));
    idx = (1+idx(end)):length(x);
    % then extrapolate
    p = polyfit(H21(idx),log10(x(idx)),1);
    ft = 10^(p(2));
end
