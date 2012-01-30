function dz = calc_dz(Va,V,x,paramlist)
%CALC_DZ Calculates Z-sensitivities given branch voltages
% $Header$
% $Author: koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
% $Log$
% Revision 1.6  2005/09/12 14:26:57  koffer
% *** empty log message ***
%

% retrieve connection and element vectors from mna-object
CONN = conn(x);
ptype = type(x);
VAL = val(x);
if isempty(VAL)
    error('CALC_DZ: No values assigned for circuit elements.');
end

%conn = conn_all(paramlist);
%ptype = type_all(paramlist);
%val = val_all(paramlist);

% Prepare som vectors for later use
s = j*2*pi*freq(x)';
e = ones(size(s));
N2 = size(V,2)^2;
kfact = shiftdim(e,-1);
kfact = repmat(kfact,[1 N2 1]);
s = shiftdim(s,-1);
s = repmat(s,[1 N2 1]);
ksfact = kfact.*s;

partials = x.partials;
params = x.params;

for m = 1:length(paramlist)
    k = paramlist(m);
    switch ptype{k}
        case 'G'
            dz(:,m,:) = calc_dzk_adm(Va,V,1+CONN{k},VAL(k),-kfact,partials(k));
        case 'C'
            dz(:,m,:) = calc_dzk_adm(Va,V,1+CONN{k},VAL(k),-ksfact,partials(k));
        case 'L'
            dz(:,m,:) = calc_dzk_imp(Va,V,1+CONN{k},VAL(k),ksfact,partials(k));
        case 'R'
            dz(:,m,:) = calc_dzk_imp(Va,V,1+CONN{k},VAL(k),kfact,partials(k));
        case 'VCCS'
            dz(:,m,:) = calc_dzk_vccs(Va,V,1+CONN{k},VAL(k),-kfact,partials(k));
        case {'VCCSD','VCCSD_TAU'}
            dz(:,m,:) = calc_dzk_vccsd(Va,V,1+CONN{k},VAL,params,ptype,-kfact,s,partials(k),k);
        otherwise
            disp(sprintf('%s not implemented!',ptype{k}));
    end
end

function dzk = calc_dzk_adm(Va,V,conn,VAL,kfact,partial)
% calculate sensitivities for admittance-elements
dzk = 0;
N = size(Va,2); % number of ports/nodes
idx_v = reshape(repmat(1:N,[N 1]),[1 N*N]); % [1 1 2 2 3 3 .. ]
idx_va = repmat(1:N,[1 N]); % [1 2 3 1 2 3 .. ]
for l=1:size(conn,1)
    idx = conn(l,:);
    iVa = diff(Va(idx,:,:));
    iV = diff(V(idx,:,:));
    % *FIXME* hardcoded for two-ports    
    iVaV = iV(:,idx_v,:).*iVa(:,idx_va,:);
    dzk = dzk + kfact.*iVaV;
end
dzk = dzk.*partial;
            
function dzk = calc_dzk_imp(Va,V,CONN,VAL,kfact,partial)
% calculate sensitivities for impedance-elements
dzk = 0;
N = size(Va,2); % number of ports/nodes
idx_v = reshape(repmat(1:N,[N 1]),[1 N*N]); % [1 1 2 2 3 3 .. ]
idx_va = repmat(1:N,[1 N]); % [1 2 3 1 2 3 .. ]
for l=1:size(CONN,1)
    idx = CONN(l,:);
    iVa = diff(Va(idx,:,:));
    iV =  diff(V(idx,:,:));
    % *FIXME* hardcoded for two-ports
    iVaV = iV(:,idx_v,:).*iVa(:,idx_va,:);
    dzk = dzk + kfact.*iVaV./((VAL*kfact).^2);
end
dzk = dzk./partial;

function dzk = calc_dzk_vccs(Va,V,CONN,VAL,kfact,partial)
% calculate sensitivities for vccs-elements
dzk = 0;
N = size(Va,2); % number of ports/nodes
idx_v = reshape(repmat(1:N,[N 1]),[1 N*N]); % [1 1 2 2 3 3 .. ]
idx_va = repmat(1:N,[1 N]); % [1 2 3 1 2 3 .. ]
for l=1:size(CONN,1)
    idx = CONN(l,1:2:3);
    iV =  diff(V(idx,:,:));
    idx = CONN(l,2:2:4);
    iVa = diff(Va(idx,:,:));
    z = zeros(size(Va(1,1,:)));
    % *FIXME* hardcoded for two-ports
    iVaV = iV(:,idx_v,:).*iVa(:,idx_va,:);
    dzk = dzk + kfact.*iVaV;
end
dzk = dzk.*partial;

function dzk = calc_dzk_vccsd(Va,V,CONN,vals,params,ptype,kfact,s,partial,kthis)
% calculate sensitivities for vccsd-elements
dzk = 0;
N = size(Va,2); % number of ports/nodes
idx_v = reshape(repmat(1:N,[N 1]),[1 N*N]); % [1 1 2 2 3 3 .. ]
idx_va = repmat(1:N,[1 N]); % [1 2 3 1 2 3 .. ]
for l=1:size(CONN,1)
    idx = CONN(l,1:2:3);
    iV =  diff(V(idx,:,:));
    idx = CONN(l,2:2:4);
    iVa = diff(Va(idx,:,:));
    z = zeros(size(Va(1,1,:)));
    % *FIXME* hardcoded for two-ports
    iVaV = iV(:,idx_v,:).*iVa(:,idx_va,:);
    dzk = dzk + kfact.*iVaV;
end
% *FIXME* this code below only allows ONE VCCSD!
% find transconductance params
k_tau = [];k_g = [];
for k=1:length(vals)
    if strcmp(ptype{k},'VCCSD_TAU')
        k_tau = k;
    elseif strcmp(ptype{k},'VCCSD')
        k_g = k;
    end
end
% calculate partial transconductance derivatives
if strcmp(ptype{kthis},'VCCSD_TAU')
    % partial derivative with respect to tau
    local_partial = -s.*vals(k_g).*exp(-s.*vals(k_tau));
else
    % partial derivative with respect to g
    local_partial = exp(-s.*vals(k_tau));
end
dzk = dzk.*local_partial;
