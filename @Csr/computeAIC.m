function [aic,varhat_k] = computeAIC(obj,gp,index,k)

% compute temporary membership values - gammahat_kn (Equation 4)
gpmodel = gpmodel2struct(gp,index);
yhatk = gpmodel.val.ypred;
% QUESTION: GAMMAHAT FOR ALL MODES OR ONLY THIS ONE????
% GREEDY WOULD SUGGEST ALL????
% This is equivalent to option 1.b in runEM().
% for one candidate for the new pareto set
gammahat = obj.computeGammaHat(k,obj.var_val,obj.x_val,obj.y_val,yhatk);

% compute temporary variance - sigmahat^2_k (Equation 5)
varhat_k.val = obj.computeVar(k,gp,index,'val',gammahat);
varhat_k.train = obj.computeVar(k,gp,index,'train',gammahat);
varhat_k.test = obj.computeVar(k,gp,index,'test',gammahat);
% QUESTION: or do we use gamma instead of gammahat. 
% very confused now. 

% compute global fitness using temporary values - E_csr (Equation 2)
ecsr = 0;
yhat = obj.predictData('all','val');
weights = obj.getWeightsVal('all');
weights(k,:) = gammahat;
yhat(:,k) = yhatk;
for kk=1:obj.K
    ecsr = ecsr + obj.kAbsError(yhat(:,kk),obj.y_val,weights(kk,:));
end

c = gp.fitness.nodecount(index);
N = size(obj.y_val,1);

%global AIC
aic = 2*c + N*log(ecsr);

end

