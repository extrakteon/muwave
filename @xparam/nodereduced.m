function xp_out = nodereduced(xp_in,index)

xp_in = convert(xp_in,'Z');
xp_out = xp_in;

all_ix = 1:get(xp_in,'ports');
all_ix(find(ismember(all_ix,index))) = [];
all_ix = fliplr(all_ix);

for k=1:length(all_ix)
    xp_out = skip(xp_out,[all_ix(k) all_ix(k)]);
end
