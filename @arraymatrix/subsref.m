function c = subsref(a,S)
% SUBSREF Overloads method subsref, eg B = A(S)

if S.type ~= '()',
    error('ARRAYMATRIX.SUBSREF: Unsupported indexing.');
end

% check what sort of indexing we are dealing with
K=length(S.subs);

if K==1
    % easy, extracting a matrix
    M = S.subs{:};
    c = arraymatrix(a.mtrx(:,:,M));
else
    % we are dealing with a vector extraction
    row = S.subs{1};
    col = S.subs{2};
    if K == 2
        c = squeeze(a.mtrx(row,col,:));
    else
        c = squeeze(a.mtrx(row,col,S.subs{3}));
    end
end    
