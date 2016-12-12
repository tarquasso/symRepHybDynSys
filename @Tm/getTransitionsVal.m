function  transition_k = getTransitionsVal(obj,k)

if nargin < 2
    k = obj.k_current;
end

transition_k = obj.transition_val(k,:);

end

