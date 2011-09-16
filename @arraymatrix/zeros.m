function c = zeros(a,n,m,elements)
% ZEROS(arraymatrix,n,m,elements)    Construct arraymatrix object filled with zeros and with size = [n,m,elements].

c = arraymatrix(zeros(n,m,elements));
