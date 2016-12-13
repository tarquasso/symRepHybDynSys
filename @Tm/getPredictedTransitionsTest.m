function  trans_k_ksub = getPredictedTransitionsTest(obj,k,ksub)

if nargin < 2
    k = obj.k_current;
    ksub = obj.ksub_current;
end

trans_k_ksub = obj.ypred_test(:,k,ksub);

end

