%% Test code for resampling the envelope for the B2B block stagger

% Divide the envelope into parts equal to the number of dwells per scan

% dwells_per_scan = (1/((sum(1./tx1.prf)/(length(tx1.prf)))));
dwells_per_scan = 1/tx1.dwell;

burst_per_scan = dwells_per_scan*length(tx1.prf);
batch = (length(env)/((burst_per_scan)));

t = repmat(tx1.pulses,1,tx1.pulses_scan/(length(tx1.prf)));

ind1 = 1;
f = 1;
for i = 1:burst_per_scan
    if i == 1
                ind1 = 1;
                ind2 = batch;
            else
                ind1 = ind2 + 1 ;
                ind2 = ind1 - 1 + batch;
    end
    
    env_resamp(1,f:f + t(i)-1) = resample(env(ind1:ind2), ...
                                                t(i),length(env(ind1:ind2)));
    f = f + t(i);

end

%%
l_l = 100; % restrict limits
u_l = 2000;
prf = [200:10:500];
chk = diff(prf);
c = chk~=chk(1);
d = chk<0;
if any(c) || ~any(d)
    disp('sds')
end



% Testing the sliding window PRF
pulses = repmat(5e-6,1,5000);
prf_s = repmat(prf,1,ceil(length(pulses)/length(prf)));

for i = 1:length(pulses)
    wf{i} = phased.LinearFMWaveform("PRF",prf_s(i),"PulseWidth",pulses(i), ...
    "SampleRate",10e6,"SweepBandwidth",1, ...
    "SweepInterval","Symmetric","NumPulses", 1);
end

