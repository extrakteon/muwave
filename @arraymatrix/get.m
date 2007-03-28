%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%


%
function c = get(a,param)

if isa(param,'char')
    switch param
        case 'n'
            c = a.n;
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
