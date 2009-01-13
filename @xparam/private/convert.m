function l = convert(data, to_type)
% CONVERT converts between different port-parameters
%
% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.11  2005/06/27 21:18:12  fager
% Now supporting wave cascade parameters: W
%
% Revision 1.10  2005/05/11 10:18:28  fager
% Compability with new version of xparam
%
% Revision 1.9  2005/04/27 21:32:43  fager
% Now allows also small letters, i.e. both s11 and S11
%
% Revision 1.8  2004/10/27 10:39:05  koffer
% Bugfix. Exchanged ident(XP) for eye(get(XP,'ports')).
%
% Revision 1.7  2003/07/22 14:58:58  kristoffer
% no message
%

switch upper(to_type),
 case 'S',
  % to S ...
  l = x2s(data);
 case 'Z',
  % to Z ...
  l = x2z(data);
 case 'Y',
  % to Y ...
  l = x2y(data);
 case 'T'
  if get(data,'ports') == 2
    l = x2t(data);
  else
    error('XPARAM.CONVERT: ABCD-parameters only defined for two-ports.');  
  end
 case 'W'
  if get(data,'ports') == 2
    l = x2w(data);
  else
    error('XPARAM.CONVERT: Wave cascade parameters only defined for two-ports.');  
  end
 otherwise
    error('XPARAM.CONVERT: Unknown target parameter.');
end


%
% Internal functions
%

function l = x2s(data);
from_type = data.type;
switch from_type,
 case 'S',
  % from S
  l = xparam(data);
 case 'Z',
  % from Z
  l = z2s(data);
 case 'Y',
  % from Y
  l = y2s(data);
 case 'T',
  % from T
  l = t2s(data); 
 case 'W',
  % from W
  l = w2s(data); 
end

function l = x2z(data);
from_type = data.type;
switch from_type,
 case 'S',
  % from S
  l = s2z(data);
 case 'Z',
  % from Z
  l = xparam(data);
 case 'Y',
  % from Y
  l = y2z(data);
 case 'T',
  % from T
  l = t2z(data);  
case 'W',
  % from W
  ltemp = w2s(data);
  l = s2z(ltemp);
end

function l = x2y(data);
from_type = data.type;
switch from_type,
 case 'S',
  % from S
  l = s2y(data);
 case 'Z',
  % from Z
  l = z2y(data);
 case 'Y',
  % from Y
  l = xparam(data);
 case 'T',
  % from T
  l = t2y(data); 
 case 'W',
  % from W
  ltemp = w2s(data);
  l = s2y(ltemp);
end


function l = x2t(data);
from_type = data.type;
switch from_type,
 case 'S',
  % from S
  l = s2t(data);
 case 'Z',
  % from Z
  l = z2t(data);
 case 'Y',
  % from Y
  l = y2t(data);
 case 'T',
  % from T
  l = xparam(data); 
 case 'W',
  % from W
  ltemp = w2s(data);
  l = s2t(ltemp);
end


function l = x2w(data);
from_type = data.type;
switch from_type,
    case 'S',
        % from S
        l = s2w(data);
    case 'W',
        % from W
        l = xparam(data);
    otherwise
        eval(strcat('ltemp = ',lower(from_type),'2s(data);'));
        l = s2w(ltemp);
end

%
% S -> Z
%
function l = s2z(data);
l = xparam(data);
I = eye(get(data,'ports'));
x = data.reference * (I + data.data) * inv(I - data.data); % Gonzales eq:1.8.3, pp 61
l = xparam(x,'Z',data.reference,data.freq,data.datacov);
%
%
%

%
% S -> Y
%
function l = s2y(data);
l = xparam(data);
I = eye(get(data,'ports'));
x = 1/data.reference * (I - data.data) * inv(I + data.data);
l = xparam(x,'Y',data.reference,data.freq,data.datacov);
%
%
%

%
% S -> T
%
function l = s2t(data);
l = xparam(data);
m = get(data,'mtrx');
s11 = squeeze(m(1,1,:));
s12 = squeeze(m(1,2,:));
s21 = squeeze(m(2,1,:));
s22 = squeeze(m(2,2,:));
z0 = get(data,'reference');
T(1,1,:) = ((1 + s11).*(1 - s22) + s12.*s21)./(2*s21);
T(1,2,:) = z0*((1 + s11).*(1 + s22) - s12.*s21)./(2*s21);
T(2,1,:) = 1/z0*((1 - s11).*(1 - s22) - s12.*s21)./(2*s21);
T(2,2,:) = ((1 - s11).*(1 + s22) + s12.*s21)./(2*s21);
l = xparam(T,'T',z0,data.freq,data.datacov);
%
%
%

%
% S -> W
%
function l = s2w(data);
l = xparam(data);
m = get(data,'mtrx');
s11 = squeeze(m(1,1,:));
s12 = squeeze(m(1,2,:));
s21 = squeeze(m(2,1,:));
s22 = squeeze(m(2,2,:));
z0 = get(data,'reference');

% Use special formulas that work for devices with negligible transmission.

