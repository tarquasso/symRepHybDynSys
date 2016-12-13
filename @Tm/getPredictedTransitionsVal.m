function  trans_k_ksub = getPredictedTransitionsVal(obj,k)

if nargin < 2
    k = obj.k_current;
    ksub = obj.ksub_current;
end

trans_k_ksub = obj.ypred_val(:,k,ksub);

end

