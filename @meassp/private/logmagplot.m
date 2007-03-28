function hlogmagplot = logmagplot(Z,freq,x,line_style)
%LOGMAGPLOT Plots complex parameters in a logmag plot
%   Support file for PARAMPLOT.
%
%   See also: PARAMPLOT

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2005-04-27 23:44:52 +0200 (Wed, 27 Apr 2005) $
% $Revision: 261 $ 
% $Log$
% Revision 1.3  2005/04/27 21:37:12  fager
% * Changed from measSP to meassp.
%
% Revision 1.2  2004/10/20 22:25:32  fager
% Help comments added
%


if nargin < 2
    error('Requires 2 or 3 input arguments.')
elseif nargin == 2 
    if isstr(Z)
        line_style = Z;
        Z = line_style;
    else
        line_style = 'auto';
    end
end
% Assume that both parameters are equally spaced in frequency?
[mr,nr] = size(Z);

if isstr(Z)
    error('Input arguments must be numeric.');
end

% get hold state
cax = newplot;
next = lower(get(cax,'NextPlot'));
hold_state = ishold;

% transform complex data to logmag.
yy = 20*log10(abs(Z));
xx = freq;

% plot data on top of grid
if strcmp(line_style,'auto')
    q = plot(xx,yy);
else
    q = plot(xx,yy,line_style);
end
if nargout > 0
    hlogmagplot = q;
end
%if ~hold_state
%    set(gca,'dataaspectratio',[1 1 1]), axis off; set(cax,'NextPlot',next);
%end
set(get(gca,'xlabel'),'visible','on')
set(get(gca,'ylabel'),'visible','on')


