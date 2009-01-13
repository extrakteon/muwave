function gt = gt(a)
%GT The transducer gain for two-port devices.
%
%   See also: GA, GP, GMSG, GTUMAX

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.5  2005/04/27 21:37:11  fager
% * Changed from measSP to meassp.
%
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