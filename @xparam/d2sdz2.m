function [H11,H12,H21,H22]=d2sdz2(a)
% DSDZ Calculates the Hessians of the Z- to S-parameter transformation for
% two-ports

% $Header$
% $Author: koffer $
% $Date: 2004-05-28 09:03:19 +0200 (Fri, 28 May 2004) $
% $Revision: 201 $ 
% $Log$
% Revision 1.1  2004/05/28 07:03:19  koffer
% *** empty log message ***
%
%

NP = get(a,'ports');
if NP ~=  2
    error('D2SDZ2: Input argument must have exactly two ports.');
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
    
    k = 4*z0./(-z12.*z21 + z11.*z22).^3;
    
    % preliminaries
    A12 = z21.*z22.^2.*k;
    A13 = z12.*z22.^2.*k;
    A23 = -0.5*z22.*(z12.*z21 + z11.*z22).*k;
    A14 = -z12.*z21.*z22.*k;
    A24 = 0.5*z21.*(z12.*z21 + z11.*z22).*k;
    A34 = 0.5*z12.*(z12.*z21 + z11.*z22).*k;
    B12 = A23;
    B13 = -z12.^2.*z22.*k;
    B14 = A34;
    B23 = z11.*z12.*z22.*k;
    B24 = -0.5*z11.*(z12.*z21+z11.*z22).*k;
    B34 = -z11.*z12.^2.*k;
    C12 = -z21.^2.*z22.*k;
    C13 = A23;
    C14 = A24;
    C23 = z11.*z21.*z22.*k;
    C24 = -z11.*z21.^2.*k;
    C34 = B24;
    D12 = A24;
    D13 = A34;
    D14 = -z11.*z12.*z21.*k;
    D23 = B24;
    D24 = z11.^2.*z21.*k;
    D34 = z11.^2.*z12.*k;
    
    % H11
    % dZ11
    H11(1,1,:) = -z22.^3.*k; % dZ11
    H11(1,2,:) = A12; % dZ21
    H11(1,3,:) = A13; % dZ12
    H11(1,4,:) = A14; % dZ22
    
    % dZ12
    H11(2,1,:) = A12; % dZ11
    H11(2,2,:) = -z21.^2.*z22.*k; % dZ21
    H11(2,3,:) = A23; % dZ12
    H11(2,4,:) = A24; % dZ22
    
    % dZ21
    H11(3,1,:) = A13; % dZ11
    H11(3,2,:) = A23; % dZ21
    H11(3,3,:) = -z12.^2.*z22.*k; % dZ12
    H11(3,4,:) = A34; % dZ22
    
    % dZ22
    H11(4,1,:) = A14; % dZ11
    H11(4,2,:) = A24; % dZ21
    H11(4,3,:) = A34; % dZ12
    H11(4,4,:) = -z11.*z12.*z21.*k; % dZ22

    % H12
    % dZ11
    H12(1,1,:) = A13; % dZ11
    H12(1,2,:) = B12; % dZ21
    H12(1,3,:) = B13; % dZ12
    H12(1,4,:) = B14; % dZ22
    
    % dZ12
    H12(2,1,:) = B12; % dZ11
    H12(2,2,:) = z11.*z21.*z22.*k; % dZ21
    H12(2,3,:) = B23; % dZ12
    H12(2,4,:) = B24; % dZ22
    
    % dZ21
    H12(3,1,:) = B13; % dZ11
    H12(3,2,:) = B23; % dZ21
    H12(3,3,:) = z12.^3.*k; % dZ12
    H12(3,4,:) = B34; % dZ22
    
    % dZ22
    H12(4,1,:) = B14; % dZ11
    H12(4,2,:) = B24; % dZ21
    H12(4,3,:) = B34; % dZ12
    H12(4,4,:) = z11.^2.*z12.*k; % dZ22
    
    % H21
    % dZ11
    H21(1,1,:) = A12; % dZ11
    H21(1,2,:) = C12; % dZ21
    H21(1,3,:) = C13; % dZ12
    H21(1,4,:) = C14; % dZ22
    
    % dZ12
    H21(2,1,:) = C12; % dZ11
    H21(2,2,:) = z21.^3.*k; % dZ21
    H21(2,3,:) = C23; % dZ12
    H21(2,4,:) = C24; % dZ22
    
    % dZ21
    H21(3,1,:) = C13; % dZ11
    H21(3,2,:) = C23; % dZ21
    H21(3,3,:) = z11.*z12.*z22.*k; % dZ12
    H21(3,4,:) = C34; % dZ22
    
    % dZ22
    H21(4,1,:) = C14; % dZ11
    H21(4,2,:) = C24; % dZ21
    H21(4,3,:) = C34; % dZ12
    H21(4,4,:) = z11.^2.*z21.*k; % dZ22

    % H22
    % dZ11
    H22(1,1,:) = -z12.*z21.*z22.*k; % dZ11
    H22(1,2,:) = D12; % dZ21
    H22(1,3,:) = D13; % dZ12
    H22(1,4,:) = D14; % dZ22
    
    % dZ12
    H22(2,1,:) = D12; % dZ11
    H22(2,2,:) = -z11.*z21.^2.*k; % dZ21
    H22(2,3,:) = D23; % dZ12
    H22(2,4,:) = D24; % dZ22
    
    % dZ21
    H22(3,1,:) = D13; % dZ11
    H22(3,2,:) = D23; % dZ21
    H22(3,3,:) = -z11.*z12.^2.*k; % dZ12
    H22(3,4,:) = D34; % dZ22
    
    % dZ22
    H22(4,1,:) = D14; % dZ11
    H22(4,2,:) = D24; % dZ21
    H22(4,3,:) = D34; % dZ12
    H22(4,4,:) = -z11.^3.*k; % dZ22
    
    % convert to arraymatrix
    H11 = arraymatrix(H11);
    H12 = arraymatrix(H12);
    H21 = arraymatrix(H21);
    H22 = arraymatrix(H22);
    
end