% Test script used to determine problem of leakage of pulses among
% receivers

clc;clear
fs = 10e6;

tx1.antenna =phased.IsotropicAntennaElement("FrequencyRange",[2.9e9 3.1e9]);
tx1.az = pattern(tx1.antenna,3e9,-180:0.01:180,0,'Normalize',true,'Type','powerdb');
% figure;plot((1:length(tx1.az))*0.01,tx1.az)
% tx1.az = db2pow(tx1.az);
%% Radiator
tx1.radiator = phased.Radiator("OperatingFrequency",3e9, ...
    "PropagationSpeed",physconst('Lightspeed'),"Sensor",tx1.antenna);

%% Transmitter
tx1.transmitter = phased.Transmitter("CoherentOnTransmit",true,"Gain",0, ...
    "PeakPower",2e6);
tx1.wf = phased.RectangularWaveform("PRF",1000, ...
    "PulseWidth",5e-6,"SampleRate",fs,"NumPulses",1);

%% Platform

tx1.pos = [300e3 ;00e3;0];
tx1.vel = [0;0;0];

tx1.pf = phased.Platform("InitialPosition",tx1.pos,"Velocity",tx1.vel, ...
    "ScanMode","None","InitialOrientationAxes",eye(3));

tx1.channel = phased.FreeSpace("OperatingFrequency", ...
        3e9,"PropagationSpeed",3e8,"SampleRate",fs, ...
        "TwoWayPropagation",false);
%% Receivers
noise_power = noisepow(fs,0,290);

sensor_pos = [00e3 -10e3 10e3 0e3; 
              00e3 10e3 10e3 -10e3;
              00e3 00e3 00e3  00e3];
antenna = phased.IsotropicAntennaElement("FrequencyRange",[2.9e9 3.1e9]);
for r = 1:4
    
    rx{r}.collector = phased.Collector("OperatingFrequency",3e9, ...
        "PropagationSpeed",physconst('Lightspeed'), ...
        "Sensor",antenna);
%     rx.az = pattern(rx.antenna,3e9,-180:0.01:180,0,'Normalize',true,'Type','powerdb');
%     figure;plot((1:length(rx.az))*0.01,rx.az)
    %% Receiver

    rx{r}.receiver = phased.ReceiverPreamp("Gain",0, ...
        "NoiseMethod","Noise power","NoiseComplexity","Complex","NoisePower",noise_power);

    %% Platform

    rx{r}.pos = sensor_pos(:,r);
    rx{r}.vel = [0;0;0];

    rx{r}.pf = phased.Platform("InitialPosition",rx{r}.pos,"Velocity",rx{r}.vel, ...
        "ScanMode","None","InitialOrientationAxes",eye(3));
end
%% Simulate the process
% For tx-1
update_rate1 = 1e-3;
for r = 1:4
    for i = 1:6

        % Update the dynamics of receiver after every PRI
        [rx{r}.pos_up,rx{r}.vel_up] = rx{r}.pf(update_rate1);

        % Update the transmitter dynamics based on velocity motion model.
        [tx1.pos_up,tx1.vel_up] = tx1.pf(update_rate1);

        % Get receiver angles w.r.t transmitter position
        [rx{r}.range,rx{r}.angle] = rangeangle(rx{r}.pos_up,tx1.pos_up);

        % This gives us the angle
        [tx1.range,tx1.angle] = rangeangle(tx1.pos_up,rx{r}.pos_up);

        % Generate and propagate tx signal
        tx1.txsig = tx1.transmitter(tx1.wf());

        % The tx signal propagates towards the receiver, specified by the
        % receiver angle

        tx1.txsig = tx1.radiator(tx1.txsig,tx1.angle);

        % The reciever is specified as the destination in the one-way
        % propagation of radiation from the transmitters, which are selected as
        % the originators.
        tx1.txsig = tx1.channel(tx1.txsig,tx1.pos_up,rx{r}.pos_up,tx1.vel_up,rx{r}.vel_up);

        % Collect the backscatter
        rx{r}.collect = rx{r}.collector(tx1.txsig, tx1.angle);

        % Compile the received signal as a radar data cube for processing
        rx{r}.rxsig1(:,i) = rx{r}.receiver(rx{r}.collect);
    end
    reset(tx1.channel)
    dwell(r,1:(tx1.wf.NumPulses*10e3)*i) = rx{r}.rxsig1(:);
end
%%
figure;plot((1:length(dwell))/fs,(abs(dwell(:,:))));