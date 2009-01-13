function c = mrdivide(a,b)
%MRDIVIDE Overload operator /

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.3  2003/08/25 14:41:58  fager
% Matrix division implemented.
%

% author: Kristoffer Andersson
%
% Overload operator/



if isa(a,'double') 
    % left 'right division' with ...
    if (ndims(a) == 2) & (size(a,1) == size(a,2))
        % scalar or matrix
        c = arraymatrix(b);
        mtrx = b.mtrx;
        M = b.m;
        for i = 1:M
            mtrx(:,:,i) = a / mtrx(:,:,i);    
        end
        c.mtrx = mtrx;
    elseif ndims(a) == 3 & (size(a,1) == size(a,2)) & (size(a,3) == b.m)
        % square 3D-matrix
        c = arraymatrix(b);
        mtrx = b.mtrx;
        M = b.m;
        for i = 1:M
            mtrx(:,:,i) = a(:,:,i) / mtrx(:,:,i);    
        end
        c.mtrx = mtrx;
    else
        error('ARRAYMATRIX.MTIMES: First argument of wrong type.');
    end
elseif isa(b,'double')   
    % right 'right division' with ...
    if (ndims(b) == 2) & (size(b,1) == size(b,2))
        % scalar or matrix
        c = arraymatrix(a);
        mtrx = a.mtrx;
        M = a.m;
        for i = 1:M
            mtrx(:,:,i) = mtrx(:,:,i)/b;    
        end
        c.mtrx = mtrx;
    elseif ndims(b) == 3 & (size(b,1) == size(b,2)) & (size(b,3) == a.m)
        % square 3D-matrix
        c = arraymatrix(a);
        mtrx = a.mtrx;
        M = a.m;
        for i = 1:M
            mtrx(:,:,i) = mtrx(:,:,i) / b(:,:,i);    
        end
        c.mtrx = mtrx;
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
            M = a.m;
            for i = 1:M
                mtrx(:,:,i) = mtrx_a(:,:,i) / mtrx_b(:,:,i);
            end
        c = arraymatrix(mtrx);
    else
        error('ARRAYMATRIX.MTIMES: ArrayMatrices must be of same length.');
    end
else
    error('ARRAYMATRIX.MTIMES: Unknwon error!');
end

