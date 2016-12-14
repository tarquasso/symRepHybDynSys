function [] = fUpdate(obj,k,ksub,gp,i_best)

obj.f{k,ksub} = gppretty(gp,i_best);

obj.ypred_train(:,k,ksub) = obj.predictDataTM(gp,gp.userdata.xtrain,i_best);
obj.ypred_test(:,k,ksub)  = obj.predictDataTM(gp,gp.userdata.xtest,i_best);
obj.ypred_val(:,k,ksub)   = obj.predictDataTM(gp,gp.userdata.xval,i_best);

end

