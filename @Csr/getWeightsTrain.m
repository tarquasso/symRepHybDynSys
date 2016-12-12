function  gamma_k = getWeightsTrain(obj,k)

% if no k is provided, return for current k:
if nargin < 2
    k = obj.k_current;
end

%return gamma for given k
gamma_k = obj.gamma_train(k,:);

end

