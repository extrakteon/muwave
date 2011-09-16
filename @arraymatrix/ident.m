function c = ident(a)
% IDENT returns the identity matrix of size a

if a.nx ~= a.ny
    error('ARRAYMATRIX.IDENT: Matrix must be square.');
else
    c = arraymatrix(repmat(eye(a.nx),[1 1 a.m]));
end
