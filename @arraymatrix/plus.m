function c = plus(a,b)
% ARRAYMATRIX/PLUS Overload operator+

THIS = 'arraymatrix:plus';

if isa(a,'double') 
    mtrx = amplus(a,b.mtrx);
elseif isa(b,'double')   
    mtrx = amplus(a.mtrx,b);
 else
    mtrx = amplus(a.mtrx,b.mtrx);
end
c = arraymatrix(mtrx);