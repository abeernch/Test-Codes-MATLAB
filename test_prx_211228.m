%% Passive multiple antenna communication - 2
clear;clc;close all

% Create structures for the sensor parameters
tx1 = struct('range',input('Tx1 Range (km) = ')*1e3,'p_tx',2e6,'tau',6.5e-6,'prf',250,'rpm',6*6,'bw',1.1,'gain',10^(43/10),'fo',3e9);
tx2 = struct('range',input('Tx2 Range (km) = ')*1e3,'p_tx',4e3,'tau',5e-6,'prf',8000,'rpm',60*6,'bw',4,'gain',10^(25/10),'fo',2.9e9);
tx3 = struct('range',input('Tx3 Range (km) = ')*1e3,'p_tx',20e3,'tau',80e-6,'prf',800,'rpm',15*6,'bw',1.45,'gain',10^(30/10),'fo',3.1e9);

rx.gain = 10^(0/10);                            % Receiver gain (linear)

% Define universal variables
var_uni.c = 3e8;                                % Propagation Speed
var_uni.imp = 50;                               % 50 ohm universal matching impedance
var_uni.np = -107;                              % Channel/receiver noise (dBm)

%% Select waveform modulation type
tx1.mod = input('Tx1 Modulation ("pulse","lfm","barker"): ','s');


%% Transmitter - 1 

tx1.lambda = var_uni.c/tx1.fo;                  % Transmission wavelength
tx1.pulses = floor(tx1.bw*tx1.prf/tx1.rpm);     % number of pulses per CPI\dwell of a scan
tx1.dwell = tx1.pulses/tx1.prf;                 % Dwell time 
tx1.fs = 20e6;                                   % Sampling frequency
tx1.ts = 1/tx1.fs;                              % Sampling interval

% Sample and create axis
tx1.samples_pri = round(tx1.fs/tx1.prf);        % No of PRI samples
tx1.samples_tau = round(tx1.fs*tx1.tau);        % No of Pulse samples

tx1.axis_pri = 0 : tx1.ts : 1/tx1.prf - tx1.ts; % Sampled PRI duration
tx1.axis_tau = 0 : tx1.ts : tx1.tau - tx1.ts;   % Sampled Pulse duration
tx1.axis_dwell = 0: tx1.ts : tx1.dwell - tx1.ts;

% Simulate PRI
tx1.sim_tau = ones(1,tx1.samples_tau);          % Initiate and Simulate a PRI
tx1.sim_pri = zeros(1,tx1.samples_pri);         % Initiate and Simulate a simple pulse

% Simulate received signal at rx (Use modified RRE for one-way propagation)
tx1.rx_peakpwr = (tx1.p_tx*tx1.gain*rx.gain*tx1.lambda^2)/((tx1.range^2)*(4*pi)^2);    % Peak power received 

tx1.delay = tx1.range/var_uni.c;                % Time delay corresponding to the transmitter range
tx1.samples_range = round(tx1.fs*tx1.delay);    % Range sampling

switch tx1.mod                                      % Modulation control        
    case 'pulse'
        tx1.rf = sin(2*pi*tx1.fo*(linspace(0,1,length(tx1.sim_tau))));
        tx1.wf = tx1.sim_tau.*tx1.rf;
        tx1.sim_pri(tx1.samples_range : tx1.samples_range + tx1.samples_tau-1) = tx1.wf;
        tx1.sim_tx = tx1.sim_pri;
    
    case 'lfm'
        tx1.pcr = input('PCR = ');
        tx1.lfm = [exp(-1i*pi*tx1.pcr.*(linspace(0,1,ceil(length(tx1.sim_tau)/2)).^2)) fliplr(exp(1i*pi*tx1.pcr.*(linspace(0,1,floor(length(tx1.sim_tau)/2)).^2)))];
        tx1.wf = tx1.sim_tau.*tx1.lfm;
        tx1.sim_pri(tx1.samples_range : tx1.samples_range + tx1.samples_tau-1) = tx1.wf;
        tx1.sim_tx = tx1.sim_pri;
end

% Form a CPI
tx1.cpi = (repmat(tx1.sim_tx,1,tx1.pulses));    
tx1.cpi = tx1.cpi.*(sind(linspace(20,150,length(tx1.cpi))));
% tx1.cpi = tx1.cpi.*(0.5 + (sin(2*pi*(1/tx1.dwell/2).*tx1.axis_dwell))/2);     
% Introduce noise
var_uni.noise = wgn(1,length(tx1.cpi),var_uni.np,'dBm');

