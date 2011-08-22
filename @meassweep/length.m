function len=length(cIN)
%LENGTH Return the number of measurements in a sweep object.
%   L = LENGTH(MSWP) returns the number of measurements in MSWP.
%
%   See also: GET

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: e7koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
% $Log$
% Revision 1.4  2004/10/20 16:59:20  fager
% Help comments added
%
% Revision 1.3  2003/07/22 14:58:51  kristoffer
% no message
%


len = length(cIN.data);