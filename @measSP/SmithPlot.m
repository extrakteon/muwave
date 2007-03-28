function smithplot(varargin)
%SMITHPLOT  Plot one or more two-port measSP objects in the Smith Chart.
%   SMITHPLOT(MSP1) plots the two-port S-parameters of MSP1 in a Smith chart.
%   SMITHPLOT(MSP1,MSP2,MSP3...) plots several meassp objects in the same plot using 
%   different colors. 
%
%   See also: PARAMPLOT

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2004-10-21 00:25:32 +0200 (Thu, 21 Oct 2004) $
% $Revision: 220 $ 
% $Log$
% Revision 1.5  2004/10/20 22:24:51  fager
% Help comments added
%

nin=nargin;
Xin=varargin;
S11vect=[];
S12vect=[];
S21vect=[];
S22vect=[];

for k=1:nin
    vl(k)=length(Xin{k});    
end
maxlen = max(vl);

for k=1:nin
    if ~isa(Xin{k},'measSP')
        error('Wrong input argument');
    end
    x = abs(maxlen-length(Xin{k}));
    if x == 0
        pad = [];
    else
        pad = repmat(NaN,[x,1]);
    end
    S11vect=cat(2,S11vect,[get(Xin{k},'S11');pad]);
    S12vect=cat(2,S12vect,[get(Xin{k},'S12');pad]);
    S21vect=cat(2,S21vect,[get(Xin{k},'S21');pad]);
    S22vect=cat(2,S22vect,[get(Xin{k},'S22');pad]);
end

subplot(2,2,1);
smiplot(S11vect);
title('S_1_1');

subplot(2,2,2);
smipolar(S12vect);
title('S_1_2');

subplot(2,2,3);
smipolar(S21vect);
title('S_2_1');

subplot(2,2,4);
smiplot(S22vect);
title('S_2_2');