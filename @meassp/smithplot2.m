function smithplot2(varargin)
%SMITHPLOT  Plot one or more two-port meassp objects in the Smith Chart.

% $Header$
% $Author: koffer $
% $Date: 2006-08-18 06:47:51 +0200 (Fri, 18 Aug 2006) $
% $Revision: 306 $ 
% $Log$
% Revision 1.2  2005/04/27 21:41:32  fager
% * Changed from measSP to meassp.
%
% Revision 1.1  2004/05/28 07:02:20  koffer
% *** empty log message ***
%
% Revision 1.4  2003/07/18 13:51:10  fager
% Matlab-standardized help and CVS-logging added.
%


cthred = [0.8 0 0];
cthgreen = [0.6 0.8 0.6];
cthblue = [0 0 0.4];
cthcolor{1} = cthred;
cthcolor{2} = cthblue;
cthcolor{3} = cthgreen;

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

style = '.';

figure(1);
smiplot(S11vect,style);
title('S11');
%h_children = get(gca,'Children');
%for n=1:length(h_children),
%   set(h_children(n),'LineWidth',3,'Color',cthcolor{n});
%end

figure(2);
smipolar(S12vect,style);
title('S12');
%h_children = get(gca,'Children');
%for n=1:length(h_children),
%   set(h_children(n),'LineWidth',3,'Color',cthcolor{n});
%end

figure(3);
smipolar(S21vect,style);
title('S21');
%h_children = get(gca,'Children');
%for n=1:length(h_children),
%   set(h_children(n),'LineWidth',3,'Color',cthcolor{n});
%end

figure(4);
smiplot(S22vect,style);
title('S22');
%h_children = get(gca,'Children');
%for n=1:length(h_children),
%   set(h_children(n),'LineWidth',3,'Color',cthcolor{n});
%end
