function c = subsref(a,S)
% SUBSREF Overloads method subsref, eg B = A(S)

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.2  2005/05/04 09:50:23  koffer
% Support for 3D-indexing.
%
%

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
        c = arraymatrix(a.mtrx(row,col,:));
    else
        c = arraymatrix(a.mtrx(row,col,S.subs{3}));
    end
end    
