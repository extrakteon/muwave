function l = convert(data, to_type)
% CONVERT converts between different port-parameters
%
% $Header$
% $Author: koffer $
% $Date: 2004-10-27 12:39:05 +0200 (Wed, 27 Oct 2004) $
% $Revision: 229 $ 
% $Log$
% Revision 1.8  2004/10/27 10:39:05  koffer
% Bugfix. Exchanged ident(XP) for eye(get(XP,'ports')).
%
% Revision 1.7  2003/07/22 14:58:58  kristoffer
% no message
%

switch to_type,
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
end


%
% S -> Z
%
function l = s2z(data);
l = xparam(data);
I = eye(get(data,'ports'));
l.data = data.reference * (I + data.data) * inv(I - data.data); % Gonzales eq:1.8.3, pp 61
l.type = 'Z';
%
%
%

%
% S -> Y
%
function l = s2y(data);
l = xparam(data);
I = eye(get(data,'ports'));
l.data = 1/data.reference * (I - data.data) * inv(I + data.data);
l.type = 'Y';
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
l = xparam(T,'T');
%
%
%


%
% Z -> S
%
function l = z2s(data);
l = xparam(data);
I = eye(get(data,'ports'));
l.data = inv(data.data + data.reference*I) * (data.data - data.reference*I);
l.type = 'S';

%
% Z -> Y
%
function l = z2y(data);
l = xparam(data);
l.data = inv(data.data);
l.type = 'Y';
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
l = xparam(T,'T');
%
%
%

%
% Y -> S
%
function l = y2s(data);
l = xparam(data);
I = eye(get(data,'ports'));
l.data = -1 * inv(data.data + 1/data.reference*I) * (data.data - 1/data.reference*I); 
l.type = 'S';
%
%
%

%
% Y -> Z
%
function l = y2z(data);
l = xparam(data);
l.data = inv(data.data);
l.type = 'Z';

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
l = xparam(T,'T');
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
l = xparam(Z,'Z');
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
l = xparam(S,'S');
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
l = xparam(Y,'Y');
%
%
%
