function [aic,varhat_k] = computeAIC(obj,gp,index,k)

% compute temporary membership values - gammahat_kn (Equation 4)
gpmodel = gpmodel2struct(gp,index);
yhatk = gpmodel.val.ypred;
% QUESTION: GAMMAHAT FOR ALL MODES OR ONLY THIS ONE????
% GREEDY WOULD SUGGEST ALL????
% This is equivalent to option 1.b in runEM().
gammahat = obj.computeGammaHat(k,obj.var_val,obj.x_val,obj.y_val,yhatk);

% compute temporary variance - sigmahat^2_k (Equation 5)
varhat_k.val = obj.computeVar(k,gp,index,'val',gammahat);
varhat_k.train = obj.computeVar(k,gp,index,'train',gammahat);
varhat_k.test = obj.computeVar(k,gp,index,'test',gammahat);
% QUESTION: or do we use gamma instead of gammahat. 
% very confused now. 

% compute global fitness using temporary values - E_csr (Equation 2)
ecsr = 0;
for kk=1:obj.K
    if kk == k
        weights = gammahat;
        yhat = yhatk;
    else
        weights = obj.getWeightsVal(kk);
        yhat = obj.predictData(kk,obj.x_val);
    end
    ecsr = ecsr + obj.kAbsError(yhat,obj.y_val,weights);
end

c = gp.fitness.nodecount(index);
N = size(obj.y_val,1);

aic = 2*c + N*log(ecsr);

end

