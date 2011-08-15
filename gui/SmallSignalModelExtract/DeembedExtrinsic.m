function swp_out= DeembedExtrinsic(swp,Cpg,Cpd,Lg,Ld,Ls,Rg,Rd,Rs,deembedFet)
Y_e = get(swp.Y,'arraymatrix');
f = swp.freq;

% Note: complex omega
omega = 1i*2*pi*f;

% pad capacitance matrix
Y_C = arraymatrix(zeros(size(Y_e)));
Y_C(1,1) = omega*Cpg/2;
Y_C(2,2) = omega*Cpd/2;

% pad inductance matrix
Z_L = arraymatrix(zeros(size(Y_e)));
Z_L(1,1) = omega*Lg;
Z_L(2,2) = omega*Ld;

% de-embedd pads
Y_i = Y_e - Y_C;
Z_i = inv(Y_i) - Z_L;
Y_i = inv(Z_i) - Y_C;

% de-embedd series FET parasitics
if deembedFet == 1
    Z_L(1,1) = Rs+Rg+omega*Ls;
    Z_L(1,2) = Rs+omega*Ls;
    Z_L(2,1) = Rs+omega*Ls;
    Z_L(2,2) = Rs+Rd+omega*Ls;
    Z_i = inv(Y_i) - Z_L;
    Y_i = inv(Z_i);
end

sp = xparam(Y_i,'Y',50,f); % Replace the admitance matrix with the new one
swp_out = swp;
swp_out = set(swp_out,'data',sp);
