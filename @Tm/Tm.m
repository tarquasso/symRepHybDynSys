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
        runTM(obj)
        f_k_ksub = getAlgebraicFunction(obj,k,ksub)

        trans_k_ksub = getPredictedTransitionsTrain(obj,k,ksub)
        trans_k_ksub = getPredictedTransitionsVal(obj,k,ksub)
        trans_k_ksub = getPredictedTransitionsTest(obj,k,ksub)

        gammatilde_k = getGammaTildeTrain(obj,k)
        gammatilde_k = getGammaTildeVal(obj,k)
        gammatilde_k = getGammaTildeTest(obj,k)
        
        gp = gpConfigTM(obj,gp) %move to private methods?
    end
    
    methods (Access = private)
        [gp,index_pareto] = symRegTM(obj,k)
        aic = computeAICTransitionFitness(obj,gp,index,k)
        [] = fUpdate(obj,k,ksub,gp,i_best);
    end
    
    properties (Access = private)
        % Weight Balance
        ptp_train;
        ptp_val;
        
        ntp_train;
        ntp_val;
        
        ntpTilde_train;
        ntpTilde_val;
        
        gammaTilde_train;
        gammaTilde_val;
        gammaTilde_test;
        
        x_train;
        y_train;
        x_val;
        y_val;
        x_test;
        y_test;
        
        ypred_train;
        ypred_val;
        ypred_test;
        
        k_current;
        ksub_current;
        K;
        
        f;
        
        runningTM;
        initiated;
    end
    
    methods (Static)
        fitness = transitionFitness(ypred,yactual,gammatilde);
        [fitness,gp] = tmFitfun(evalstr,gp)
        [valfitness,gp,ypredval] = tmFitfunValidate(gp)
        ypred = predictDataTM(predictor,x,index)

    end
end

