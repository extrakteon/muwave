function c = mtimes_na_dot_left(a,b)
N = size(b,1);
M = size(b,3);
a = reshape(a,[N 1]);
b = reshape(b,[N M]);
for k = 1:length(a)
    c(k,:) = a(k)*b(k,:);
end
c = sum(c,1);
    