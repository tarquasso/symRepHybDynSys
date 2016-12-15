function gp = symRegTM(obj)

obj.pareto_fstr = [];
obj.pareto_complex = [];
obj.pareto_fit = [];

% symbolic regression
gp = rungp(@obj.gpConfigTM); %Running GPTIPS (p.15) for obj.ksub_current

% the pareto set is automatically updated after each generation in
% updateParetoSet and stored in object.
end