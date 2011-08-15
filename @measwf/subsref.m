function b = subsref(a,SX)
%SUBSREF    Overloads the subsref operator.
%   V = M.P equals V = get(M,P)
%
%   M2 = M(f1) returns a new meassp object with the new frequency vector
%   defined from the f1 vector of new frequencies. 
%
%   See also: SUBSASGN, SET, GET, MEASMNT/ADDPROP

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
% $Log$
% Revision 1.7  2005/05/03 12:32:02  koffer
% Implemented "nested" indexing, e.g. data.S11(1:4).
%
% Revision 1.6  2005/04/27 21:43:51  fager
% * Frequencies -> xparam
%
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


S = SX(1); % the first indexing applies to meassp
NS = length(SX);
if NS > 1 % let the rest follow the object
    AUX = SX(2:end);
end

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

% perform any remaining indexing operation
if NS > 1
    b = subsref(b,AUX);
end
