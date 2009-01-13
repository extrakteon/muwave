function x = recalc(x,val)
% RECALC  Recalculates the Y-matrix for a given symbolic MNA-matrix
%       if the parameter list is a cell-array the paramers are treated as
%       conversion-matrices

% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
% Revision 1.4  2005/09/12 14:19:26  koffer
% *** empty log message ***
%
% Revision 1.3  2003/11/14 16:49:29  kristoffer
% no message
%
% Revision 1.2  2003/10/07 13:47:13  fager
% returns 3d-matrix instead of xparam object.
%
% Revision 1.1  2003/10/07 11:51:59  kristoffer
% no message
%
%

% check which parameters has changed
% this doesn't make a big difference anymore...
xval = val;
if x.valid_calc
    pchg = x.val ~= xval;
else
    pchg = logical(ones(1,length(x.params)));
end

x.val = val;
if isempty(x.Yc)
    x = calc2(x,val);
end
Yc = get(x.Yc,'mtrx');

% check if we have matrix input
if isa(xval,'cell')
    CONVERSION = true;
    NC = length(x.f);
    E = eye(NC);
    for i=1:length(xval)
        xitem = xval{i};
        sizx = size(xitem);
        if ~any(sizx>1)
            % we have a scalar; convert to matrix
            xval{i} = E*xitem;
        else
            % we have a vector/matrix
            if any(sizx==1)
                % we have vector; convert to matrix
                xval{i} = diag(xitem);
            end
        end
    end
    s = j*2*pi*diag(x.f);
else
    CONVERSION = false;
    s = j*2*pi*x.f;
    NFREQ = length(s);
end

% load parameter values
if ~CONVERSION
    CSTR = '=xval(i);';
else
    CSTR = '=xval{i};';
end   
for i=1:length(x.params)
    eval([x.params{i},CSTR]);
end

% use logical indexing
tmap = x.map(:,:,pchg);
if ~isempty(tmap)
    imap = squeeze(tmap(:,:,1));
    for k=2:size(tmap,3)
        imap = or(imap,squeeze(tmap(:,:,k)));
    end
    % find which positions to change
    [krow,kcol]=find(imap);
    if ~CONVERSION
        for k=1:length(krow)
            cellexpr = x.Y{krow(k),kcol(k)};
            yitem = eval(vectorize(cellexpr));
            if length(yitem) ~= NFREQ
                yitem = repmat(yitem,[1 NFREQ]);
            end
            Yc(krow(k),kcol(k),:) = yitem;
        end
    else
        for k=1:length(krow)
            cellexpr = x.Y{krow(k),kcol(k)};    
            cellexpr = regexprep(cellexpr,'1/','E/');
            idx = 1:NC;
            Yc(idx+NC*(row-1),idx+NC*(col-1)) = eval(cellexpr);    
        end
    end
end

x.Yc = xparam(Yc,'Y',50,freq(x));
x.valid_calc = true;
