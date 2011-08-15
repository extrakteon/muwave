
function conn=conn(x)
% CONN return list of element connections in parameter order

% $Header$
% $Author: kristoffer $
% $Date: 2003-11-12 23:36:38 +0100 (Wed, 12 Nov 2003) $
% $Revision: 166 $ 
% $Log$
% Revision 1.1  2003/11/12 22:36:37  kristoffer
% Basic support for adjoint sensitivity calculations
%

conn=x.param_conn;