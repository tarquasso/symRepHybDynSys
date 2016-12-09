% top level file for clustered symbolic regression
% input:
%   unclustered input-output data - u_n , y_n
%   the number of subfunctions - K
% output: 
%   behavior for each mode - f_k (u_n)
%   variance for each mode - sigma^2_k

function [f,var] = csr(u,y,K)

% initialize random membership values

% for each behavior in K modes :
    % sr_solutions = symbolic_regression(y_n = f_k(u_n),fitfunc)
    % returns pareto set
    % set behavior f k to solution with lowest local AIC score in sr_solutions

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

end