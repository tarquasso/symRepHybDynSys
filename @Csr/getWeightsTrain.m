function  gamma_k = getWeightsTrain(obj,k)

if nargin < 2
    k = obj.k_current;
end
gamma_k = obj.gamma_train(k,:);

end

