clc;
j =1;
grid on
for i = 1:400
    d =  readmatrix("interleaved.csv","Range",[j 1 j+rx.sim_interval*tx1.fs*tx1.int_factor-1 1]);
    
    plot(1e3*(j:rx.sim_interval*tx1.fs*tx1.int_factor*i)./tx1.fs,(pow2db(abs(d)) + 30),'Color',[0.0392 0.4314 0.6314])
    xlim([0 rx.sim_time*tx1.fs*tx1.int_factor]);ylim([-100 0])
    hold on
    j = j + rx.sim_interval*tx1.fs*tx1.int_factor;
    disp(i)
    pause(0.2)
end
hold off

%% Test electronic scanning
tx1.pulses = 1000;
tt= 50e-3;
t = 'random';
v1 = 1;
i = 1;
tx1.elscan = zeros(1,sum(tx1.pulses));

while v1/sum(tx1.pulses)<=1
    switch t 
        case 'fixed'
            rv_length = tt*sum(tx1.pulses);
        case'random'
            rv_length = floor(rand*(((sum(tx1.pulses))/5)-2)+2);
    end

    samp_rand = round((rand*(27001-9001))+9001);
    tx1.elscan(1,v1:v1+rv_length-1) = env(samp_rand)*ones(1,rv_length);

    v1 = v1 + rv_length;
    
end
tx1.elscan = tx1.elscan(1:sum(tx1.pulses));
scatter((1:length(tx1.elscan)),pow2db(tx1.elscan)+30);