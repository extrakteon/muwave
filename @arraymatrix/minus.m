function c = minus(a,b)
% ARRAYMATRIX/MINUS Overload operator-

THIS = 'arraymatrix:minus';

if isa(a,'double') 
    mtrx = amminus(a,b.mtrx);
elseif isa(b,'double')   
    mtrx = amminus(a.mtrx,b);
 else
    mtrx = amminus(a.mtrx,b.mtrx);
end
c = arraymatrix(mtrx);