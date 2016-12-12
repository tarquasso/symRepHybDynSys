function [gp,index_pareto] = symRegTM(obj,k)

% symbolic regression
gp = rungp(@obj.gpConfigTM); %Running GPTIPS (p.15)

% compute fitness matrix and complexity for current population
pop = gp.runcontrol.pop_size; % size of population
valfitness = zeros(pop,1); % init fitness
complexity = gp.fitness.complexity; %complexity integer, based on node complexities
gammatilde = obj.getGammaTildeVal(k); %prior transition get gamma for current k

N = size(obj.y_val,1);

for p=1:pop
    gpmodel = gpmodel2struct(gp,p); % simplify gp to a single model struct
    err = obj.y_val(2:N) - logsig(gpmodel.val.ypred); % calculate error based on validation - prediction
    valfitness(p) = sum(-gammatilde .* (err.^2));
end

sumGammaTilde = sum(gammatilde);
valfitness = valfitness./sumGammaTilde; %denominator operation of eq. 7, normalizes

% find pareto front as 0,1-vector
index_pareto = ndfsort_rank1([valfitness complexity]); % finds pareto solution from gptips2 
% dimension of index_pareto for whole population the last generation
% index =1 for the best fitness in every complexity level

end