tx1.cpi = sqrt((tx1.rx_peakpwr.*tx1.cpi).*var_uni.imp); 
tx1.cpi_dbm = 10*log10(10*((tx1.cpi + var_uni.noise).^2)); 

%In order to emulate the beamshaping loss due to 3dB beamwidth of the
%antenna, the CPI is multiplied with a sinusoid having a frequency
%corresponding to the half of the dwell time. i.e., the period of the
%sinusoid is half of the dwell time. Also, since the 3dB loss max reduction
%in power of the received signals will be half of maximum, therefore, the 
% sinusoid is scaled and shifted such that min amplitude is 0.5 and max is
% 1 This brings the max towards the center and again wanes away the 
% constant amplitude to half 

figure
plot((1:length(tx1.cpi)).*tx1.ts*1e3 ,tx1.cpi_dbm) 
grid on; xlabel('Dwell Time (ms)');ylabel('Voltage (dBm)')
title('3dB Beamwidth Affected CPI received from TX1')
ylim([-130 0])

%% Transmitter - 2

%% Select waveform modulation type
tx2.mod = input('Tx2 Modulation ("pulse","lfm","barker"): ','s');

%%
tx2.lambda = var_uni.c/tx2.fo;                  % Transmission wavelength
tx2.pulses = floor(tx2.bw*tx2.prf/tx2.rpm);     % number of pulses per CPI\dwell of a scan
tx2.dwell = tx2.pulses/tx2.prf;                 % Dwell time 
tx2.fs = 2e6;                                   % Sampling frequency
tx2.ts = 1/tx2.fs;                              % Sampling interval

% Sample and create axis
tx2.samples_pri = round(tx2.fs/tx2.prf);        % No of PRI samples
tx2.samples_tau = round(tx2.fs*tx2.tau);        % No of Pulse samples

tx2.axis_pri = 0 : tx2.ts : 1/tx2.prf - tx2.ts; % Sampled PRI duration
tx2.axis_tau = 0 : tx2.ts : tx2.tau - tx2.ts;   % Sampled Pulse duration
tx2.axis_dwell = 0: tx2.ts : tx2.dwell - tx2.ts;

% Simulate PRI
tx2.sim_tau = ones(1,tx2.samples_tau);          % Initiate and Simulate a PRI
tx2.sim_pri = zeros(1,tx2.samples_pri);         % Initiate and Simulate a simple pulse

% Simulate received signal at rx (Use modified RRE for one-way propagation)
tx2.rx_peakpwr = (tx2.p_tx*tx2.gain*rx.gain*tx2.lambda^2)/((tx2.range^2)*(4*pi)^2);    % Peak power received 

tx2.delay = tx2.range/var_uni.c;                                % Time delay corresponding to the transmitter range
tx2.samples_range = round(tx2.fs*tx2.delay);                    % Range sampling

switch tx2.mod
    case 'pulse'
        tx2.rf = sin(2*pi*tx2.fo*(linspace(0,1,length(tx2.sim_tau))));
        tx2.wf = tx2.sim_tau.*tx2.rf;
        tx2.sim_pri(tx2.samples_range : tx2.samples_range + tx2.samples_tau-1) = tx2.wf;
        tx2.sim_tx = tx2.sim_pri;
    
    case 'lfm'
        tx2.pcr = input('PCR = ');
        tx2.lfm = exp(1i*pi*tx2.pcr.*(linspace(0,1,length(tx2.sim_tau))).^2);
        tx2.wf = tx2.sim_tau.*tx2.lfm;
        tx2.sim_pri(tx2.samples_range : tx2.samples_range + tx2.samples_tau-1) = tx2.wf;
        tx2.sim_tx = tx2.sim_pri;
end

% Form a CPI
tx2.cpi = (repmat(tx2.sim_tx,1,tx2.pulses));    
tx2.cpi = tx2.cpi.*(sind(linspace(20,150,length(tx2.cpi))));
% tx2.cpi = tx2.cpi.*(0.5 + (sin(2*pi*(1/tx2.dwell/2).*tx2.axis_dwell))/2);     
% Introduce noise
var_uni.noise = wgn(1,length(tx2.cpi),var_uni.np,'dBm');

