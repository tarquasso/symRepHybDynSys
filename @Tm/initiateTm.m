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

obj.f = cell(obj.K,1); %transition functions

% obj.var_train = zeros(obj.K,1);
% obj.var_test = obj.var_train;
% obj.var_val = obj.var_train;

% obj.gamma_train = [];
% obj.gamma_test = [];
% obj.gamma_val = [];

obj.n_train = size(obj.x_train,1);
obj.n_test  = size(obj.x_test,1);
obj.n_val = size(obj.x_val,1);

% Weight Balance
obj.ptp_train = zeros(obj.K,n_train-1);
obj.ptp_val = zeros(obj.K,n_val-1);

obj.ntp_train = zeros(obj.K,n_train-1);
obj.ntp_val = zeros(obj.K,n_val-1);

obj.ntpTilde_train = zeros(obj.K,n_train-1);
obj.ntpTilde_val = zeros(obj.K,n_val-1);

obj.gammaTilde_train = zeros(obj.K,n_train-1);
obj.gammaTilde_val = zeros(obj.K,n_val-1);

obj.ypred_train = zeros(obj.K,n_train);
obj.ypred_test = zeros(obj.K,n_test);
obj.ypred_val = zeros(obj.K,n_val);

obj.runningTM = false;
obj.initiated = true;

end

