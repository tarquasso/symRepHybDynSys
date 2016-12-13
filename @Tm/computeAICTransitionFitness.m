function aic = computeAICTransitionFitness(obj,gp,index)

c = gp.fitness.nodecount(index);
N = size(obj.y_val,1);
gpmodel = gpmodel2struct(gp,index);
ypred = gpmodel.val.ypred;
yactual = gp.userdata.yval;
gammatilde = obj.getGammaTildeVal(obj.k_current);

aic = 2*c + N*log(obj.transitionFitness(ypred,yactual,gammatilde));

end