tx2.cpi = sqrt((tx2.rx_peakpwr.*tx2.cpi).*var_uni.imp); 
tx2.cpi_dbm = 10*log10(10*((tx2.cpi + var_uni.noise).^2)); 

figure;plot((1:length(tx2.cpi)).*tx2.ts*1e3 ,tx2.cpi_dbm) 
grid on; xlabel('Dwell Time (ms)');ylabel('Voltage (dBm)')
title('3dB Beamwidth Affected CPI received from TX2')
ylim([-130 0])

%% Transmitter - 3

%% Select waveform modulation type
tx3.mod = input('Tx3 Modulation ("pulse","lfm","barker"): ','s');

%%
tx3.lambda = var_uni.c/tx3.fo;                  % Transmission wavelength
tx3.pulses = floor(tx3.bw*tx3.prf/tx3.rpm);     % number of pulses per CPI\dwell of a scan
tx3.dwell = tx3.pulses/tx3.prf;                 % Dwell time 
tx3.fs = 2e6;                                   % Sampling frequency
tx3.ts = 1/tx3.fs;                              % Sampling interval

% Sample and create axis
tx3.samples_pri = round(tx3.fs/tx3.prf);        % No of PRI samples
tx3.samples_tau = round(tx3.fs*tx3.tau);        % No of Pulse samples

tx3.axis_pri = 0 : tx3.ts : 1/tx3.prf - tx3.ts; % Sampled PRI duration
tx3.axis_tau = 0 : tx3.ts : tx3.tau - tx3.ts;   % Sampled Pulse duration
tx3.axis_dwell = 0: tx3.ts : tx3.dwell - tx3.ts;

% Simulate PRI
tx3.sim_tau = ones(1,tx3.samples_tau);          % Initiate and Simulate a PRI
tx3.sim_pri = zeros(1,tx3.samples_pri);         % Initiate and Simulate a simple pulse

% Simulate received signal at rx (Use modified RRE for one-way propagation)
tx3.rx.peakpwr = (tx3.p_tx*tx3.gain*rx.gain*tx3.lambda^2)/((tx3.range^2)*(4*pi)^2);    % Peak power received 

tx3.delay = tx3.range/var_uni.c;                                % Time delay corresponding to the transmitter range
tx3.samples_range = round(tx3.fs*tx3.delay);                    % Range sampling

switch tx3.mod                                      % Modulation control        
    case 'pulse'
        tx3.rf = sin(2*pi*tx3.fo*(linspace(0,1,length(tx3.sim_tau))));
        tx3.wf = tx3.sim_tau.*tx3.rf;
        tx3.sim_pri(tx3.samples_range : tx3.samples_range + tx3.samples_tau-1) = tx3.wf;
        tx3.sim_tx = tx3.sim_pri;
    
    case 'lfm'
        tx3.pcr = input('PCR = ');
        tx3.lfm = exp(1i*pi*tx3.pcr.*(linspace(0,1,length(tx3.sim_tau))).^2);
        tx3.wf = tx3.sim_tau.*tx3.lfm;
        tx3.sim_pri(tx3.samples_range : tx3.samples_range + tx3.samples_tau-1) = tx3.wf;
        tx3.sim_tx = tx3.sim_pri;
end

% Form a CPI
tx3.cpi = (repmat(tx3.sim_tx,1,tx3.pulses));     
tx3.cpi = tx3.cpi.*(sind(linspace(30,150,length(tx3.cpi)))); 

% Introduce noise
var_uni.noise = wgn(1,length(tx3.cpi),var_uni.np,'dBm');
tx3.cpi = sqrt((tx3.rx.peakpwr.*tx3.cpi).*var_uni.imp); 
tx3.cpi_dbm = 10*log10(10*((tx3.cpi + var_uni.noise).^2)); 

figure;plot((1:length(tx3.cpi)).*tx3.ts*1e3 ,tx3.cpi_dbm) 
grid on; xlabel('Dwell Time (ms)');ylabel('Voltage (dBm)')
title('3dB Beamwidth Affected CPI received from TX3')
ylim([-130 0])

