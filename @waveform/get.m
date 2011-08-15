function val = get(a,param)
% GET   Returns properties from an waveform object.
%
%   (c) Kristoffer Andersson & Christian Fager, Chalmers University of Technology, Sweden

% $Header$
% $Author: e7koffe@CHALMERS.SE $
% $Date: 2009-09-01 11:14:53 +0200 (ti, 01 sep 2009) $
% $Revision: 112 $
% $Log$
%

if nargin == 1, % Just return the available properties
    disp('Valid waveform properties');
    disp(sprintf('\treference :\t%d',get(a,'reference')));
    disp(sprintf('\ttype :\t%s',get(a,'type')));
    disp(sprintf('\tfundamental :\t[%d]',length(get(a,'fundamental'))));
    disp(sprintf('\telements :\t%d',get(a,'elements')));
end

if isa(param,'char')
    switch param
        case 'reference',
            val = a.reference;
        case 'type',
            val = a.type;
        case 'freq',
            val = a.freq;
        case 'omega',
            val = 2*pi*freq;
        case 'ports',
            val = size(a.data,1)/2;
        case 'elements',
            val = length(a.data);
        case 'arraymatrix',
            val = a.data;
        case {'data'}
            val = a.data;
        case 'fundamental'
            val = a.fundamental;
        case 't'
            [tmp, val] = td(a);
        otherwise
            tmp = regexp(param,'([d]\D{1}|\D{1})(\d*)(\w{2,}|)','tokens');
            param_type = char(tmp{1}(1));
            param_index = char(tmp{1}(2));
            if isempty(param_index)
                param_index = -1;
            else
                param_index = str2double(param_index);
            end
            param_aux = char(tmp{1}(3));
            val = convert(a, param_type, param_index, param_aux);
    end
else
    error('WAVEFORM.GET: Unknown error.');
end

%
% Internal functions
%