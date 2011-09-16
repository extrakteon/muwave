function m = size(a,dim)
% SIZE returns the size of ArrayMatrix

x = [a.nx a.ny a.m];
if nargin==2
    if dim < 1
        error('ARRAYMATRIX.SIZE: Dimension number must be a non-negative integer in the range 1 to 2^31.');
    elseif dim > 3
        m = 1;
    else
        m = x(dim);
    end
else
    m = x;
end