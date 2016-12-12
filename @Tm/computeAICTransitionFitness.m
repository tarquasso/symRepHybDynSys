function aic = computeAICTransitionFitness(obj,gp,index,k)

c = gp.fitness.nodecount(index);
N = size(obj.y_val,1);
gpmodel = gpmodel2struct(gp,index);
ypred = gpmodel.val.ypred;
yactual = obj.y_val;
weights = obj.getWeightsVal(k);

aic = 2*c + N*log(obj.kAbsError(ypred,yactual,weights));

end

