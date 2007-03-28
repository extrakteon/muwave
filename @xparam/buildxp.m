
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
% CHANGES:
% 2002-01-04, Kristoffer Andersson
%             Major rewrite version
% 2002-01-05, Christian Fager
%             Added xparam object, XP, as input parameter.
%
% 2003-06-14, Kristoffer Andersson
%             Total rewrite to fit new class arraymatrix

function cOUT = buildxp(XP,B,type,reference)

if isa(XP,'xparam')
    if isa(B,'double') 
        ports = ceil(sqrt(size(B,2)));
        elements = size(B,1);
        mtrx = zeros(ports,ports,elements);
        k = 1;
        for y = 1:ports
            for x = 1:ports
                mtrx(x,y,:) = B(:,k);
                k = k + 1;
            end
        end
        if nargin == 2
            cOUT = xparam(mtrx);
        elseif nargin == 3
            cOUT = xparam(mtrx,type);
        elseif nargin == 4
            cOUT = xparam(mtrx,type,reference);
        else
            error('XPARAM.BUILDXP: To many arguments.');
        end
    else
        error('XPARAM.BUILDXP: Second argument must be a matrix.')
    end
else
    error('XPARAM.BUILDXP: First argument must be an xparam object');
end