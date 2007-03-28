function c = plus(a,b)
% ARRAYMATRIX/MINUS Overload operator+
%
% $Header$
% $Author: koffer $
% $Date: 2004-10-27 20:24:36 +0200 (Wed, 27 Oct 2004) $
% $Revision: 230 $ 
% $Log$
% Revision 1.4  2004/10/27 18:24:36  koffer
% minus/plus and mtimes where so full of bugs that they have been rewwritten from srcatch. Local functions have been moved to /private
%
% Revision 1.3  2004/10/26 14:13:12  koffer
% Optimization. Now should run about 5 times faster.
%
%

THIS = 'arraymatrix:plus';


if isa(a,'double') 
    % left addition with ...
    anx = size(a,1);
    any = size(a,2);
    am = size(a,3);
    if (am == 1)
        if (anx == 1)&&(any == 1)
            % scalar argument
            mtrx = a + b.mtrx;
        elseif (anx == b.nx)&&(any == b.ny)
            % matrix argument
            mtrx = plus_na_matrix(a,b.mtrx);
        else
            error(THIS,'Matrix dimensions mudt match.');
        end
    elseif (am == b.m)
        if (anx == 1)&&(any == 1)
            % scalar array
            mtrx = plus_a_scalar(a,b.mtrx);
        elseif (anx == b.nx)&&(any == b.ny)
            % matrix array
            mtrx = a + b.mtrx;
        else
            error(THIS,'Matrix dimensions must match.');
        end
    else
        error(THIS,'Length of marguments must match.');
    end
elseif isa(b,'double')   
    % right addition with ...
    bnx = size(b,1);
    bny = size(b,2);
    bm = size(b,3);
    if (bm == 1)
        if (bnx == 1)&&(bny == 1)
            % scalar argument
            mtrx = a.mtrx + b;
        elseif (a.nx == bnx)&&(a.ny == bny)
            % matrix argument
            mtrx = plus_na_matrix(b,a.mtrx); % switched order of arguments
        else
            error(THIS,'Matrix dimensions must match.');
        end
    elseif (a.m == bm)
        if (bnx == 1)&&(bny == 1)
            % scalar array
            mtrx = plus_a_scalar(b,a.mtrx); % switched order of arguments
        elseif (a.nx == bnx)&&(a.ny == bny)
            % matrix array
            mtrx = a.mtrx + b;
        else
            error(THIS,'Matrix dimensions must match.');
        end
    else
        error(THIS,'Length of marguments must match.');
    end
elseif strcmp(class(a),class(b))
    if (a.m == b.m)
        if (a.nx == 1)&&(a.ny == 1)
            % a is a scalar
            mtrx = plus_a_scalar(a.mtrx,b.mtrx);
        elseif (b.nx == 1)&&(b.ny == 1)
            % b is a scalar
            mtrx = plus_a_scalar(b.mtrx,a.mtrx); % switched order
        elseif (a.nx == b.nx)&&(a.ny == b.ny)
            mtrx = a.mtrx + b.mtrx;
        else
            error(THIS,'Matrix dimensions must match');
        end
    else
       error(THIS,'ArrayMatrixes must have equal length.'); 
    end
else
    error(THIS,'Wrong input arguments.');
end
c = arraymatrix(mtrx);
