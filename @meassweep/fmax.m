function out=fmax(cIN)
%FMAX Calculates ft for each meassp-object.

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: $
% $Date: $
% $Revision: $ 
% $Log$
%

for k = 1:length(cIN.data)
    out(k) = fmax(cIN.data{k});
end