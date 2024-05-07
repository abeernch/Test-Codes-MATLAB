
v1 = 1;                                                                         % intialize a counter
tx{n}.elscan = zeros(1,sum(tx{n}.pulses_sim));                                  % pre allocate array

if tx{n}.platformType == 1

    chk = (abs(tx{n}.bear(1,1:length(tx{n}.ori)).') + abs(tx{n}.ori));
    fin = find(chk < 200 & chk > 160);
    fout = find(chk > 200 | chk < 160);

    while v1/length(fin)<=1

         switch tx{n}.el_scan_mode 
            case 'fixed'                                                            % User defined lobe retention time
                rv_length = floor(tx{n}.lobe_scan_time*length(fin));                % length is equal to the number of pulses in the defined interval
            case'random'                                                            % automatically switch lobes after random interval
                rv_length = floor(rand*(((length(fin))/5)-2)+2);                    % max length of interval vector is 1/5 of the total pulses
         end
                samp_rand = round((rand*(27001-9001))+9001);                        % access a random sample from the tx az pattern
                eslcan_in(1,v1:v1+rv_length-1) = env(samp_rand)*ones(1,rv_length);
                v1 = v1 + rv_length; 
    end
    tx{n}.elscan(fout) = 0;
    tx{n}.elscan(fin) = eslcan_in(1:length(fin));
end

if tx{n}.platformType == 

    while v1/sum(tx{n}.pulses_sim)<=1                                               % run until elscan pattern generated for all pulses
    

        if tx{n}.platformType == 1
            
            chk = (abs(tx{n}.bear(1,1:length(tx{n}.ori)).') + abs(tx{n}.ori));
            fin = find(chk < 200 & chk > 160);
            fout = find(chk > 200 | chk < 160);

             switch tx{n}.el_scan_mode 
                case 'fixed'                                                            % User defined lobe retention time
                    rv_length = floor(tx{n}.lobe_scan_time*length(fin));                % length is equal to the number of pulses in the defined interval
                case'random'                                                            % automatically switch lobes after random interval
                    rv_length = floor(rand*(((length(fin))/5)-2)+2);                    % max length of interval vector is 1/5 of the total pulses
             end
                samp_rand = round((rand*(27001-9001))+9001);                            % access a random sample from the tx az pattern
                eslcan_in(1,v1:v1+rv_length-1) = env(samp_rand)*ones(1,rv_length);
        else
            switch tx{n}.el_scan_mode 
                case 'fixed'                                                            % User defined lobe retention time
                    rv_length = floor(tx{n}.lobe_scan_time*sum(tx{n}.pulses_sim));      % length is equal to the number of pulses in the defined interval
                case'random'                                                            % automatically switch lobes after random interval
                    rv_length = floor(rand*(((sum(tx{n}.pulses_sim))/5)-2)+2);          % max length of interval vector is 1/5 of the total pulses
                    samp_rand = round((rand*(27001-9001))+9001);
            end
            
            tx{n}.elscan(1,v1:v1+rv_length-1) = env(samp_rand)*ones(1,rv_length);       % append the collected pattern and scale by the value 
                                                                                        % of randomly sampled envelope 
        end
   tx{n}.elscan(fout) = 0;
   tx{n}.elscan(fin) = eslcan_in;
   v1 = v1 + rv_length;                                                        % incrementer
end
    

tx{n}.elscan = tx{n}.elscan(1:sum(tx{n}.pulses_sim));


