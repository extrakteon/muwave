function m = size(a,dim)
% SIZE  Returns the size of an xparam object
%   S = SIZE(XP) returns a vector with the size of the data object:
%   [NX,NY,NELEMENTS]
%
%   See also: length, @arraymatrix/size

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author$
% $Date$
% $Revision$
% $Log$
% Revision 1.1  2005/04/27 21:50:34  fager
% * Initial version
% * Frequencies -> xparam
%

if nargin == 1,
    dim = [];
    m = size(get(a,'data'));
else
    m = size(get(a,'data'),dim);
end
