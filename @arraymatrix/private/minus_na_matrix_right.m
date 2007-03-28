function mtrx = minus_na_matrix_right(a,b)
% a - matrix (3D) 
% b - matrix (3D) [NXxNYx1]
NX = size(a,1);
NY = size(a,2);
M = size(a,3);
mtrx = reshape(a,[NX*NY M]); % flatten matrix
b = reshape(b,[NX*NY 1]); % flatten matrix
for k = 1:(NX*NY)
    mtrx(k,:) = mtrx(k,:) - b(k);    
end
mtrx = reshape(mtrx,[NX NY M]);
