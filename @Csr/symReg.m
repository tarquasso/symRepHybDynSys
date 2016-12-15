function gp = symReg(obj)

% symbolic regression
gp = rungp(@obj.gpConfig); %Running GPTIPS (p.15)

% the pareto set is automatically updated after each generation in
% updateParetoSet and stored in object.
end

