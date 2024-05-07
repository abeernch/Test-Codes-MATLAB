wf = phased.RectangularWaveform("PRF",500, ...
                             "PulseWidth",200e-6,"SampleRate",20e6,"NumPulses",1);

sig = exp(1i*2*pi*0.5e6*linspace(0,1/wf.PRF,length(wf())));
wf_sig = wf().*sig.';
wf_sig_n = awgn(wf_sig,90);

re_sig_norm = int16(round(real(wf_sig_n)*2^15));
im_sig_norm = int16(round(imag(wf_sig_n)*2^15));

comb_int = [re_sig_norm.';im_sig_norm.'];
comb_int = comb_int(:);
comb = typecast(comb_int,'uint32');