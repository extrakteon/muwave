function cOUT = interp(cIN,fout,prop)
%INTERP Interpolate S-parameter measurements.
%   M = subset(M,f) returns an measSP object with the new frequency vector
%   defined in f1. Extrapolation/interpolation is used to cover the entire
%   range in f1.
%
%   M = subset(M,v,prop) returns an measSP object with the new
%   vector of property-values replaced by v.
%

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2004-10-21 00:25:32 +0200 (Thu, 21 Oct 2004) $
% $Revision: 220 $ 
% $Log$
% Revision 1.2  2004/10/20 22:23:23  fager
% Help comments added
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
