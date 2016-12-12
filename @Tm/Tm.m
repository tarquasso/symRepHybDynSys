classdef (Sealed) Tm < handle
    % TM Summary
    % singleton class to cluster functionality around Tm
    % Main reason for this design choice is the necessity of accessing data
    % from various places.
    
    % methods that define singleton class
    methods (Access = private) 
        function obj = Tm
        end
    end
    methods (Static)
        function singleObj = getInstance
            persistent localObj
            if isempty(localObj) || ~isvalid(localObj)
                localObj = Tm;
                localObj.initiated = false;
            end
            singleObj = localObj;
        end
    end
    
    
    %other methods
    methods (Access = public)
        [] = initiateTm(obj,init) % initiate Tm class instance  
        [f,var] = runTM(obj,x,y,K)
        gamma_k = getTransitionsTrain(obj,k)
        gamma_k = getTransitionsTest(obj,k)
        gamma_k = getTransitionsVal(obj,k)    
        gp = gpConfigTM(obj,gp) %move to private methods?
    end
    
    methods (Access = private)
        [gp,index_pareto] = symRegTM(obj,k)
        aic = computeLocalAIC(obj,gp,index,k)
        aic = computeAIC(obj,gp,index,k)
        eTm_k = kAbsError(obj,ypred,yactual,weights);
        eTm_k = kQuadError(obj,ypred,yactual,weights);
        var = computeVar(obj,k,gp,i,set,gamma);
        yhat = predictData(obj,k,x);
        gamma = computeGamma(obj,k,var,x,y);
        gamma = computeGammaHat(obj,k,var,x,y,yhatk);
        [] = fUpdate(obj,k,gp,i_best);
    end
    
    properties (Access = private)
        % Weight Balance
        ptp;
        ntp;
        ntpTilde;
        gammaTilde;
        
        
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
        
        runningTM;
        initiated;
    end
    
    methods (Static)
        [fitness,gp,theta,ypredtrain,fitnessTest,ypredtest,pvals,r2train,r2test,r2val,geneOutputs,geneOutputsTest,geneOutputsVal]=TmFitfun(evalstr,gp)
        [valfitness,gp,ypredval] = TmFitfunValidate(gp)
    end
end

