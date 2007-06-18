function out=display(cIN)
%FT Calculates ft for each meassp-object.

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: $
% $Date: $
% $Revision: $ 
% $Log$
%

for k = 1:length(cIN.data)
    out(k) = ft(cIN.data{k});
end