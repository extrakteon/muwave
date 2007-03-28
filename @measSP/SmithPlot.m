function smithplot(varargin)
%SMITHPLOT  Plot one or more two-port measSP objects in the Smith Chart.

% $Header$
% $Author: fager $
% $Date: 2003-07-18 15:51:11 +0200 (Fri, 18 Jul 2003) $
% $Revision: 93 $ 
% $Log$
% Revision 1.4  2003/07/18 13:51:10  fager
% Matlab-standardized help and CVS-logging added.
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
