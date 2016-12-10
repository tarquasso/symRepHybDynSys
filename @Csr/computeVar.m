function var = computeVar(obj,gp,i_best,set)
% compute var for one mode  k.

weightsk = [];
ypred = [];
yactual = [];

if strcmpi(set,'val')
    
    weightsk = obj.getWeightsVal();
    gpmodel = gpmodel2struct(gp,i_best);
    ypred = gpmodel.val.ypred;
    yactual = obj.y_val;
    
elseif strcmpi(set,'test')
    
    weightsk = obj.getWeightsTest();
    gpmodel = gpmodel2struct(gp,i_best);
    ypred = gpmodel.test.ypred;
    yactual = obj.y_test;
    
else % compute variance for training set 
    
    weightsk = obj.getWeightsTrain();
    gpmodel = gpmodel2struct(gp,i_best);
    ypred = gpmodel.train.ypred;
    yactual = obj.y_train;
    
end

ecsr_k = obj.kAbsError(ypred,yactual,weightsk);
var = sum(weightsk)/(sum(weightsk).^2 - sum(weightsk.^2))*ecsr_k;

end

