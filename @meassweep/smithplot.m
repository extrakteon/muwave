function smithplot(Xin)
%SMITHPLOT  Plot meassweep objects the Smith Chart.
%   SMITHPLOT(SWP) plots the two-port S-parameters of SWP in a Smith chart.
%   
%   See also: PARAMPLOT

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: e7koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
% $Log$
%

smithplot(meassp,'meassweep',Xin.data);
