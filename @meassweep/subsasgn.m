function a = subsasgn(a,S,b)
% CHANGES:
% 2002-01-14, Christian Fager
%             First version
% Overloads method subsasgn, eg A(S) = B

switch S.type
case '()'
    switch a.DataType
    case 'SP'
        klass='measSP';
    case 'DC'
        klass='measDC';
    case 'Noise'
        klass='measNoise';
    otherwise,
        error('Unsupported measurement type');
    end
    if length(S.subs) == 1 & isa(b,klass)
        a.Data{S.subs{:}} = b;
    else
        error('Argument B is of wrong type.');
    end
otherwise
    error('Unsupported indexing.');
end


% internal functions
