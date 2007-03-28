function [d2_Z11,d2_Z21,d2_Z12,d2_Z22]=calc_d2z(x,val,params1,params2)
% CALC_D2Z calculate second order two-port Z-parameter sensitivity

% $Header$
% $Author: koffer $
% $Date: 2004-04-28 17:56:51 +0200 (Wed, 28 Apr 2004) $
% $Revision: 190 $ 
% $Log$
% Revision 1.1  2004/04/28 15:56:22  koffer
% Support for second order sensitivities
%
% Revision 1.2  2003/11/21 15:16:41  kristoffer
% *** empty log message ***
%
% Revision 1.1  2003/11/20 18:12:41  kristoffer
% *** empty log message ***
%

% inputs: x - mna-object
%         val - parameter/element values

% calculate nodal admittance matrix
Yxp = calc(x,val);
Y = get(Yxp,'arraymatrix');
NFREQ = length(Yxp);
N = x.nodes;

ports = ports(x);
NPORTS = size(ports,2);
I = zeros(N,size(ports,2));
for k=1:NPORTS
    if any(ports(:,k)==0);
        if ports(2,k)==0
            I(ports(1,k),k) = 1;
        else
            I(ports(1,k),k) = -1;
        end
    else    
        I(ports(:,k),k) = [1 -1];
    end
end    
% 
% % this is actually faster than doing a separate LU-decomposition and then
% % use the transposed matrices for finding the inverse of the adjoint

Z = Y\eye(N);
V = Z*I;
if x.reciprocal
    Va = V;
