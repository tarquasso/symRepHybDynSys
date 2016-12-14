function [valfitness,gp,ypredval] = tmSelectPareto(gp)
% this function is called after each generation to identify the current
% pareto optimal set. 

[valfitness,gp,ypredval] = Tm.getInstance.updateParetoSet(gp);


end