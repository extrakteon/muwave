C = 70e-15;
L = 60e-12;
Rc = 1.41;

W = 0.02; %[cm]
q = 1.60217646e-19;
n = 8.23e12;
mu = 1460;

swp6 = load_lsna_data('data/TLM02_6ghz_meas05.mat',6);
dswp6 = deembedd_lsna_data(swp6,L,C);

VRF6 = dswp6.v1;
IRF6 = dswp6.i1+dswp6.i2;

ERF6 = 1e-5.*(VRF6-2.*Rc.*IRF6)./2e-6;
veRF = IRF6./(W.*q.*n);

P6ix = [74 137 161 177 190];
figure();
plot(ERF6(P6ix,:).',veRF(P6ix,:).'*1e-7,'LineWidth',2);
set(gca,'FontSize',12);
legend('0.1 W','0.5 W','0.9 W','1.3 W','1.7 W','Location','NorthWest')
xlabel('Electric Field (kV/cm)');
ylabel('Electron Velocity (x10^7 cm/s)');
axis([0 100 0 3]);

