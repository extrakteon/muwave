function c = zeros(a,n,m,elements)
%ZEROS(arraymatrix,n,m,elements)    Construct arraymatrix object filled with zeros and with size = [n,m,elements].

% $Header$
% $Author: fager $
% $Date: 2004-10-26 16:30:54 +0200 (Tue, 26 Oct 2004) $
% $Revision: 227 $ 
% $Log$
% Revision 1.1  2004/10/26 14:30:54  fager
% Initial version
%
% Revision 1.4  2003/11/17 07:47:02  kristoffer
% *** empty log message ***

c = arraymatrix(zeros(n,m,elements));
