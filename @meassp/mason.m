function mason = mason(a)
% Mason's gain, U. Activity of device. If U = 0 no gain -> fmax. 
%
%   See also: h21
%

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
% $Log$
% Revision 1.3  2005/04/27 21:37:12  fager
% * Changed from measSP to meassp.
%
% Revision 1.2  2004/10/29 11:07:44  ferndahl
% No changes
%
% Revision 1.1  2004/10/29 11:06:46  ferndahl
% no message

switch nargin
case 1
    if get(a.data,'ports') == 2
        mason = abs(a.data.Z21-a.data.Z12).^2./(4.*(real(a.data.Z11).*real(a.data.Z22) + real(a.data.Z12).*real(a.data.Z21)));
    else
        error('MEAZZP.MASON: Argument must be a 2-port.');
    end
otherwise
    error('MEAZZP.MASON: Wrong number of arguments.');
end