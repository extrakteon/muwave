function ft = ft(varargin)
%FT The ft parameter for two-port devices.
%   F = FT(MSP) returns the ft-parameter for the two-port measurements in the meassp-object MSP. 
%   The results are obtained by extrapolating to the frequency where the short-circuit current 
%   gain equals unity.
%
%   See also: FMAX

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2004-10-21 00:25:32 +0200 (Thu, 21 Oct 2004) $
% $Revision: 220 $ 
% $Log$
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

H21 = 20*log10(abs(h21(a)));
% see if we have measured the zero-dB crossing

if any(H21<=0) & spline
    % then use interpolation
    ft = interp1(H21,freq(a),0,'spline',NaN);
else
    % otherwise use extrapolation
    p = polyfit(H21,log10(freq(a)),1);
    ft = 10^(p(2));
end
