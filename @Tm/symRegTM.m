function [gp,index_pareto] = symRegTM(obj)

% symbolic regression
gp = rungp(@obj.gpConfigTM); %Running GPTIPS (p.15) for obj.ksub_current

%% Cant find in SR the val fitness for whole population, can't extract
% compute fitness matrix and complexity for current population
pop = gp.runcontrol.pop_size; % size of population

%valfitness = zeros(pop,1); % init fitness
valfitness = zeros(pop,1); % init fitness
complexity = gp.fitness.complexity; %complexity integer, based on node complexities
gammatilde_val = obj.getGammaTildeVal(obj.k_current); %prior transition get gamma for current k


for p=1:pop
    ypredval = Tm.predictDataTM(gp,gp.userdata.xval,p);
    valfitness(p) = Tm.transitionFitness(ypredval,gp.userdata.yval,gammatilde_val);
end

% find pareto front as 0,1-vector
index_pareto = ndfsort_rank1([valfitness complexity]); % finds pareto solution from gptips2 
% dimension of index_pareto for whole population the last generation
% index =1 for the best fitness in every complexity level

end