warning('off','MATLAB:divideByZero');
ix = find(abs(s21)<1e-6);
if ~isempty(ix),warning('matlab_milou:ZeroTransCascade','Small transmission device - Using normalized cascade matrices.');end
W1(1,1,:) = (s12.*s21-s11.*s22)./s21;
W2(1,1,:) = -s11.*s22;

W1(1,2,:) = s11./s21;
W2(1,2,:) = s11;

W1(2,1,:) = -s22./s21;
W2(2,1,:) = -s22;

W1(2,2,:) = 1./s21;
W2(2,2,:) = ones(size(s11));

W = W1;
W(:,:,ix) = W2(:,:,ix);
l = xparam(W,'W',z0,data.freq,data.datacov);

warning('on','MATLAB:divideByZero');
%
%
%

%
% Z -> S
%
function l = z2s(data);
l = xparam(data);
I = eye(get(data,'ports'));
x = inv(data.data + data.reference*I) * (data.data - data.reference*I);
l = xparam(x,'S',data.reference,data.freq,data.datacov);

%
% Z -> Y
%
function l = z2y(data);
l = xparam(data);
x = inv(data.data);
l = xparam(x,'Y',data.reference,data.freq,data.datacov);
%
%
%

%
% Z -> T
%
function l = z2t(data);
l = xparam(data);
m = get(data,'mtrx');
z11 = squeeze(m(1,1,:));
z12 = squeeze(m(1,2,:));
z21 = squeeze(m(2,1,:));
z22 = squeeze(m(2,2,:));
T(1,1,:) = z11./z21;
T(1,2,:) = (z11.*z22 - z12.*z21)./z21;
T(2,1,:) = 1./z21;
T(2,2,:) = z22./z21;
l = xparam(T,'T',data.reference,data.freq,data.datacov);

%
%
%

%
% Y -> S
%
function l = y2s(data);
l = xparam(data);
I = eye(get(data,'ports'));
x = -1 * inv(data.data + 1/data.reference*I) * (data.data - 1/data.reference*I); 
l = xparam(x,'S',data.reference,data.freq,data.datacov);
%
%
%

%
% Y -> Z
%
function l = y2z(data);
l = xparam(data);
x = inv(data.data);
l = xparam(x,'Z',data.reference,data.freq,data.datacov);

%
% Y -> T
%
function l = y2t(data);
l = xparam(data);
m = get(data,'mtrx');
y11 = squeeze(m(1,1,:));
y12 = squeeze(m(1,2,:));
y21 = squeeze(m(2,1,:));
y22 = squeeze(m(2,2,:));
T(1,1,:) = -y22./y21;
T(2,1,:) = -(y11.*y22 - y12.*y21)./y21;
T(1,2,:) = -1./y21;
T(2,2,:) = -y11./y21;
l = xparam(T,'T',data.reference,data.freq,data.datacov);

%
%
%

%
% T -> Z
%
function l = t2z(data);
l = xparam(data);
m = get(data,'mtrx');
a = squeeze(m(1,1,:));
b = squeeze(m(1,2,:));
c = squeeze(m(2,1,:));
d = squeeze(m(2,2,:));
Z(1,1,:) = a./c;
Z(1,2,:) = (a.*d - b.*c)./c;
Z(2,1,:) = 1./c;
Z(2,2,:) = d./c;
l = xparam(Z,'Z',data.reference,data.freq,data.datacov);
%
%
%

%
% T -> S
%
function l = t2s(data);
l = xparam(data);
z0 = get(data,'reference');
m = get(data,'mtrx');
a = squeeze(m(1,1,:));
b = squeeze(m(1,2,:))/z0;
c = squeeze(m(2,1,:))*z0;
d = squeeze(m(2,2,:));
sum = a + b + c + d;
S(1,1,:) = (a + b - c - d)./sum;
S(1,2,:) = 2*(a.*d - b.*c)./sum;
S(2,1,:) = 2./sum;
S(2,2,:) = (-a + b - c + d)./sum;
l = xparam(S,'S',data.reference,data.freq,data.datacov);
%
%
%


%
% T -> Y
%
function l = t2y(data);
l = xparam(data);
m = get(data,'mtrx');
a = squeeze(m(1,1,:));
b = squeeze(m(1,2,:));
c = squeeze(m(2,1,:));
d = squeeze(m(2,2,:));
Y(1,1,:) = d./b;
Y(1,2,:) = -(a.*d-b.*c)./b;
Y(2,1,:) = -1./b;
Y(2,2,:) = a./b;
l = xparam(Y,'Y',data.reference,data.freq,data.datacov);
%
%
%

%
% W -> S
%
function l = w2s(data);
l = xparam(data);
m = get(data,'mtrx');
w11 = squeeze(m(1,1,:));
w12 = squeeze(m(1,2,:));
w21 = squeeze(m(2,1,:));
w22 = squeeze(m(2,2,:));
z0 = get(data,'reference');

S(1,1,:) = w12./w22;
S(1,2,:) = w11 - w12.*w21./w22;
S(2,1,:) = 1./w22;
S(2,2,:) = -w21./w22;
l = xparam(S,'S',z0,data.freq,data.datacov);
%