figure
subplot(3,1,1); plot((1:length(tx1.sim_pri)).*tx1.ts,tx1.sim_pri)
subplot(3,1,2); plot((1:length(tx2.sim_pri)).*tx2.ts,tx2.sim_pri)
subplot(3,1,3); plot((1:length(tx3.sim_pri)).*tx3.ts,tx3.sim_pri)

%% Concatenating the data over a single dwell

% Initialize arrays with consistent dimensions to allocate dwells    
var_uni.refary1 = zeros(1,max([length(tx1.cpi),length(tx2.cpi),length(tx3.cpi)]));
var_uni.refary2 = zeros(1,max([length(tx1.cpi),length(tx2.cpi),length(tx3.cpi)]));
var_uni.refary3 = zeros(1,max([length(tx1.cpi),length(tx2.cpi),length(tx3.cpi)]));

var_uni.refary1(1:length(tx1.cpi)) = (tx1.cpi);                        % Assign dwells in ""dBm""
var_uni.refary2(1:length(tx2.cpi)) = (tx2.cpi);
var_uni.refary3(1:length(tx3.cpi)) = (tx3.cpi);

% The signals assigned above are noise free because when each noisy dwell
% is added, each signal adds noise according to its own bandwidth. Here,
% noiseless signals are concatenated followed by a unanimous single
% noise for the  entire period

% introducing noise
var_uni.noise_3 = wgn(3,length(var_uni.refary1),var_uni.np,'dBm');   
    
% concatenating dwells frome the transmitters vertically
rx.interleave_dwellun = 10*log10((10*([var_uni.refary1;                                             % Unnormalized Interleaved dwells 
                  var_uni.refary2;
                  var_uni.refary3]+ var_uni.noise_3).^2));

figure                                                                                              % Plotting the unnormalized dwells
plot((1:length(var_uni.refary1)).*tx1.ts*1e3, rx.interleave_dwellun(:,:)); 
xlabel('Dwell Time (ms)'); ylabel('Received Voltage (dBm)'); title('Un-normalized Interleaved Transmitter Dwells ')
grid on; legend('Transmitter 1','Transmitter 2', 'Transmitter 3')
ylim([-130 0])

%% Simulate Receiver Scan listening time for the transmitters
% This section is divided into 03 sub-sections, where the received dwells
% from each transmitter are individually determined and then visualised.
% The dwells impinging on the receiver are manifested with the range delay
% incorporated into the dwell. In addition to that, the delay due to the 
% (mechanical) scan rate is also incorporated here.
% This is done by determining the time per revolution (TPR) of the
% transmitters followed by their conversion into samples and assigning the
% dwell values to the correspoding listening time samples. To randomly
% initialize the angle of the transmitter w.r.t the receiver, such that the
% rx and tx are not directly facing each other at the start of the
% listening time, the scan delay for the first dwell is randomly
% initialized followed with the periodic reception of dwells (since the
% scan rate is constant). To RANDOMLY INITIALIZE the scan delay, the min
% and max of these delays were identified which are 0 and TPR respectively,
% a scan delay cannot be more than the TPR of a tx.
% A random number is generated between zero and TPR and converted into
% samples. The first scan delay is randomly intialized using that sampled
% random number (with max =tpr). For the next dwells to be received, the
% dwells are started from (scandelay + i*TPR) where i is the number of
% dwells that a receiver can receive in its period. Since the scan rate of
% the transmitters is "assumed" to be unknown, a while loop is used to
% accept the dwells. The logic is ""while i*TPR/max(listening time)<1""
%This will only present the dwells during that time and keep the dimensions
%consitent.

% A listening time of "lt" secs for the receiver is created
rx.lt = input('Enter receiver listening period (s): ');
rx.t = 0 : tx1.ts : rx.lt - tx1.ts;                 % Receiver listening time
rx.tsample = tx1.fs*rx.t;                           % Samples

rx.list = zeros(3,length(rx.tsample));              % Listening time initialized 
rx.noise = wgn(3,length(rx.tsample),var_uni.np);
%% Transmitter 1
tx1.tpr = 60*6/tx1.rpm;                             % Time per revolution of TX1
rx.list1 = rx.list(1,:);

tx1.scandelay = tx1.fs*(tx1.tpr*rand(1,1));         % Generate Random no to manifest non-zero scan delay at the receiver 
                                                    % multiplied with samp freq to  shift samples 
