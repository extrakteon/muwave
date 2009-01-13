function c = zeros(a,n,m,elements)
%ZEROS(arraymatrix,n,m,elements)    Construct arraymatrix object filled with zeros and with size = [n,m,elements].

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.1  2004/10/26 14:30:54  fager
% Initial version
%
% Revision 1.4  2003/11/17 07:47:02  kristoffer
% *** empty log message ***

c = arraymatrix(zeros(n,m,elements));
