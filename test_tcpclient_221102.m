% This script is the client-end code for accepting and organizing data 
% received at the client end for the TCP/IP comm protocol for real-time
% streaming of IQ data in the ELINT SG.

clc;clear

% Initialize variables
re = [];
im = [];

% Create a client object. This must be initialized after the server is
% already created
Client_ = tcpclient('192.168.100.1',10011);


fs = 200e6;                         % Sampling frequency
sim_interval = 5e-3;                % Simulation interval (s)
datagram_Size = sim_interval*fs*16; % Total number of bytes per batch
batch_samples = sim_interval*fs;    % No. of samples in a single batch
packets = Client_.NumBytesAvailable;% Total number of bytes (all batches)

batches = packets/datagram_Size;    % Determine the total no of batches received

% This 'for loop' carries out the process of receiving the IQ samples for
% each batch and interleaving the real and imaginary samples that are
% originally received as blocs. The first batch_samples/2 are real samples
% and the succeeding ones are imaginary.

for i = 1:batches
                data = read(Client_,batch_samples,"double");
                a = data;
                re = [re a];
                data = read(Client_,batch_samples,"double");
                a = data;
                im = [im a];      
end
% Add to create a complex double array.
out = re + j*im;