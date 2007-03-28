function gp = gp(a)
%GP The power gain for two-port devices.
%
%   See also: GA, GMSG, GT, GTUMAX

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2004-10-21 00:25:32 +0200 (Thu, 21 Oct 2004) $
% $Revision: 220 $ 
% $Log$
% Revision 1.4  2004/10/20 22:21:48  fager
% Help comments added
%

switch nargin
case 1
    if get(a.data,'ports') == 2
        s21 = abs(a.data.S21);
        s11 = abs(a.data.S11);
        gp = s21.*s21./(1-s11.*s11);
    else
        error('MEASSP.GP: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.GP: Wrong number of arguments.');
end