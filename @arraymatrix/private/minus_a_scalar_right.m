function mtrx = minus_a_scalar_left(a,b)
% a - matrix (3D) 
% b - matrix (3D) [1x1xM]
NX = size(a,1);
NY = size(a,2);
M = size(a,3);
b = reshape(b,[1 M]); % make sure it is a row matrix
mtrx = reshape(a,[NX*NY M]); % flatten matrix
for k = 1:(NX*NY)
    mtrx(k,:) = mtrx(k,:) - b;    
end
mtrx = reshape(mtrx,[NX NY M]);
