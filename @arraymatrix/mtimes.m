function c = mtimes(a,b)
%MTIMES Overload operator *.

% $Header$
% $Author: kristoffer $
% $Date: 2003-11-17 08:49:10 +0100 (Mon, 17 Nov 2003) $
% $Revision: 169 $ 
% $Log$
% Revision 1.8  2003/11/17 07:47:02  kristoffer
% *** empty log message ***
%
% Revision 1.7  2003/08/25 14:42:36  fager
% Matrix multiplication now works both with rectangular matrices and scalars.
%
% Revision 1.6  2003/08/25 09:25:45  fager
% Multiplication with scalar implemented and verified.
%
% Revision 1.5  2003/08/25 09:12:52  fager
% no message
%
% Revision 1.4  2003/08/25 09:08:11  fager
% Removed necessity of the input arguments to be of same size (multiplication f rectangular matrices).
%


if isa(a,'double') 
    % left multiplication with ...
    if ndims(a) == 2 
        M = b.m;
        % scalar or matrix?
        if (size(a,1) == 1) &  (size(a,2) == 1)
            % scalar
            mtrx = zeros(b.nx,b.ny,M);
        elseif size(a,2) == b.nx
            % matrix
            mtrx = zeros(size(a,1),b.ny,M);
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
            mtrx = zeros(a.nx,a.ny,M);
        elseif size(b,1) == a.ny
            % matrix
            mtrx = zeros(a.nx,size(b,2),M);
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
    if b.m == a.m
        mtrx_a = a.mtrx;
        mtrx_b = b.mtrx;
        siz_a = size(mtrx_a);
        siz_b = size(mtrx_b);
        if siz_a(1:2)==[1 1] 
            mtrx = zeros(b.nx,b.ny,b.m);
        elseif siz_b(1:2)==[1 1] 
            mtrx = zeros(a.nx,a.ny,a.m);
        else
            mtrx = zeros(a.nx,b.ny,a.m);
        end
        if (a.nx == 2 & a.ny == 2) & (b.nx == 2 & b.ny == 2)
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
        error('ARRAYMATRIX.MTIMES: ArrayMatrices must be of same length.');
    end
else
    error('ARRAYMATRIX.MTIMES: Unknwon error!');
end

