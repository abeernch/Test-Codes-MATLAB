%% TCP/IP
data = (1:100);
client_port = 10011;
client_address = '127.0.0.1';
tic

% server = tcpserver(client_address,client_port);
client = tcpclient('127.0.0.1',client_port,"Timeout",300);

write(client,data)
toc

read(server,length(data),"double")

%% UDP
data = (0.01:100);

client_port = 10011;
client_address = '127.0.0.1';

start = tic;
u1 = udpport("datagram","IPV4",OutputDatagramSize=length(data));
% for i=1:100
    write(u1,real(data),"double",client_address,client_port);
%     write(u1,imag(data),"double",client_address,client_port);
% end
toc(start)
