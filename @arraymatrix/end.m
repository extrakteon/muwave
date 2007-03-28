function m = end(a,k,n);
% END  overloads the end-operator for class ARRAYMATRIX
%

% $Header$
% $Author: koffer $
% $Date: 2005-05-04 11:51:11 +0200 (Wed, 04 May 2005) $
% $Revision: 272 $ 
% $Log$
% Revision 1.1  2005/05/04 09:50:01  koffer
% First introduction of end-operator
%
%

% single index e.g. a(end)
if n == 1
    m = length(a);
% two or more indexes e.g. a(1,end,2)
else
    m = size(a,k);
end
