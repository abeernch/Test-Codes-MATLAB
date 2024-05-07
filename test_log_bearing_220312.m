% init_TargetLoc = [1000;2000;0];
% init_TargetVel = [100;10;0];
Origin = [0;0;0];
k =1;
tx.bearing = zeros(tx.pulses_sim,2);
for i=1: tx.pulses_sim
update_rate = 1/1000;
            
% Update the dynamics of receiver after every PRI
[rx.pos_up,rx.vel_up] = rx.pf(update_rate);

% Update the transmitter dynamics based on velocity motion model.
[tx.pos_up,tx.vel_up] = tx.pf(update_rate);

% Get receiver angles w.r.t transmitter position (non-essential)
[rx.range,rx.angle] = rangeangle(rx.pos_up,tx.pos_up);

% This gives us the angle
[tx.range,tx.angle] = rangeangle(tx.pos_up,rx.pos_up);
tx.bearing(i,:) = tx.angle;
end
    