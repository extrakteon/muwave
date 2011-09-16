function c = get(a,param)
% GET get basic properties for arraymatrix

if isa(param,'char')
    switch param
        case 'nx'
            c = a.nx;
        case 'ny'
            c = a.ny;    
        case 'm'
            c = a.m;
        case 'mtrx'
            c = a.mtrx;
        otherwise
            error('ARRAYMATRIX.GET: Unknown property.');
    end
else
    error('ARRAYMATRIX.GET: Unknown property.');
end
