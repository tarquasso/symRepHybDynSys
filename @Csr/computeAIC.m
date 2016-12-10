function aic = computeAIC(obj,gp,index,k)

% compute temporary membership values - gammahat_kn (Equation 4)
gpmodel = gpmodel2struct(gp,index);
yhatk = gpmodel.val.ypred;
gammahat = obj.computeGammaHat(k,obj.var_val,obj.x_val,obj.y_val,yhatk);

% compute temporary variance - sigmahat^2_k (Equation 5)
varhat_k = obj.computeVarHat(k,gp,index,gammahat);

% compute global fitness using temporary values - E_csr (Equation 2)
ecsr = 0;
for kk=1:obj.K
    if kk == k
        weights = gammahat;
        yhat = yhatk;
    else
        weights = obj.getWeightsVal(kk);
        yhat = obj.predictData(kk,obj.x_val);
    end
    ecsr = ecsr + obj.kAbsError(yhat,obj.y_val,weights);
end

c = gp.fitness.nodecount(index);
N = size(obj.y_val,1);

aic = 2*c + N*log(ecsr);

end

