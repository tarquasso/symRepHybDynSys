function gp = gpConfigTM(obj,gp)
    
    tmobj = Tm.getInstance;

    % runcontrol
    gp.runcontrol.pop_size = 64; %population size
    gp.runcontrol.num_gen = 20000; % number of generations - paper used 20000
    gp.runcontrol.showBestInputs = true; 
    gp.runcontrol.showValBestInputs = true;
    gp.runcontrol.timeout = inf; %adjust?
    gp.runcontrol.runs = 1; %single run per transition
    gp.runcontrol.parallel.auto = false; %potentially faster
    gp.runcontrol.verbose = 100; 
    
    % selection - not mentioned in paper
    gp.selection.tournament.size = 8;
    gp.selection.tournament.p_pareto = 0;
    gp.selection.elite_fraction = 0.05;
    
    % fitness
    gp.fitness.minimisation = true;         %true to minimise the fitness function (if false it is maximised).
    gp.fitness.fitfun = @tmobj.tmFitfun; 		         
    
    % data, naming convention is different for single tree
    gp.userdata.name = 'Transitions';
    gp.userdata.x = obj.x_train;
    gp.userdata.y = obj.y_train(:,obj.ksub_current);
    gp.userdata.xtrain = obj.x_train;
    gp.userdata.ytrain = obj.y_train(:,obj.ksub_current);
    gp.userdata.xval   = obj.x_val;
    gp.userdata.yval   = obj.y_val(:,obj.ksub_current);
    gp.userdata.xtest  = obj.x_test;
    gp.userdata.ytest  = obj.y_test(:,obj.ksub_current);
    [gp.userdata.numytrain, gp.nodes.inputs.num_inp] = size(gp.userdata.x);
    
    % enables paretoCheck after each generation
    gp.userdata.user_fcn =  @tmobj.tmSelectPareto;
    
    if size(gp.userdata.x,1) ~= size(gp.userdata.y,1)
        error('There must be the same number of rows in gp.userdata.x and gp.userdata.y');
    end
    
    if any(any(~isfinite(gp.userdata.x))) || any(any(~isfinite(gp.userdata.y)))
        error('Non-finite values detected in gp.userdata.xtrain or gp.userdata.y');
    end
    
    if any(any(~isreal(gp.userdata.x))) || any(any(~isreal(gp.userdata.y)))
        error('Complex values detected in gp.userdata.x or gp.userdata.y');
    end
    
    % tree information (make it possibly deeper since we only have one tree)
    gp.treedef.max_depth = 3;
    gp.treedef.max_mutate_depth = 3;
    
    %genetic operators
    gp.operators.mutation.p_mutate = 0.03;    
    gp.operators.crossover.p_cross = 0.70;
    gp.operators.directrepro.p_direct = 1-gp.operators.mutation.p_mutate-gp.operators.crossover.p_cross; 
    
    % function nodes
    gp.nodes.functions.name = {'times','minus','plus'};
    %gp.nodes.functions.name = {'times','minus','plus','rdivide','square',...
    %    'mult3','add3','sqrt','cube','neg'};
    
    % constants
    gp.nodes.const.p_ERC = 0.25; % probability of a constant instead of x
    gp.nodes.const.range = [-10 10]; % range of constants
    gp.nodes.const.p_int = 0.0;
    
    % multigene - NO
    gp.genes.multigene = false;
    gp.genes.max_genes = 1;
    
end