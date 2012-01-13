function Wave = Waveform(data,NumPoints)
% generate waveform data from lsna measured data
[a b] = size(data.a1);
freq = data.freq;
T=1./freq(1, 2);
t=linspace(0, 2.*T, NumPoints);
[xomega,xt]=meshgrid(2.*pi.*freq(1,:), t);
H=exp(j.*xomega.*xt);

for Idx = 1:a   
    a1 = []; a2 = []; b1 = []; b2 = [];
    v1 = []; v2 = []; i1 = []; i2 = [];

    % a1
    a1t = H*data.a1(Idx, :).';
    a1 = 0.5*(a1t + conj(a1t));
    % a2
    a2t = H*data.a2(Idx, :).';
    a2 = 0.5*(a2t + conj(a2t));
    % b1
    b1t = H*data.b1(Idx, :).';
    b1 = 0.5*(b1t + conj(b1t));
    % b2
    b2t = H*data.b2(Idx, :).';
    b2 = 0.5*(b2t + conj(b2t));

    % v1
    v1t = H*data.v1(Idx, :).';
    v1 = 0.5*(v1t + conj(v1t));
    % v2
    v2t = H*data.v2(Idx, :).';
    v2 = 0.5*(v2t + conj(v2t));
    % i1
    i1t = H*data.i1(Idx, :).';
    i1 = 0.5*(i1t + conj(i1t));
    % i2
    i2t = H*data.i2(Idx, :).';
    i2 = 0.5*(i2t + conj(i2t));
    
    Wave.a1(Idx,:) = a1;
    Wave.b1(Idx,:) = b1;
    Wave.a2(Idx,:) = a2;
    Wave.b2(Idx,:) = b2;
    Wave.v1(Idx,:) = v1;
    Wave.i1(Idx,:) = i1;
    Wave.v2(Idx,:) = v2;
    Wave.i2(Idx,:) = i2;
end
Wave.t = t;