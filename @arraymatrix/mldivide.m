function c = mldivide(a,b)
% MLDIVIDE Overload operator \

if isa(a,'double') 
    mtrx = ammul(aminv(a), b.mtrx);
elseif isa(b,'double')   
    mtrx = ammul(aminv(a.mtrx), b);
elseif strcmp(class(a),class(b))
    mtrx = ammul(aminv(a.mtrx), b.mtrx);
else
    error('ARRAYMATRIX.MTIMES: Unknwon error!');
end
c = arraymatrix(mtrx);

% if isa(a,'double') 
%     % left 'left division' with ...
%     if (ndims(a) == 2) & (size(a,1) == size(a,2))
%         % scalar or matrix
%         c = arraymatrix(b);
%         mtrx = b.mtrx;
%         M = b.m;
%         for i = 1:M
%             mtrx(:,:,i) = a \ mtrx(:,:,i);    
%         end
%         c.mtrx = mtrx;
%     elseif ndims(a) == 3 & (size(a,1) == size(a,2)) & (size(a,3) == b.m)
%         % square 3D-matrix
%         c = arraymatrix(b);
%         mtrx = b.mtrx;
%         M = b.m;
%         for i = 1:M
%             mtrx(:,:,i) = a(:,:,i) \ mtrx(:,:,i);    
%         end
%         c.mtrx = mtrx;
%     else
%         error('ARRAYMATRIX.MTIMES: First argument of wrong type.');
%     end
% elseif isa(b,'double')   
%     c = ildivide(a,b);
% elseif strcmp(class(a),class(b))
%     % both arguments are ArrayMatrix-objects
%     if b.m == a.m
%         mtrx_a = a.mtrx;
%         mtrx_b = b.mtrx;
%         siz_a = size(mtrx_a);
%         siz_b = size(mtrx_b);
%         if siz_a(1:2)==[1 1] 
%             mtrx = zeros(b.nx,b.ny,b.m);
%         elseif siz_b(1:2)==[1 1] 
%             mtrx = zeros(a.nx,a.ny,a.m);
%         else
%             mtrx = zeros(a.nx,b.ny,a.m);
%         end
%         M = a.m;
%         for i = 1:M
%             mtrx(:,:,i) = mtrx_a(:,:,i) \ mtrx_b(:,:,i);
%         end
%         c = arraymatrix(mtrx);
%     else
%         error('ARRAYMATRIX.MTIMES: ArrayMatrices must be of same length.');
%     end
% else
%     error('ARRAYMATRIX.MTIMES: Unknwon error!');
% end
