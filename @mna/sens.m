function [Z,dZ]=sens(x,val)
% SENS basic sensitivity

% $Header$
% $Author: koffer $
% $Date: 2004-05-11 16:16:38 +0200 (Tue, 11 May 2004) $
% $Revision: 194 $ 
% $Log$
% Revision 1.6  2004/05/11 14:16:38  koffer
% bugfix
%
% Revision 1.5  2004/04/28 15:55:48  koffer
% Support for second order sensitivities
%
% Revision 1.4  2003/11/17 18:55:54  kristoffer
% no message
%
% Revision 1.3  2003/11/17 07:46:35  kristoffer
% *** empty log message ***
%
% Revision 1.2  2003/11/14 16:49:22  kristoffer
% no message
%
% Revision 1.1  2003/11/12 23:21:38  kristoffer
% *** empty log message ***
%

% inputs: x - mna-object
%         val - parameter/element values

% calculate nodal admittance matrix
Yxp = calc(x,val);
Y = get(Yxp,'arraymatrix');
NFREQ = length(Yxp);

params = 1:length(params(x));
ports = ports(x);
NPORTS = size(ports,2);
I = zeros(x.nodes,size(ports,2));
for k=1:NPORTS
    if any(ports(:,k)==0);
        if ports(2,k)==0
            I(ports(1,k),k) = 1;
        else
            I(ports(1,k),k) = -1;
        end
    else    
        I(ports(:,k),k) = [1 -1];
    end
end    

% this is actually faster than doing a separate LU-decomposition and then
% use the transposed matrices for finding the inverse of the adjoint
V = Y\I;
if x.reciprocal
    Va = V;
else
    Va = (Y.')\I;
end
    
% add zero volt reference
z = zeros(1,NPORTS,NFREQ);
Vb = [z;get(V,'mtrx')];
Vba = [z;get(Va,'mtrx')];

% calculate sens.
dZ = calc_dz(Vba,Vb,x,params);
for k = 1:NPORTS
    % 04/03/09 changed order of Vp from (:,k,:) to (k,:,:)
    Vp(k,:,:) = -1*diff(Vb(1+ports(:,k),:,:));   
end

% produce output
Z = xparam(Vp,'Z');
dZ = arraymatrix(dZ);

