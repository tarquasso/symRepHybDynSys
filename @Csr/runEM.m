% top level file for clustered symbolic regression
% input:
%   unclustered input-output data - u_n , y_n
%   the number of subfunctions - K
% output: 
%   behavior for each mode - f_k (u_n)
%   variance for each mode - sigma^2_k, var_k

function [f,var_train] = runEM(obj)

% making sure we don't run the EM algorithm without initialization
errorMsg = 'You cannot start the EM-algorithm without initialization! Aborting';
assert(obj.initiated == true,errorMsg);
% making sure we don't run the EM algorithm multiple times at the same time
errorMsg = 'You cannot start the EM-algorithm twice! Aborting';
assert(obj.runningEM == false,errorMsg);
obj.runningEM = true;

% get some variables ready 
f = cell(obj.K,1);
var_train = zeros(obj.K,1); % this is always on the training set
var_test = var_train;
var_val = var_train;

% initialize and normalize random membership values
obj.gamma_train = rand(obj.K,size(obj.y_train,1));
obj.gamma_train = obj.gamma_train./repmat(sum(obj.gamma_train),obj.K,1);

obj.gamma_test = rand(obj.K,size(obj.y_test,1));
obj.gamma_test = obj.gamma_test./repmat(sum(obj.gamma_test),obj.K,1);

obj.gamma_val = rand(obj.K,size(obj.y_val,1));
obj.gamma_val = obj.gamma_val./repmat(sum(obj.gamma_val),obj.K,1);

% for each behavior in K modes :
for k = 1:obj.K
    obj.k_current = k;
    
    % sr_solutions = symbolic_regression(y_n = f_k(u_n),fitfunc)
    [gp,index] = obj.symReg(); % returns pareto set
    
    % check out best solution
    aic = zeros(size(index));
    aic(index == 0) = Inf;
        for i = 1:size(index,1)
            if index(i) == 0
                continue;
            end
            aic(i) = obj.computeLocalAIC(gp,i,k);
        end
    
    % set behavior f_k to solution with lowest local AIC score in sr_solutions
    [~,i_best] = min(aic);
    f{k} = gpmodel2sym(gp,i_best);
    
    % set variance for each behavior - sigma^2_k (Equation 5)
    var_train(k) = obj.computeVar(k,gp,i_best,'train'); % on training set!!
    var_test(k) = obj.computeVar(k,gp,i_best,'test');
    var_test(k) = obj.computeVar(k,gp,i_best,'val');
    
    
end

% while convergence is not achieved :
while true
    
    % for each behavior in K modes :
    for k = 1:obj.K
        obj.k_current = k;
        
        % # EXPECTATION STEP ##
        % for all the N data points :
        obj.gamma_train(k,:) = obj.computeGamma(k,obj.var_train,obj.x_train,obj.y_train);
        % #####################

        % # MAXIMIZATION STEP #
        % sr_solutions = symbolic_regression(y_n = f_k(u_n),fitfunc)
        % returns pareto set
        
        % for each solution in sr_solutions :
            % compute temporary membership values - gammahat_kn (Equation 4)
            % compute temporary variance - sigmahat^2_k (Equation 5)
            % compute global fitness using temporary values - E_csr (Equation 2)
            % compute AIC score using global fitness (Equation 8)
        
        % NOTE @RKK: This is what they mean by 'greedy'. The steps below
        % are within the for-loop for the K modes but not outside.
        
        % set behavior f k to solution with lowest AIC score in sr_solutions
        % set variance to corresponding value - σ 2 k (Equation 5)
        % #####################
        
    end
end

% return behaviors f_k and variances sigma^2_k
% safe them internally as well
obj.f = f;
obj.var_train = var_train;
obj.var_val = var_val;
obj.var_test = var_test;


% algorithm finished
obj.runningEM = false;

end