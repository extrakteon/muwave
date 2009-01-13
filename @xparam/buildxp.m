function cOUT = buildxp(XP,B,type,reference,freq)
% BUILDXP   Build xparam object from a "Touchstone-like" matrix.
%
% XP = BUILDXP(XPARAM,B)
%
% XP = BUILDXP(XPARAM,B,TYPE)
%
% XP = BUILDXP(XPARAM,B,TYPE,REFERENCE)
%
% XP = BUILDXP(XPARAM,B,TYPE,REFERENCE,FREQ)
%
%   See also: @meassp/read_touchstone

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.3  2005/04/27 21:31:05  fager
% * Version logging added.
% * Frequencies -> xparam.
% * Added mode allowing frequency as input parameter (used by read_touchstone)
%

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
        elseif nargin == 5
            cOUT = xparam(mtrx,type,reference,freq);
        else
            error('XPARAM.BUILDXP: To many arguments.');
        end
    else
        error('XPARAM.BUILDXP: Second argument must be a matrix.')
    end
else
    error('XPARAM.BUILDXP: First argument must be an xparam object');
end
