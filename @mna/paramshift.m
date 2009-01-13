function mna_out = paramshift(mna_in,order)
% MNA/PARAMSHIFT   Reorder parameters of an MNA object
%
% Usage: mna_out = paramshift(mna_in,[1 3 2]);
%
% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.5  2004/09/27 12:38:50  SYSTEM
% Fixed a bug introduced in previous version
%
% Revision 1.4  2004/09/17 14:19:41  ferndahl
%

mna_out = mna_in;
mna_out.params = mna_in.params(order);
mna_out.map = mna_out.map(:,:,order);
mna_out.param_type = mna_in.param_type(order); % type of each parameter
mna_out.partials = mna_in.partials(order);
mna_out.param_conn = mna_in.param_conn(order);
if ~isempty(mna_out.val)
    mna_out.val = mna_in.val(order);
end
mna_out.valid_calc = false;
