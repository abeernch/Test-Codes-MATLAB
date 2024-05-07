[status, commandOutput] = system('ipconfig');

str = 'IPv4 Address. . . . . . . . . . . : ';

% Extract ip addresses. There will be one for each network adapter, e.g. wired, wireless, etc.
index = strfind(commandOutput, str);
startingIndex = index + length(str);

% Access the indices representing the ip address
s = commandOutput(startingIndex:startingIndex+15);

% Get rid of any trailing non-numeric characters
s = erase(s,{newline,' '});

%%
% [status, commandOutput] = system('ipconfig')
% str = 'IPv4 Address. . . . . . . . . . . : ';
% % Extract ip addresses. There will be one for each network adapter, e.g. wired, wireless, etc.
% index = strfind(commandOutput, str);
% startingIndex = index + length(str);
% for k = 1 : length(startingIndex)
%     s = commandOutput(startingIndex(k):startingIndex(k) + 15);
% % Get rid of any trailing non-numeric characters
%     while isnan(str2double(s(end))) && length(s) > 1
%         s = s(1 : end-1);
%     end
%     ipaddress{k} = s;
% end