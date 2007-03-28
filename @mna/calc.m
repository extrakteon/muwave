function Yx = calc(x,val)
% populate the Y-matrix and return a xparam-object
if nargin == 2
    xval = val;
else
    xval = x.val;
end

% load parameter values
s = j*2*pi*x.f;
for i=1:length(x.params)
    eval(strcat(x.params{i},'=',num2str(xval(i)),';'));    
end

N = length(x.Y);
for row = 1:N
    for col = 1:N
        cellexpr = x.Y{row,col};
        if isempty(cellexpr)
            Yc(row,col,:) = 0;
        else
            Yc(row,col,:) = eval(cellexpr);
        end
    end
end

Yx = xparam(Yc,'Y',50);

% clear parameter values
for i=1:length(x.params)
    eval(sprintf('clear %s',x.params{i}));    
end