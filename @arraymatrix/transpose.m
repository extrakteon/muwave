function c = transpose(a)
% TRANSPOSE Overladed transpose .*

M = a.m;
mtrx = zeros(a.ny,a.nx,a.m);
mtrx_a = a.mtrx;
for i = 1:M
    mtrx(:,:,i) = mtrx_a(:,:,i).';
end
c = arraymatrix(mtrx);