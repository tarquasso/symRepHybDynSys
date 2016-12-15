function gamma = computeGamma(obj,k,var,x,y)
% compute gammas for one k and all data points n as row vector

n = size(y,1);

% yhat = n x k
% y = n x 1
% y_large = n x k
% var = k x 1
% var_large = n x k
% prob = n x k
% gamma = 1 x n
yhat = obj.getAllPredictions(x);
y_large = repmat(y,1,obj.K);
var_large = repmat(var',n,1);

prob = normpdf(y_large,yhat,var_large);
gamma = ( prob(:,k)./sum(prob,2) )';

end

