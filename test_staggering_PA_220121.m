staggers = 3;
pulses = 4;
fs =1.5e6;
prf = [250 800 1500];
pw = [5e-6 10e-6 50e-6 80e-6];
tau_bw = 1./pw;
np = 12;


pcr1 = 5;
n_dur = 1:length(pw);
prf_s = repmat(prf,1,np/length(prf));
tau_s = repmat(pw,1,np/length(pw));
tau_bw_s = repmat(tau_bw,1,np/length(tau_bw)); 

for i = 1:np

    tx1.wf{i} = phased.LinearFMWaveform("PRF",prf_s(i),"PulseWidth",tau_s(i), ...
                "SampleRate",fs,"SweepBandwidth",tau_bw_s(i)*pcr1, ...
                "SweepInterval","Symmetric","NumPulses", 1);
end
%%
% tx1.az.*wf{1}()
figure(1)
plot(wf{1}())

%% testing different staggering
stag = 1;

fs =1.5e6;
prf = [250 800 1500];
pw = [5e-6 100e-6];
tau_bw = 1./pw;
np = [10 5 15];
pcr1 = 5;

prf_ary = zeros(length(prf),max(np));
for j = 1:length(prf)
    prf_ary(j,1:np(j)) = repmat(prf(j),1,np(j));
end
prf_ary = prf_ary.';
prf_ary = prf_ary(:);
prf_s =prf_ary(prf_ary~=0).';
tau_s = repmat(pw,1,sum(np)/length(pw));
tau_bw_s = repmat(tau_bw,1,sum(np)/length(tau_bw)); 
switch stag
    case stag==1 % block stagger
        for i = 1:length(tau_s)
        wf{i} = phased.LinearFMWaveform("PRF",prf_s(i),"PulseWidth",tau_s(i), ...
                "SampleRate",fs,"SweepBandwidth",tau_bw_s(i)*pcr1, ...
                "SweepInterval","Symmetric","NumPulses", 1);
        end

end



