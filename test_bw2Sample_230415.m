% Generalized formula for converting between degrees of beamwidth to sample
% number to determine the first null of the pattern (and can be used for
% other parameters as well)

% Abeer Nasir Chaudhry
antenna = phased.SincAntennaElement("Beamwidth",[round((rand(1,1)*48)+2) 2], ...
    "FrequencyRange",[1e9 2e9]);

az = pattern(antenna,1e9,-180:360/ind_share(i):180-(1/ind_share(i)),0,'Normalize',true,'Type','powerdb');
env = db2pow(az);
factor = ind_share(1)/360;
element = (antenna.Beamwidth(1)+1)*factor;
null = [(ind_share(1)/2) - element, (ind_share(1)/2) + element]
figure;plot(env,'.')