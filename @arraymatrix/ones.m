function c = ones(a,n,m,elements)
% ONES(arraymatrix,n,m,elements)    Construct arraymatrix object filled with ones and with size = [n,m,elements].

c = arraymatrix(ones(n,m,elements));
