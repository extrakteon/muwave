function gmsg = gmsg(a)
%GMSG The maximum stable gain for two-port devices.
%
%   See also: GT, GA, GP, GTUMAX

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2004-10-21 00:25:32 +0200 (Thu, 21 Oct 2004) $
% $Revision: 220 $ 
% $Log$
% Revision 1.4  2004/10/20 22:19:32  fager
% Help comments added
%
% Revision 1.2  2003/07/18 13:51:10  fager
% Matlab-standardized help and CVS-logging added.
%

switch nargin
case 1
    if get(a.Data,'ports') == 2
        s21 = abs(a.Data.S21);
        s12 = abs(a.Data.S12);
        gmsg = abs(s21)./abs(s12);
    else
        error('MEASSP.GMSG: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.GMSG: Wrong number of arguments.');
end