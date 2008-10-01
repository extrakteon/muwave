function cOUT = deembed(cIN,Packobj)
% DEEMBED Deembed extrinsic to intrinsic data using a package matrix description.
%   SP = DEEMBED(MSP,PACKMTRX) deembeds the S-parameter data in MSP using a four- or 
%   five port representation of the embedding package. 
%   
%   Example:
%       intr = Deembed(extrinsic,fet_package)
%
%   See also HEMTPACKAGE, PACKAGE, PACKMATRIXREDUCE

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header: /milou/matlab_milou/@measSP/Deembed.m,v 1.3 2005/04/27 21:33:01 fager Exp $
% $Author: fager $
% $Date: 2005/04/27 21:33:01 $
% $Revision: 1.3 $ 
% $Log: Deembed.m,v $

%


INobj=meassp(cIN);
Packobj=meassp(Packobj);
if get(INobj,'ports') ~= 2
    error('The Input object must have 2 ports');
end
% if any(freq(INobj) ~= freq(Packobj))
%     Packobj = Packobj(freq(INobj));
% end
if get(Packobj,'ports') == 5
    
    % Have to use 3-dim matrix operations to make it work on rectangular matrices.
    YE(1,1,:)=get(INobj,'Y11');
    YE(1,2,:)=get(INobj,'Y12');
    YE(2,1,:)=get(INobj,'Y21');
    YE(2,2,:)=get(INobj,'Y22');
    
    YEE(1,1,:)=get(Packobj,'Y11');
    YEE(1,2,:)=get(Packobj,'Y12');
    YEE(2,1,:)=get(Packobj,'Y21');
    YEE(2,2,:)=get(Packobj,'Y22');
    
    YEI(1,1,:)=get(Packobj,'Y13');
    YEI(1,2,:)=get(Packobj,'Y14');
    YEI(2,1,:)=get(Packobj,'Y23');
    YEI(2,2,:)=get(Packobj,'Y24');
    
    YEC(1,1,:)=get(Packobj,'Y15');
    YEC(2,1,:)=get(Packobj,'Y25');
    
    YIE(1,1,:)=get(Packobj,'Y31');
    YIE(1,2,:)=get(Packobj,'Y32');
    YIE(2,1,:)=get(Packobj,'Y41');
    YIE(2,2,:)=get(Packobj,'Y42');
    
    YII(1,1,:)=get(Packobj,'Y33');
    YII(1,2,:)=get(Packobj,'Y34');
    YII(2,1,:)=get(Packobj,'Y43');
    YII(2,2,:)=get(Packobj,'Y44');
    
    YIC(1,1,:)=get(Packobj,'Y35');
    YIC(2,1,:)=get(Packobj,'Y45');
    
    YCE(1,1,:)=get(Packobj,'Y51');
    YCE(1,2,:)=get(Packobj,'Y52');
    
    YCI(1,1,:)=get(Packobj,'Y53');
    YCI(1,2,:)=get(Packobj,'Y54');
    
    YCC=get(Packobj,'Y55');
    
    for k=1:length(INobj)
        A=([1 1]*YIE(:,:,k)+YCE(:,:,k))/(YCC(k)+[1 1]*YIC(:,:,k));
        B=([1 1]*YII(:,:,k)+YCI(:,:,k))/(YCC(k)+[1 1]*YIC(:,:,k));
        C=inv(YEI(:,:,k)-YEC(:,:,k)*B)*(YE(:,:,k)+YEC(:,:,k)*A-YEE(:,:,k));
        YI(:,:,k)=(YIC(:,:,k)*(A+B*C)-YII(:,:,k)*C-YIE(:,:,k))*inv([1;1]*A+(eye(2)+[1;1]*B)*C);
    end    
    Yspm=reshape(permute(YI,[3,1,2]),length(INobj),[]);
    INobj.data=buildxp(xparam,Yspm,'Y',50,freq(INobj));
    INobj=set(INobj,'Info',[get(INobj,'Info'),' Deembedded data.']);
    cOUT=INobj;
elseif get(Packobj,'ports') == 4 
    
    % Have to use 3-dim matrix operations to make it work on rectangular matrices.
    YE(1,1,:)=get(INobj,'Y11');
    YE(1,2,:)=get(INobj,'Y12');
    YE(2,1,:)=get(INobj,'Y21');
    YE(2,2,:)=get(INobj,'Y22');
    
    YEE(1,1,:)=get(Packobj,'Y11');
    YEE(1,2,:)=get(Packobj,'Y12');
    YEE(2,1,:)=get(Packobj,'Y21');
    YEE(2,2,:)=get(Packobj,'Y22');
    
    YEI(1,1,:)=get(Packobj,'Y13');
    YEI(1,2,:)=get(Packobj,'Y14');
    YEI(2,1,:)=get(Packobj,'Y23');
    YEI(2,2,:)=get(Packobj,'Y24');
    
    YIE(1,1,:)=get(Packobj,'Y31');
    YIE(1,2,:)=get(Packobj,'Y32');
    YIE(2,1,:)=get(Packobj,'Y41');
    YIE(2,2,:)=get(Packobj,'Y42');
    
    YII(1,1,:)=get(Packobj,'Y33');
    YII(1,2,:)=get(Packobj,'Y34');
    YII(2,1,:)=get(Packobj,'Y43');
    YII(2,2,:)=get(Packobj,'Y44');
    
    for k=1:length(INobj)
        YI(:,:,k)=YIE(:,:,k)*inv(YEE(:,:,k)-YE(:,:,k))*YEI(:,:,k)-YII(:,:,k);
    end    
    Yspm=reshape(permute(YI,[3,1,2]),length(INobj),[]);
    INobj.Data=buildxp(xparam,Yspm,'Y',50,freq(INobj));
    INobj=setInfo(INobj,[getInfo(INobj),' Deembedded data.']);
    cOUT=INobj;
    
else
    error('The package matrix must have 4 or 5 ports');
end