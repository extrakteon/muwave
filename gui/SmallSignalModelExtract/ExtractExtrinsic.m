function [Cg_out dLd dLg Ls Rd  Rdy_out dRi Rs] = ...
    ExtractExtrinsic(swp,Rc,Rg,Ri,dLg,Rdy_in,Cg_in,LF1,LF2,HF1,HF2,counter)
f = swp.freq;
W = 2*pi*f;

Z11 = swp.Z11;
Z12 = swp.Z12;
Z21 = swp.Z21;
Z22 = swp.Z22;

%Zs=Z12 = Rs+Rc/2+Ls  gives  Rs & Ls (Rorsman eq. 4)
Rs_extr = real(Z12)-Rc/2;
Rs = MeanValue(Rs_extr, LF1, LF2);
Ls_extr = imag(Z12)./W;
Ls = MeanValue(Ls_extr, HF1, HF2);

%Zd = Z22-Z21 = Rd+Rc/2+(delta)Ld gives Rd & delta Ld (Rorsman eq. 4-5)
Rd_extr = real(Z22)-real(Z12)-0.5*Rc;
dLd_extr = (imag(Z22)-imag(Z12))./W;
Rd = MeanValue(Rd_extr,LF1,LF2);
dLd = MeanValue(dLd_extr,HF1,HF2); % If already deembeded this should become 0

%calculating Rdy and Cg
if mod(counter,2)==1  % Odd(1,3, 5,...)
    x=Z11-Z12-Rg-Ri-1i*dLg*W;
    Rdy_extr= real(x).*(1+(imag(x)./real(x)).^2); % (Rorsman eq. 3-4)
    Cg_extr = -imag(x)./(real(x).*W.*Rdy_extr);   % (Rorsman eq. 3-4)
    Rdy_out = MeanValue(Rdy_extr,LF1,LF2);
    Cg_out = MeanValue(Cg_extr,LF1,LF2);
    dRi = 0;
    dLg = 0;
end
%calculating delta Ri and delta Lg
if mod(counter,2)==0 % Even (2,4,6,...)'
    x= Z11-Z12-Rg-(Rdy_in./(1+1i*Rdy_in*Cg_in.*W));
    dRi_extr = real(x);
    dLg_extr = imag(x)./W;
    dRi = MeanValue(dRi_extr,HF1,HF2);
    dLg = MeanValue(dLg_extr, HF1, HF2);
    Rdy_out = Rdy_in;
    Cg_out = Cg_in;
end