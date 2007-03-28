function [Z]=reduce(x,val)
% REDUCE calculate port impedence matrix

% $Header$
% $Author: koffer $
% $Date: 2004-03-10 10:41:28 +0100 (Wed, 10 Mar 2004) $
% $Revision: 184 $ 
% $Log$
% Revision 1.2  2004/03/10 09:41:28  koffer
% Fixed a problem with non-reciprocal elements.
%
% Revision 1.1  2003/11/17 22:10:33  kristoffer
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
        I(ports(:,k),k) = [1;-1];
    end
end    

V = Y\I;
z = zeros(1,NPORTS,NFREQ);
Vb = [z;get(V,'mtrx')];
for k = 1:NPORTS
    % 04/03/09 changed order of Vp from (:,k,:) to (:,:,k)
    Vp(k,:,:) = -1*diff(Vb(1+ports(:,k),:,:));   
end
Z = xparam(Vp,'Z');
