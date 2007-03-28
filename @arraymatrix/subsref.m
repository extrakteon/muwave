%
% ArrayMatrix
% class for handling arrays of matrices
%
% author: Kristoffer Andersson
%
%


% Overloads method subsref, eg B = A(S)
function c = subsref(a,S)

if S.type ~= '()',
    error('ARRAYMATRIX.SUBSREF: Unsupported indexing.');
end

% check what sort of indexing we are dealing with
K=length(S.subs);

if K==1
    % easy, extracting a matrix
    M = S.subs{:};
    c = arraymatrix(a.mtrx(:,:,M));
elseif K==2
    % we are dealing with a vector extraction
    x = S.subs{1};
    y = S.subs{2};
    c = squeeze(a.mtrx(x,y,:));
else
    error('ARRAYMATRIX.SUBSREF: Unknown error.');
end    
