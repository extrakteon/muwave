function gtu = gtumax(a)
%GTUMAX The maximum unilateral transducer gain for two-port devices.
% 
%   See also: GA, GP, GMSG, GT

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2004-10-21 00:25:32 +0200 (Thu, 21 Oct 2004) $
% $Revision: 220 $ 
% $Log$
% Revision 1.4  2004/10/20 22:22:09  fager
% Help comments added
%
% Revision 1.2  2003/07/18 13:51:10  fager
% Matlab-standardized help and CVS-logging added.
%

switch nargin
case 1
    if get(a.data,'ports') == 2
        s21 = abs(a.data.S21);
        s11 = abs(a.data.S11);
        s22 = abs(a.data.S22);
        gtu = s21.*s21./((1-s11.*s11).*(1-s22.*s22));
    else
        error('MEASSP.GTUMAX: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.GTUMAX: Wrong number of arguments.');
end