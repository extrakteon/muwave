function val=get(cIN,prop)
%GET Gets a specific measurement object property for each sweep object
%   P = GET(MSWP,'Prop') returns the measurement object property 'Prop' in P. 
%   Each sweep object results in a separate column in P.
%
%   See also: SET, ADD, PLOT

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2004-10-20 19:01:34 +0200 (Wed, 20 Oct 2004) $
% $Revision: 218 $ 
% $Log$
% Revision 1.3  2004/10/20 16:59:39  fager
% Help comments added
%

val=[];
INclass=meassweep(cIN);
if nargin~=2, error('Wrong number of input arguments');end
if ismember(prop,get(cIN.measmnt))
    val = get(cIN.measmnt,prop);
    return;
end
if strcmpi(prop,'data'), val=INclass.data; end
for k=1:length(cIN.data)
    val=cat(2,val,get(INclass.data{k},prop));
end