rx.list1((tx1.scandelay) : (tx1.scandelay) + length(tx1.cpi)-1) = (tx1.cpi);
rx.list1 = rx.list1(1:length(rx.t));
% The maximum delay that will incur due to scan rate of the tx equals the
% tpr of the transmitters. The max delay will be when the tx starts
% operating just after it stops facing the rx antenna, and the min scan
% rate delay will be zero, meaning that the tx is directly bearing towards
% the rx. The delays must be manifested accordingly.

% figure
% plot(rx.t,rx.list1);xlabel('Receiver listening time (s)');ylabel('Receive Voltage (mV)')
% title('Dwells received as a function of transmitter 1 scan rate')
% grid on;

%% Transmitter 2
tx2.tpr = 60*6/tx2.rpm;                             % Time per revolution of TX1
rx.list2 = rx.list(2,:);                            % Reference axis

tx2.scandelay = tx2.fs*(tx2.tpr*rand(1,1));         % Generate Random no to manifest non-zero scan delay at the receiver 

i=1;                                                % Counter

% initiate the first dwell received based on randomly initialized scan
% position
rx.list2((tx2.scandelay) : (tx2.scandelay) + length(tx2.cpi)-1) = (tx2.cpi);

% Dwells received for the entire listening time
while (i*tx2.tpr)/rx.t(end) <= 1.0                  % Generalized receiver listening 
    rx.list2((tx2.scandelay + i*tx2.fs*tx2.tpr) : (tx2.scandelay + i*tx2.fs*tx2.tpr) + length(tx2.cpi)-1) = (tx2.cpi);
i = i+1;
end 
rx.list2 = rx.list2(1:length(rx.t));

% figure
% plot(rx.t,rx.list2);xlabel('Receiver listening time (s)');ylabel('Receive Voltage (mV)')
% title('Dwells received as a function of transmitter 2 scan rate')
% grid on;

%% Transmitter 3
tx3.tpr = 60*6/tx3.rpm;
rx.list3 = rx.list(3,:);
tx3.scandelay = tx3.fs*(tx3.tpr*rand(1,1));         % Generate Random no to manifest non-zero scan delay at the receiver 

rx.list3((tx3.scandelay) : (tx3.scandelay) + length(tx3.cpi)-1) = (tx3.cpi); % Initializing the random scan delay

i=1;
while (i*tx3.tpr)/rx.t(end) < 1                                                      % Inputting the remaining dwells
    rx.list3((tx3.scandelay + i*tx3.fs*tx3.tpr) : (tx3.scandelay + i*tx3.fs*tx3.tpr) + length(tx3.cpi)-1) = (tx3.cpi);
    i = i+1;
end

rx.list3 = rx.list3(1:length(rx.t));
% figure
% plot(rx.t,rx.list3);xlabel('Receiver listening time (s)');ylabel('Receive Voltage (dBm)')
% title('Dwells received as a function of transmitter 3 scan rate')
% grid on;

%% Interleaving the tx dwells received over the listening period of the receiver
% In this section, the dwells observed in the previous section are
% interleaved together over the same listening time of the receiver. This
% is done by first creating a matrix consisting of the vectors representing
% dwells in individual and then plotting them.
rx.interleaved_dbm = 10*log10(10.*([rx.list1;rx.list2;rx.list3]+ rx.noise).^2 );

rx.interleaved = [rx.list1;rx.list2;rx.list3];

figure                                              
plot(rx.t, rx.interleaved_dbm(:,:)); 
xlabel('Receive Time (s)'); ylabel('Received Voltage (dBm)'); title('Interleaved dwells at the receiver')
grid on; legend('Transmitter 1','Transmitter 2', 'Transmitter 3')
ylim([-110 0])

%% Summing the received dwells
% In this section, dwells received from the three dwells are summed. As a
% result, it is expected that the overlapping pulses of the various dwells 
% will form a maligned signal which will have to be cleaned and processed
% for use in DSP and estimation of the true properties of the waveforms and
% hence characteristics of the transmitters

rx.summed = 10*log10(10.*(sum(rx.interleaved)+ rx.noise).^2 );     % The sum function sums the rows of the 
% matrix, i.e., a(1,1) + a(2,1) 

figure                                              
plot(rx.t, rx.summed(1,:)); 
xlabel('Receive Time (s)'); ylabel('Received Voltage (dBm)'); title('Cumulative dwells at the receiver')
grid on;
ylim([-110 0])

