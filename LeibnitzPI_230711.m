%% Leibnitz Theorem for calculation of Pi
paii = 0;
aaa = 0;
for l= 0:1e5
    aaa = 4*((-1)^l)*1/(2*l+1);
    paii = paii+aaa;
end