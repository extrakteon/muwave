function VS = var(XP)
% VAR   Retrieve variance information from XPARAM object with covariance
% information available.
%
%   VS = VAR(XP) returns an N-by-M matrix whose rows corresponds to the
%   differrent frequencies. For each row, the columns are the variances
%   given as: [VAR(Re(S11)) VAR(IM(S11)) VAR(Re(S21)) ... VAR(Im(S22))]
%
%   See also: COV

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author$
% $Date$
% $Revision$
% $Log$
% Revision 1.1  2005/05/12 07:40:17  fager
% Initial version.
%

wid = 2*size(XP.data,2)*size(XP.data,1);
VS = zeros(size(XP.data,3),wid);
for k = 1:wid
    VS(:,k) = XP.datacov(k,k);
end