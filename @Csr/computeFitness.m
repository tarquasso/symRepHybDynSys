function fitness = computeFitness(weights,y,ypred)

% checking for correct size and if a elements are finite reals
% This check is necessary since there is a small number of models that are
% generated and just bullshit (less than 1%, checked)
check_size = isequal(size(ypred),size(y));
check_valid = all( isfinite( ypred(:) ));
check_real = all( isreal( ypred(:) ));

if check_size && check_valid && check_real
    %calculate weighted, mean logarithmic error
    abserr = abs(y - ypred);
    fitness = ( weights*log(1+abserr) )  / sum(weights);
else    
    fitness = inf;   
    %   warning('Invalid predictions, setting fitness to Inf');    
end

end

