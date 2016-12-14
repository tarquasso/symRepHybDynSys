function [valfitness,gp,ypredval] = updateParetoSet(obj,gp)

% obj.pareto_fstr:
% cell array with current pareto set.
% It will be saved as their internal string for efficiency. Will be
% preferred over more readible, yet less efficient symbolic version.
% (and we don' have to do many unneccary conversions)

% obj.pareto_fit:
% current fitnesses in pareto set

% obj.pareto_complex:
% complexities of current pareto set

% compute fitness matrix and complexity for current population
pop = gp.runcontrol.pop_size; % size of population

valfitness = zeros(pop,1); % init fitness
complexity = gp.fitness.complexity; %complexity integer, based on node complexities
gammatilde_val = obj.getGammaTildeVal(obj.k_current); %prior transition get gamma for current k

for p=1:pop
    ypredval = Tm.predictDataTM(gp,gp.userdata.xval,p);
    valfitness(p) = Tm.transitionFitness(ypredval,gp.userdata.yval,gammatilde_val);
end

% find pareto front as 0,1-vector
index_pareto = logical(ndfsort_rank1([valfitness complexity])); % finds pareto solution from gptips2 
% dimension of index_pareto for whole population the last generation
% index =1 for the best fitness in every complexity level

% extract new pareto set
valfitness = valfitness(index_pareto);
complexity = complexity(index_pareto);
fstr = gp.pop(index_pareto);

% merge current and new pareto set
valfitness = [valfitness;obj.pareto_fit];
complexity = [complexity;obj.pareto_complex];
fpop = [fstr ; obj.pareto_fstr];

% find new overall pareto set
index_pareto = ndfsort_rank1([valfitness complexity]);
obj.pareto_fit = valfitness(index_pareto);
obj.pareto_complex = complexity(index_pareto);
obj.pareto_fstr = fpop(index_pareto);

end

