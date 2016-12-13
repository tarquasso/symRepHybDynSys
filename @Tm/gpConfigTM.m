function gp = gpConfigTM(obj,gp)

    % runcontrol
    gp.runcontrol.pop_size = 64; %population size
    gp.runcontrol.num_gen = 500; % number of generations - paper used 20000
    gp.runcontrol.showBestInputs = true; 
    gp.runcontrol.showValBestInputs = true;
    gp.runcontrol.timeout = 30; %adjust?
    gp.runcontrol.runs = 1; %single run per transition
    gp.runcontrol.parallel.auto = false; %potentially faster
    
    % selection - not mentioned in paper
    gp.selection.tournament.size = 15;
    gp.selection.tournament.p_pareto = 0.7;
    gp.selection.elite_fraction = 0.3;
    gp.nodes.const.p_int = 0.5;
    tmobj = Tm.getInstance;
    % fitness
    gp.fitness.fitfun = @tmobj.tmFitfun;
    
    
    %input configuration 
    gp.nodes.inputs.num_inp = 1; 		         

    % multigene
    gp.genes.max_genes = 6;
    
    % constants
    gp.nodes.const.p_ERC = 0.05;
    
    % tree information
    gp.treedef.max_depth = 4;
    
    % data
    gp.userdata.xtrain = obj.x_train;
    gp.userdata.ytrain = obj.y_train(:,obj.ksub_current);
    gp.userdata.xval   = obj.x_val;
    gp.userdata.yval   = obj.y_val(:,obj.ksub_current);
    gp.userdata.xtest  = obj.x_test;
    gp.userdata.ytest  = obj.y_test(:,obj.ksub_current);
    [gp.userdata.numytrain, gp.nodes.inputs.num_inp] = size(gp.userdata.xtrain);
    
    if size(gp.userdata.xtrain,1) ~= size(gp.userdata.ytrain,1)
        error('There must be the same number of rows in gp.userdata.xtrain and gp.userdata.ytrain');
    end
    
    if any(any(~isfinite(gp.userdata.xtrain))) || any(any(~isfinite(gp.userdata.ytrain)))
        error('Non-finite values detected in gp.userdata.xtrain or gp.userdata.ytrain');
    end
    
    if any(any(~isreal(gp.userdata.xtrain))) || any(any(~isreal(gp.userdata.ytrain)))
        error('Complex values detected in gp.userdata.xtrain or gp.userdata.ytrain');
    end
    
    gp.userdata.name = 'Transitions';
    
    
    %enables hold out validation set
    gp.userdata.user_fcn =  @tmobj.tmFitfunValidate;
    
    % variable names
    %gp.nodes.inputs.names = {'z','dz','theta','dtheta'};
    
    % TODO: add termination criterion 
    % the maximum amount of time to run for (in seconds) 
    % can be set for each run as well as a target fitness.
    % E.g. for multigene regression the target fitness can be set as model
    % root mean squared error (RMSE) on the training data
    % gp.fitness.terminate = true;
    % gp.fitness.terminate_value = 0.2;

    %genetic operators
    gp.operators.mutation.p_mutate = 0.03;    
    gp.operators.crossover.p_cross = 0.70;
    gp.operators.directrepro.p_direct = 1-gp.operators.mutation.p_mutate-gp.operators.crossover.p_cross; 
    
    % function nodes
    gp.nodes.functions.name = {'times','minus','plus','rdivide'};
    
%     gp.nodes.functions.name = {'times','minus','plus','rdivide','square',...
%         'mult3','add3','sqrt','cube','neg'};
      
    
end