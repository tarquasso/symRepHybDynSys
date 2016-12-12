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
obj.f = cell(obj.K,1);
obj.var_train = zeros(obj.K,1);
obj.var_test = obj.var_train;
obj.var_val = obj.var_train;

% initialize and normalize random membership values
% normalize each column of gamma so the sum of columns is 1: 
obj.gamma_train = rand(obj.K,size(obj.y_train,1));
obj.gamma_train = obj.gamma_train./repmat(sum(obj.gamma_train),obj.K,1);

%see above
obj.gamma_test = rand(obj.K,size(obj.y_test,1));
obj.gamma_test = obj.gamma_test./repmat(sum(obj.gamma_test),obj.K,1);

%see above
obj.gamma_val = rand(obj.K,size(obj.y_val,1));
obj.gamma_val = obj.gamma_val./repmat(sum(obj.gamma_val),obj.K,1);

% for each behavior in K modes :
for k = 1:obj.K
    obj.k_current = k;
    
    % sr_solutions = symbolic_regression(y_n = f_k(u_n),fitfunc)
    [gp,index_pareto] = obj.symReg(k); % returns pareto set
    
    % check out best solution
    pop = size(index_pareto,1);
    aic = zeros(pop,1);
    aic(index_pareto == 0) = Inf; %can't be a solution
        for i = 1:pop
            if index_pareto(i) == 0 
                continue; %skip it, see above
            end
            aic(i) = obj.computeLocalAIC(gp,i,k); %for all with index = 1, compute AIC
        end
    
    % set behavior f_k to solution with lowest local AIC score in sr_solutions
    [~,i_best] = min(aic); % only need index of aic vector
    obj.f{k} = gpmodel2sym(gp,i_best); % take the best and format into symbolic eq
    % convert into symbolic equation since it allows flexible value assignment
    
    % set variance for each behavior - sigma^2_k (Equation 5)
    obj.var_train(k) = obj.computeVar(k,gp,i_best,'train'); % on training set!!
    obj.var_test(k)  = obj.computeVar(k,gp,i_best,'test');
    obj.var_val(k)   = obj.computeVar(k,gp,i_best,'val');
     
end

last_ecsr = Inf;
lastImprovement = 0;
notConverged = true;
% while convergence is not achieved :
while notConverged % TODO: add convergence criterion
    
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
        [gp,index_pareto] = obj.symReg(k); % returns pareto set
        
        % for each solution in sr_solutions :
        pop = size(index_pareto,1);
        aic = zeros(pop,1);
        aic(index_pareto == 0) = Inf; %for all solutions with 0 in index_pareto, set aic to infinity
        varhat_k = cell(pop,1);
        for i = 1:pop
            if index_pareto(i) == 0
                continue;
            end

            % compute AIC score using global fitness (Equation 8)
            [aic(i),varhat_k{i}] = obj.computeAIC(gp,i,k);
        end        
        
        % set behavior f_k to solution with lowest AIC score in sr_solution
        [~,i_best] = min(aic);
        obj.f{k} = gpmodel2sym(gp,i_best);
        
        % "update weights (key: greedy implementation, in the next iteration
        % for the next mode this behavior is already fixed and should be
        % reflected in all the parameters for this mode. Especially when
        % computing the global E_CSR we need to have to up-to-date
        % weights."
        % QUESTION: YES OR NO?
        % PSEUDO ALGORITHM IN PAPER WOULD SUGGEST NO.
        % let's say NO for now
        
        % OPTION (1)
        %obj.gamma_train(k,:) = obj.computeGamma(k,obj.var_train,obj.x_train,obj.y_train);
        %obj.gamma_val(k,:) = obj.computeGamma(k,obj.var_val,obj.x_val,obj.y_val);
        %obj.gamma_test(k,:) = obj.computeGamma(k,obj.var_test, obj.x_test,obj.y_test);
        % set variance for each behavior - sigma^2_k (Equation 5)
        %obj.var_train(k) = obj.computeVar(k,gp,i_best,'train'); % on training set!!
        %obj.var_test(k)  = obj.computeVar(k,gp,i_best,'test');
        %obj.var_val(k)   = obj.computeVar(k,gp,i_best,'val');
        
        % OPTION (1).(b)
        % reverse the order of (1).
        
        % OPTION (2)
        % set variance for each behavior - sigma^2_k (Equation 5)
        %obj.var_train(k) = varhat_k{i_best}.train;
        %obj.var_test(k)  = varhat_k{i_best}.test;
        %obj.var_val(k)   = varhat_k{i_best}.val;
        
        % OPTION (3)
        % set variance for each behavior - sigma^2_k (Equation 5)
        obj.var_train(k) = obj.computeVar(k,gp,i_best,'train'); % on training set!!
        obj.var_test(k)  = obj.computeVar(k,gp,i_best,'test');
        obj.var_val(k)   = obj.computeVar(k,gp,i_best,'val');
        % right now I believe it's this update but I cannnot decide
        % between the three. 
        
        % #####################
        
    end
    
    % Convergence occurs when global error produces less than 2% change for the
    % last 5 iterations
    % ecsr = 
    
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