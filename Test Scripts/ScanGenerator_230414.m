%% Controlled Random scan/amplitude Generator for PDW Simulator
clc;

% Available Frequency Agilities
typeScan = {'Circular', 'Electronic', 'Bidirectional'};
% Access random agility for the no. of emitters to simulate
% scan = randi(length(typeScan),1,nEmitters);
scan = [3,1];
% Bound for Frequency
freq_lim = [-100e6 100e6];

% Initialize
k = 1;

% Generate standard SINC scan pattern

%% Switch case for agility type
for i = 1:nEmitters
    % Randomly generate beamwidth [2 50]
    antenna = phased.SincAntennaElement("Beamwidth",[round((rand(1,1)*48)+2) 2], ...
        "FrequencyRange",[1e9 2e9]);

    az = pattern(antenna,1e9,-180:360/ind_share(i):180-(1/ind_share(i)),0,'Normalize',true,'Type','powerdb');
    env = db2pow(az);
    % Determine the first nulls of the pattern generally
    factor = ind_share(i)/360;
    element = (antenna.Beamwidth(i) + 1)*factor;
    null = [(ind_share(i)/2) - element, (ind_share(i)/2) + element];


    switch scan(i)
        % Circular
        case 1
            % Variable parameter
            % 1. Delay
            % scan = env(null(1)-round(0.1*null(1)):round(null(2)+0.1*null(2)));
            % f = find(env < 2e-3);
            % env(f) = inf;
            env = awgn(env,70);
            delay = round(rand()*length(env));
            scan = circshift(env,delay).';
            % Log the parameters into the structure
            tx{i}.amp = scan;
            tx{i}.type_scan = 'Circular';

            % Electronic
        case 2
            % Variable parameters
            % 1. Scan limits (-90 to 90)
            % 2. Automatic/fixed switching
            % 3. Lobe scan time

            % Random selection of elscanmode
            mode = {'fixed';'random'};
            el_scan_mode = mode{randi([1 2],1)};
            % Random lobe scan time
            lobe_scan_time = round((rand(1,1)*99e-3) + 1e-3,3);

            v1 = 1;                                                                          % intialize a counter
            chk_fix = round(rand*(100-10)+10);                                               % err control in case fixed samples < 1

            while v1/ind_share(i) <= 1                                                               % run until elscan pattern generated for all pulses
                switch el_scan_mode
                    case 'fixed'                                                             % User defined lobe retention time
                        rv_length = floor(lobe_scan_time*ind_share(i));                              % length is equal to the number of pulses in the defined interval
                        if rv_length < 1
                            rv_length = chk_fix;
                        end
                    case'random'                                                             % automatically switch lobes after random interval
                        rv_length = floor(rand*(((sum(ind_share(i)))/5)-2)+2);                       % max length of interval vector is 1/5 of the total pulses
                end

                samp_rand = round((rand*(null(2)-null(1))) + null(1));                                     % access a random sample from the tx az pattern
                elscan(1, v1:v1 + rv_length - 1) = env(samp_rand)*ones(1,rv_length);         % append the collected pattern and scale by the value
                % of randomly sampled envelope
                v1 = v1 + rv_length;                                                         % incrementer
            end
            elscan = awgn(elscan,70);
            scan = elscan(1:ind_share(i));
            % Log the parameters into the structure
            tx{i}.amp = scan;
            tx{i}.type_scan = 'Electronic';

            % Bidirectional
        case 3
            % Variable parameters
            % 1. Scan limits (-90 to 90 degrees)
            env_bi = env(round(null(1) - 0.2*null(1)) : round(null(2) + 0.2*null(2)));
            scan_lim = [-1*round((rand()*89)+1) round((rand()*89)+1)];
            samps = round((sum(abs(scan_lim)))/(360/ind_share(i)));
            sec_scan = env_bi(1:samps);                                                        % single sided sector scan pattern for the given limits
            sec_scan = [sec_scan; flipud(sec_scan)].';
            sec_scan = resample(sec_scan,ind_share(i),length(sec_scan));
            delay = round(rand()*length(sec_scan));
            sec_scan = circshift(sec_scan,delay);
            % f = find(sec_scan < 2e-3);
            % sec_scan(f) = inf;
            % Log the parameters into the structure
            tx{i}.amp = sec_scan;
            tx{i}.type_scan = 'Bidirectional';

    end
    %% Accumlate the scans
    cumScan(k : k + ind_share(i) -1) = tx{i}.amp;
    k = k + ind_share(i);
end
%% Interleave PWs under the same scheme of random permutation
% Call previously generated controlled random number sequence
rng(s)
% Shuffle (interleave the PWs) using random permutation of the values from
% all emitters
t = (randperm(length(cumScan)));
% Apply logical masking
reportedAmp = cumScan(t);


figure;plot((reportedAmp),'.')
figure;plot((cumScan),'.')
