function val = convert(a, param_type, param_index, param_aux)
% CONVERT convert to different wave form types

% select the wanted port(s)
N = size(a.data,1);
a_idx = 1:2:N;
b_idx = 2:2:N;
if param_index > 0
    a_idx = a_idx(param_index);
    b_idx = b_idx(param_index);
end

freq_index = [];
if ~isempty(param_aux)
    % if DC is requested switch to frequency-domain
    if strmatch(param_aux,'dc')
        param_type = upper(param_type);
        freq_index = 1;
    end
    % if fc shorthand is used for frequency indexing, discard the time-domain
    if strmatch(param_aux,'fc')
        param_type = upper(param_type);
        freq_index = 2;
    end
end

% if stored in VI-form convert to AB
if strcmp(a.type,'VI')
    a = vi2ab(a);
end

switch param_type,
    case 'A'
        val = a.data(a_idx,:);
    case 'B'
        val = a.data(b_idx,:);
    case 'V'
        val = (a.data(a_idx,:) + a.data(b_idx,:));
    case 'I'
        val = ((a.data(a_idx,:) - a.data(b_idx,:))/a.reference);
    case 'a'
        tmp = td(a);
        val = tmp(a_idx,:);
    case 'b'
        tmp = td(a);
        val = tmp(b_idx,:);
    case 'v'
        tmp = td(a);
        val = tmp(a_idx,:) + tmp(b_idx,:);
    case 'i'
        tmp = td(a);
        val = (tmp(a_idx,:) - tmp(b_idx,:))/a.reference;
    case 'da'
        tmp = dtd(a);
        val = tmp(a_idx,:);
    case 'db'
        tmp = dtd(a);
        val = tmp(b_idx,:);
    case 'dv'
        tmp = dtd(a);
        val = tmp(a_idx,:) + tmp(b_idx,:);
    case 'di'
        tmp = dtd(a);
        val = (tmp(a_idx,:) - tmp(b_idx,:))/a.reference;
    otherwise
        error('WAVEFORM.CONVERT: Unknown target parameter.');
end

if ~isempty(freq_index)
    val = val(:,freq_index);
end

end

%
% Internal functions
%

function ab = vi2ab(vi)
% convert from VI to AB form    
    V = vi.data(1:2:end,:);
    I = vi.data(2:2:end,:);
    ab = vi;
    ab.type = 'AB';
    ab.data(1:2:end,:) = (V + I*ab.reference)/2;
    ab.data(2:2:end,:) = (V - I*ab.reference)/2;
end
