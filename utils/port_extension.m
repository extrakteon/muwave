function swp = port_extension(swp, varargin)
% PORT_EXTENSION
% 

if nargin == 2
    port1 = varargin{1};
    port2 = port1;
elseif nargin == 3
    port1 = varargin{1};
    port2 = varargin{2};
end

omega = 2*pi*swp.freq;
S11 = swp.S11.*exp(-j*omega*(2*port1));
S21 = swp.S21.*exp(-j*omega*(port1+port2));
S12 = swp.S12.*exp(-j*omega*(port1+port2));
S22 = swp.S22.*exp(-j*omega*(2*port2));

switch class(swp)
    case 'meassp'
        swp.S11 = S11;
        swp.S21 = S21;
        swp.S12 = S12;
        swp.S22 = S22;
    case 'meassweep'
        for k = 1:length(swp)
           item = swp(k);
           item.S11 = S11(:,k);
           item.S21 = S21(:,k);
           item.S12 = S12(:,k);
           item.S22 = S22(:,k);
           swp(k) = item;
        end
end

