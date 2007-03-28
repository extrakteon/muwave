function cOUT = PackMatrixReduce(cIN)
% Creates a 4-port matrix description from a 5-port representation.
% Created 02-01-10 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-10
% Created

INobj=measSP(cIN);

if get(INobj,'ports') == 5
    omega=2*pi*freq(INobj).';
    % Have to use 3-dim matrix operations to make it work on rectangular matrices.
    
    YA(1,1,:)=get(INobj,'Y11');
    YA(1,2,:)=get(INobj,'Y12');
    YA(1,3,:)=get(INobj,'Y13');
    YA(1,4,:)=get(INobj,'Y14');
    YA(2,1,:)=get(INobj,'Y21');
    YA(2,2,:)=get(INobj,'Y22');
    YA(2,3,:)=get(INobj,'Y23');
    YA(2,4,:)=get(INobj,'Y24');
    YA(3,1,:)=get(INobj,'Y31');
    YA(3,2,:)=get(INobj,'Y32');
    YA(3,3,:)=get(INobj,'Y33');
    YA(3,4,:)=get(INobj,'Y34');
    YA(4,1,:)=get(INobj,'Y41');
    YA(4,2,:)=get(INobj,'Y42');
    YA(4,3,:)=get(INobj,'Y43');
    YA(4,4,:)=get(INobj,'Y44');
    
    YB(1,1,:)=get(INobj,'Y15');
    YB(2,1,:)=get(INobj,'Y25');
    YB(3,1,:)=get(INobj,'Y35');
    YB(4,1,:)=get(INobj,'Y45');
    
    YC(1,1,:)=get(INobj,'Y51');
    YC(1,2,:)=get(INobj,'Y52');
    YC(1,3,:)=get(INobj,'Y53');
    YC(1,4,:)=get(INobj,'Y54');
    
    YD=get(INobj,'Y55');
    
    for k=1:length(omega)
        Y4P(:,:,k)=(YA(:,:,k)-YB(:,:,k)*([0 0 1 1]*YA(:,:,k)+YC(:,:,k))/(YD(k)+[0 0 1 1]*YB(:,:,k)))*inv(eye(4)+([0;0;1;1]*([0 0 1 1]*YA(:,:,k)+YC(:,:,k))/(YD(k)+[0 0 1 1]*YB(:,:,k))));
    end    
    
    Yspm=reshape(permute(Y4P,[3,1,2]),length(omega),4*4);
    INobj.Data=buildxp(xparam,Yspm,'Y',50);
    info=getInfo(INobj);
    info=strrep(info,'Package Matrix.','');
    INobj=setInfo(INobj,[info,'4-port Package Matrix. ']);
    cOUT=INobj;
else
    error('The input is not a valid package matrix with 5 ports');
end