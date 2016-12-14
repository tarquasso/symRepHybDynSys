function fitness = transitionFitness(ypred,yactual,gammatilde)


% persistent count_valid;
% persistent count_invalid;
%
% if isempty(count_valid)
%     count_valid = 0;
% end
%
% if isempty(count_invalid)
%     count_invalid = 0;
% end


% checking for correct size and if a elements are finite reals
% This check is necessary since there is a small number of models that are
% generated and just bullshit (less than 1%, checked)
check_size = isequal(size(ypred),size(yactual));
check_valid = all( isfinite( ypred(:) ));
check_real = all( isreal( ypred(:) ));

if check_size && check_valid && check_real
    
    err = yactual(2:end) - logsig(ypred(1:end-1)); % calculate error based on validation - prediction
    fitness = sum(gammatilde .* (err.^2));
    sumGammaTilde = sum(gammatilde);
    fitness = fitness/sumGammaTilde; %denominator operation of eq. 18, normalizes
    
    %  count_valid = count_valid + 1;
    
else
    
    fitness = inf;
    
    %   warning('Invalid predictions, setting fitness to Inf');
    %   count_invalid = count_invalid + 1;
    %   disp(['valid count:' num2str(count_valid), ', invalid:' num2str(count_invalid)]);
    
end

end