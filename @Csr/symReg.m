function [gp,index_pareto] = symReg(obj)

% symbolic regression
gp = rungp(@obj.gpConfig);

% compute fitness metrix and complexity for current population
pop = gp.runcontrol.pop_size;
valfitness = zeros(pop,1);
complexity = gp.fitness.complexity;
weights = obj.getWeightsVal();

for p=1:pop
    gpmodel = gpmodel2struct(gp,p);
    err = obj.y_val - gpmodel.val.ypred;
    for i=1:size(err,1)
        valfitness(p) = valfitness(p) - weights(i)*log(1+norm(err(i,:)));
    end
    valfitness(p) = valfitness(p)/sum(weights);
end

% find pareto front
index_pareto = ndfsort_rank1([valfitness complexity]);

end

