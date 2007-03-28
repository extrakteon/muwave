%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%

% Overload operator-
function c = minus(a,b)

if isa(a,'double') 
    % left addition with ...
    if (ndims(a) == 2) & (samesize(b,a) | scalar(a))
        % scalar or matrix
        c = arraymatrix(b);
        mtrx = b.mtrx;
        M = b.m;
        for i = 1:M
            mtrx(:,:,i) = a - mtrx(:,:,i);    
        end
        c.mtrx = mtrx;
    elseif ndims(a) == 3 & samesize(b,a) & (size(a,3) == b.m)
        % square 3D-matrix
        c = arraymatrix(b);
        mtrx = b.mtrx;
        M = b.m;
        for i = 1:M
            mtrx(:,:,i) = a(:,:,i) - mtrx(:,:,i);    
        end
        c.mtrx = mtrx;
    else
        error('ARRAYMATRIX.MTIMES: First argument of wrong type.');
    end
elseif isa(b,'double')   
    % right addition with ...
    if (ndims(b) == 2) & (samesize(a,b) | scalar(b))
        % scalar or matrix
        c = arraymatrix(a);
        mtrx = a.mtrx;
        M = a.m;
        for i = 1:M
            mtrx(:,:,i) = mtrx(:,:,i) - b;    
        end
        c.mtrx = mtrx;
    elseif ndims(b) == 3 & samesize(a,b) & (size(b,3) == a.m)
        % square 3D-matrix
        c = arraymatrix(a);
        mtrx = a.mtrx;
        M = a.m;
        for i = 1:M
            mtrx(:,:,i) = mtrx(:,:,i) - b(:,:,i);    
        end
        c.mtrx = mtrx;
    else
        error('ARRAYMATRIX.MTIMES: Second argument of wrong type.');
    end
elseif strcmp(class(a),class(b))
    % both arguments are ArrayMatrix-objects
    if b.m == a.m & a.nx == b.nx & a.ny == b.ny
        c = arraymatrix(a);
        mtrx = a.mtrx;
        mtrx_b = b.mtrx;
        mtrx = mtrx - mtrx_b;
        c.mtrx = mtrx;
    else
        error('ARRAYMATRIX.MTIMES: ArrayMatrices must be of same size');
    end
else
    error('ARRAYMATRIX.MTIMES: Unknwon error!');
end

% internal functions
function x = samesize(a,b)
    x = (size(b,1) == a.nx) & (size(b,2) == a.ny);
    
function x = scalar(a)
    x = (size(a,1) == 1) & (size(a,2) == 1);