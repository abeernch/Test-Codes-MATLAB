clc;
% Create Pulsed signal structure (DC = 1pc)
pulse = ones(1,100);
pri = zeros(1,900);
Pri = [pulse pri];

% Introduce RF signal
rf_sig = exp(1i*2*pi*100e3*(linspace(0,length(Pri),length(Pri))));

rf_train = rf_sig.*Pri;
% Replicate to create a train of pulses
train = repmat(rf_train,1,100);

%% Add white Gaussian noise to complex signal
noisySig = awgn(train,100,0);

%% Add pink noise
pk_noise = pinknoise(1,length(noisySig));

noisySig = noisySig + pk_noise;
figure;plot(1:length(train),db(noisySig))
fax = linspace(-1e3/2,1e3/2,4096);
figure; plot(fax,db(abs(fftshift(fft(noisySig(950:1150),4096)))))