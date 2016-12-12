function var = computeVar(obj,k,gp,i,set,gamma)
% compute var for one mode  k.

weightsk = [];
ypred = [];
yactual = [];

if strcmpi(set,'val')
    
    weightsk = obj.getWeightsVal(k);
    gpmodel = gpmodel2struct(gp,i);
    ypred = gpmodel.val.ypred;
    yactual = obj.y_val;
    
elseif strcmpi(set,'test')
    
    weightsk = obj.getWeightsTest(k);
    gpmodel = gpmodel2struct(gp,i);
    ypred = gpmodel.test.ypred;
    yactual = obj.y_test;
    
else % compute variance for training set 
    
    weightsk = obj.getWeightsTrain(k);
    gpmodel = gpmodel2struct(gp,i);
    ypred = gpmodel.train.ypred;
    yactual = obj.y_train;
    
end

% if necessary, we can overwrite the default weights. Used to compute
% temporary variance. 
if nargin > 5
    weightsk = gamma;
end

ecsr_k = obj.kAbsError(ypred,yactual,weightsk);
var = sum(weightsk)/(sum(weightsk).^2 - sum(weightsk.^2))*ecsr_k;

end

