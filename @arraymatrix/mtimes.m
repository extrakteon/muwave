function c = mtimes(a,b)
%MTIMES Overload operator *.

% $Header$
% $Author: koffer $
% $Date: 2004-10-27 20:24:36 +0200 (Wed, 27 Oct 2004) $
% $Revision: 230 $ 
% $Log$
% Revision 1.9  2004/10/27 18:24:36  koffer
% minus/plus and mtimes where so full of bugs that they have been rewwritten from srcatch. Local functions have been moved to /private
%
% Revision 1.8  2003/11/17 07:47:02  kristoffer
% *** empty log message ***
%
% Revision 1.7  2003/08/25 14:42:36  fager
% Matrix multiplication now works both with rectangular matrices and scalars.
%
% Revision 1.6  2003/08/25 09:25:45  fager
% Multiplication with scalar implemented and verified.
%
% Revision 1.5  2003/08/25 09:12:52  fager
% no message
%
% Revision 1.4  2003/08/25 09:08:11  fager
% Removed necessity of the input arguments to be of same size (multiplication of rectangular matrices).
%

SMALL_MATRIX = 30;
THIS = 'array:matrix';

if isa(a,'double') 
    % left multiplication with ...
    anx = size(a,1);
    any = size(a,2);
    am = size(a,3);
    if am == 1
        %  non array argument
        if (anx == 1)&&(any == 1)
            % argument is a scalar
            mtrx = a*b.mtrx;
        elseif (any == b.nx)
            % argument is a matrix
            mtrx = mtimes_na_matrix_left(a,b.mtrx);
        else
            error(THIS,'Inner matrix dimensions must match.');
        end
    elseif am == b.m
        % array argument
        if (anx == 1)&&(any == 1)
            % scalar array
            mtrx = mtimes_a_scalar(a,b.mtrx);
        elseif (any == b.nx)
            % matrix array
            mtrx = mtimes_a_matrix(a,b.mtrx);
        else
            error(THIS,'Inner matrix dimensions must match.');
        end    
    else
        error(THIS,'Length of arguments must match.');
    end
    
elseif isa(b,'double');
    % left multiplication with ...
    bnx = size(b,1);
    bny = size(b,2);
    bm = size(b,3);
    if bm == 1
        %  non array argument
        if (bnx == 1)&&(bny == 1)
            % argument is a scalar
            mtrx = a.mtrx*b;
        elseif (a.ny == bnx)
            % argument is a matrix
            mtrx = mtimes_na_matrix_right(a.mtrx,b);
        else
            error(THIS,'Inner matrix dimensions must match.');
        end 
    elseif bm == a.m
        % array argument
        if (bnx == 1)&&(bny == 1)
            % scalar array
            mtrx = mtimes_a_scalar(b,a.mtrx); % this function expects the first argument to be a scalar-array
        elseif (a.ny == bnx)
            % matrix array
            mtrx = mtimes_a_matrix(a.mtrx,b);
        else
            error(THIS,'Inner matrix dimensions must match.');
        end    
    else
        error(THIS,'Length of arguments must match.');
    end
    
elseif strcmp(class(a),class(b))
    % multiplication with arraymatrix
    if (a.m == b.m)
        if (a.nx == 1)&&(a.ny ==1)
            % a is a "scalar"
            mtrx = mtimes_a_scalar(a.mtrx,b.mtrx);% this function expects the first argument to be a scalar-array
        elseif (b.nx == 1)&&(b.ny ==1)
            % b is a "scalar"
            mtrx = mtimes_a_scalar(b.mtrx,a.mtrx);% this function expects the first argument to be a scalar-array
        elseif (a.ny == b.nx)
            mtrx = mtimes_a_matrix(a.mtrx,b.mtrx); 
        else
            error(THIS,'Inner matrix dimensions must match');
        end
    else
        error(THIS,'ArrayMatrixes must have equal length');    
    end
else
    error(THIS,'Wrong input arguments.');
end

% assign output argument
c = arraymatrix(mtrx);