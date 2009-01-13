function c = times(a,b)
%TIMES Overload operator .*

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.5  2004/11/24 13:56:45  fager
% Added possibility of multipying 1x1xN - vector with n x m x N arraymatrix.
% The multiplication is done element-wise
%
% Revision 1.4  2004/09/27 15:23:52  SYSTEM
% Major overhaul of valid operations.
%
%

if isa(a,'double') 
    c = itimes_pre(a,b);
elseif isa(b,'double')
    c = itimes_post(a,b);
elseif strcmp(class(a),class(b))
    c = itimes(a,b);
else
    error('ARRAYMATRIX/TIMES: One input argument must be a vector.'); 
end

function c=itimes(a,b)
% input: a is a arraymatrix
%        b is a arraymatrix
% output: c=a.*b

SIZA = size(a);
SIZB = size(b);

% check that arguments have equal length
LEN = SIZA(3);
if LEN == SIZB(3)
    % now check that we can perform an element multiplication
    if (SIZA(1) == SIZB(1)) & (SIZA(2) == SIZB(2))
        % element multiply
        mtrxA = a.mtrx;
        mtrx = b.mtrx;
        for k=1:LEN
            mtrx(:,:,k) = mtrxA(:,:,k).*mtrx(:,:,k);
        end
    elseif (SIZA(1) == 1) & (SIZA(2) == 1)
        % a is a scalar
        scalar = a.mtrx;
        mtrx = b.mtrx;
        for k=1:LEN
            mtrx(:,:,k) = scalar(1,1,k).*mtrx(:,:,k);
        end
    elseif (SIZB(1) == 1) & (SIZB(2) == 1)
        % b is a scalar
        mtrx = a.mtrx;
        scalar = b.mtrx;
        for k=1:LEN
            mtrx(:,:,k) = mtrx(:,:,k).*scalar(1,1,k);
        end
    else
        error('ARRAYMATRIX/TIMES: Inner matrix dimensions must agree.');
    end
    c = arraymatrix(mtrx);
else
    error('ARRAYMATRIX/TIMES: Length of the two arrays must be equal.'); 
end

function c=itimes_pre(a,b)
% input: a is a matrix
%        b is a arraymatrix
% output: c=a.*b

SIZA = size(a);
if length(SIZA)<3
    % a is a 2d-matrix
    LEN = [];
else
    % a is a 3d-matrix
    LEN = SIZA(3);
end
LENB = b.m;

if isempty(LEN)
    mtrxB = b.mtrx;
    if size(a,1)==LENB & size(a,2)==1
    mtrx = zeros([size(mtrxB(:,:,1)) LENB]);
        % a is a vector of length = #freqpoints
        % Multiply each of the elements in b with the 
        % corresponding scalar element in a
        for k = 1:LENB
            mtrx(:,:,k) = a(k).*mtrxB(:,:,k);   
        end
    else
    mtrx = zeros([size(a.*mtrxB(:,:,1)) LENB]);
        for k = 1:LENB
            mtrx(:,:,k) = a.*mtrxB(:,:,k);   
        end
    end
elseif LEN == 1
    mtrxB = b.mtrx;
    mtrx = zeros([size(a(:,:,1).*mtrxB(:,:,1)) LENB]);
    for k = 1:LENB
        mtrx(:,:,k) = a(:,:,1).*mtrxB(:,:,k);    
    end
elseif LEN == LENB
    mtrxB = b.mtrx;
    mtrx = zeros([size(a(:,:,1).*mtrxB(:,:,1)) LENB]);
    for k = 1:LENB
        mtrx(:,:,k) = a(:,:,k).*mtrxB(:,:,k);    
    end
else
    error('ARRAYMATRIX/TIMES: Length of the two arrays must be equal.'); 
end
c = arraymatrix(mtrx);

function c=itimes_post(a,b)
% input: a is a arraymatrix
%        b is a matrix
% output: c=b.*a

SIZA = size(b);
if length(SIZA)<3
    % b is a 2d-matrix
    LEN = [];
else
    % b is a 3d-matrix
    LEN = SIZA(3);
end
LENA = a.m;

if isempty(LEN)
    mtrxA = a.mtrx;
    mtrx = zeros([size(mtrxA(:,:,1)) LENA]);
    if size(b,1)==LENA & size(b,2)==1
        % b is a vector of length = #freqpoints
        % Multiply each of the elements in a with the 
        % corresponding scalar element in b
        for k = 1:LENA
            mtrx(:,:,k) = mtrxA(:,:,k).*b(k);   
        end
    else
    mtrx = zeros([size(mtrxA(:,:,1).*b) LENA]);
        for k = 1:LENA
            mtrx(:,:,k) = mtrxA(:,:,k).*b;   
        end
    end
elseif LEN == 1
    mtrxA = a.mtrx;
    mtrx = zeros([size(mtrxA(:,:,1).*b(:,:,1)) LENA]);
    for k = 1:LENA
        mtrx(:,:,k) = mtrxA(:,:,k).*b(:,:,1);    
    end
elseif LEN == LENA
    mtrxA = a.mtrx;
    mtrx = zeros([size(mtrxA(:,:,1).*b(:,:,1)) LENA]);
    for k = 1:LENA
        mtrx(:,:,k) = mtrxA(:,:,k).*b(:,:,k);    
    end
else
    error('ARRAYMATRIX/TIMES: Length of the two arrays must be equal.'); 
end
c = arraymatrix(mtrx);
