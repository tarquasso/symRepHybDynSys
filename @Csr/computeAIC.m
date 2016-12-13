function aic = computeAIC(obj,gp,index,k)

% compute temporary membership values - gammahat_kn (Equation 4)
gpmodel = gpmodel2struct(gp,index);
yhatk = gpmodel.val.ypred;

% for one candidate for the new pareto set
gammahat = obj.computeGammaHat(k,obj.var_val,obj.x_val,obj.y_val,yhatk);

% compute global fitness using temporary values - E_csr (Equation 2)
yhat = obj.predictData('all','val');
weights = obj.getWeightsVal('all');
weights(k,:) = gammahat;
yhat(:,k) = yhatk;
ecsr = obj.absError(yhat,yactual,weights);

c = gp.fitness.nodecount(index);
N = size(obj.y_val,1);

%global AIC
aic = 2*c + N*log(ecsr);

end

