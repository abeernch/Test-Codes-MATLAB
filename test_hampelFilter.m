%% Hampel filter Design
id = [];
win_size = 6;
k = 1;
while k<length(tdoa{1})
    t_int = tdoa{1}(k:k + win_size);
    t_median = median(t_int);
    t_stdev = std(t_int);
    
    for i = 1:length(t_int)
        if (t_int(i)) > t_median + 1*t_stdev || t_int(i) < t_median - 1*t_stdev
            idx(i) = i;
            t_int(i) = t_median;
        else
            t_int(i) = t_int(i);
        end
    end
tdoa_hampel(k:k+win_size) = t_int; 
% id = [id ;idx(idx~=0)];
    k = k + win_size;
end

figure;plot(abs(tdoa{1}),'*')
hold on
plot(tdoa_hampel,'.')
%%
[y,i,xmedian,xsigma] = hampel(tdoa{1});
n = 1:length(tdoa{1});
plot(n,tdoa{1})
hold on
% plot(n,xmedian-3*xsigma,n,xmedian+3*xsigma)
plot(find(i),tdoa{1}(i),'sk')
hold off
legend('Original signal','Lower limit','Upper limit','Outliers')


%% Re-writing own Hampel filter
winSize = 3;
nsigma = 3;
medAD = movmad(tdoa{1},3);
med = movmedian(tdoa{1},winSize);
scale = -1 /(sqrt(2)*erfcinv(3/2));
xsigma = scale*medAD;

% identify points that are either NaN or beyond the desired threshold
xi = ~(abs(tdoa{1}-med) <= nsigma*xsigma);

% replace identified points with the corresponding median value
xf = tdoa{1};
xf(xi) = med(xi);

figure;plot((tdoa{1}),'*')
hold on
plot(xf,'.')