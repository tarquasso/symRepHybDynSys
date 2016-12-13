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
    valfitness(p) = obj.computeFitness(weights,obj.y_val,gpmodel.val.ypred);
end

% find pareto front as 0,1-vector
% both smaller is better (smaller fitness and smaller complexity) 
index_pareto = ndfsort_rank1([valfitness complexity]); % finds pareto solution from gptips2 
% dimension of index_pareto for whole population the last generation
% index =1 for the best fitness in every complexity level

end

