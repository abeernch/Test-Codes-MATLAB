% Transmitter
tx_ant = phased.SincAntennaElement("Beamwidth",2,"FrequencyRange",[2.9e9 3.1e9]);
tx=phased.Transmitter("Gain",1,"PeakPower",2e6);
rad = phased.Radiator("OperatingFrequency",3.1e9,"Sensor",tx_ant);

% Receiver
rx_ant = phased.SincAntennaElement("Beamwidth",180,"FrequencyRange",[2.9e9 3.1e9]);
rx=phased.ReceiverPreamp("Gain",25,"SampleRate",10e9);
collect = phased.Collector("OperatingFrequency",2.9e9,"Sensor",rx_ant);

% Signal
t= linspace(0,1,1000);
% sig = exp(i*2*pi*30.*t);
sig = phased.LinearFMWaveform("NumPulses",1,"PRF",1e6,"PulseWidth",0.1e-6,"SampleRate",2e9,"SweepBandwidth",100e6,"SweepInterval","Symmetric");
rxsig = [];
for i = 1:length(sig)
    
    txsig = sig(); 
    txsig = rad(txsig,(1:length(sig))*0);
    rf = sin(2*pi*1e9*(linspace(0,0.1e-6,length(sig()))));
    wf = sig().*rf.';    
    rxsig(:,i) = collect(txsig,ones(1,length(sig)));
%     rxsig(:,i) = rx(rxsig);
end
%%
figure,plot(real(rxsig))
figure,plot(real(wf))
faxis = -20/2: 20/length(sig()) : 20/2 -(20/length(sig())); %Ratio of fs and sweep bandwidth gives the right scale for LFM
figure; plot((faxis),db(abs(fftshift(fft(wf)))))
