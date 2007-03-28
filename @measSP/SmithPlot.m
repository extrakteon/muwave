function SmithPlot(varargin)
% Method to plot one or two measSP objects in the Smith-chart.

% Version 1.0
% Created 02-01-04 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-04
% Created from old xparam method.

nin=nargin;
Xin=varargin;
S11vect=[];
S12vect=[];
S21vect=[];
S22vect=[];
for k=1:nin
    if ~isa(Xin{k},'measSP')
        error('Wrong input argument');
    end
    S11vect=cat(2,S11vect,get(Xin{k},'S11'));
    S12vect=cat(2,S12vect,get(Xin{k},'S12'));
    S21vect=cat(2,S21vect,get(Xin{k},'S21'));
    S22vect=cat(2,S22vect,get(Xin{k},'S22'));
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
