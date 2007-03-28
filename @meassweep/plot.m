function val=plot(cIN,indepvar,depvar)
% Method to plot parameters of a meassweep object.

% Version 1.0
% Created 02-01-04 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-08
% Created.


ivar=get(cIN,indepvar).';
var=get(cIN,depvar).';

if ~isempty(ivar) & ~isempty(var)

[Y,I]=sortrows([ivar,var],1);

ivarunique=unique(Y(:,1));
var_mtrx=reshape(Y(:,2),[],length(ivarunique)).';
plot(ivarunique.',var_mtrx.')
xlabel(indepvar)
ylabel(depvar)
else
    error('The parameters may not be empty!');
end
