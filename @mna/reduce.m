function [Z]=reduce(x,val)
% REDUCE calculate port impedence matrix

% $Header$
% $Author: fager $
% $Date: 2005-02-22 08:56:20 +0100 (Tue, 22 Feb 2005) $
% $Revision: 240 $ 
% $Log$
% Revision 1.4  2005/02/22 07:56:20  fager
% Renamed parameter names (conflict in Matlab v7)
%
% Revision 1.3  2004/12/01 10:32:15  fager
% Now it works also for 1-ports...
%
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

%pars = 1:length(params(x));
PORTS = ports(x);
NPORTS = size(PORTS,2);
I = zeros(x.nodes,size(PORTS,2));
for k=1:NPORTS
    if any(PORTS(:,k)==0);
        if PORTS(2,k)==0
            I(PORTS(1,k),k) = 1;
        else
            I(PORTS(1,k),k) = -1;
        end
    else    
        I(PORTS(:,k),k) = [1;-1];
    end
end    

V = Y\I;
z = zeros(1,NPORTS,NFREQ);
Vb = [z;get(V,'mtrx')];

% Predefine the Vp size. Otherwise Matlab removes the first dimension for
% 1-ports...
Vp = zeros(NPORTS,NPORTS,NFREQ);
for k = 1:NPORTS
    % 04/03/09 changed order of Vp from (:,k,:) to (:,:,k)
    Vp(k,:,:) = -1*diff(Vb(1+PORTS(:,k),:,:));   
end
Z = xparam(Vp,'Z');
