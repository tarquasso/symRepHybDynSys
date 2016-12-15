function vark = computeVar(obj,k,set,gamma)
% compute var for one mode  k.

if strcmpi(set,'val')
    
    weightsk = obj.getWeightsVal(k);
    ypred = obj.getAllPredictions('val',k);
    yactual = obj.y_val;
    
elseif strcmpi(set,'test')
    
    weightsk = obj.getWeightsTest(k);
    ypred = obj.getAllPredictions('test',k);
    yactual = obj.y_test;
    
else % compute variance for training set 
    
    weightsk = obj.getWeightsTrain(k);
    ypred = obj.getAllPredictions('train',k);
    yactual = obj.y_train;
    
end

% if necessary, we can overwrite the default weights. Used to compute
% temporary variance. 
if nargin > 5
    weightsk = gamma;
end

% eq.5 to calculate variance of mode k
ecsr_k = obj.kQuadError(ypred,yactual,weightsk); % last part of the equation
vark = ( sum(weightsk)/(sum(weightsk).^2 - sum(weightsk.^2)) ) * ecsr_k;

end

