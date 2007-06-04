function wf_out = deembed(wf_in,sp)
%DEEMBED
%   
% $Header$
% $Author: $
% $Date: $
% $Revision: $ 
% $Log$
%

% Check data types
if not(strcmp(class(sp),'xparam') | strcmp(class(sp),'meassp'))
    error('WAVEFORM.DEEMBED: SP must be of type xparam/meassp.');
end

% Check dimensions
if 2*get(wf_in,'ports')~=sp.ports
    error('WAVEFORM.EMBED: The number of ports of SP needs to be twice that of WF_IN.');
end

% Select frequencies *FIXME* replace with a interpolation feature
freq_wf = reshape(wf_in.freq, [1 length(wf_in.freq)]);
freq_sp = reshape(sp.freq, [1 length(sp.freq)]);
delta = abs(repmat(freq_wf',[1 length(freq_sp)]) - repmat(freq_sp,[length(freq_wf) 1]));
[void, idx] = min(delta,[],2);
% idx is now a vector of frequency indexes that match the waveform

% Perform de-embedding
idxI = 1:get(wf_in,'ports');
idxE = max(idxI)+idxI;

% partition S-parameter matrix
S = get(sp(idx),'arraymatrix');
Sii = S(idxI,idxI);
Sie = S(idxI,idxE);
Sei = S(idxE,idxI);
See = S(idxE,idxE);

% partition waveform data
ae = get(wf_in,'a');
be = get(wf_in,'b');

% Calculate intrinsic waveforms
ai = Sei\(be - See*ae);
bi = Sie*ae + Sii*ai;

% Assign output data
wf_out = wf_in;
wf_out = set(wf_out,'a',ai);
wf_out = set(wf_out,'b',bi);