else
    Va = (Z.')*I;
end
     
% add zero volt reference
z = zeros(1,NPORTS,NFREQ);
Vb = [z;get(V,'mtrx')];
Vba = [z;get(Va,'mtrx')];

partials = x.partials;
ptypes = x.param_type;
conns = conn(x);
vals = x.val;
params = x.params;
Nz = zeros(1,N+1);
s=repmat(shiftdim(j*2*pi*freq(x),-2),[N N 1]);
e=ones(size(s));


% set up index vectors and delete any repeated terms
NP1 = length(params1);
NP2 = length(params2);
ridx = repmat(params1,[1 NP2]);
cidx = reshape(repmat(params2,[NP1 1]),[1 NP2*NP1]);
[void,idx]=unique(sum([(ridx.^2)' (cidx.^2)']'));
ridx=ridx(idx)';
cidx=cidx(idx)';

% calculate second order derivatives, loop through each pair of
% params1&params2
for k = 1:length(ridx)
    row = ridx(k);
    col = cidx(k);
    
    % second order system derivative
    d2T = build_d2t(row,col,conns([row col]),ptypes([row col]),val([row col]),partials([row col]),Nz,s,e,vals,ptypes);
    
    % first order system derivatives
    dT1 = build_dt(conns{row},ptypes{row},val(row),partials(row),Nz,s,e,vals,ptypes);
    dX1 = Z*dT1*V;
    if col == row
        dT2 = dT1;
        dX2 = dX1;
    else
        dT2 = build_dt(conns{col},ptypes{col},val(col),partials(col),Nz,s,e,vals,ptypes);
        dX2 = Z*dT2*V;
    end
    
    d2v = (Va.')*(d2T*V + dT1*dX2 + dT2*dX1);
    
    d2_Z11(row,col,:) = d2v(1,1);
    d2_Z21(row,col,:) = d2v(2,1);
    d2_Z12(row,col,:) = d2v(1,2);
    d2_Z22(row,col,:) = d2v(2,2);
    
    % Hessian is symmetric
    if col ~= row
        d2_Z11(col,row,:) = d2_Z11(row,col,:);
        d2_Z21(col,row,:) = d2_Z21(row,col,:);
        d2_Z12(col,row,:) = d2_Z12(row,col,:);
        d2_Z22(col,row,:) = d2_Z22(row,col,:);
    end

end

% convert to arraymatrixx
d2_Z11 = arraymatrix(d2_Z11);
d2_Z12 = arraymatrix(d2_Z12);
d2_Z21 = arraymatrix(d2_Z21);
d2_Z22 = arraymatrix(d2_Z22);

% RETURN

% LOCAL FUNCTIONS
%
function d2T = build_d2t(row,col,conn,ptype,val,partial,Nz,s,e,vals,ptypes)
% calculate element-specific second order derivative

d2t_elements = ismember(ptype,{'R','L','VCCSD','VCCSD_TAU'});
if any(d2t_elements)
    % we have a element with a second derivative
    if row == col
        % for the R and L only the "diagonal" terms is non-zero
        switch ptype{1}
            case 'R'
                d2x = arraymatrix(2/(val(1)^3)*e);
            case 'L'
                d2x = arraymatrix(2./(s*val(1)^3));
            case 'VCCSD'
                d2x = arraymatrix(0*e);
            case 'VCCSD_TAU'
                % *FIXME* this code only allows one VCCSD per circuit
                gm = vals(find(ismember(ptypes,'VCCSD')));
                d2x = arraymatrix(gm*(s).^2.*exp(-s*val(1)));
        end
    else
        % non diagonal second derivatives
        if isempty(setxor(ptype,{'VCCSD_TAU','VCCSD'}))
            % we have both parts of the delayed transconductance
            tau = val(find(ismember(ptype,'VCCSD_TAU')));
            d2x = arraymatrix(-s.*exp(-s*tau));
        else
            d2x = arraymatrix(0*e);   
        end
    end
else
    d2x = arraymatrix(0*e);
end

item = 1 + conn{1};
item_partial = partial(1);
switch size(item,2)
    case 2
        d2T = 0;
        for p = 1:size(item,1)
            x = Nz;
            x(item(p,:)) = [1 -1];
            x(1) = []; % delete zero reference;
            % for some reason the d2T should be negative
            d2T = d2T - item_partial^2*d2x.*sparse(x'*x);
        end
    case 4
        d2T = 0;
        for p = 1:size(item,1)
            x_ctrl = Nz;
            x_ctrl(item(p,1:2:4)) = [1 -1];
            x_ctrl(1) = [];
            x_source = Nz;
            x_source(item(p,2:2:4)) = [1 -1];
            x_source(1) = [];
            % for some reason the d2T should be negative
            d2T = d2T - item_partial^2*d2x.*sparse(x_source.'*x_ctrl);
        end
    otherwise
        error('Not implemented.');
end

function dT = build_dt(conn,ptype,val,partial,Nz,s,e,vals,ptypes)
item = 1 + conn;
% calculate element-specific partial derivative
switch ptype
    case 'R'
        dx = arraymatrix(-1/(val^2)*e);
    case {'G','VCCS'}
        dx = arraymatrix(e);
    case 'C'
        dx = arraymatrix(s);
    case 'L'
        dx = arraymatrix(-1./(s*(val^2)));
    case 'VCCSD'
        % *FIXME* this only works for one VCCSD per circuit
        tau = vals(find(ismember(ptypes,'VCCSD_TAU')));
        dx = arraymatrix(exp(-s.*tau));
    case 'VCCSD_TAU'
        dx = arraymatrix(-s.*exp(-s*val));
    otherwise
        error('Not implemented.');
end

switch size(item,2)
    case 2
        dT = 0;
        for p = 1:size(item,1)
            x = Nz;
            x(item(p,:)) = [1 -1];
            x(1) = []; % delete zero reference;
            dT = dT + partial*dx.*sparse(x'*x);
        end
    case 4
        dT = 0;
        for p = 1:size(item,1)
            x_ctrl = Nz;
            x_ctrl(item(p,1:2:4)) = [1 -1];
            x_ctrl(1) = [];
            x_source = Nz;
            x_source(item(p,2:2:4)) = [1 -1];
            x_source(1) = [];
            dT = dT + partial*dx.*sparse(x_source.'*x_ctrl);
        end
    otherwise
        error('Not implemented.');
end

