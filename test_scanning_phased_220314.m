% Test script used to determine whether the beamwidth manifests its effect
% in terms of power reduction/increase as a target traverses throught the
% space. Given the orientation and beaering of the receiver and the
% emitterr, the power level must vary according the mainlobe and side-lobe
% levels.

clc;clear
fs = 10e6;
% tx1.antenna = phased.SincAntennaElement("Beamwidth",[5 5], ...
%               "FrequencyRange",[2.99e9 3.01e9]);
tx1.antenna =phased.IsotropicAntennaElement("FrequencyRange",[2.9e9 3.1e9]);
tx1.az = pattern(tx1.antenna,3e9,-180:0.01:180,0,'Normalize',true,'Type','powerdb');
figure;plot((1:length(tx1.az))*0.01,tx1.az)
tx1.az = db2pow(tx1.az);
%% Radiator
tx1.radiator = phased.Radiator("OperatingFrequency",3e9, ...
               "PropagationSpeed",physconst('Lightspeed'),"Sensor",tx1.antenna);

%% Transmitter
tx1.transmitter = phased.Transmitter("CoherentOnTransmit",true,"Gain",0, ...
                  "PeakPower",2e6);
tx1.wf = phased.RectangularWaveform("PRF",500, ...
                 "PulseWidth",1e-6,"SampleRate",fs);

%% Platform

tx1.pos = [10e3 ;10e3;0];
tx1.vel = [0;-10000;0];

% tx1.pf = phased.Platform("InitialPosition",tx1.pos,"Velocity",tx1.vel, ...
%         "ScanMode","Circular","InitialOrientationAxes", eye(3),"InitialScanAngle", ...
%         0,"AzimuthScanRate",60);

tx1.pf = phased.Platform("InitialPosition",tx1.pos,"Velocity",tx1.vel, ...
        "ScanMode","None","InitialOrientationAxes", [-1.0000   -0.0000         0;
    0.0000   -1.0000         0;
         0         0    1.0000]);
% tx1.pf = phased.Platform("InitialPosition",tx1.pos,"Velocity",tx1.vel, ...
%         "ScanMode","None","InitialOrientationAxes", eye(3));
%%
% rx.antenna = phased.SincAntennaElement("Beamwidth",20,"FrequencyRange",[2e9 4e9]);
rx.antenna = phased.IsotropicAntennaElement("FrequencyRange",[2.9e9 3.1e9]);
rx.collector = phased.Collector("OperatingFrequency",3e9, ...
              "PropagationSpeed",physconst('Lightspeed'), ...
              "Sensor",rx.antenna);
rx.az = pattern(rx.antenna,3e9,-180:0.01:180,0,'Normalize',true,'Type','powerdb');
figure;plot((1:length(rx.az))*0.01,rx.az)
%% Receiver
noise_power = noisepow(fs,0,290);
rx.receiver = phased.ReceiverPreamp("Gain",0, ...
    "NoiseMethod","Noise power","NoiseComplexity","Complex","NoisePower",noise_power);

%% Platform

rx.pos = [0;0;0];
rx.vel = [0;0;0];

rx.pf = phased.Platform("InitialPosition",rx.pos,"Velocity",rx.vel, ...
        "ScanMode","None","InitialOrientationAxes", [1 0 0; 0 1  0;  0  0  1]);
rx.channel = phased.FreeSpace("OperatingFrequency", ...
             3e9,"PropagationSpeed",physconst('Lightspeed'),"SampleRate",fs, ...
             "TwoWayPropagation",false);

%% Simulate the process
% For tx-1
update_rate1 = 1e-3;

for i = 1:2000

    % Update the dynamics of receiver after every PRI
    [rx.pos_up,rx.vel_up] = rx.pf(update_rate1);

    % Update the transmitter dynamics based on velocity motion model.
    [tx1.pos_up,tx1.vel_up] = tx1.pf(update_rate1);
      
    % Get receiver angles w.r.t transmitter position
    [rx.range,rx.angle] = rangeangle(rx.pos_up,tx1.pos_up);

    % This gives us the angle
    [tx1.range,tx1.angle] = rangeangle(tx1.pos_up,rx.pos_up);
    
    % Generate and propagate tx signal
    tx1.txsig = tx1.transmitter(tx1.wf());
        
    % The tx signal propagates towards the receiver, specified by the 
    % receiver angle 
    
    tx1.txsig = tx1.radiator(tx1.txsig,tx1.angle);
    
    % The reciever is specified as the destination in the one-way
    % propagation of radiation from the transmitters, which are selected as
    % the originators.
    tx1.txsig = rx.channel(tx1.txsig,tx1.pos_up,rx.pos_up,tx1.vel_up,rx.vel_up);

    % Collect the backscatter
    rx.collect = rx.collector(tx1.txsig, tx1.angle);

    % Compile the received signal as a radar data cube for processing
    rx.rxsig1(:,i) = rx.receiver(rx.collect);
end

dwell = rx.rxsig1(:);
figure;plot((1:length(dwell))/fs,(abs(dwell)));

%%
% ori = zeros(3,3,5040);
% for i = 1:5040
%     [~,~,ori(:,:,i)] = step(tx.pf,1e-3);
%     
%     ori_deg(:,:,i) = rad2deg(rotm2eul(ori(:,:,i)));
%    
% end
% ori_deg = squeeze(ori_deg);