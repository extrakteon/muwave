function c = mtimes(a,b)
% MTIMES Overload operator * (matrix multiply)

if isa(a,'double') 
    mtrx = ammul(a,b.mtrx);
elseif isa(b,'double')   
    mtrx = ammul(a.mtrx,b);
 else
    mtrx = ammul(a.mtrx,b.mtrx);
end
c = arraymatrix(mtrx);
