function [] = fUpdate(obj,k,gp,i_best)

obj.f{k} = gpmodel2sym(gp,i_best);
gpmodel = gpmodel2struct(gp,i_best);
obj.ypred_train(:,k) = gpmodel.train.ypred;
obj.ypred_test(:,k)  = gpmodel.test.ypred;
obj.ypred_val(:,k)   = gpmodel.val.ypred;

end

