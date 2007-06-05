function gd = delay(SP)
% tries to calculate group delay from measured S-parameters

f = freq(SP); % our frequency vector

% fist ignore the effects of missmatch...
A = SP.S21; % this is our transfer function
phi = unwrap(angle(A));
% unwrap may destroy the negative slope. Check that!
if phi(2)>phi(1)
    phi = -phi;
end
d_phi = gradient(phi);
d_omega = gradient(2*pi*f);
gd = -d_phi./d_omega;
