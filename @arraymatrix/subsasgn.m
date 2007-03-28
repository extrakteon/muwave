%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%


% Overloads method subsasgn, eg A(S) = B
function a = subsasgn(a,S,b)

switch S.type
case '()'
     if length(S.subs) == 1
         % A(n) = B type of assignment, where B is a matrix
         b = arraymatrix(b);
         K = S.subs{:};
         if b.m ~= length(K)
             error('ARRAYMATRIX.SUBSASGN: Length of vectors must be equal.');
         elseif b.n ~= a.n
             error('ARRAYMATRIX.SUBSASGN: Matrix dimensions must be equal.');
         else    
            mtrx = a.mtrx;
            mtrx(:,:,K) = b.mtrx;
            a.mtrx = mtrx;
        end
     elseif length(S.subs) == 2
         % A(n,m) = B type of assignment, where B is a vector
         x = S.subs{1};
         y = S.subs{2};
         if (x > a.n | y > a.n)
             error('ARRAYMATRIX.SUBSASGN: Subscript larger than matrix dimension.');    
         elseif length(b) ~= a.m
             error('ARRAYMATRIX.SUBSASGN: Length of vectors must be equal.');
         else    
            mtrx = a.mtrx;
            mtrx(x,y,:) = b;
            a.mtrx = mtrx;
        end
     end
otherwise    
    error('ARRAYMATRIX.SUBSASGN: Unsupported indexing.');
end

% internal functions
