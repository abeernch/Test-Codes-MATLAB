n_files = 2;
fs = 200e6;
sim_interval = 5e-3;
sim_time =  1;
j = 1;

for i = 1:n_files
    d =  readmatrix("data.csv","Range",[j 1 j + (sim_time/n_files)*fs-1 1]);
    name = 'data_file' + string(i)+ '.csv';
    writematrix(d,name);
    j = j + (sim_time/n_files)*fs;
end