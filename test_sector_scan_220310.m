antenna = phased.SincAntennaElement("Beamwidth",[10 2], ...
              "FrequencyRange",[1e9 2e9]);
az = pattern(antenna,1.5e9,-180:0.01:180,0,'Normalize',true,'Type','powerdb');
env = db2pow(az);
env = env(9001:27001);
samps = (sum(abs(tx{1}.scan_lim)))/0.01;
env = circshift(env,round((rand()*(27001-9001))));
sec_scan = env(1:samps);                                                        % single sided sector scan pattern for the given limits
sec_scan = [sec_scan; flipud(sec_scan)];
scatter((1:length(sec_scan)).*0.01,(sec_scan))