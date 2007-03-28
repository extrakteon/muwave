function b = subsref(a,S)

% Calls the same function for the underlying xparam object.
% Created 02-01-06 by Christian Fager
%
% Revision history.
% v1.0 -- Date 02-01-06
% v2.0 -- Date 02-01-10
%       SP.Vgsq, SP.Freq etc. now allowed in addition to SP.S11 etc.

% Calls xparam/subsref
switch S.type
case '()',	% Frequency indexing and interpolation (and extrapolation)
    b=a;
    fout=[S.subs{:}];
    b=set(b,'Freq',fout);
    b=setInfo(b,[getInfo(b),'Interpolated.']);	% Add comment about that interpolation has been performed.
    fin=freq(a);
    ports=get(a.Data,'ports');
    datatype=get(a.Data,'type');
    reference=get(a.Data,'reference');
    for col=1:ports	% The only way I could think of...
        for row=1:ports
            indexstr=upper([datatype,int2str(row),int2str(col)]);
            temp(:,row+(col-1)*ports)=interp1(fin,get(a.Data,indexstr),fout,'spline','extrap').';
        end
    end
    b.Data=buildxp(xparam,temp,datatype,reference);
case '{}'
    b = a;
    S.type='()';
    b.Data=subsref(a.Data,S);
    ftmp = freq(a);
    b = set(b,'Freq',ftmp(S.subs{:}));
case '.'
    try
        b = get(a,S.subs);
    catch
        b = subsref(a.Data,S);
    end
end

