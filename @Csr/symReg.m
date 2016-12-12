function [gp,index_pareto] = symReg(obj,k)

% symbolic regression
gp = rungp(@obj.gpConfig); %Running GPTIPS (p.15)

% compute fitness metrix and complexity for current population
pop = gp.runcontrol.pop_size;
valfitness = zeros(pop,1);
complexity = gp.fitness.complexity;
weights = obj.getWeightsVal(k);

for p=1:pop
    gpmodel = gpmodel2struct(gp,p);
    err = obj.y_val - gpmodel.val.ypred;
    for i=1:size(err,1)
        valfitness(p) = valfitness(p) - weights(i)*log(1+norm(err(i,:)));
    end
end
valfitness = valfitness./sum(weights);

% find pareto front as 0,1-vector
index_pareto = ndfsort_rank1([valfitness complexity]);

end

