%% Testing the simulatneous operation of two vectors of different length in the same general for loop
clear;clc
% create two arrays
n1 = ones(1,10000);
n2 = ones(1,8500);

%% Determine total iterations needed
total = max([length(n1)  length(n2)]);

% pre-allocate a matrix for assignment
op = (zeros(1,total));

% zero-padding the vectors

%%
j = 1;
for i = 1:total
    
    if i <= length(n1) % keep the operation as long as the vector lasts, then append zeros for the rest of the samples
        n1(i) = rand*n1(i);
    else
        n1(i) = 0;
    end
    if i <= length(n2)
        n2(i)  = rand*n1(i);
    else
        n2(i)  = 0;
    end

    op(i) = n1(i) + n2(i);
    
    % plotting in for loop
%     figure(1)
%     plot(i,op(i))
%     hold on
%     grid on
%     xlim([0 total])
%     ylim([-1 1])
    
end


    
