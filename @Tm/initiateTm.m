function initiateTm(obj,init)
      
% All Data Sets with multiple K in the Gamma (in y)
obj.x_train = init.x_train;
obj.y_train = init.y_train;
obj.x_val   = init.x_val;
obj.y_val   = init.y_val;
obj.x_test  = init.x_test;
obj.y_test  = init.y_test;

obj.K = init.K;

% do not touch
obj.k_current = [];
obj.ksub_current = [];

% do not touch
obj.pareto_fstr = [];
obj.pareto_complex = [];
obj.pareto_fit = [];

obj.f = cell(obj.K,obj.K); %transition functions KxK, diagonal terms do not matter

n_train = length(obj.x_train);
n_test  = length(obj.x_test);
n_val = length(obj.x_val);

% Weight Balance
obj.ptp_train = zeros(n_train-1,obj.K); %one element shorter
obj.ptp_val = zeros(n_val-1,obj.K); %one element shorter

obj.ntp_train = zeros(n_train-1,obj.K); %one element shorter
obj.ntp_val = zeros(n_val-1,obj.K); %one element shorter

obj.ntpTilde_train = zeros(n_train-1,obj.K); %one element shorter
obj.ntpTilde_val = zeros(n_val-1,obj.K); %one element shorter

obj.gammaTilde_train = zeros(n_train-1,obj.K);%one element shorter
obj.gammaTilde_val = zeros(n_val-1,obj.K);%one element shorter

% Outputs
obj.ypred_train = zeros(n_train,obj.K,obj.K);
obj.ypred_test = zeros(n_test,obj.K,obj.K);
obj.ypred_val = zeros(n_val,obj.K,obj.K);

obj.runningTM = false;
obj.initiated = true;

end

