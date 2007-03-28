%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%

% Overload operator*
function c = mtimes(a,b)

if isa(a,'double') 
    % left multiplication with ...
    if ndims(a) == 2 
        M = b.m;
        % scalar or matrix?
        if (size(a,1) == 1) &  (size(a,2) == 1)
            % scalar
            mtrx = zeros(b.nx,b.ny,M);
        elseif size(a,1) == b.ny & size(a,2) == b.nx
            mtrx = zeros(b.ny,b.ny,M);
        else
            error('ARRAYMATRIX.MTIMES: Inner matrix dimensions must agree.');
        end
        mtrx_b = b.mtrx;
        for i = 1:M
            mtrx(:,:,i) = a * mtrx_b(:,:,i);    
        end
         c = arraymatrix(mtrx);
    elseif ndims(a) == 3 & (size(a,1) == b.ny) & (size(a,2) == b.nx) & (size(a,3) == b.m)
        % 3D-matrix
        mtrx_b = b.mtrx;
        M = b.m;
        mtrx = zeros(b.ny,b.nx,M);
        for i = 1:M
            mtrx(:,:,i) = a(:,:,i) * mtrx_b(:,:,i);    
        end
         c = arraymatrix(mtrx);
    else
        error('ARRAYMATRIX.MTIMES: First argument of wrong type or dimension.');
    end
elseif isa(b,'double')   
    % right multiplication with ...
    if ndims(b) == 2 
        M = a.m;
        % scalar or matrix?
        if (size(b,1) == 1) &  (size(b,2) == 1)
            % scalar
            mtrx = zeros(a.ny,a.ny,M);
        elseif size(b,1) == a.ny & size(b,2) == a.nx
            mtrx = zeros(a.nx,a.nx,M);
        else
            error('ARRAYMATRIX.MTIMES: Inner matrix dimensions must agree.');
        end
        mtrx_a = a.mtrx;
        for i = 1:M
            mtrx(:,:,i) = mtrx_a(:,:,i) * b;    
        end
        c = arraymatrix(mtrx);
    elseif ndims(b) == 3 & (size(b,1) == a.ny) & (size(b,2) == a.nx) & (size(b,3) == a.m)
        % square 3D-matrix
        mtrx_a = a.mtrx;
        M = a.m;
        mtrx = zeros(a.nx,a.ny,M);
        for i = 1:M
            mtrx(:,:,i) = mtrx_a(:,:,i) * b(:,:,i);    
        end
         c = arraymatrix(mtrx);
    else
        error('ARRAYMATRIX.MTIMES: Second argument of wrong type.');
    end
elseif strcmp(class(a),class(b))
    % both arguments are ArrayMatrix-objects
    if b.m == a.m & (a.nx == b.ny) & (a.ny == b.nx)
        mtrx_a = a.mtrx;
        mtrx_b = b.mtrx;
        mtrx = zeros(a.nx,b.ny,a.m);
        if a.nx == 2
            % special version for 2x2 matrices    
            a = mtrx_a(1,1,:); b = mtrx_a(1,2,:);
            c = mtrx_a(2,1,:); d = mtrx_a(2,2,:);
            A = mtrx_b(1,1,:); B = mtrx_b(1,2,:);
            C = mtrx_b(2,1,:); D = mtrx_b(2,2,:);
            mtrx(1,1,:) = a.*A + b.*C;
            mtrx(1,2,:) = a.*B + b.*D;
            mtrx(2,1,:) = c.*A + d.*C;
            mtrx(2,2,:) = c.*B + d.*D;
        else
            M = a.m;
            for i = 1:M
                mtrx(:,:,i) = mtrx_a(:,:,i) * mtrx_b(:,:,i);
            end
        end
        c = arraymatrix(mtrx);
    else
        error('ARRAYMATRIX.MTIMES: ArrayMatrices must be of same size');
    end
else
    error('ARRAYMATRIX.MTIMES: Unknwon error!');
end

