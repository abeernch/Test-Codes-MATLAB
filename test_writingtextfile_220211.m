x =  resample(rx.dwell,10000,round(length(rx.dwell)/100));
t = table(x);
writetable(t,'d','WriteMode','overwrite','Delimiter','')
%%
fileID = fopen('nums1.txt','a');
for i = 1:length(x)
% fprintf(fileID,'number of pulses are: %4.4f\n',sum(tx1.pulses));
fprintf(fileID,'%4.4f\n',x(i));
end
fclose(fileID);
%% file read
% very very dlow for a large file
file_id = fopen('tx1','r');
a = fscanf(file_id,'%f');
%%
t = table(rx.rxsig1);
writetable(t,'d.csv','WriteMode','append','Delimiter',' ')
%%
