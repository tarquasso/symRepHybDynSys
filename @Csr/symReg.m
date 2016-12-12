function [gp,index_pareto] = symReg(obj,k)

% symbolic regression
gp = rungp(@obj.gpConfig); %Running GPTIPS (p.15)

% compute fitness matrix and complexity for current population
pop = gp.runcontrol.pop_size; % size of population
valfitness = zeros(pop,1); % init fitness
complexity = gp.fitness.complexity; %complexity integer, based on node complexities
weights = obj.getWeightsVal(k); %prior membership gammas

N = size(obj.y_val,1);

for p=1:pop
    gpmodel = gpmodel2struct(gp,p); % simplify gp to a single model struct
    err = obj.y_val - gpmodel.val.ypred; % calculate error based on validation - prediction
    
    for i=1:N
        valfitness(p) = valfitness(p) - weights(i)*log( 1+norm(err(i)) ); % concatenate the fitness by each n
    end
end

valfitness = valfitness./sum(weights); %denominator operation of eq. 7, normalizes

% find pareto front as 0,1-vector
index_pareto = ndfsort_rank1([valfitness complexity]); % finds pareto solution from gptips2 
% dimension of index_pareto for whole population the last generation
% index =1 for the best fitness in every complexity level

end

