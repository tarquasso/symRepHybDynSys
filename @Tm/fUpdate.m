function [] = fUpdate(obj,k,ksub,gp,i_best)

evalstr = gpreformat(gp,obj.pareto_fstr{i_best}); % get decoded function string

obj.ypred_train(:,k,ksub) = obj.predictDataTM(evalstr,gp.userdata.xtrain);
obj.ypred_test(:,k,ksub)  = obj.predictDataTM(evalstr,gp.userdata.xtest);
obj.ypred_val(:,k,ksub)   = obj.predictDataTM(evalstr,gp.userdata.xval);

% Our own version of gppretty to get symbolic, simplified equation out of it
obj.f{k,ksub} = obj.tmPretty(evalstr);

end