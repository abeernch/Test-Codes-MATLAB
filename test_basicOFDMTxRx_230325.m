% OFDM Transmitter and Receiver

%% Transmitter
% Define parameters
N = 64;                 % Number of subcarriers
cp_len = 16;            % Length of cyclic prefix
data_len = N - cp_len;  % Length of data in each OFDM symbol
num_symbols = 100;      % Number of OFDM symbols to transmit
snr = 10;               % Signal-to-noise ratio in dB

% Generate random data to transmit
data = randi([0 1], data_len*num_symbols, 1);

% Reshape data into subcarriers
data_matrix = reshape(data, data_len, num_symbols);

% Perform IFFT on each subcarrier to generate time-domain signal
time_domain = ifft(data_matrix, N);

% Add cyclic prefix to each symbol
cp = time_domain(end-cp_len+1:end,:);
time_domain_cp = [cp; time_domain];

% Convert time-domain signal to serial stream for transmission
transmitted_signal = time_domain_cp(:);

% Add Gaussian noise to transmitted signal
noise = sqrt(0.5*10^(-snr/10))*(randn(length(transmitted_signal),1) + 1i*randn(length(transmitted_signal),1));
received_signal = transmitted_signal + noise;

%% Receiver
% Remove cyclic prefix from received signal
received_signal_nocp = reshape(received_signal, N+cp_len, num_symbols);
received_signal_nocp = received_signal_nocp(cp_len+1:end,:);

% Perform FFT on each subcarrier to recover data
data_received = fft(received_signal_nocp, N);

% Reshape received data into serial stream
data_received = data_received(:);

% Calculate bit error rate
[num_errors, ber] = biterr(round(abs(data_received)), round(abs(data_received)));

% Display results
fprintf('Number of errors: %d\n', num_errors);
fprintf('Bit error rate: %g\n', ber);
