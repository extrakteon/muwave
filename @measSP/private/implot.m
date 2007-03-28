% $Header$
% $Author: kristoffer $
% $Date: 2003-06-17 14:17:51 +0200 (Tue, 17 Jun 2003) $
% $Revision: 2 $ 
% $Log$
% Revision 1.1  2003/06/17 12:17:52  kristoffer
% Initial revision
%
% Revision 1.1  2002/04/15 12:00:44  kristoffer
% no message
%
% 
function himplot = implot(Z,freq,x,line_style)
% Plots complex parameters in a logmag plot

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
yy = imag(Z);
xx = freq;

% plot data on top of grid
if strcmp(line_style,'auto')
    q = plot(xx,yy);
else
    q = plot(xx,yy,line_style);
end
if nargout > 0
    himplot = q;
end
%if ~hold_state
%    set(gca,'dataaspectratio',[1 1 1]), axis off; set(cax,'NextPlot',next);
%end
set(get(gca,'xlabel'),'visible','on')
set(get(gca,'ylabel'),'visible','on')
