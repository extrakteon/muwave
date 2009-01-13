function am = arraymatrix(a,b,c)
%ARRAYMATRIX    Constructor.

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.6  2005/10/12 16:17:34  koffer
% Changed to scalar binary operators (& -> &&, | -> ||).
%
% Revision 1.5  2005/05/11 10:12:52  fager
% Error in constructor fixed.
%
% Revision 1.4  2003/11/17 07:47:02  kristoffer
% *** empty log message ***
%
% Revision 1.3  2003/08/25 10:37:59  fager
% Added assignment method for single vector input argument.
%

if nargin==0
    % Default: Return an empty matrix with dimension 2
    p.nx = 2; % matrix dimension 
    p.ny = 2;
    p.m = 0; % number of elements
    p.mtrx = [];
    am = class(p, 'arraymatrix');
elseif isa(a,'arraymatrix')
    % If constructor is applied to a arraymatrix-object return the object unchanged
    am = a;
elseif nargin==1 && isa(a,'double') 
    % arraymatrix(mtrx)
    switch ndims(a)
        case 3,
            p.nx = size(a,1);
            p.ny = size(a,2);
            p.m = size(a,3);
            p.mtrx = a;
        case 2
            p.nx = size(a,1);
            p.ny = size(a,2);    
            p.m = 1;
            p.mtrx = a;
        otherwise
            error('Illegal assignment method.');
    end
    am = class(p, 'arraymatrix'); 
elseif nargin==2 
    if isa(a,'double') && isa(b,'double')
        % arraymatrix(A, m)
        if ((size(a,2) > 1) || (size(a,1) > 1)) && (b > 0)
            % where A is a matrix to be repeated m-times
            p.nx = size(a,1);
            p.ny = size(a,2);
            p.m = b;
            p.mtrx = repmat(a,[1 1 b]);
            am = class(p,'arraymatrix');
        end
    end
elseif nargin==3
    if isa(a,'double') && isa(b,'double') && isa(c,'double')
        if c > 0
            % allocate a matrix of zeros of size:
            % a=nx, b=ny, c=elements
            p.nx = a;
            p.ny = b;
            p.m = c;
            p.mtrx = repmat(zeros(a,b),[1 1 c]);
            am = class(p,'arraymatrix');
        end
    end
else
    error('ARRAYMATRIX.ARRAYMATRIX: Invalid input argument(s).')   
end
