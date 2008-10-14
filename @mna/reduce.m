function [varargout]=reduce(x,val)
% REDUCE calculate port impedence matrix
%
% inputs: 
%       x - mna-object
%       val - parameter/element values
% outputs:
%       x - mna-object
%       Z - port impedence matrix
%       h_dZ - struct containing information used by sense
%
% $Header$
% $Author: ferndahl $
% $Date: 2006-08-28 17:02:55 +0200 (Mon, 28 Aug 2006) $
% $Revision: 310 $ 
% $Log$
% Revision 1.5  2005/09/12 14:22:20  koffer
% *** empty log message ***
%

% calculate nodal admittance matrix
[x,Yxp] = calc(x,val);    

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
            I(PORTS(2,k),k) = -1; % 2004/10/23 fixed typo (but who defines ports negative to ground, anyway?)
        end
    else    
        I(PORTS(:,k),k) = [1;-1];
    end
end   

% 2004/10/23
% put 1T-ohm-resistors across all ports
% *FIXME* define threshold somewhere
TRESH = 1e12;
if cond(get(Y(1),'mtrx')) > TRESH % sufficent to check at low-frequency
    warning('mna:singular','1T ohm resistors placed over each port and to ground');
    Yr = zeros(x.nodes);
    Rport = 1e12;
    for k=1:NPORTS
        if any(PORTS(:,k)==0);
            if PORTS(2,k)==0
                Yr(PORTS(1,k),PORTS(1,k)) = 1;
            else
                Yr(PORTS(2,k),PORTS(2,k)) = 1;
            end
        else    
            Yr(PORTS(:,k),PORTS(:,k)) = [1 -1;-1 1];
        end
    end    
    Yr = 1/Rport*(eye(x.nodes) + Yr);
    Y = Y + Yr;
end
V = (Y)\I;
z = zeros(1,NPORTS,NFREQ);
Vb = [z;get(V,'mtrx')];

% Predefine the Vp size. Otherwise Matlab removes the first dimension for
% 1-ports...
Vp = zeros(NPORTS,NPORTS,NFREQ);
for k = 1:NPORTS
    % 04/03/09 changed order of Vp from (:,k,:) to (:,:,k)
    Vp(k,:,:) = -1*diff(Vb(1+PORTS(:,k),:,:));   
end
Z = xparam(Vp,'Z',50,x.f);

% output rearranged for better integration with sensitivity code
switch nargout
    case 1,
    varargout{1} = Z;
    case 2,
    varargout{1} = x;
    varargout{2} = Z;
    case 3,
    h_dZ.Y = Y;
    h_dZ.V = V;
    h_dZ.Z = Z;
    h_dZ.I = I;
    h_dZ.NPORTS = NPORTS;
    h_dZ.NFREQ = NFREQ;
    h_dZ.PORTS = PORTS;
    h_dZ.x = x;
    h_dZ.val = val;
    varargout{1} = x;
    varargout{2} = Z;
    varargout{3} = h_dZ;
end