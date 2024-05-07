%% Script to generate files for scan mode testing and training  for AI threat detection processor
% The script generates the scan shapes for each of the following scans:
% 1. Bi-Directional Sector
% 2. Circular 
% 3. Electronic
% 4. Steady

% Each scan is generated with a random set of relevant parameters 'N'
% number of times 

%% General variable parameters
%  are listed as follows:
% 1. Azimuth beamwidth (2-50 degrees)

% Variables specific to each scan type are listed in the specific bloc
clear; clc
%% Initialize Antenna
N = 1000;
scan_data = cell(1,4);
for i = 1 : N
    antenna = phased.SincAntennaElement("Beamwidth",[round((rand(1,1)*48)+2) 2], ...
              "FrequencyRange",[1e9 2e9]);
% antenna = phased.SincAntennaElement("Beamwidth",[2 2], ...
%               "FrequencyRange",[1e9 2e9]);

    az = pattern(antenna,1.5e9,-180:0.36:180-0.36,0,'Normalize',true,'Type','powerdb');
    env = db2pow(az);

%% Electronic Scan
% Variable parameters
% 1. Scan limits (-90 to 90)
% 2. Automatic/fixed switching
% 3. Lobe scan time

% Random selection of elscanmode
    mode = {'fixed';'random'};
    el_scan_mode = mode{randi([1 2],1)};
    % Random lobe scan time
    lobe_scan_time = round((rand(1,1)*99e-3) + 1e-3);
    
    v1 = 1;                                                                          % intialize a counter
    chk_fix = round(rand*(100-10)+10);                                               % err control in case fixed samples < 1
    elscan = zeros(1,1000);                                                          % pre allocate array
            
    while v1/1000 <= 1                                                               % run until elscan pattern generated for all pulses
        switch el_scan_mode 
            case 'fixed'                                                             % User defined lobe retention time
                rv_length = floor(lobe_scan_time*1000);                              % length is equal to the number of pulses in the defined interval
                if rv_length < 1
                    rv_length = chk_fix;
                end
            case'random'                                                             % automatically switch lobes after random interval
                rv_length = floor(rand*(((sum(1000))/5)-2)+2);                       % max length of interval vector is 1/5 of the total pulses
        end
    
        samp_rand = round((rand*(510-490))+490);                                     % access a random sample from the tx az pattern
        elscan(1, v1:v1 + rv_length - 1) = env(samp_rand)*ones(1,rv_length);         % append the collected pattern and scale by the value 
                                                                                     % of randomly sampled envelope        
        v1 = v1 + rv_length;                                                         % incrementer
    
    end
    elscan = elscan(1:1000);
    % Plot
    % plot((1:length(elscan)).*0.36,(elscan))
    clearvars el_scan_mode samp_rand lobe_scan_time mode rv_length v1 chk_fix
%% Bisector scan
% Variable parameters
% 1. Scan limits (-90 to 90 degrees)
    env_bi = env(251:751);
    scan_lim = [-1*round((rand()*89)+1) round((rand()*89)+1)];
    samps = (sum(abs(scan_lim)))/0.36;
    env = circshift(env,round((rand()*(251-751))));
    sec_scan = env_bi(1:samps);                                                        % single sided sector scan pattern for the given limits
    sec_scan = [sec_scan; flipud(sec_scan)].';
    sec_scan = resample(sec_scan,1000,length(sec_scan));        
    delay = round(rand()*length(sec_scan));
    sec_scan = circshift(sec_scan,delay);
    % Plot
    % plot((1:length(sec_scan)).*0.36,(sec_scan))
    clearvars samps scan_lim env_bi delay

%% Circular Scan
% Variable parameter
% 1. Delay
    delay = round(rand()*length(env));
    circ_scan = circshift(env,delay).';
    % Plot
    % plot((1:length(circ_scan)).*0.36,(circ_scan))
    clearvars delay 

%% Steady Scan
    samp = round((rand()*(510-490))+490);
    steady_scan = env(samp);
    delay = round(rand()*length(steady_scan));
    steady_scan = circshift(steady_scan,delay);
    steady_scan = steady_scan.*ones(1,1000);
    
    % Plot
    % plot(1:length(steady_scan),(steady_scan))
    clearvars samp env delay az antenna

%% Accumulate data
scan_data{1}(i,:) = elscan; 
scan_data{2}(i,:) = sec_scan; 
scan_data{3}(i,:) = circ_scan; 
scan_data{4}(i,:) = steady_scan; 
clearvars steady_scan elscan circ_scan sec_scan
end