function var = computeVar(obj,gp,i_best,set)

weights = [];
ypred = [];
yactual = [];

if strcmpi(set,'val')
    
    weights = obj.getWeightsVal();
    gpmodel = gpmodel2struct(gp,i_best);
    ypred = gpmodel.val.ypred;
    yactual = obj.y_val;
    
elseif strcmpi(set,'test')
    
    weights = obj.getWeightsTest();
    gpmodel = gpmodel2struct(gp,i_best);
    ypred = gpmodel.test.ypred;
    yactual = obj.y_test;
    
else % compute variance for training set 
    
    weights = obj.getWeightsTrain();
    gpmodel = gpmodel2struct(gp,i_best);
    ypred = gpmodel.train.ypred;
    yactual = obj.y_train;
    
end

ecsr_k = obj.kAbsError(ypred,yactual,weights);
var = sum(weights)/(sum(weights).^2 - sum(weights.^2))*ecsr_k;

end

