function xpout = addspmeascov(xpin,uncertmodel_name);
% ADDSPMEASCOV  Add uncertainty information to xparam-object using
% empirical measurement uncertainty models.
%
%   XP = ADDSPMEASCOV(XP) uses the default empirical uncertainty model
%   developed for 8510 measurements ('8510CF').
%
%   XP = ADDSPMEASCOV(XP,'MODELNAME') uses the uncertainty model specified
%   by name MODELNAME. Valid names are: '8510KA', '8510CF'
%
%   See also:
%

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.1  2005/04/27 21:50:17  fager
% * Initial version
% * Frequencies -> xparam
%

if (size(xpin,1) ~= 2)|(size(xpin,2)~=2)
    error('Only implemented for two-port measurements');
end

if nargin==1
    uncertmodel_name = '8510KA';
end

f = freq(xpin);

Cw3D = zeros(8,8,length(xpin));

% S11
M = get(xpin,'S11');
A = abs(M);
Theta = angle(M);
s_A = SigmaMagSrefl(A,f,uncertmodel_name);
s_Theta = SigmaAngSrefl(A,f,uncertmodel_name);
Cw3D(1:2,1:2,:) = MagPhase2ReIm(A,Theta,s_A,s_Theta);


% S21
M = get(xpin,'S21');
A = abs(M);
Theta = angle(M);
s_A = SigmaMagStrans(A,f,uncertmodel_name);
s_Theta = SigmaAngStrans(A,f,uncertmodel_name);
Cw3D(3:4,3:4,:) = MagPhase2ReIm(A,Theta,s_A,s_Theta);

% S12
M = get(xpin,'S12');
A = abs(M);
Theta = angle(M);
s_A = SigmaMagStrans(A,f,uncertmodel_name);
s_Theta = SigmaAngStrans(A,f,uncertmodel_name);
Cw3D(5:6,5:6,:) = MagPhase2ReIm(A,Theta,s_A,s_Theta);

% S22
M = get(xpin,'S22');
A = abs(M);
Theta = angle(M);
s_A = SigmaMagSrefl(A,f,uncertmodel_name);
s_Theta = SigmaAngSrefl(A,f,uncertmodel_name);
Cw3D(7:8,7:8,:) = MagPhase2ReIm(A,Theta,s_A,s_Theta);

xpout = convert(xpin,'S');
xpout = set(xpout,'datacov',arraymatrix(Cw3D));

%%%%%%%%%%%%
% Local functions defining the relative uncertainties from Agilent 8510C specifications
% D_WC = Worst-case deviation = interpreted as 3*sigma_D

function s_D=SigmaMagSrefl(Gam,f,vnamodel)
switch upper(vnamodel)
    case '8510CF'
        D_WC=0.04*(1+exp(-15*(-.17+abs(Gam)))).*(1+(1-0.5)*(f-40e9)/(40e9-2e9));
        s_D=D_WC/3;
    case '8510KA'
        s_D = exp(6.5e-11*f - 6.9)./Gam;
    otherwise
        error('Specified uncertainty model not implemented');
end

function s_D=SigmaAngSrefl(Gam,f,vnamodel)
switch upper(vnamodel)
    case '8510CF'
        D_WC=0.04*(1+exp(-15*(-.17+abs(Gam)))).*(1+(1-0.5)*(f-40e9)/(40e9-2e9));
        s_D=D_WC/3;
    case '8510KA'
        s_D = exp(6.5e-11*f - 6.9);
    otherwise
        error('Specified uncertainty model not implemented');
end

function s_D=SigmaMagStrans(S,f,vnamodel)
switch upper(vnamodel)
    case '8510CF'
        D_WC=0.016*(1+exp(-0.2*(38+20*log10(abs(S))))).*(1+(1-0.25)*(f-40e9)/(40e9-2e9));
        s_D=D_WC/3;
    case '8510KA'
        s_D = exp(-4.1e-10*f - 3.3) + exp(9.2e-11*(f-5.8e9) - 6);
    otherwise
        error('Specified uncertainty model not implemented');
end

function s_D=SigmaAngStrans(S,f,vnamodel)
switch upper(vnamodel)
    case '8510CF'
        D_WC=0.016*(1+exp(-0.2*(38+20*log10(abs(S))))).*(1+(1-0.25)*(f-40e9)/(40e9-2e9));
        s_D=D_WC/3;
    case '8510KA'
        s_D = exp(-4.1e-10*f - 3.3) + exp(9.2e-11*(f-5.8e9) - 6);
    otherwise
        error('Specified uncertainty model not implemented');
end


function C_S3d = MagPhase2ReIm(A,Theta,s_A,s_Theta)
% Convert from independent relative magnitude and absolute phase
% uncertainties into correlated absolute real and imaginary uncertainties.

C_ReS   = .5*A.^2.*((exp(2*s_Theta.^2) + cos(2*Theta)).*(s_A.^2 + 1) - 2*exp(s_Theta.^2).*cos(Theta).^2)./exp(2*s_Theta.^2);
C_ImS   = .5*A.^2.*((exp(2*s_Theta.^2) - cos(2*Theta)).*(s_A.^2 + 1) - 2*exp(s_Theta.^2).*sin(Theta).^2)./exp(2*s_Theta.^2);
C_ReImS = -.5*A.^2.*cos(Theta).*sin(Theta).*(exp(s_Theta.^2) - 1 - s_A.^2)./exp(2*s_Theta.^2);

C_S3d   = zeros(2,2,length(A));
C_S3d(1,1,:) = C_ReS;
C_S3d(1,2,:) = C_ReImS;
C_S3d(2,1,:) = C_ReImS;
C_S3d(2,2,:) = C_ImS;