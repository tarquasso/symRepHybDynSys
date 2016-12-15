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
gamma_val = Csr.getInstance.getWeightsVal();

for p=1:pop
    ypredval = Csr.predictData(gp,gp.userdata.xval,p);
    valfitness(p) = Csr.computeFitness(gamma_val,gp.userdata.yval,ypredval);
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

% remove doubles from pareto set
criterion = [valfitness complexity];
[criterion,ic] = unique(criterion,'rows','stable');
valfitness = valfitness(ic);
complexity = complexity(ic);
fpop = fpop(ic);

% find new overall pareto set
index_pareto = logical(ndfsort_rank1(criterion));
obj.pareto_fit = valfitness(index_pareto);
obj.pareto_complex = complexity(index_pareto);
obj.pareto_fstr = fpop(index_pareto);

end

