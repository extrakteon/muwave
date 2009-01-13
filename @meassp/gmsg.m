function gmsg = gmsg(a)
%GMSG The maximum stable gain for two-port devices.
%
%   See also: GT, GA, GP, GTUMAX

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.5  2005/04/27 21:37:11  fager
% * Changed from measSP to meassp.
%
% Revision 1.4  2004/10/20 22:19:32  fager
% Help comments added
%
% Revision 1.2  2003/07/18 13:51:10  fager
% Matlab-standardized help and CVS-logging added.
%

switch nargin
case 1
    if get(a.data,'ports') == 2
        s21 = abs(a.data.S21);
        s12 = abs(a.data.S12);
        gmsg = abs(s21)./abs(s12);
    else
        error('MEASSP.GMSG: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.GMSG: Wrong number of arguments.');
end