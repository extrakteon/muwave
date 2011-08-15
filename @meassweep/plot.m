function val=plot(cIN,indepvar,depvar)
%PLOT Plot parameters of a meassweep object versus sweep parameters.
%   PLOT(MSWP,'Vgs','Ids') plots Ids versus Vgs for the measurements in MSWP.
%
%   See also: GET

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2004-10-20 19:01:34 +0200 (Wed, 20 Oct 2004) $
% $Revision: 218 $ 
% $Log$
% Revision 1.2  2004/10/20 16:58:36  fager
% Help comments added
%

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
