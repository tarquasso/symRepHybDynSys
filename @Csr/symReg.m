function gp = symReg(obj)

% reset pareto variables for new run
obj.pareto_fstr = [];
obj.pareto_fit = [];
obj.pareto_complex = [];

% symbolic regression
gp = rungp(@obj.gpConfig); %Running GPTIPS (p.15)

% the pareto set is automatically updated after each generation in
% updateParetoSet and stored in object.
end

