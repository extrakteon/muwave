function c = vertcat(a,varargin)
% VERTCAT vertical concatenation of arraymatrixes with equal
% number of rows and lengths

if isempty(a)
    mtrx = [];
else
    mtrx = a.mtrx;
end

for k = 1:length(varargin)
    b = varargin{k};
    mtrx = [mtrx; b.mtrx];
end
c = arraymatrix(mtrx);

