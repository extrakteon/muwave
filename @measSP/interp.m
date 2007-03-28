function cOUT = interp(cIN,fout,prop)
%INTERP Interpolate measurements.
%   M = subset(M,f) returns an measSP object with the new frequency vector
%   defined in f1. Extrapolation/interpolation is used to cover the entire
%   range in f1.
%
%   M = subset(M,v,prop) returns an measSP object with the new
%   vector of property-values replaced by v.

% $Header$
% $Author: fager $
% $Date: 2003-07-18 16:28:53 +0200 (Fri, 18 Jul 2003) $
% $Revision: 97 $ 
% $Log$
% Revision 1.1  2003/07/18 14:28:53  fager
% Initial.
%
% Revision 1.3  2003/07/18 07:54:04  fager
% msp.Data -> msp.data and error handling improved.
%
% Revision 1.2  2003/07/16 15:39:39  fager
% Updated for the new meassp class definitions.
%

cOUT=cIN;
if nargin == 2, prop = 'Freq'; end
fin = get(cIN,prop);
if length(fin) ~= length(cIN.data), error('Differrent lengths of independent parameter and data.'); end
cOUT=set(cOUT,prop,fout);
cOUT=set(cOUT,'Info',[get(cOUT,'Info'),' Interpolated ',prop,'.']);	% Add comment about that interpolation has been performed.
ports=get(cIN.data,'ports');
datatype=get(cIN.data,'type');
reference=get(cIN.data,'reference');
for col=1:ports	% The only way I could think of...
    for row=1:ports
        indexstr=upper([datatype,int2str(row),int2str(col)]);
        temp(:,row+(col-1)*ports)=interp1(fin,get(cIN.data,indexstr),fout,'spline','extrap').';
    end
end
cOUT.data=buildxp(xparam,temp,datatype,reference);
