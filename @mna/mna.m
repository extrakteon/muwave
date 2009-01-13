function l = mna(n)
%
% MNA
% 
% Class for building Y-matrices from netlists
%
%

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.9  2004/04/28 15:55:31  koffer
% no message
%
%

if nargin == 0
    n = 1;
end
p.nodes = n; % number of nodes in circuit
p.f = []; % frequency vector
p.params = []; % parameter names
p.partials = []; % cell vector containing partial derivatives with respect to parameters
p.param_type = []; % type of each parameter
p.param_conn = []; % node connection of each parameter
p.val = []; % parameter values
p.Y = []; % symbolic nodal admittance matrix
p.map = []; % boolean 3D-matirx map of parameters
p.Yc = []; % numeric nodal admittance matrix
p.ports = []; % matrix holding port definitions in each column
p.valid_calc = false; % status flag
p.reciprocal = true; % is the circuit reciprocal
l = class(p, 'mna');
l = inity(l);