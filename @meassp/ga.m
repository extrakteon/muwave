function ga = ga(a)
%GA Maximum available gain for two-port devices.
%
% See also: GP, GT, GTUMAX

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2005-04-27 23:44:52 +0200 (Wed, 27 Apr 2005) $
% $Revision: 261 $ 
% $Log$
% Revision 1.5  2005/04/27 21:37:11  fager
% * Changed from measSP to meassp.
%
% Revision 1.4  2004/10/20 22:21:47  fager
% Help comments added
%
% Revision 1.2  2003/07/18 13:51:09  fager
% Matlab-standardized help and CVS-logging added.
%

switch nargin
case 1
    if get(a.data,'ports') == 2
        s21 = a.data.S21;
        s12 = a.data.S12;
        k = k_fact(a);
        ga = abs(s21).*(k - sqrt(k.^2 - 1))./abs(s12);
    else
        error('MEASSP.GA: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.GA: Wrong number of arguments.');
end