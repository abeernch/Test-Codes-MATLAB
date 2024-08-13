clc; clear
j =1;
total_time = 0.5;
sim_interval = 5e-3;
fs = 200e6;
while(j/(total_time*fs)) <=1
    d =  readmatrix("data1.csv","Range",[j 1 j + sim_interval*fs-1 1]);
   %%
    pause(5)
    sig = d.';
    % Network config
    client_port = 10011;
    client_address = "192.168.1.106";
    % Data packets
    data_size = 1e6;
    packet_size = 50e3;
    start = tic;
    u1 = udpport("datagram","IPV4","OutputDatagramSize",packet_size);
    for i=1:(data_size/packet_size)
        write(u1,real(sig((i-1)*packet_size+1:(i-1)*packet_size+packet_size)),"double",client_address,client_port);
        write(u1,imag(sig((i-1)*packet_size+1:(i-1)*packet_size+packet_size)),"double",client_address,client_port);
    end
    toc(start)
   %%
    j = j + sim_interval*fs;
    pause(0.2)
end
