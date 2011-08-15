function logmplot(varargin)
%LOGMPLOT  Plot one or more two-port meassp objects in a logmag format.
%   LOGMPLOT(MSP1) plots the two-port S-parameters of MSP1 in a logmag format.
%   LOGMPLOT(MSP1,MSP2,MSP3...) plots several meassp objects in the same plot using 
%   different colors. 
%
%   See also: PARAMPLOT, SMITHPLOT

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: koffer $
% $Date: 2005-06-30 09:30:20 +0200 (Thu, 30 Jun 2005) $
% $Revision: 292 $ 
% $Log$
% Revision 1.1  2005/06/30 07:30:20  koffer
% All four S-parameters in LOGM-format. Similar to SMITHPLOT.
%
% Revision 1.6  2005/04/27 21:41:32  fager
% * Changed from measSP to meassp.
%
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
    if ~isa(Xin{k},'meassp')
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
freq = get(Xin{1},'freq');

subplot(2,2,1);
logmagplot(S11vect,freq);
title('S_1_1');

subplot(2,2,2);
logmagplot(S12vect,freq);
title('S_1_2');

subplot(2,2,3);
logmagplot(S21vect,freq);
title('S_2_1');

subplot(2,2,4);
logmagplot(S22vect,freq);
title('S_2_2');
