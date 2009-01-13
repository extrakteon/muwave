function wf_out = embed(wf_in,sp)
%EMBED
%   
% $Header$
% $Author$
% $Date$
% $Revision$ 
% $Log$
%

% Check data types
if not(strcmp(class(sp),'xparam') | strcmp(class(sp),'meassp'))
    error('WAVEFORM.EMBED: SP must be of type xparam/meassp.');
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

% Perform embedding
idxI = 1:get(wf_in,'ports');
idxE = max(idxI)+idxI;

% partition S-parameter matrix
S = get(sp(idx),'arraymatrix');
Sii = S(idxI,idxI);
Sie = S(idxI,idxE);
Sei = S(idxE,idxI);
See = S(idxE,idxE);

% partition waveform data
ai = get(wf_in,'a');
bi = get(wf_in,'b');

% Calculate extrinsic waveforms
ae = Sie\(bi - Sii*ai);
be = Sei*ai + See*ae;

% Assign output data
wf_out = wf_in;
wf_out = set(wf_out,'a',ae);
wf_out = set(wf_out,'b',be);

