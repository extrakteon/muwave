%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%

function am = arraymatrix(a,b)
%
% Constructor
%
if nargin==0
   % Default: Return an empty matrix with dimension 2
   p.n = 2; % matrix dimension, always square 
   p.m = 0; % number of elements
   p.mtrx = [];
   am = class(p, 'arraymatrix');
elseif isa(a,'arraymatrix')
   % If constructor is applied to a arraymatrix-object return the object unchanged
   am = a;
elseif nargin==1 & ((isa(a,'double') & (size(a,1) == size(a,2)))) 
   % arraymatrix(mtrx)
   p.n = size(a,1);
   p.m = size(a,3);
   p.mtrx = a;
   am = class(p, 'arraymatrix'); 
elseif nargin==2 
    if isa(a,'double') & isa(b,'double')
       % arraymatrix(A, n)
       if (size(a,1) == size(a,2)) & (size(a,1) > 1) & (b > 0)
       % where A is a square matrix to be repeated m-times
           p.n = size(a,1);
           p.m = b;
           p.mtrx = repmat(a,[1 1 b]);
           am = class(p,'arraymatrix');
       elseif (size(a,1) == size(a,2)) & (size(a,3) == 1) & (b > 0)
           % allocate a matrix of zeros of size:
           % a=ports, b=elements
           p.n = a;
           p.m = b;
           p.mtrx = repmat(zeros(a),[1 1 b]);
           am = class(p,'arraymatrix');
       end
   end
else
   error('ARRAYMATRIX.ARRAYMATRIX: Invalid input argument(s).')   
end
