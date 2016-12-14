function aic = computeAICTransitionFitness(obj,gp,index)

yval = gp.userdata.yval;
xval = gp.userdata.xval;

ypredval = obj.predictDataTM(gp,xval,index);
gammatildeval = obj.getGammaTildeVal(obj.k_current);

c = gp.fitness.nodecount(index);
N = size(yval,1);

aic = 2*c + N*log(obj.transitionFitness(ypredval,yval,gammatildeval));

end

