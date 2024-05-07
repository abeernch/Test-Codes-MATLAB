%  Generate n (div) random numbers that add upto the total set


total = 10e3;
div = 5;
% Generate n random no btw 0-1
share = abs(round(randn(1,div),5));
% divide each by the sum of all and multiply by the total
ind_share = round((share./sum(share))*total);
% the sum would be equal to the 'total'
sum(ind_share)