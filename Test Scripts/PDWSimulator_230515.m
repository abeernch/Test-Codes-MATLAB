%% Controlled Random PRI Generator for PDW Simulator
clear;clc

% User configurable
nEmitters = 1;
nPDWs = 1e4;
percErr = 0.00000;

% From the total no of PDWs to be generated, assign each emitter random no
% of PDWs that are modeled as a Gaussian Distributed variable
% Generate no btw 0-1
share = abs(round(randn(1,nEmitters),5));

% Divide each by sum of the values generated and multiply by the total no
% of PDWs to be generated
ind_share = round((share./sum(share))*nPDWs);

% If sum falls below the nPDWs, add the shortage to the share of the last
% emitter

while sum((ind_share)) < nPDWs
    ind_share(end) = ind_share(end) + nPDWs - sum(ind_share);
end

% Available PRI Agilities
typePool = {'Fixed', 'Staggered', 'DnS', 'Jitter'};

% Access random agility for the no. of emitters to simulate
rng(2014)
agility = randi(length(typePool),1,nEmitters);

% Bound for PRIs
pri_lim = [100e-6 5e-3];

% Initialize
tx = cell(1,nEmitters);
k = 1;

%% Switch case for agility type
for i = 1:nEmitters
    switch agility(i)
        % Fixed
        case 1
            % generate a controlled random fixed PRI equal to the equal to the share of the emitters in no of PDWs
            tx{i}.levels_pri = 0;
            tx{i}.type_pri = 'Fixed';
            pri = round(rand(1)*(pri_lim(2) - pri_lim(1)) + pri_lim(1),6);
            tx{i}.pri = pri;
            pri = repelem(pri,ind_share(i));
            tx{i}.toa = pri + rand(1,ind_share(i))*(0.01*percErr*pri(1)*2) - (0.01*percErr*pri(1));

            % Staggered
        case 2
            % PRI levels [2 10]
            tx{i}.levels_pri = round(rand()*8+2);
            tx{i}.type_pri = 'Staggered';
            subrange = [rand()*(pri_lim(2) - pri_lim(1)) + pri_lim(1) rand()*(pri_lim(2) - pri_lim(1)) + pri_lim(1)];
            pri = round(rand(1,tx{i}.levels_pri)*(max(subrange) - min(subrange)) + min(subrange),6);
            tx{i}.pri = pri;
            pri = repmat(pri,1,ceil(ind_share(i)/length(pri)));
            pri = pri(1:ind_share(i));
            tx{i}.toa = pri;

            % DNS
        case 3
            % PRI levels [2 10]
            tx{i}.levels_pri = round(rand()*8+2);   
            tx{i}.type_pri = 'DnS';
            subrange = [rand()*(pri_lim(2) - pri_lim(1)) + pri_lim(1) rand()*(pri_lim(2) - pri_lim(1)) + pri_lim(1)];
            pri = round(rand(1,tx{i}.levels_pri)*(max(subrange) - min(subrange)) + min(subrange),6);
            tx{i}.pri = pri;
            pri = repelem(pri,1,tx{i}.levels_pri);
            pri = repmat(pri,1,ceil(ind_share(i)/length(pri)));
            pri = pri(1:ind_share(i));
            tx{i}.toa = pri;

            % Jitter
        case 4
            tx{i}.levels_pri(i) = 0;
            tx{i}.type_pri = 'Jitter';
            subrange = [rand()*(pri_lim(2) - pri_lim(1)) + pri_lim(1) rand()*(pri_lim(2) - pri_lim(1)) + pri_lim(1)];
            pri = round(rand(1,ind_share(i))*(max(subrange) - min(subrange)) + min(subrange),6);
            tx{i}.pri = pri;
            pri = pri(1:ind_share(i));
            tx{i}.toa = pri;
    end

    %% Accumlate the PRIs and convert them into TOAs
    cumPRI(k : k + ind_share(i) -1) = tx{i}.toa;
    k = k + ind_share(i);
end


%% Create TOAs
% by taking cumulutive sum of the elements of PRI for each emitter and
% Interleave randomly and save the generator to reproduce sequence for
% other parameters

v_toa = cumsum(cumPRI);

% Generate a controlled random number sequence
s = rng;
% Shuffle (interleave the TOAs) using random permutation of the values from
% all emitters
t = (randperm(length(cumPRI)));
% Apply logical masking
cumTOA = cumPRI(t);
% Final TOA Array
reportedTOA = cumsum(cumTOA);


% figure;plot((cumPRI),'.')
% figure;plot((reportedTOA),'.')
% figure;plot((cumTOA),'.')


%% Controlled Random Frequency Simulator
%% Controlled Random Frequency Generator for PDW Simulator
clc;close all

% Available Frequency Agilities
typePool = {'Fixed', 'Staggered', 'DnS', 'Jitter'};
% Access random agility for the no. of emitters to simulate
agility = randi(length(typePool),1,nEmitters);
% Bound for Frequency
freq_lim = [0 200e6];

% Initialize
k = 1;

