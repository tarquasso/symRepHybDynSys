function ecsr = absError(obj,ypred,yactual,weights)
% compute E_Csr where sum over all modes and the whole data set.

% ypred = n x k 
% yactual = n x 1
% weights = k x n
% E_csr = sum_k sum_n gamma_kn*abs(y_n - ypred_kn)

err = abs(ypred - repmat(yactual,1,obj.K));
ecsr_kn = weights.*err';
ecsr = sum(ecsr_kn(:));

end

