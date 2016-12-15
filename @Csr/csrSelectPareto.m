function [valfitness,gp,ypredval] = csrSelectPareto(gp)
% this function is called after each generation to identify the current
% pareto optimal set. 

[valfitness,gp,ypredval] = Csr.getInstance.updateParetoSet(gp);


end