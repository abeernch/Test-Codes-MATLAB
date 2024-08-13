%% Test UDP
%%

clear;clc
toa = [];
load('tdoa_v33.mat')
client_port = 10012;
client_address = '127.0.0.1';
toa_arr = [TOA1.';TOA2.';TOA3.'];

u1 = udpport("datagram","IPV4","LocalHost",client_address,"LocalPort",client_port);

for i=1:length(TOA1)
    for j = 1:3
%     for i=1:length(TOA1)
        write(u1,(toa_arr(j,i)),"double",client_address,client_port);
    end
end

for j = 1:3
    for i=1:length(TOA1)
        data = read(u1,1,"double");
        d = data.Data;
        toa(j,i) = d;
    end
end