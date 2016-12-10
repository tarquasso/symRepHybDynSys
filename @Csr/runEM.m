% top level file for clustered symbolic regression
% input:
%   unclustered input-output data - u_n , y_n
%   the number of subfunctions - K
% output: 
%   behavior for each mode - f_k (u_n)
%   variance for each mode - sigma^2_k, var_k

function [f,var] = runEM(obj)

% making sure we don't run the EM algorithm without initialization
errorMsg = 'You cannot start the EM-algorithm without initialization! Aborting';
assert(obj.initiated == true,errorMsg);
% making sure we don't run the EM algorithm multiple times at the same time
errorMsg = 'You cannot start the EM-algorithm twice! Aborting';
assert(obj.runningEM == false,errorMsg);
obj.runningEM = true;

% get some variables ready 
f = cell(obj.K,1);
var_k = zeros(obj.K,1);

% initialize random membership values

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
    [aic_best,i_best] = min(aic);
    f{k} = gpmodel2sym(gp,i_best);
    
end

% set variance for each behavior - sigma^2_k (Equation 5)

% while convergence is not achieved :
    
    % for each behavior in K modes :
        
        % # EXPECTATION STEP
        % for all the N data points :
            % compute membership values - gamma_kn (Equation 4)
        % #####

        % # MAXIMIZATION STEP
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


% return behaviors f_k and variances sigma^2_k


% algorithm finished
obj.runningEM = false;

end