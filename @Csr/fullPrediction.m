function yhat = fullPrediction(obj,x)
% For some input data get mixture model prediction
% i.e. y_n = sum_k (weights_k,n * y_n,k)

if strcmpi(x,'val') || isequal(x,obj.x_val)
    % gamma = k x n
    % ypred = n x k
    % gamma.*ypred --> one line per data point
    % sum --> sum out the columns to get one prediction for one data point
    % for the mixture model
    % same as yhat_n = (ypred*gamma)_nn
    yhat = sum(obj.gamma_val'.*obj.ypred_val,2);
    return;
end

if strcmpi(x,'test') || isequal(x,obj.x_test)
    yhat = sum(obj.gamma_test'.*obj.ypred_test,2);
    return;
end

if strcmpi(x,'train') || isequal(x,obj.x_train)
    yhat = sum(obj.gamma_train'.*obj.ypred_train,2);
    return;
end

assert(false,'Use x = {train,test,val');

end