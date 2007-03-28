%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%
% Method inv
function b=inv(a)


b=a;
mtrx=a.mtrx;
if a.nx ~= a.ny
    error('ARRAYMATRIX.INV: Matrices must be square.');
else
    N = a.nx;
    M = a.m;
    if N == 2
        % if dim=2 calculate inverse explicitly using vectors
        K = [M 1];
        a11 = reshape(mtrx(1,1,:),K);
        a12 = reshape(mtrx(1,2,:),K);
        a21 = reshape(mtrx(2,1,:),K);
        a22 = reshape(mtrx(2,2,:),K);
        delta = a11.*a22 - a12.*a21;
        mtrx(1,1,:) = a22./delta;
        mtrx(1,2,:) = -a12./delta;
        mtrx(2,1,:) = -a21./delta;
        mtrx(2,2,:) = a11./delta;
    else
        % otherwise use a for-loop
        E = eye(N);
        for i=1:M
            mtrx(:,:,i) = E/mtrx(:,:,i);
        end
    end
    b.mtrx=mtrx;
end