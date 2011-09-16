function c = otimes(a,b)
%OTIMES Kronecker product

if isa(a,'double') 
    c = iotimes_pre(a,b);
elseif isa(b,'double')
    c = iotimes_post(a,b);
elseif strcmp(class(a),class(b))
    c = iotimes(a,b);
else
    error('ARRAYMATRIX/OTIMES: One input argument must be a vector.'); 
end

function c=iotimes(a,b)
% input: a is a arraymatrix
%        b is a arraymatrix
% output: c=kron(a,b)

SIZA = size(a);
SIZB = size(b);

% check that arguments have equal length
LEN = SIZA(3);
if LEN == SIZB(3)
    mtrx = zeros([SIZA(1)*SIZB(1) SIZA(2)*SIZB(2) LEN]);
    
    rxa = ones(SIZB(1),1)*(1:SIZA(1));
    cxa = ones(SIZB(2),1)*(1:SIZA(2));
    rxb = (1:SIZB(1))'*ones(1,SIZA(1));
    cxb = (1:SIZB(2))'*ones(1,SIZA(2));
   
    for k=1:LEN
        mtrx(:,:,k) = a.mtrx(rxa,cxa,k).* b.mtrx(rxb,cxb,k);
    end
    c = arraymatrix(mtrx);
else
    error('ARRAYMATRIX/OTIMES: Length of the two arrays must be equal.'); 
end

function c=iotimes_pre(a,b)
% input: a is a matrix
%        b is a arraymatrix
% output: c=a.*b

SIZA = size(a);
SIZB = size(b);
LEN = SIZB(3);

mtrx = zeros([SIZA(1)*SIZB(1) SIZA(2)*SIZB(2) LEN]);
    
rxa = ones(SIZB(1),1)*(1:SIZA(1));
cxa = ones(SIZB(2),1)*(1:SIZA(2));
rxb = (1:SIZB(1))'*ones(1,SIZA(1));
cxb = (1:SIZB(2))'*ones(1,SIZA(2));

if length(SIZA)==3
    % a is a 3d-matrix with same "length" as b
    if SIZA(3)==LEN
        for k=1:LEN
            mtrx(:,:,k) = a(rxa,cxa,k).* b.mtrx(rxb,cxb,k);
        end
    else
       error('ARRAYMATRIX/OTIMES: Length of the two arrays must be equal.');
    end
else
    for k=1:LEN
        mtrx(:,:,k) = a(rxa,cxa).* b.mtrx(rxb,cxb,k);
    end
end
c = arraymatrix(mtrx);


function c=iotimes_post(a,b)
% input: a is a arraymatrix
%        b is a matrix
% output: c=b.*a

SIZA = size(a);
SIZB = size(b);
LEN = SIZA(3);

mtrx = zeros([SIZA(1)*SIZB(1) SIZA(2)*SIZB(2) LEN]);
    
rxa = ones(SIZB(1),1)*(1:SIZA(1));
cxa = ones(SIZB(2),1)*(1:SIZA(2));
rxb = (1:SIZB(1))'*ones(1,SIZA(1));
cxb = (1:SIZB(2))'*ones(1,SIZA(2));

if length(SIZB)==3
    % b is a 3d-matrix with same "length" as b
    if SIZB(3)==LEN
        for k=1:LEN
            mtrx(:,:,k) = a.mtrx(rxa,cxa,k).* b(rxb,cxb);
        end
    else
       error('ARRAYMATRIX/OTIMES: Length of the two arrays must be equal.');
    end
else
    for k=1:LEN
        mtrx(:,:,k) = a.mtrx(rxa,cxa,k).* b(rxb,cxb);
    end
end
c = arraymatrix(mtrx);
