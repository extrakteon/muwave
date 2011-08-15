function [Rj Cgd Ri Cgs Rds Cds gm tau]= ExtractIntrinsicFET(swp)
Omega = 2*pi*swp.freq;
Y11 = swp.Y11;
Y12 = swp.Y12;
Y21 = swp.Y21;
Y22 = swp.Y22;

Rj = -real(1./Y12);
Cgd = 1./(Omega.*imag(1./Y12));
Ri = real(1./(Y11+Y12));
Cgs = -1./(Omega.*imag(1./(Y11+Y12)));
Rds = 1./(real(Y12+Y22));
Cds = imag(Y12+Y22)./Omega;
gm = abs((Y12-Y21).*(Y11+Y12)./imag(Y11+Y12));
tau = (pi/2 - angle(Y12-Y21) + angle(Y11+Y12))./Omega;

% Correct gm depending on current
if(swp.I2_SET < 0)
%     if(swp.Ids < 0)
    gm = -gm;
end


