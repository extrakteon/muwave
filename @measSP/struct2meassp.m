function cOUT = struct2meassp(cSP,Y,fname)
%STRUCT2MEASSP    

% $Header$
% $Author: koffer $
% $Date: 2004-05-28 09:03:19 +0200 (Fri, 28 May 2004) $
% $Revision: 201 $ 
% $Log$
% Revision 1.1  2004/05/28 07:00:18  koffer
% *** empty log message ***
%
for k=1:length(Y.props)
    if ismember(Y.props{k},{'Origin','Date','Operator','Info','Transistor','Batch'})
        if strcmpi(Y.props{k},'Date') & isempty(Y.values{k})
            Y.values{k} = datestr(now)
        end
        cSP.measmnt=addprop(cSP.measmnt,Y.props{k},Y.values{k});  
    else
        cSP.measstate=addprop(cSP.measstate,Y.props{k},Y.values{k});  
    end
end
% filename
cSP.measmnt=addprop(cSP.measmnt,'Origin',fname);
% frequency list
cSP.measstate = addprop(cSP.measstate,'Freq',Y.freq_list);

% Assign the data property, xparam object
XP=xparam;
cSP.data=buildxp(XP,Y.data,Y.datatype,Y.ref);
cOUT=cSP;