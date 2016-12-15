function yhat = maxPrediction(obj,x)
% For some input data get mixture model prediction
% i.e. y_n = sum_k (weights_k,n * y_n,k)

if strcmpi(x,'val') || isequal(x,obj.x_val)
    gamma = obj.gamma_val;
    ypred = obj.ypred_val';

elseif strcmpi(x,'test') || isequal(x,obj.x_test)
    gamma = obj.gamma_test;
    ypred = obj.ypred_test';
elseif strcmpi(x,'train') || isequal(x,obj.x_train)
    gamma = obj.gamma_train;
    ypred = obj.ypred_train';
else
    assert(false,'Use x = {train,test,val');
end

maxindex = gamma == max(gamma,[],1);
yhat = ypred(maxindex);
    
end