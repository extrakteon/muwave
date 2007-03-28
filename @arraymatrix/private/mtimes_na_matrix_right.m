function mtrx = mtimes_na_matrix_right(a,b)
% a - matrix (3D)
% b - matrix (2D)
SMALL_MATRIX = 30;

M = size(a,3);
N = size(a,2);
NX = size(a,1);
NY = size(b,2);

if NX*N*NY < SMALL_MATRIX
    for row = 1:NX
        for col = 1:NY
            mtrx(row,col,:) = mtimes_na_dot_right(a(row,:,:),b(:,col));     
        end
    end    
else
    for k = 1:M
        mtrx(:,:,k) = a(:,:,k)*b;
    end
end