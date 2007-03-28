function cOUT = Package(cIN,varargin)
% Creates a 5-port matrix description of the standard HEMT package that
% can be used with the DeEmbed and Embed functions.
% see. Rorsman et.al, "Accurate high-frequency modeling of HFET...", MTT
% Created 02-01-06 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-06
% Created

property_argin = varargin;
INclass=measSP(cIN);

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
	fnames=fieldnames(varargin{2});
	if all(ismember(fnames,params))
		for k=1:length(fnames)
			P=setfield(P,fnames{k},getfield(varargin{2},fnames{k}));
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
            elseif strcmp(prop,'Ports') & ismember(val,[4,5])
                PackPorts=val;
            else
				warning(['Unknown/erroneous property: "',prop,'".']);
			end
		end
	end
	cOUT=INclass;
else
	error('Inproper number of input arguments');
end
omega=2*pi*freq(INclass).';

sp=empty(spmatrix,7,length(omega));
YP=xparam(sp+1e-15,'Y',50);
YP.Y16=-1./(j*omega*P.Lg);
YP.Y11=-YP.Y16+j*omega*P.Cpg/2;

YP.Y27=-1./(j*omega*P.Ld);
YP.Y22=-YP.Y27+j*omega*P.Cpd/2;

YP.Y36=-1/P.Rg*ones(size(omega));
YP.Y33=-YP.Y36;

YP.Y47=-1/P.Rd*ones(size(omega));
YP.Y44=-YP.Y47;

YP.Y55=1./(P.Rs+j*omega*P.Ls);

YP.Y61=YP.Y16;
YP.Y63=YP.Y36;
YP.Y67=-j*omega*P.Cpgd;
YP.Y66=-YP.Y61-YP.Y63-YP.Y67+j*omega*P.Cpg/2;

YP.Y72=YP.Y27;
YP.Y74=YP.Y47;
YP.Y76=YP.Y67;
YP.Y77=-YP.Y72-YP.Y74-YP.Y76+j*omega*P.Cpd/2;

% The internal nodes are removed after converting to Z-parameters

ZP7=convert(YP,'Z');
ZP6=skip(ZP7,[7 7]);
ZP5=skip(ZP6,[6 6]);

YP5=convert(ZP5,'Y');

INclass=setInfo(INclass,[getInfo(INclass),'Package Matrix. ']);
INclass.Data=YP5;
cOUT=INclass;


% 
% for k=1:length(omega)
% 	Ztemp=inv(Y(:,:,k));
% 	Ztemp(6:7,:)=[];
% 	Ztemp(:,6:7)=[];
% 	YPack(:,:,k)=inv(Ztemp);
% end
% 
% % Convert the 5 node-admittance matrix into 4 port-admittance-matrix
% 
% YA=YPack(1:4,1:4,:);
% YB=YPack(1:4,5,:);
% YC=YPack(5,1:4,:);
% YD=YPack(5,5,:);
% 
% for k=1:length(omega)
% 	Ya=YA(:,:,k);
% 	Yb=YB(:,:,k);
% 	Yc=YC(:,:,k);
% 	Yd=YD(:,:,k);
% 	YPackage(:,:,k)=(Ya-(Yb*([0 0 1 1]*Ya+Yc))/(Yd+[0 0 1 1]*Yb))*inv(eye(4)+[0;0;1;1]*([0,0,1,1]*Ya+Yc)/(Yd+[0 0 1 1]*Yb));
% end

% Test