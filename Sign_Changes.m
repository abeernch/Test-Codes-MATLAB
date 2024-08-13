function N = Sign_Changes(x)
N = 0;
chk = sign(x(1));
for i = 2:numel(x)
chk_up = sign(x(i));
if chk ~= chk_up
    N = N+1;
else
    continue 
end
chk = chk_up;
end
end
%% Alternate, more efficient sol
% N = sum(diff(sign(x))~=0)