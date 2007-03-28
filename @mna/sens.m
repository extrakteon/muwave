function [varargout]=sens(x,opt)
% SENS basic sensitivity
% inputs: 
%         x - mna-object
%         val - parameter/element values 
%   or    
%         h_dZ - structure from reduce
% outputs:
%         dZ - derivatives
%   or  
%         Z  - port impedenaces
%         dZ - derivatives
%
% $Header$
% $Author: koffer $
% $Date: 2005-09-12 16:25:30 +0200 (Mon, 12 Sep 2005) $
% $Revision: 296 $ 
% $Log$
% Revision 1.8  2005/09/12 14:24:14  koffer
% *** empty log message ***
%

if isstruct(opt)
    h_dZ = opt;
else
    [x, Z, h_dZ]=reduce(x,opt);    
end


Y = h_dZ.Y;
V = h_dZ.V;
Z = h_dZ.Z;
I = h_dZ.I;
NPORTS = h_dZ.NPORTS;
NFREQ = h_dZ.NFREQ;
PORTS = h_dZ.PORTS;

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
d_params = 1:length(params(x)); % take derivative wrt all parameters
dZ = calc_dz(Vba,Vb,x,d_params);
for k = 1:NPORTS
    % 04/03/09 changed order of Vp from (:,k,:) to (k,:,:)
    Vp(k,:,:) = -1*diff(Vb(1+PORTS(:,k),:,:));   
end

% produce output
dZ = arraymatrix(dZ);
varargout{1} = x;
if nargout == 2
    varargout{2} = dZ;
elseif nargout == 3
    varargout{2} = Z;
    varargout{3} = dZ;
end