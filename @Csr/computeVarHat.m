function var = computeVarHat(obj,gp,i,gammahat)
% compute temporary variance for mode k 

    gpmodel = gpmodel2struct(gp,i);
    ypred = gpmodel.val.ypred;
    yactual = obj.y_val;

ecsr_k = obj.kAbsError(ypred,yactual,gammahat);
var = sum(gammahat)/(sum(gammahat).^2 - sum(gammahat.^2))*ecsr_k;

end