%% Switch case for agility type
for i = 1:nEmitters
    switch agility(i)
        % Fixed
        case 1
            % generate a controlled random fixed PRI equal to the equal to the share of the emitters in no of PDWs
            tx{i}.levels_freq = 0;
            tx{i}.type_freq = 'Fixed';
            freq = round(rand(1)*(freq_lim(2) - freq_lim(1)) + freq_lim(1),6);
            tx{i}.freq = freq;
            freq = repelem(freq,ind_share(i));

            % Staggered
        case 2
            % freq levels [2 10]
            tx{i}.levels_freq = round(rand()*8+2);
            tx{i}.type_freq = 'Staggered';
            subrange = [rand()*(freq_lim(2) - freq_lim(1)) + freq_lim(1) rand()*(freq_lim(2) - freq_lim(1)) + freq_lim(1)];
            freq = round(rand(1,tx{i}.levels_freq)*(max(subrange) - min(subrange)) + min(subrange),6);
            tx{i}.freq = freq;
            freq = repmat(freq,1,ceil(ind_share(i)/length(freq)));
            freq = freq(1:ind_share(i));

            % DNS
        case 3
            % freq levels [2 10]
            tx{i}.levels_freq = round(rand()*8+2);
            tx{i}.type_freq = 'DnS';
            subrange = [rand()*(freq_lim(2) - freq_lim(1)) + freq_lim(1) rand()*(freq_lim(2) - freq_lim(1)) + freq_lim(1)];
            freq = round(rand(1,tx{i}.levels_freq)*(max(subrange) - min(subrange)) + min(subrange),6);
            tx{i}.freq = freq;
            freq = repelem(freq,1,tx{i}.levels_freq);
            freq = repmat(freq,1,ceil(ind_share(i)/length(freq)));
            freq = freq(1:ind_share(i));

            % Jitter
        case 4
            tx{i}.levels_freq(i) = 0;
            tx{i}.type_freq = 'Jitter';
            subrange = [rand()*(freq_lim(2) - freq_lim(1)) + freq_lim(1) rand()*(freq_lim(2) - freq_lim(1)) + freq_lim(1)];
            freq = round(rand(1,ind_share(i))*(max(subrange) - min(subrange)) + min(subrange),6);
            tx{i}.freq = freq;
            freq = freq(1:ind_share(i));
    end
    %% Accumlate the freqs and convert them into TOAs
    cumFreq(k : k + ind_share(i) -1) = freq;
    k = k + ind_share(i);
end

%% Interleave PWs under the same scheme of random permutation
% Call previously generated controlled random number sequence
rng(s)
% Shuffle (interleave the PWs) using random permutation of the values from
% all emitters
t = (randperm(length(cumFreq)));
% Apply logical masking
reportedFreq = cumFreq(t);


% figure;plot((reportedFreq),'.')
% figure;plot((cumFreq),'.')

%% Controlled Random Scan Amplitude
reportedScan = ones(length(reportedFreq),1);

%% Controlled Random PW Generator
clc;close all

% Available PRI Agilities
typePool = {'Non-Agile','Agile'};
% Access random agility for the no. of emitters to simulate
agility = randi(length(typePool),1,nEmitters);
% Bound for PRIs
pw_lim = [0.1e-6 100e-6];

% Initialize
k = 1;


%% Switch case for agility type
for i = 1:nEmitters
    switch agility(i)
        % Non-Agile
        case 1
            % generate a controlled random non-agile pulse width equal to the share of the emitters in no of PDWs
            tx{i}.type_pw = 'Non-Agile';
            pw = round(rand(1)*(pw_lim(2) - pw_lim(1)) + pw_lim(1),8);
            tx{i}.pw = pw;
            pw = repelem(pw,ind_share(i));

            % Agile
        case 2
            % PW levels [2 10]
            tx{i}.levels_pw = round(rand()*8+2);
            tx{i}.type_pw = 'Agile';
            subrange = [rand()*(pw_lim(2) - pw_lim(1)) + pw_lim(1) rand()*(pw_lim(2) - pw_lim(1)) + pw_lim(1)];
            pw = round(rand(1,tx{i}.levels_pw)*(max(subrange) - min(subrange)) + min(subrange),8);
            tx{i}.pw = pw;
            pw = repmat(pw,1,ceil(ind_share(i)/length(pw)));
            pw = pw(1:ind_share(i));
    end
    %% Accumlate the PRIs and convert them into TOAs
    cumPW(k : k + ind_share(i) -1) = pw;
    k = k + ind_share(i);
end

%% Interleave PWs under the same scheme of random permutation
% Call previously generated controlled random number sequence
rng(s)
% Shuffle (interleave the PWs) using random permutation of the values from
% all emitters
t = (randperm(length(cumPW)));
% Apply logical masking
reportedPW = cumPW(t);

% figure;plot((reportedPW),'.')
% figure;plot((cumPW),'.')



pdw(1:length(reportedTOA),1) = reportedTOA.';
pdw(1:length(reportedTOA),2) = reportedFreq.';
pdw(1:length(reportedTOA),3) = reportedScan;
pdw(1:length(reportedTOA),4) = reportedPW;

figure;plot(1:length(cumPRI),cumPRI,'.')
figure;plot(1:length(cumFreq),cumFreq,'.')
figure;plot(1:length(cumPW),cumPW,'.')