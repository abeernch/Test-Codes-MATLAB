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


figure;plot((reportedFreq),'.')
figure;plot((cumFreq),'.')
