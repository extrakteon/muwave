function c = mtimes_na_dot_right(a,b)
a = squeeze(a);
b = squeeze(b);
for k = 1:length(b)
    c(k,:) = a(k,:)*b(k);
end
c = sum(c,1);
    