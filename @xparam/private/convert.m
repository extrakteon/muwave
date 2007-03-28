%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
% CHANGES:
% 2002-01-03, Kristoffer Andersson
%             Major rewrite version
%

%
% Convert to specified parameter type
%
function l = convert(data, to_type)

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
end

%
% S -> Z
%
function l = s2z(data);
l = xparam(data);
I = ident(l.data);
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
I = ident(l.data);
l.data = 1/data.reference * (I - data.data) * inv(I + data.data);
l.type = 'Y';
%
%
%

%
% Z -> S
%
function l = z2s(data);
l = xparam(data);
I = ident(l.data);
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
% Y -> S
%
function l = y2s(data);
l = xparam(data);
I = ident(l.data);
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









