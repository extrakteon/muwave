function gt = gt(a)
%GT The transducer gain for two-port devices.
%
%   See also: GA, GP, GMSG, GTUMAX

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
        gt = s21.*s21;
    else
        error('MEASSP.GT: Argument must be a 2-port.');
    end
otherwise
    error('MEASSP.GT: Wrong number of arguments.');
end