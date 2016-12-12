function aic = computeLocalAIC(obj,gp,index,k)

c = gp.fitness.nodecount(index); % nodes for current candidate
N = size(obj.y_val,1); % data set size
gpmodel = gpmodel2struct(gp,index);
ypred = gpmodel.val.ypred; %prediction for current mode and candidate
yactual = obj.y_val; % output of validation (same for all modes and candidates)
weights = obj.getWeightsVal(k); % current mode

% local AIC score eq.8 only for current gp in one mode (local)
aic = 2*c + N*log(obj.kAbsError(ypred,yactual,weights));

end

