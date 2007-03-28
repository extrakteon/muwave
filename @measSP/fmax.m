function fmax = fmax(varargin)
%FMAX   Returns the maximum oscillation frequency of two-port devices.

%FMAX Maximum oscillation frequency of two-port devices.
%   F = FMAX(MSP) returns the maximum frequency of oscillation for the two-port
%   measurements in MSP.
%
%   See also: FT

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2004-10-21 00:25:32 +0200 (Thu, 21 Oct 2004) $
% $Revision: 220 $ 
% $Log$
% Revision 1.5  2004/10/20 22:18:23  fager
% Help comments added
%

a = varargin{1};
if nargin > 1
    spline = varargin{2};
else
    spline = 1;
end

% find stable region
idx_stable = find(stable(a));
idx_unstable = find(~stable(a)); % stupid solution...
% for some reason subsref doesn't work from within the class
S.type = '()';S.subs={idx_stable};
a_stable = subsref(a,S);
S.type = '()';S.subs={idx_unstable};
a_unstable = subsref(a,S);
x = freq(a);
x_stable = x(idx_stable);
x_unstable = x(idx_unstable);

% calculate MSG and MAG
MSG = 20*log10(gmsg(a_unstable));
MAG = 20*log10(ga(a_stable));
% see if we have measured the zero-dB crossing
if any(MSG<=0) & spline
    fmax = interp1(MSG,x_unstable,0,'spline',NaN);
elseif any(MAG<=0) & spline
    fmax = interp1(MAG,x_stable,0,'spline',NaN);
else
    if length(x_stable)<2
        LFU = log10(x_unstable);
        pU = polyfit(MSG,LFU,1);
        fmax = 10^(pU(2));
    else
        LFS = log10(x_stable);
        pS = polyfit(MAG,LFS,1);
        fmax = 10^(pS(2));
    end
end


