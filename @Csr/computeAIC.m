function aic = computeAIC(obj,gp,index,k)

yactual = obj.y_val;
yhatk = obj.predictData(gp,obj.x_val,index);

% for one candidate for the new pareto set
gammahatk = obj.computeGammaHat(k,obj.var_val,obj.x_val,yactual,yhatk);

% compute global fitness using temporary values - E_csr (Equation 2)
yhat = obj.getAllPredictions('val');
weights = obj.getWeightsVal('all');
weights(k,:) = gammahatk;
yhat(:,k) = yhatk;
ecsr = obj.absError(yhat,yactual,weights);

c = gp.fitness.nodecount(index);
N = size(yactual,1);

%global AIC
aic = 2*c + N*log(ecsr);

end

