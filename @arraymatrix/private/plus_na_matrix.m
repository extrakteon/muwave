function mtrx = plus_na_matrix(a,b)
% a - matrix (3D) [NXxNYx1]
% b - matrix (3D)
NX = size(b,1);
NY = size(b,2);
M = size(b,3);
a = reshape(a,[NX*NY 1]); % flatten matrix
mtrx = reshape(b,[NX*NY M]); % flatten matrix
for k = 1:(NX*NY)
    mtrx(k,:) = a(k) + mtrx(k,:);    
end
mtrx = reshape(mtrx,[NX NY M]);
