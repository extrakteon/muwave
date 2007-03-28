function c = mtimes_dot(a,b)
N = size(b,1);
M = size(b,3);
a = reshape(a,[N M]);
b = reshape(b,[N M]);
c = sum(a.*b,1);