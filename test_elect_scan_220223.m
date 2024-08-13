%% Test electronic scanning
tx1.pulses = 5000;
% tx1.bear = tx{1}.bear;
% env = db2pow(tx{1}.az);
tt= 50e-3;
t = 'random';
v1 = 1;
theta_inc = 1;
i = 1;
tx1.elscan = zeros(1,sum(tx1.pulses));

while v1/sum(tx1.pulses)<=1
    switch t 
        case 'fixed'
            rv_length = tt*sum(tx1.pulses);
        case'random'
            rv_length = floor(rand*(((sum(tx1.pulses))/5)-2)+2);
    end

%     switch air_profile
%         case 1 % Fighter profile
            if theta_inc+rv_length-1 <= tx1.pulses
                if abs(tx1.bear(1,theta_inc: theta_inc+rv_length-1)) <= 60
                    samp_rand = round((rand*(27001-9001))+9001);
                else
                    samp_rand = round((rand*9000)+1);
                end
                    theta_inc = theta_inc + rv_length;
            end
     
%         case 2 % AEWACS
%             if theta_inc+rv_length-1 <= tx1.pulses
%                 if abs(tx1.bear(1,theta_inc: theta_inc+rv_length-1))+90 <= 90
%                     samp_rand = round((rand*(27001-9001))+9001);
%                 else
%                     samp_rand = round((rand*9000)+1);
%                 end
%                     theta_inc = theta_inc + rv_length;
%             end
%     end

%     end
    tx1.elscan(1,v1:v1+rv_length-1) = env(samp_rand)*ones(1,rv_length);

    v1 = v1 + rv_length;
    
end
tx1.elscan = tx1.elscan(1:sum(tx1.pulses));
scatter((1:length(tx1.elscan)),pow2db(tx1.elscan)+30);

%% New approach for electronic scanning for airborne platforms
tx1.pulses = 5000;
tx1.bear = tx{1}.bear;
env = db2pow(tx{1}.az);
tt= 50e-3;
t = 'random';
v1 = 1;
theta_inc = 1;
i = 1;
tx1.elscan = zeros(1,sum(tx1.pulses));

inside = find(abs(tx1.bear(1,:))<=60);
outside = find(abs(tx1.bear(1,:))>60);


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


