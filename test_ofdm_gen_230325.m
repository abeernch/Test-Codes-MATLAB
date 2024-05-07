% Generate two orthogonal waveforms

% Define parameters
N = 64;  % Number of samples per waveform

% Generate first waveform
w1 = rand(1, N);    % A simple example of a waveform
w1 = w1/norm(w1);   % Normalize the waveform

% Generate second waveform
w2 = randn(1, N);   % A random waveform
w2 = w2 - dot(w2,w1)*w1;   % Orthogonalize the waveform to the first waveform
w2 = w2/norm(w2);   % Normalize the waveform

% Plot the waveforms
t = 1:N;
figure
plot(t, w1, 'b', t, w2, 'r')
xlabel('Sample index')
ylabel('Amplitude')
legend('Waveform 1', 'Waveform 2')
title('Two Orthogonal Waveforms')
