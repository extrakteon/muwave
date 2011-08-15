function h21 = h21(a)
%H21 The short-circuit gain of a two-port device.
%
%   See also: FT

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2005-04-27 23:44:52 +0200 (Wed, 27 Apr 2005) $
% $Revision: 261 $ 
% $Log$
% Revision 1.6  2005/04/27 21:37:12  fager
% * Changed from measSP to meassp.
%
% Revision 1.5  2004/10/20 22:23:03  fager
% Help comments added
%

switch nargin
case 1
    if get(a.data,'ports') == 2
        h21 = -2*a.data.S21./((1 - a.data.S11).*(1 + a.data.S22) + a.data.S12.*a.data.S21);
    else
        error('MEASSP.H21: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.H21: Wrong number of arguments.');
end