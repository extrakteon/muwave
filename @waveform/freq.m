function out = freq(fundamental, order_lower, order_upper)
%WAVEFORM 
%   
% $Header$
% $Author: $
% $Date: $
% $Revision: $ 
% $Log$
%
% Converts a Harmonic-Frequency-grid to a Linear-Frequency-grid

NFUND = length(fundamental);
fundamental = reshape(fundamental, [1 NFUND]); % convert to row vectors
order_lower = reshape(order_lower, [1 NFUND]); 
order_upper = reshape(order_upper, [1 NFUND]);
order = order_upper - order_lower + 1;
% flip vectors
order = fliplr(order);
order_lower = fliplr(order_lower);
order_upper = fliplr(order_upper);
fundamental = fliplr(fundamental);

% construct the harmonic index from the linear index
N = prod(order);
linear_index = 1:N;
eval(['[' sprintf('order_index(:,%d),',1:NFUND) '] = ind2sub(order, linear_index);']);
    
% calculate the frequency at each index
harmonic_matrix = zeros(size(order_index));
for k=1:NFUND
    factor = order_lower(k):order_upper(k);
    harmonic_matrix(:,k) = factor(order_index(:,k));
end
out = harmonic_matrix*fundamental';
% remove negative frequencies
idx_negative = find(out < 0);
out(idx_negative) = [];

