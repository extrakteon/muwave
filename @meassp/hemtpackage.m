function cOUT = HEMTPackage(cIN,varargin)
%HEMTPACKAGE Creates 4-port HEMT package matrix representation.
%   P = HEMTPACKAGE(MSP,'Rg',0.4,'Lg',1e-10,...) creates a 4-port matrix description 
%   of the standard HEMT package that can be used with the DeEmbed and Embed functions.
%   see. Rorsman et.al, "Accurate high-frequency modeling of HFET...", MTT.
%   Allowed package parameters are (with default values in parenthesis): 
%   'Rg' (1e-3)
%   'Lg' (1e-15)
%   'Cpg' (0)
%   'Rs' (1e-3)
%   'Ls' (1e-15)
%   'Rd' (1e-3)
%   'Ld' (1e-15)
%   'Cpd' (0)
%   'Cpgd' (0)
%
%   See also: PACKAGE, PACKMATRIXREDUCE, DEEMBED, EMBED

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: koffer $
% $Date: 2006-08-18 06:47:51 +0200 (Fri, 18 Aug 2006) $
% $Revision: 306 $ 
% $Log$
% Revision 1.3  2005/04/27 21:37:12  fager
% * Changed from measSP to meassp.
%
% Revision 1.2  2004/10/20 22:23:13  fager
% Help comments added
%

property_argin = varargin;
INclass=meassp(cIN);

%Default values
P.Rg=1e-3;
P.Lg=1e-15;
P.Cpg=0;
P.Rs=1e-3;
P.Ls=1e-15;
P.Rd=1e-3;
P.Ld=1e-15;
P.Cpd=0;
P.Cpgd=0;

params={'Rg','Lg','Cpg','Rs','Ls','Rd','Ld','Cpd','Cpgd'};

if nargin == 2 	% The only input argument is supposed to be a structure with the model parameters
	fnames=fieldnames(varargin{1});
	if all(ismember(fnames,params))
		for k=1:length(fnames)
			P=setfield(P,fnames{k},getfield(varargin{1},fnames{k}));
		end	
	else
		error('The input structure does not have valid parameter names');
	end
	% Assume that the only input argument is a structure.
elseif nargin>2 & mod(nargin,2)==1   %set(cIN,'Prop1',val,'Prop2',val2,...)
	while length(property_argin) >= 2
		prop = property_argin{1};
		val = property_argin{2};
		property_argin = property_argin(3:end);
		switch prop
		case 'Freq',
			if isnumeric(val)
				INclass.State=set(INclass.State,'Freq',val);      
			else
				error('Frequencies must be numeric.');
			end
		otherwise,
			if ismember(prop,params) & isnumeric(val)
				P=setfield(P,prop,val);
			else
				warning(['Unknown/erroneous property: "',prop,'".']);
			end
		end
    end
else
	error('Inproper number of input arguments');
end
cOUT = INclass;
omega=2*pi*freq(INclass);

%sp=empty(spmatrix,7,length(omega));
%YP=xparam(sp+1e-15,'Y',50);

ix=inline('r+(c-1)*7');

YM=zeros(length(omega),7^2);
YM(:,ix(1,6))=-1./(j*omega*P.Lg);
YM(:,ix(1,1))=-YM(ix(1,6))+j*omega*P.Cpg/2;

YM(:,ix(2,7))=-1./(j*omega*P.Ld);
YM(:,ix(2,2))=-YM(:,ix(2,7))+j*omega*P.Cpd/2;

YM(:,ix(3,6))=-1/P.Rg*ones(size(omega));
YM(:,ix(3,3))=-YM(:,ix(3,6));

YM(:,ix(4,7))=-1/P.Rd*ones(size(omega));
YM(:,ix(4,4))=-YM(:,ix(4,7));

YM(:,ix(5,5))=1./(P.Rs+j*omega*P.Ls);

YM(:,ix(6,1))=YM(:,ix(1,6));
YM(:,ix(6,3))=YM(:,ix(3,6));
YM(:,ix(6,7))=-j*omega*P.Cpgd;
YM(:,ix(6,6))=-YM(:,ix(6,1))-YM(:,ix(6,3))-YM(:,ix(6,7))+j*omega*P.Cpd/2;

YM(:,ix(7,2))=YM(:,ix(2,7));
YM(:,ix(7,4))=YM(:,ix(4,7));
YM(:,ix(7,6))=YM(:,ix(6,7));
YM(:,ix(7,7))=-YM(:,ix(7,2))-YM(:,ix(7,4))-YM(:,ix(7,6))+j*omega*P.Cpg/2;

YP=buildxp(xparam,YM,'Y',50);

% The internal nodes are removed after converting to Z-parameters

ZP7=YP.Z;
ZP6=skip(ZP7,[7 7]);
ZP5=skip(ZP6,[6 6]);

cOUT = set(cOUT,'data',ZP5);