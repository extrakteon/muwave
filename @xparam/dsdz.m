function [J]=dsdz(a)
% DSDZ Calculates the jacobian of the Z- to S-parameter transformation for
% two-ports

% $Header$
% $Author: kristoffer $
% $Date: 2003-11-17 20:55:38 +0100 (Mon, 17 Nov 2003) $
% $Revision: 172 $ 
% $Log$
% Revision 1.2  2003/11/17 19:55:37  kristoffer
% *** empty log message ***
%
% Revision 1.1  2003/11/17 10:27:21  kristoffer
% no message
%

NP = get(a,'ports');
if NP ~=  2
    error('DSDZ: Input argument must have exactly two ports.');
else
    % for some reason a.Z simply don't work...
    S.type = '.';S.subs = 'Z';
    a = subsref(a,S); % make sure Z holds Z-parameters
    z0 = a.reference;
    % this is the fastest way of extracting parameters from a XPARAM-object
    m = get(a,'mtrx');
    z11 = z0 + m(1,1,:);
    z21 = m(2,1,:);
    z12 = m(1,2,:);
    z22 = z0 + m(2,2,:);
    
    k = 2*z0./((z11.*z22 - z12.*z21).^2); 
    
    % preliminaries
    J12 = -z12.*z22.*k;
    J13 = -z21.*z22.*k;
    J14 = z12.*z21.*k;
    J22 = z11.*z22.*k;
    J24 = -z11.*z21.*k;
    J34 = -z11.*z12.*k;
    
    % dS11
    J(1,1,:) = (z22.^2).*k; % dZ11
    J(1,2,:) = J12; % dZ21
    J(1,3,:) = J13; % dZ12
    J(1,4,:) = J14; % dZ22
    
    % dS21
    J(2,1,:) = J13; % dZ11
    J(2,2,:) = J22; % dZ21
    J(2,3,:) = (z21.^2).*k; % dZ12
    J(2,4,:) = J24; % dZ22
    
    % dS12
    J(3,1,:) = J12; % dZ11
    J(3,2,:) = (z12.^2).*k; % dZ21
    J(3,3,:) = J22; % dZ12
    J(3,4,:) = J34; % dZ22
    
    % dS22
    J(4,1,:) = J14; % dZ11
    J(4,2,:) = J34; % dZ21
    J(4,3,:) = J24; % dZ12
    J(4,4,:) = (z11.^2).*k; % dZ22
    
    % convert to arraymatrix
    J = arraymatrix(J);
end