function mtrx = minus_a_scalar_left(a,b)
% a - matrix (3D) [1x1xM]
% b - matrix (3D)
NX = size(b,1);
NY = size(b,2);
M = size(b,3);
a = reshape(a,[1 M]); % make sure it is a row matrix
mtrx = reshape(b,[NX*NY M]); % flatten matrix
for k = 1:(NX*NY)
    mtrx(k,:) = a - mtrx(k,:);    
end
mtrx = reshape(mtrx,[NX NY M]);
