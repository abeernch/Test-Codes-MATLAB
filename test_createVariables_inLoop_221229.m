for k=1:5
    temp_var = strcat( 'x',num2str(k) );
    eval(sprintf('%s = %g',temp_var,k*2));
end