dec_fact = (sim.sim_interval*tx{1}.fs)/25000;
sub_samp = 1:dec_fact:length(channel);
for int = 1:length(sub_samp)
    dec_save(int) = channel(sub_samp(int));
end
int = int+1;