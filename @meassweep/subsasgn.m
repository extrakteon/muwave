function a = subsasgn(a,S,b)
% SUBSASGN Allows subscripted assignments of type A(k).name = b
%   A = SUBSASGN(A,S,b) allows subscripted assignments of type A(k).name = b
%
%   See also: GET, SET, SUBSREF

%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: e7koffe $
% $Date: 2009-01-13 11:05:46 +0100 (ti, 13 jan 2009) $
% $Revision: 96 $ 
% $Log$
% Revision 1.4  2005/04/27 21:44:08  fager
% * Changed from measSP to meassp.
%
% Revision 1.3  2004/10/20 17:01:16  fager
% Help comments added
%

if length(S) == 1
    switch S.type
        case '()'
            %     switch a.DataType
            %     case 'SP'
            %         klass='meassp';
            %     case 'DC'
            %         klass='measDC';
            %     case 'Noise'
            %         klass='measNoise';
            %     otherwise,
            %         error('Unsupported measurement type');
            %     end
            %     if length(S.subs) == 1 & isa(b,klass)
            a.data{S.subs{:}} = b;
            %     else
            %         error('Argument B is of wrong type.');
            %     end
        otherwise
            error('Unsupported indexing.');
    end
elseif length(S) == 2
    if ~(S(1).type == '()' & S(2).type == '.'), error('Unsupported indexing.'); end
    a.data{S(1).subs{:}} = set(a.data{S(1).subs{:}},S(2).subs,b);
else
    error('Unsupported indexing.');
end


% internal functions
