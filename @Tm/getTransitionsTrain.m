function  transition_k = getTransitionsTrain(obj,k)

% if no k is provided, return for current k:
if nargin < 2
    k = obj.k_current;
end

%return gamma for given k
transition_k = obj.transition_train(k,:);

end

