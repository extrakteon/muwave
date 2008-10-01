function x = calc(x,val)
% CALC  Calculates the Y-matrix for a given symbolic MNA-matrix
%       if the parameter list is a cell-array the paramers are treated as
%       conversion-matrices

% $Header$
% $Author: kristoffer $
% $Date: 2003-11-17 20:55:38 +0100 (Mon, 17 Nov 2003) $
% $Revision: 172 $ 
% $Log$
% Revision 1.4  2003/11/17 19:55:36  kristoffer
% *** empty log message ***
%
% Revision 1.3  2003/11/14 16:49:35  kristoffer
% no message
%
% Revision 1.2  2003/10/07 11:31:58  kristoffer
% no message
%
% Revision 1.1  2003/10/06 16:38:32  kristoffer
% no message
%
% Revision 1.5  2003/10/06 07:11:45  kristoffer
% no message
%
% Revision 1.4  2003/10/06 06:47:14  kristoffer
% no message
%

if nargin == 2
    xval = val;
else
    xval = x.val;
end
x.val = xval;

% check if we have any matrix input
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
    eval(strcat(x.params{i},CSTR));
end
 
N = length(x.Y);
for row = 1:N
    for col = 1:N
        cellexpr = x.Y{row,col};
        if isempty(cellexpr)
            Yc(row,col,:) = 0;
        else
            if ~CONVERSION
                yitem = eval(vectorize(cellexpr));
                if length(yitem) ~= NFREQ
                    yitem = repmat(yitem,[1 NFREQ]);
                end
                Yc(row,col,:) = yitem;
            else
                cellexpr = regexprep(cellexpr,'1/','E/');
                idx = 1:NC;
                Yc(idx+NC*(row-1),idx+NC*(col-1)) = eval(cellexpr);    
            end    
        end
    end
end

x.Yc = xparam(Yc,'Y',50,freq(x));
