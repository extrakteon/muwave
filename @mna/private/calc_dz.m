function dz = calc_dz(Va,V,x,paramlist)
%CALC_DZ Calculates Z-sensitivities given branch voltages

% $Header$
% $Author: koffer $
% $Date: 2004-05-11 16:16:38 +0200 (Tue, 11 May 2004) $
% $Revision: 194 $ 
% $Log$
% Revision 1.4  2004/05/11 14:16:14  koffer
% bugfix
%

% retrieve connection and element vectors from mna-object
conn = conn(x);
ptype = type(x);
val = val(x);
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
            dz(:,m,:) = calc_dzk_adm(Va,V,1+conn{k},val(k),-kfact,partials(k));
        case 'C'
            dz(:,m,:) = calc_dzk_adm(Va,V,1+conn{k},val(k),-ksfact,partials(k));
        case 'L'
            dz(:,m,:) = calc_dzk_imp(Va,V,1+conn{k},val(k),ksfact,partials(k));
        case 'R'
            dz(:,m,:) = calc_dzk_imp(Va,V,1+conn{k},val(k),kfact,partials(k));
        case 'VCCS'
            dz(:,m,:) = calc_dzk_vccs(Va,V,1+conn{k},val(k),-kfact,partials(k));
        case {'VCCSD','VCCSD_TAU'}
            dz(:,m,:) = calc_dzk_vccsd(Va,V,1+conn{k},val,params,ptype,-kfact,s,partials(k),k);
        otherwise
            disp(sprintf('%s not implemented!',ptype{k}));
    end
end

function dzk = calc_dzk_adm(Va,V,conn,val,kfact,partial)
% calculate sensitivities for admittance-elements
dzk = 0;
for l=1:size(conn,1)
    idx = conn(l,:);
    iVa = diff(Va(idx,:,:));
    iV = diff(V(idx,:,:));
    % *FIXME* hardcoded for two-ports
    iVaV = iV(:,[1 1 2 2],:).*iVa(:,[1 2 1 2],:);
    dzk = dzk + kfact.*iVaV;
end
dzk = dzk.*partial;
            
function dzk = calc_dzk_imp(Va,V,conn,val,kfact,partial)
% calculate sensitivities for impedance-elements
dzk = 0;
for l=1:size(conn,1)
    idx = conn(l,:);
    iVa = diff(Va(idx,:,:));
    iV =  diff(V(idx,:,:));
    % *FIXME* hardcoded for two-ports
    iVaV = iV(:,[1 1 2 2],:).*iVa(:,[1 2 1 2],:);
    dzk = dzk + kfact.*iVaV./((val*kfact).^2);
end
dzk = dzk./partial;

function dzk = calc_dzk_vccs(Va,V,conn,val,kfact,partial)
% calculate sensitivities for vccs-elements
dzk = 0;
for l=1:size(conn,1)
    idx = conn(l,1:2:3);
    iV =  diff(V(idx,:,:));
    idx = conn(l,2:2:4);
    iVa = diff(Va(idx,:,:));
    z = zeros(size(Va(1,1,:)));
    % *FIXME* hardcoded for two-ports
    iVaV = iV(:,[1 1 2 2],:).*iVa(:,[1 2 1 2],:);
    dzk = dzk + kfact.*iVaV;
end
dzk = dzk.*partial;

function dzk = calc_dzk_vccsd(Va,V,conn,vals,params,ptype,kfact,s,partial,kthis)
% calculate sensitivities for vccsd-elements
dzk = 0;
for l=1:size(conn,1)
    idx = conn(l,1:2:3);
    iV =  diff(V(idx,:,:));
    idx = conn(l,2:2:4);
    iVa = diff(Va(idx,:,:));
    z = zeros(size(Va(1,1,:)));
    % *FIXME* hardcoded for two-ports
    iVaV = iV(:,[1 1 2 2],:).*iVa(:,[1 2 1 2],:);
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
