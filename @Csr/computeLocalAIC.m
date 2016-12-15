function aic = computeLocalAIC(obj,gp,index,k)

evalstr = tree2evalstr(obj.pareto_fstr{index},gp); % get decoded function string
ypredval = obj.predictData(evalstr,obj.x_val);

yval = obj.y_val; % output of validation (same for all modes and candidates)
weights = obj.getWeightsVal(k); % current mode

% local AIC score eq.8 only for current gp in one mode (local)
c = gp.fitness.nodecount(index); % nodes for current candidate
N = size(obj.y_val,1); % data set size

aic = 2*c + N*log(obj.kAbsError(ypredval,yval,weights));

end

