function c = amsparse(rowindex,colindex,a,nrow,ncol)
% AMSPARSE create a matrix with elements at rowindex,colindex of
% dimension [nrow,ncol,length(a)]

LEN = max(size(a,1),size(a,2));
if not(LEN==length(rowindex) && LEN==length(colindex))
    error(['ARRAYMATRIX/AMSPARSE: Length of rowindex/colindex must ' ...
           'equal that of a.']);
end

mtrx = zeros(nrow,ncol,size(a,3));

if size(a,2) == 1
    % columnvector
    for k = 1:length(rowindex)
        mtrx(rowindex(k),colindex(k),:) = a.mtrx(k,1,:); 
    end
elseif size(a,1) == 1
    % rowvector
    for k = 1:length(rowindex)
        mtrx(rowindex(k),colindex(k),:) = a.mtrx(k,1,:); 
    end
else
    error('ARRAYMATRIX/AMSPARSE: a must either be a row- or column-vector.');
end

c = arraymatrix(mtrx);

