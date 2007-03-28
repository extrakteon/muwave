%
% XPARAM
% 
% Class for handling S,Z,Y and T-parameters
%
% CHANGES:
% 2002-01-07, Kristoffer Andersson
%             First version
%
% Overloads method eq, eg A == B
% Returns true if A and B have equal 'dimensions'.
function iseq = eq(a,b)

a = xparam(a);
b = xparam(b);

eq_ports = get(a,'ports') == get(b,'ports');
eq_elements = get(a,'elements') == get(b,'elements');
eq_reference = get(a,'reference') == get(b,'reference');
eq_type = get(a,'type') == get(b,'type');

iseq = eq_ports & eq_elements & eq_reference & eq_type;