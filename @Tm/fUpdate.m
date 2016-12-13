function [] = fUpdate(obj,k,ksub,gp,i_best)

obj.f{k,ksub} = gpmodel2sym(gp,i_best);
gpmodel = gpmodel2struct(gp,i_best);
obj.ypred_train(:,k,ksub) = gpmodel.train.ypred;
obj.ypred_test(:,k,ksub)  = gpmodel.test.ypred;
obj.ypred_val(:,k,ksub)   = gpmodel.val.ypred;

end

