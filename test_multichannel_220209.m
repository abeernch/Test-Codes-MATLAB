clc;clear
wf = phased.LinearFMWaveform('PulseWidth',1e-5,'SampleRate',1e9,'SweepBandwidth',200e3, 'PRF',1000,...
    'SweepInterval','Symmetric');
wff = phased.RectangularWaveform('PulseWidth',1e-5,'SampleRate',1e9);
rf = exp(1i*2*pi*100e6*(linspace(0,wf.PulseWidth,length(wff()))));
wf1 = wff().*rf.'; 
% wf2 = wf().*rf.';
% wf1 = wf();
% wf1 = fmmod(abs(wf()),100e6,wf.SampleRate,1);
% wf = wff();
% wf2 = fmmod(abs(wff()),100e6,wff.SampleRate,1);


%%
ch1 = phased.FreeSpace;
ch2 = comm.RayleighChannel("PathDelays",[0 50e-6],"SampleRate",wf.SampleRate,'NormalizePathGains',0);
ch2.AveragePathGains = [0 0];
N = round(wf.SampleRate/wf.PRF);
t = (0:(N-1))/wf.SampleRate;
x = wf2;
xc1 = step(ch1,x,[0;0;0],[2000;0;0],[0;0;0],[0;0;0]);
xc2 = step(ch2,x);

figure;
subplot(311); plot(t,abs(x));
subplot(312); plot(t,(xc1));
subplot(313); plot(t,(xc2));