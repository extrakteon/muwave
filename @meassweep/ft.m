function out=display(cIN)
%FT Calculates ft for each meassp-object.

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: e7koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
% $Log$
%

for k = 1:length(cIN.data)
    out(k) = ft(cIN.data{k});
end