%
% MNA
% 
% Class for building Y-matrices from netlists
%
%

function l = mna(n)
    if nargin == 0
        n = 1;
    end
    p.nodes = n;
    p.f = [];
    p.params = [];
    p.Y = [];
    l = class(p, 'mna');
    l = inity(l);