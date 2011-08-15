function [H]=sens2(xmna,val,params1,params2,Z,dZ,g)
% SENS2 basic second-order sensitivity

% $Header$
% $Author: koffer $
% $Date: 2004-04-28 17:56:51 +0200 (Wed, 28 Apr 2004) $
% $Revision: 190 $ 
% $Log$
% Revision 1.3  2004/04/28 15:55:54  koffer
% Support for second order sensitivities
%
%

[h11,h12,h21,h22]=d2sdz2(Z);
[d2_Z11,d2_Z21,d2_Z12,d2_Z22]=calc_d2z(xmna,val,params1,params2);

% arrange the tensor
% perhaps this should be moved to some other place
M11=get(d2_Z11,'mtrx');
M12=get(d2_Z12,'mtrx');
M21=get(d2_Z21,'mtrx');
M22=get(d2_Z22,'mtrx');
G=get(g,'mtrx');
g11=arraymatrix(G(1,:,:));
g12=arraymatrix(G(2,:,:));
g21=arraymatrix(G(3,:,:));
g22=arraymatrix(G(4,:,:));

% set up indeval vectors and delete any repeated terms
NP1 = length(params1);
NP2 = length(params2);
ridx = repmat(params1,[1 NP2]);
cidx = reshape(repmat(params2,[NP1 1]),[1 NP2*NP1]);
[void,idx]=unique(sum([(ridx.^2)' (cidx.^2)']'));
ridx=ridx(idx)';
cidx=cidx(idx)';
% loop through all parameter pairs
% this loop is identical to that in calc_d2z
for k=1:length(ridx)
    row=ridx(k);
    col=cidx(k);
    t=[];
    t(1,1,:)=M11(row,col,:);
    t(2,1,:)=M12(row,col,:);
    t(3,1,:)=M21(row,col,:);
    t(4,1,:)=M22(row,col,:);
    t=arraymatrix(t);
    g_H11(row,col,:)=get(g11*t,'mtrx');
    g_H12(row,col,:)=get(g12*t,'mtrx');
    g_H21(row,col,:)=get(g21*t,'mtrx');
    g_H22(row,col,:)=get(g22*t,'mtrx');
    if row==col
        g_H11(col,row,:)=g_H11(row,col,:);
        g_H12(col,row,:)=g_H12(row,col,:);
        g_H21(col,row,:)=g_H21(row,col,:);
        g_H22(col,row,:)=g_H22(row,col,:);
    end    
end

% calculate Hessians using chain rule
H{1,1} = arraymatrix(dZ'*h11*dZ + g_H11);
H{1,2} = arraymatrix(dZ'*h12*dZ + g_H12);
H{2,1} = arraymatrix(dZ'*h21*dZ + g_H21);
H{2,2} = arraymatrix(dZ'*h22*dZ + g_H22);

