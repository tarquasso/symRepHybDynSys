classdef (Sealed) Csr < handle
    % CSR Summary
    % singleton class to cluster functionality around CSR
    % Main reason for this design choice is the necessity of accessing data
    % from various places.
    
    % methods that define singleton class
    methods (Access = private) 
        function obj = Csr
        end
    end
    methods (Static)
        function singleObj = getInstance
            persistent localObj
            if isempty(localObj) || ~isvalid(localObj)
                localObj = Csr;
            end
            singleObj = localObj;
        end
    end
    
    
    %other methods
    methods (Access = public)
        [f,var] = runEM(obj,x,y,K)
        gamma_k = getWeightsTrain(obj,k)
        gamma_k = getWeightsTest(obj,k)
        gamma_k = getWeightsVal(obj,k)
        [] = initiateCsr(obj,init) % initiate CSR class instance
        gp = gpConfig(obj,gp)
    end
    
    methods (Access = private)
        [gp,index_pareto] = symReg(obj)
        aic = computeLocalAIC(obj,gp,index,k)
        aic = computeAIC(obj,gp,index,k)
        ecsr_k = kAbsError(obj,ypred,yactual,weights);
        var = computeVar(obj,k,gp,i_best,set);
        var = computeVarHat(obj,k,gp,i,gammahat);
        yhat = predictData(obj,k,x);
        gamma = computeGamma(obj,k,var,x,y);
        gamma = computeGammaHat(obj,k,var,x,y,yhatk);
    end
    
    properties (Access = private)
        x_train;
        y_train;
        x_test;
        y_test;
        x_val;
        y_val;
        
        k_current;
        K;
        gamma_train;
        gamma_test;
        gamma_val;
        
        
        f;
        var_train;
        var_test;
        var_val;
        
        runningEM;
        initiated;
    end
    
    methods (Static)
        [fitness,gp,theta,ypredtrain,fitnessTest,ypredtest,pvals,r2train,r2test,r2val,geneOutputs,geneOutputsTest,geneOutputsVal]=csrFitfun(evalstr,gp)
        [valfitness,gp,ypredval] = csrFitfunValidate(gp)
    end
end

