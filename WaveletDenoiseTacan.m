%% Multiresolution Analysis using MODWT and reconstruction using selective components
% define number of levels to use
Signal_Tacan = awgn(sin(2*60*linspace(0,1,1e6)),10,0) ;
numLevels = floor(log2(length(Signal_Tacan)));
wvlet = 'sym18';
% perform maximal overlap discrete wavelet transform (MODWT)
wt = modwt(Signal_Tacan, wvlet, numLevels);
% Get the separated signal components in time 
mra = modwtmra(wt,wvlet);

%% Reconstruct the signal using only the components of interest
% Naturally, the components of interest in MRA are those not representing
% noise, i.e. the last components of the MRA
% The recontructed signal is acquired by excluding the high frequency
% isolated components and summing the low frequency components.

reconstr_sig = sum(mra(end-3:end,:)); % The last three components

%% Plot and compare
figure,plot(Signal_Tacan)
hold on
plot(reconstr_sig,'LineWidth',3)