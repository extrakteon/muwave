function ft = ft(a)
%FMAX   Returns the ft parameter for two-port devices.

% $Header$
% $Author: fager $
% $Date: 2003-07-18 15:51:11 +0200 (Fri, 18 Jul 2003) $
% $Revision: 93 $ 
% $Log$
% Revision 1.2  2003/07/18 13:51:09  fager
% Matlab-standardized help and CVS-logging added.
%
ft = interp1(abs(h21(a)),freq(a),1,'spline','extrap');