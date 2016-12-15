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

% initialize random membership values
% see initiateCsr.m

% for each behavior in K modes :
for k = 1:obj.K
    obj.k_current = k;
    
    % sr_solutions = symbolic_regression(y_n = f_k(u_n),fitfunc)
    gp = obj.symReg(); % returns pareto set
    
    % check out best solution
    par_size = size(obj.pareto_fit,1);
    aic = zeros(par_size,1);
    for i = 1:par_size
            aic(i) = obj.computeLocalAIC(gp,i,k); %for all with index = 1, compute AIC
    end
        
    % set behavior f_k to solution with lowest local AIC score in sr_solutions
    [~,i_best] = min(aic); % only need index of aic vector
    obj.fUpdate(k,gp,i_best); % take the best and format into symbolic eq
    % convert into symbolic equation since it allows flexible value assignment
    
    % set variance for each behavior - sigma^2_k (Equation 5)
    obj.var_train(k) = obj.computeVar(k,'train'); % on training set!!
    obj.var_test(k)  = obj.computeVar(k,'test');
    obj.var_val(k)   = obj.computeVar(k,'val');
     
end

last_ecsr = realmax;
lastImprovement = 0;
notConverged = true;
% while convergence is not achieved :
while notConverged 
    
    % for each behavior in K modes :
    for k = 1:obj.K
        obj.k_current = k;
        
        % # EXPECTATION STEP ##
        % Calculate Membership values
        % eq.4. for all the N data points in current k:
        obj.gamma_train(k,:) = obj.computeGamma(k,obj.var_train,obj.x_train,obj.y_train);
        obj.gamma_val(k,:) = obj.computeGamma(k,obj.var_val,obj.x_val,obj.y_val);
        obj.gamma_test(k,:) = obj.computeGamma(k,obj.var_test, obj.x_test,obj.y_test);
        % #####################

        % # MAXIMIZATION STEP #
        % sr_solutions = symbolic_regression(y_n = f_k(u_n),fitfunc)
        gp = obj.symReg(); % returns pareto set
        
        % for each solution in sr_solutions :
        par_size = size(obj.pareto_fit,1);
        aic = zeros(par_size,1);
        for i = 1:par_size
            % compute AIC score using transition fitness (Equation 18)
            aic(i) = obj.computeAIC(gp,i,k);
        end
        
        % set behavior f_k to solution with lowest AIC score in sr_solution
        [~,i_best] = min(aic);
        obj.fUpdate(k,gp,i_best);
        
        % set variance for each behavior - sigma^2_k (Equation 5)
        obj.var_train(k) = obj.computeVar(k,'train'); % on training set!!
        obj.var_test(k)  = obj.computeVar(k,'test');
        obj.var_val(k)   = obj.computeVar(k,'val');
        % #####################
        
    end
    
    % Convergence occurs when global error produces less than 2% change for the
    % last 5 iterations
    ecsr = obj.absError(obj.ypred_val,obj.y_val,obj.gamma_val);
    relative = 1 - ecsr/last_ecsr;
    last_ecsr = ecsr;
    
    if relative > 0.02
        lastImprovement = 0;
    else 
        lastImprovement = lastImprovement + 1;
    end
    
    if lastImprovement > 4 || ecsr < 1e-10
        notConverged = false;
    end
    
    
    disp('CURRENT METRICS:')
    disp(['Lowest error: ' num2str(ecsr) ', last Improvement: ', num2str(lastImprovement)]);
    disp('Current functions: ');
    disp(obj.f{1});
    disp(obj.f{2});
    disp(['Converged? --> ',num2str(~notConverged)]);
    
end

% return behaviors f_k and variances sigma^2_k
% safe them internally as well
f = obj.f;
var_train = obj.var_train;
var_val = obj.var_val;
var_test = obj.var_test;


% algorithm finished
obj.runningEM = false;
obj.initiated = false;

end