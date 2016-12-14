function aic = computeAICTransitionFitness(obj,gp,index)

yval = gp.userdata.yval;
xval = gp.userdata.xval;

evalstr = tree2evalstr(obj.pareto_fstr{index},gp); % get decoded function string
ypredval = obj.predictDataTM(evalstr,xval);
gammatildeval = obj.getGammaTildeVal(obj.k_current);

c = gp.fitness.nodecount(index);
N = size(yval,1);

aic = 2*c + N*log(obj.transitionFitness(ypredval,yval,gammatildeval));

end

