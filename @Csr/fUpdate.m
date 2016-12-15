function [] = fUpdate(obj,k,gp,i_best)

evalstr = tree2evalstr(obj.pareto_fstr{i_best},gp); % get decoded function string

obj.ypred_train(:,k) = obj.predictData(evalstr,obj.x_train);
obj.ypred_test(:,k)  = obj.predictData(evalstr,obj.x_test);
obj.ypred_val(:,k)   = obj.predictData(evalstr,obj.x_val);

obj.f{k} = obj.csrPretty(gp,obj.pareto_fstr{i_best});

end

