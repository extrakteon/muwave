function c=ildivide(a,b); 
%ILDIVIDE Part of mldivide

% $Header$
% $Author: ferndahl $
% $Date: 2005-03-22 12:31:07 +0100 (Tue, 22 Mar 2005) $
% $Revision: 246 $ 
% $Log$
% Revision 1.3  2005/03/22 11:31:07  ferndahl
% no message
%
% Revision 1.2  2004/09/17 14:24:36  ferndahl
% Changed \ to pinv due to numerical problems (NaN,Inf...)
%
% Revision 1.1  2003/11/17 07:47:03  kristoffer
% *** empty log message ***
%

% right 'left division' with ...
if (ndims(b) == 2)
    if size(b,1) == 1
        % scalar
        mtrx_out = zeros(a.nx,a.nx,a.m);
    elseif size(b,1) == a.nx
        % matrix
        mtrx_out = zeros(a.nx,size(b,2),a.m);
    else
        error('ARRAYMATRIX.MTIMES: Second argument of wrong size.');
    end
    mtrx = a.mtrx;
    M = a.m;
    
    for i = 1:M
%        mtrx_out(:,:,i) = mtrx(:,:,i) \ b;
%        if sum(isinf(mtrx_out(:,:,i))) > 1
           mtrx_out(:,:,i) = pinv(mtrx(:,:,i)) * b; % Changed by Fager, Ferndahl 040916
%        end   
    end
    c = arraymatrix(mtrx_out);
elseif ndims(b) == 3 & (size(b,1) == size(b,2)) & (size(b,3) == a.m)
    % square 3D-matrix
    mtrx = a.mtrx;
    M = a.m;
    for i = 1:M
        mtrx(:,:,i) = mtrx(:,:,i) \ b(:,:,i);    
    end
    c = arraymatrix(mtrx);
else
    error('ARRAYMATRIX.MTIMES: Second argument of wrong type.');
end