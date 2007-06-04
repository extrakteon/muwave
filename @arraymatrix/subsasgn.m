function a = subsasgn(a,S,b)
% Overloads method subsasgn, eg A(S) = B
%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%
% $Header$
% $Author: $
% $Date: $
% $Revision: $ 
% $Log$
%
switch S.type
case '()'
     KK = length(S.subs);
     if KK == 1
         % A(n) = B type of assignment, where B is a matrix
         b = arraymatrix(b);
         K =cell2mat(S.subs{:});
         if b.m ~= length(K)
             error('ARRAYMATRIX.SUBSASGN: Length of vectors must be equal.');
         elseif (b.nx ~= a.nx) & (b.ny ~= a.ny)
             error('ARRAYMATRIX.SUBSASGN: Matrix dimensions must be equal.');
         else    
            mtrx = a.mtrx;
            mtrx(:,:,K) = b.mtrx;
            a.mtrx = mtrx;
        end
     elseif KK == 2
         % A(nx,ny,m) = b type of assignment, where b is a vector
         x = S.subs{1};
         y = S.subs{2};
         %if (x > a.nx | y > a.ny)
         %    error('ARRAYMATRIX.SUBSASGN: Subscript larger than matrix dimension.');    
         if length(b) ~= a.m
             error('ARRAYMATRIX.SUBSASGN: Length of vectors must be equal.');
         else    
            mtrx = a.mtrx;
            if strcmp(class(b),'arraymatrix')
                mtrx(x,y,:) = b.mtrx;
            else
                mtrx(x,y,:) = b;
            end
            a.mtrx = mtrx;
        end
     end
otherwise    
    error('ARRAYMATRIX.SUBSASGN: Unsupported indexing.');
end

% internal functions
