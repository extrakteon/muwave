function [SM,X] = ExtractIntrinsic(intr,Smoothing)
%EXTRACTINTRINSIC Calculate FET model parameters from intrinsic S-parameters.
%   [SM,X] = EXTRACTINTRISINC(INTR,SMOOTHING) returns a structure SM containing
%   the eight FET intrinsic model parameters versus frequency. 
%   The parameters are extracted using the direct extraction method from 
%   the meassp-object INTR. Optionally the parameters are smoothed with a 
%   factor SMOOTHING.
%
%   See also: HEMTPACKAGE

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: koffer $
% $Date: 2006-08-18 06:47:51 +0200 (Fri, 18 Aug 2006) $
% $Revision: 306 $ 
% $Log$
% Revision 1.3  2005/04/27 21:37:26  fager
% no message
%
% Revision 1.2  2004/10/20 22:06:35  fager
% Help comments added
%

f=get(intr,'Freq');
omega=2*pi*f;
Y11=get(intr,'Y11');
Y12=get(intr,'Y12');
Y21=get(intr,'Y21');
Y22=get(intr,'Y22');

Ri=real(1./(Y11+Y12));
Cgs=-1./(omega.*imag(1./(Y11+Y12)));

Rj=real(-1./Y12);
Cgd=-1./(omega.*imag(-1./Y12));

gds=real(Y12+Y22);
Cds=1./omega.*imag(Y12+Y22);

gm=abs((Y21-Y12).*(1+j*omega.*Cgs.*Ri));
tau=-unwrap(angle((Y21-Y12).*(1+j*omega.*Cgs.*Ri)))./omega;

if (nargin==2)&(Smoothing>0)'
	Cgs=smooth(Cgs',Smoothing)';
	Ri=smooth(Ri',Smoothing)';
	Cgd=smooth(Cgd',Smoothing)';
	Rj=smooth(Rj',Smoothing)';
	Cds=smooth(Cds',Smoothing)';
	gds=smooth(gds',Smoothing)';
	gm=smooth(gm',Smoothing)';
	tau=smooth(tau',Smoothing)';
end
SM.Cgs=Cgs;
SM.Ri=Ri;
SM.Cgd=Cgd;
SM.Rj=Rj;
SM.gm=gm;
SM.tau=tau;
SM.Cds=Cds;
SM.gds=gds;
if nargout==2
    XM=eps+zeros(length(omega),8^2);
    XM(:,sub2ind([8 8],1:8,1:8))=[Ri Cgs Rj Cgd gds Cds gm tau];
    X=buildxp(xparam,XM,'Y',50);
end