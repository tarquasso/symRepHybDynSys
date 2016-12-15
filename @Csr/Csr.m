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
                localObj.initiated = false;
            end
            singleObj = localObj;
        end
    end
    
    
    %other methods
    methods (Access = public)
        [] = initiateCsr(obj,init); % initiate CSR class instance  
        [f,var] = runEM(obj);
        gamma_k = getWeightsTrain(obj,k);
        gamma_k = getWeightsTest(obj,k);
        gamma_k = getWeightsVal(obj,k);
        gamma = getAllWeightsTrain(obj);
        gamma = getAllWeightsTest(obj);
        gamma = getAllWeightsVal(obj);
        gp = gpConfig(obj,gp) %move to private methods?
        
        [valfitness,gp,ypredval] = updateParetoSet(obj,gp);
    end
    
    methods (Access = private)
        gp = symReg(obj)
        aic = computeLocalAIC(obj,gp,index,k)
        aic = computeAIC(obj,gp,index,k)
        ecsr_k = kAbsError(obj,ypred,yactual,weights);
        ecsr_k = kQuadError(obj,ypred,yactual,weights);
        ecsr = absError(obj,ypred,yactual,weights);
        vark = computeVar(obj,k,gp,i,set,gamma);
        ypred = predictData(predictor,x,index);
        yhat = fullPrediction(obj,x); % predict data according to mixture model
        yhat = maxPrediction(obj,x); % predict data according to most likely membership
        gamma = computeGamma(obj,k,var,x,y);
        gamma = computeGammaHat(obj,k,var,x,y,yhatk);
        [] = fUpdate(obj,k,gp,i_best);
    end
    
    properties (Access = private)
        x_train;
        y_train;
        x_test;
        y_test;
        x_val;
        y_val;
        
        ypred_train;
        ypred_test;
        ypred_val;
        
        k_current;
        K;
        gamma_train;
        gamma_test;
        gamma_val;
        
        
        f;
        var_train;
        var_test;
        var_val;
        
        pareto_fstr;
        pareto_fit;
        pareto_complex;
        
        runningEM;
        initiated;
    end
    
    methods (Static)
        [fitness,gp] = csrFitfun(evalstr,gp);
        fitness = computeFitness(weights,y,ypred);
        [valfitness,gp,ypredval] = csrSelectPareto(gp)
    end
end

