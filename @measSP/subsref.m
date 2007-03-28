function b = subsref(a,S)
%SUBSREF    Overloads the subsref operator.
%   V = M.P equals V = get(M,P)
%
%   M2 = M(f1) returns a new measSP object with the new frequency vector
%   defined from the f1 vector of new frequencies. 
%
%   See also: SUBSASGN, SET, GET, MEASMNT/ADDPROP

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: fager $
% $Date: 2004-10-21 00:25:32 +0200 (Thu, 21 Oct 2004) $
% $Revision: 220 $ 
% $Log$
% Revision 1.5  2004/10/20 22:25:05  fager
% Help comments added
%
% Revision 1.4  2003/07/18 14:29:31  fager
% msp(index) replaces old interpolation metod.
%
% Revision 1.3  2003/07/18 07:54:04  fager
% msp.Data -> msp.data and error handling improved.
%
% Revision 1.2  2003/07/16 15:39:39  fager
% Updated for the new meassp class definitions.
%

switch S.type
    case '()',	% Frequency indexing and interpolation (and extrapolation)
        b = a;
        S.type='()';
        b.data=subsref(a.data,S);
        ftmp = freq(a);
        b = set(b,'Freq',ftmp(S.subs{:}));
    case '{}'
        error('Illegal indexing method.');
    case '.'
        try
            b = get(a,S.subs);
        catch
            try
                b = subsref(a.data,S);
            catch
                error(['Unknown property: ',S.subs]);
            end
        end
end

