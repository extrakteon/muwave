tuner1 = read_tuner('../test/mt982e_demo.tun');
tuner2 = read_tuner('../test/mt982e_demo.tun');


% dummy stuff for testing
freq = 1e9*linspace(1,50,101);
sp1 = [0 1;1 0]; % ideal thru
sp1 = xparam(repmat(sp1,[1 1 length(freq)]),'S',50,freq);


% calculate embedding-network
% port-1 is referenced to DUT-side

tuner1_z0 = sp1;
probe1 = sp1;

tuner2_z0 = sp1;
probe2 = sp1;

% calculate embedding 4-port:
tp1_z0 = cascade(probe1, tuner1_z0);
tp2_z0 = cascade(probe2, tuner2_z0);
tp_z0 = build4p(tp1_z0, tp2_z0);


% calculate deembedding 4-port:
tp1 = cascade(probe1, tuner1);
tp2 = cascade(probe2, tuner2);
tp_z0 = build4p(tp1_z0, tp2_z0);


wf_raw = embed(wf_qraw, tp_z0);
wf_meas = deembed(wf_raw, tp);

