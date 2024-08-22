%% Controlled Random PW Generator for PDW Simulator
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


figure;plot((reportedPW),'.')
figure;plot((cumPW),'.')
