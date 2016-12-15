function aic = computeAIC(obj,gp,index,k)

xval = obj.x_val;
yval = obj.y_val;
varval = obj.var_val;

evalstr = tree2evalstr(obj.pareto_fstr{index},gp); % get decoded function string
ypredvalk = obj.predictData(evalstr,xval);

% for one candidate for the new pareto set
gammahatk = obj.computeGammaHat(k,varval,xval,yval,ypredvalk);

% compute global fitness using temporary values - E_csr (Equation 2)
ypredval = obj.getAllPredictions('val');
ypredval(:,k) = ypredvalk;

weightsval = obj.getWeightsVal('all');
weightsval(k,:) = gammahatk;

% global AIC
ecsr = obj.absError(ypredval,yval,weightsval);
c = gp.fitness.nodecount(index);
N = size(yval,1);

aic = 2*c + N*log(ecsr);

end

