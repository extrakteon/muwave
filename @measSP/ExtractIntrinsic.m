function [SM,X]=ExtractIntrinsic(intr,Smoothing)
f=get(intr,'Freq');
omega=2*pi*f';
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